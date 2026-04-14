// WebView-based JSON editor driven by a JSON schema.
//
// Uses the json-editor JS library (https://github.com/json-editor/json-editor),
// following the same approach as the Android DevExample's ViewConfigEditorFragment.
//
// Schema sources are designed to be swapped between local assets (bundled for
// development) and remote URLs once schemas are published.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _kEditorHtmlAsset = 'anyline_assets/json_schema_editor/json-editor.html';
const _kEditorJsAsset = 'anyline_assets/json_schema_editor/jsoneditor.js';
const _kSpectreAsset = 'anyline_assets/json_schema_editor/spectre.min.css';
const _kSpectreExpAsset = 'anyline_assets/json_schema_editor/spectre-exp.min.css';
const _kSpectreIconsAsset = 'anyline_assets/json_schema_editor/spectre-icons.min.css';

// ─── JsonSchemaSource ────────────────────────────────────────────────────────

/// Source for a JSON schema used by [JsonSchemaEditorWidget].
///
/// Use [JsonSchemaSource.remote] to load schemas via AJAX (requires network).
/// Use [JsonSchemaSource.asset] or [JsonSchemaSource.assetBundled] for
/// locally bundled schemas (no network required).
abstract class JsonSchemaSource {
  const JsonSchemaSource();

  /// Single local schema file. Suitable when the schema has no cross-file $refs.
  const factory JsonSchemaSource.asset(String assetPath) = _SingleAssetSource;

  /// Bundled local schemas: merges multiple schema files into one document so
  /// cross-file $refs resolve correctly without AJAX.
  ///
  /// [primaryAssetPath] is the main schema file.
  ///
  /// [additionalAssets] maps each $ref filename (as it appears in the schema,
  /// after ref-flattening by update_anyline-mobile-sdk-resources.sh) to its
  /// Flutter asset path. Example:
  /// ```dart
  /// additionalAssets: {
  ///   'exported_scan_result.schema.json':
  ///       '$_kSchemasBase/exported_scan_result.schema.json',
  /// }
  /// ```
  ///
  /// [ref] scopes the editor root to a definition, e.g.
  ///   `'#/definitions/wrapperSessionScanResultConfig'`.
  ///
  /// [propertyPath] extracts a nested property as the editor root, e.g.
  ///   `'definitions/wrapperSessionScanStartRequest/properties/platformOptions'`.
  const factory JsonSchemaSource.assetBundled({
    required String primaryAssetPath,
    required Map<String, String> additionalAssets,
    String? ref,
    String? propertyPath,
  }) = _BundledAssetSource;

  /// Fetch schema from a remote URL using json-editor's built-in AJAX.
  /// Requires a network connection. Register [JsonSchemaEditorWidget.onError]
  /// to handle AJAX failures gracefully.
  const factory JsonSchemaSource.remote(String url) = _RemoteSource;

  Future<String> resolveSchemaJson(AssetBundle bundle);
  bool get requiresAjax;
}

// ─── Implementations ─────────────────────────────────────────────────────────

class _SingleAssetSource extends JsonSchemaSource {
  final String assetPath;
  const _SingleAssetSource(this.assetPath);

  @override
  bool get requiresAjax => false;

  @override
  Future<String> resolveSchemaJson(AssetBundle bundle) =>
      bundle.loadString(assetPath);
}

class _RemoteSource extends JsonSchemaSource {
  final String url;
  const _RemoteSource(this.url);

  @override
  bool get requiresAjax => true;

  @override
  Future<String> resolveSchemaJson(AssetBundle bundle) async =>
      json.encode({'\$ref': url});
}

class _BundledAssetSource extends JsonSchemaSource {
  final String primaryAssetPath;
  final Map<String, String> additionalAssets;
  final String? ref;
  final String? propertyPath;

  const _BundledAssetSource({
    required this.primaryAssetPath,
    required this.additionalAssets,
    this.ref,
    this.propertyPath,
  });

  @override
  bool get requiresAjax => false;

  @override
  Future<String> resolveSchemaJson(AssetBundle bundle) async {
    final primary = json.decode(await bundle.loadString(primaryAssetPath))
        as Map<String, dynamic>;

    // Load all additional schema files keyed by their $ref filename.
    final extras = <String, Map<String, dynamic>>{};
    for (final entry in additionalAssets.entries) {
      extras[entry.key] =
          json.decode(await bundle.loadString(entry.value)) as Map<String, dynamic>;
    }

    // Merge definitions from all files into one pool.
    //
    // For every additional schema file:
    //   1. Its internal definitions (if any) are merged into the pool so that
    //      intra-file "#/definitions/Foo" refs continue to resolve.
    //   2. The root schema itself is always registered under a title-derived
    //      name so that whole-file "$ref": "filename.json" refs from the
    //      primary schema can be rewritten to "#/definitions/Title".
    //      The "definitions" key is stripped from this root entry to avoid
    //      duplicating definitions already merged in step 1.
    final mergedDefs = <String, dynamic>{};
    mergedDefs.addAll(
        (primary['definitions'] as Map<String, dynamic>?) ?? {});
    for (final entry in extras.entries) {
      final extraDefs =
          (entry.value['definitions'] as Map<String, dynamic>?) ?? {};
      // Step 1: merge internal definitions.
      if (extraDefs.isNotEmpty) {
        mergedDefs.addAll(extraDefs);
      }
      // Step 2: register the root schema as a named definition.
      final title = entry.value['title'] as String? ?? '';
      if (title.isNotEmpty) {
        final defName = _titleToDefName(title);
        mergedDefs[defName] = Map<String, dynamic>.from(entry.value)
          ..remove('\$schema')
          ..remove('definitions'); // already merged in step 1
      }
    }

    // Determine the root schema.
    Map<String, dynamic> root;
    if (ref != null) {
      root = {'\$ref': ref};
    } else if (propertyPath != null) {
      root = Map<String, dynamic>.from(
          _extractByPath(primary, propertyPath!.split('/')));
    } else {
      root = Map<String, dynamic>.from(primary)..remove('definitions');
    }

    // Flatten cross-file $refs in both the root and the merged definitions.
    final flatRoot = _flattenRefs(root, extras) as Map<String, dynamic>;
    final flatDefs = _flattenRefs(mergedDefs, extras) as Map<String, dynamic>;

    return json.encode({...flatRoot, 'definitions': flatDefs});
  }

  // Recursively replace cross-file $refs with in-document refs:
  //   "filename.json#/definitions/Foo"  →  "#/definitions/Foo"
  //   "filename.json"                   →  "#/definitions/<TitleBasedName>"
  static dynamic _flattenRefs(
      dynamic node, Map<String, Map<String, dynamic>> extras) {
    if (node is Map<String, dynamic>) {
      return _flattenRefsInMap(node, extras);
    } else if (node is List) {
      return node.map((e) => _flattenRefs(e, extras)).toList();
    }
    return node;
  }

  static Map<String, dynamic> _flattenRefsInMap(
      Map<String, dynamic> node, Map<String, Map<String, dynamic>> extras) {
    if (node.containsKey('\$ref')) {
      final rewritten = _tryRewriteRef(node, extras);
      if (rewritten != null) return rewritten;
    }
    return Map.fromEntries(
        node.entries.map((e) => MapEntry(e.key, _flattenRefs(e.value, extras))));
  }

  static Map<String, dynamic>? _tryRewriteRef(
      Map<String, dynamic> node, Map<String, Map<String, dynamic>> extras) {
    final refVal = node['\$ref'] as String;
    if (refVal.startsWith('#') || refVal.startsWith('http')) return null;
    final sibling = Map<String, dynamic>.fromEntries(
        node.entries.where((e) => e.key != '\$ref'));
    final hashIdx = refVal.indexOf('#');
    if (hashIdx >= 0) {
      // Cross-file ref with fragment: strip filename, keep fragment.
      return {'\$ref': refVal.substring(hashIdx), ...sibling};
    }
    // Whole-file ref: rewrite to the title-derived definition name.
    return _tryRewriteWholeFileRef(refVal, sibling, extras);
  }

  static Map<String, dynamic>? _tryRewriteWholeFileRef(
      String refVal,
      Map<String, dynamic> sibling,
      Map<String, Map<String, dynamic>> extras) {
    final target = extras[refVal];
    if (target == null) return null;
    final defName = _titleToDefName(target['title'] as String? ?? '');
    if (defName.isEmpty) return null;
    return {'\$ref': '#/definitions/$defName', ...sibling};
  }

  static Map<String, dynamic> _extractByPath(
      Map<String, dynamic> obj, List<String> path) {
    dynamic current = obj;
    for (final key in path) {
      if (current is Map<String, dynamic>) {
        current = current[key];
      } else {
        return <String, dynamic>{};
      }
    }
    return (current as Map<String, dynamic>?) ?? <String, dynamic>{};
  }

  /// "Android ScanView Attributes Config" → "AndroidScanViewAttributesConfig"
  static String _titleToDefName(String title) => title
      .split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join('');
}

// ─── JsonSchemaEditorWidget ───────────────────────────────────────────────────

/// A WebView-based JSON editor driven by a JSON schema.
///
/// Mirrors the approach used in the Android DevExample's
/// ViewConfigEditorFragment. Auto-sizes its height to fit the rendered form.
class JsonSchemaEditorWidget extends StatefulWidget {
  final JsonSchemaSource schema;

  /// The initial JSON value as a string.
  final String value;

  /// Called whenever the user edits any field. Receives the full JSON string.
  final ValueChanged<String> onChanged;

  /// Whether this tab is currently the active (fully visible) tab.
  /// HTML is loaded only on the first transition to [visible] == true,
  /// ensuring the native WebView has correct bounds before rendering.
  final bool visible;

  /// When provided, the widget sizes itself to fit its content height and
  /// calls this callback with the content height in logical pixels whenever
  /// the editor finishes rendering. Use this when stacking multiple editors
  /// in a [SingleChildScrollView]. When null, the widget fills its parent.
  final ValueChanged<double>? onHeightChanged;

  /// Called when a network error occurs while loading a remote schema via AJAX.
  /// The message describes the failure. The caller should typically show an
  /// alert and abandon the editing screen.
  final ValueChanged<String>? onError;

  const JsonSchemaEditorWidget({
    Key? key,
    required this.schema,
    required this.value,
    required this.onChanged,
    this.visible = true,
    this.onHeightChanged,
    this.onError,
  }) : super(key: key);

  @override
  State<JsonSchemaEditorWidget> createState() => _JsonSchemaEditorWidgetState();
}

class _JsonSchemaEditorWidgetState extends State<JsonSchemaEditorWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _resourcesLoaded = false;
  String? _schemaJson;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'AnylineChannel',
        onMessageReceived: (msg) => widget.onChanged(msg.message),
      )
      ..addJavaScriptChannel(
        'ReadyChannel',
        onMessageReceived: (msg) {
          final h = double.tryParse(msg.message);
          if (h != null) widget.onHeightChanged?.call(h);
          if (mounted) setState(() => _isLoading = false);
        },
      )
      ..addJavaScriptChannel(
        'ErrorChannel',
        onMessageReceived: (msg) => widget.onError?.call(msg.message),
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => _injectData(),
        onWebResourceError: (e) =>
            debugPrint('[JsonSchemaEditor] WebResourceError: ${e.description}'),
      ));

    if (widget.visible) {
      _resourcesLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadResources());
    }
  }

  @override
  void didUpdateWidget(JsonSchemaEditorWidget old) {
    super.didUpdateWidget(old);
    // Load on first transition to visible — the tab animation has settled
    // and the native WebView has correct bounds at this point.
    if (widget.visible && !old.visible && !_resourcesLoaded) {
      _resourcesLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadResources());
    }
  }

  Future<void> _loadResources() async {
    final bundle = DefaultAssetBundle.of(context);
    final results = await Future.wait([
      bundle.loadString(_kEditorJsAsset),
      bundle.loadString(_kEditorHtmlAsset),
      widget.schema.resolveSchemaJson(bundle),
      bundle.loadString(_kSpectreAsset),
      bundle.loadString(_kSpectreExpAsset),
      bundle.loadString(_kSpectreIconsAsset),
    ]);

    _schemaJson = results[2];
    final html = results[1]
        .replaceFirst('{{JSONEDITOR_JS}}', results[0])
        .replaceFirst('{{SPECTRE_CSS}}', results[3])
        .replaceFirst('{{SPECTRE_EXP_CSS}}', results[4])
        .replaceFirst('{{SPECTRE_ICONS_CSS}}', results[5]);
    await _controller.loadHtmlString(html);
  }

  Future<void> _injectData() async {
    if (_schemaJson == null) return;
    // json.encode wraps each string in quotes and escapes it, producing a
    // valid JS string literal that loadData() receives as a string argument
    // and then passes to JSON.parse() internally.
    final schemaArg = json.encode(_schemaJson);
    final valueArg = json.encode(widget.value);
    final useAjax = widget.schema.requiresAjax;
    await _controller.runJavaScript(
        'loadData($schemaArg, $valueArg, $useAjax, false);');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: WebViewWidget(
              controller: _controller,
              gestureRecognizers: widget.onHeightChanged == null
                  ? {
                      Factory<VerticalDragGestureRecognizer>(
                          () => VerticalDragGestureRecognizer()),
                    }
                  : const {},
            ),
          ),
          if (_isLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}