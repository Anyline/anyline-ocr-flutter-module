// Scan Options screen — lets users configure scan request parameters via a
// schema-driven JSON editor. Each tab corresponds to one top-level field
// of WrapperSessionScanStartRequest (excluding scanViewConfigContentString,
// which is provided per-scan).
//
// Schemas are fetched remotely via the json-editor's AJAX support.
// A network connection is required to open this screen.

import 'dart:convert';

import 'package:anyline_plugin/models/wrapper_session_parameters.dart';
import 'package:flutter/material.dart';
import 'package:anyline_plugin_example/infinity/json_schema_editor_widget.dart';
import 'package:anyline_plugin_example/infinity/scan_options.dart';

String _schemaBase(String pluginVersion) =>
    'https://documentation.anyline.com/flutter-plugin-component/$pluginVersion/mobile-sdk-common/_attachments/json-schemas';

// ─── Scan Result Config sub-schema builders ─────────────────────────────────

JsonSchemaSource _encodedContainerSchema(String base) => JsonSchemaSource.remote(
  '$base/exported_scan_result.schema.json#/definitions/exportedScanResultImageContainerEncoded',
);

JsonSchemaSource _savedContainerSchema(String base) => JsonSchemaSource.remote(
  '$base/exported_scan_result.schema.json#/definitions/exportedScanResultImageContainerSaved',
);

JsonSchemaSource _imageParametersSchema(String base) => JsonSchemaSource.remote(
  '$base/exported_scan_result.schema.json#/definitions/exportedScanResultImageParameters',
);

JsonSchemaSource _cleanStrategySchema(String base) => JsonSchemaSource.remote(
  '$base/wrapper_session_parameters.schema.json#/definitions/wrapperSessionScanResultCleanStrategyConfig',
);

enum _ImageContainerMode { encoded, saved }

class ScanOptionsScreen extends StatefulWidget {
  final ScanOptions initial;
  final String pluginVersion;

  const ScanOptionsScreen({
    Key? key,
    required this.initial,
    required this.pluginVersion,
  }) : super(key: key);

  @override
  State<ScanOptionsScreen> createState() => _ScanOptionsScreenState();
}

class _ScanOptionsScreenState extends State<ScanOptionsScreen>
    with SingleTickerProviderStateMixin {
  late ScanOptions _options;
  late final TabController _tabController;
  int _activeTab = 0;
  bool _errorShown = false;

  // ─── Schema sources (remote, built from plugin version) ─────────────────────

  late final String _base = _schemaBase(widget.pluginVersion);

  late final _initParamsSchema = JsonSchemaSource.remote(
    '$_base/scanview_initialization_parameters.schema.json',
  );

  late final _platformOptionsSchema = JsonSchemaSource.remote(
    '$_base/wrapper_session_parameters.schema.json#/definitions/wrapperSessionScanStartRequest/properties/platformOptions',
  );


  @override
  void initState() {
    super.initState();
    _options = widget.initial;
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _activeTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Options'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context, _options),
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Save',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Scan Result Config'),
            Tab(text: 'Platform Options'),
            Tab(text: 'Initialization Parameters'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTab(
            _ScanResultConfigTab(
              initial: _options.scanResultConfig,
              schemaBase: _base,
              onChanged: (config) => setState(
                  () => _options = _options.copyWith(scanResultConfig: config)),
              onError: _onSchemaError,
            ),
          ),
          _buildTab(
            JsonSchemaEditorWidget(
              schema: _platformOptionsSchema,
              value: _options.platformOptions?.toRawJson() ?? '{}',
              visible: _activeTab == 1,
              onChanged: (v) => setState(() => _options = _options.copyWith(
                    platformOptions:
                        WrapperSessionScanStartPlatformOptions.fromRawJson(v),
                  )),
              onError: _onSchemaError,
            ),
          ),
          _buildTab(
            JsonSchemaEditorWidget(
              schema: _initParamsSchema,
              value: _options.initializationParameters?.toRawJson() ?? '{}',
              visible: _activeTab == 2,
              onChanged: (v) => setState(() => _options = _options.copyWith(
                    initializationParameters:
                        ScanViewInitializationParameters.fromRawJson(v),
                  )),
              onError: _onSchemaError,
            ),
          ),
        ],
      ),
    );
  }

  void _onSchemaError(String message) {
    if (_errorShown) return;
    _errorShown = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Network Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dismiss dialog
              Navigator.pop(context); // pop screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(Widget child) => SizedBox.expand(child: child);
}

// ─── _ScanResultConfigTab ─────────────────────────────────────────────────────

class _ScanResultConfigTab extends StatefulWidget {
  final WrapperSessionScanResultConfig initial;
  final String schemaBase;
  final ValueChanged<WrapperSessionScanResultConfig> onChanged;
  final ValueChanged<String>? onError;

  const _ScanResultConfigTab({
    required this.initial,
    required this.schemaBase,
    required this.onChanged,
    this.onError,
  });

  @override
  State<_ScanResultConfigTab> createState() => _ScanResultConfigTabState();
}

class _ScanResultConfigTabState extends State<_ScanResultConfigTab> {
  late _ImageContainerMode _mode;
  late WrapperSessionScanResultConfig _config;

  // Kept separately so switching modes preserves values for both container types.
  ExportedScanResultImageContainerEncoded? _encodedContainer;
  ExportedScanResultImageContainerSaved? _savedContainer;

  double _containerHeight = 120;
  double _parametersHeight = 120;
  double _cleanStrategyHeight = 80;

  @override
  void initState() {
    super.initState();
    _config = widget.initial;
    _encodedContainer = _config.imageContainer?.encoded;
    _savedContainer = _config.imageContainer?.saved;
    _mode = _savedContainer != null
        ? _ImageContainerMode.saved
        : _ImageContainerMode.encoded;
  }

  // Returns the raw JSON string for the active container type.
  String get _containerValue => _mode == _ImageContainerMode.encoded
      ? (_encodedContainer?.toRawJson() ?? '{}')
      : (_savedContainer?.toRawJson() ?? '{}');

  String get _parametersValue => _config.imageParameters?.toRawJson() ?? '{}';

  // Returns a JSON-encoded string (e.g. '"cleanFolderOnStartScanning"' with quotes).
  // _injectData calls json.encode() on this value too, so the double-encoding is
  // intentional: JS receives a quoted string that JSON.parse decodes to the plain value.
  String get _cleanStrategyValue {
    final s = _config.cleanStrategy;
    final key = s == null
        ? null
        : wrapperSessionScanResultCleanStrategyConfigValues.reverse[s];
    return json.encode(key ?? WrapperSessionScanResultCleanStrategyConfig.CLEAN_FOLDER_ON_START_SCANNING);
  }

  void _update(WrapperSessionScanResultConfig config) {
    setState(() => _config = config);
    widget.onChanged(config);
  }

  void _onContainerChanged(String v) {
    final ExportedScanResultImageContainer container;
    if (_mode == _ImageContainerMode.encoded) {
      _encodedContainer = ExportedScanResultImageContainerEncoded.fromRawJson(v);
      container = ExportedScanResultImageContainer(encoded: _encodedContainer);
    } else {
      _savedContainer = ExportedScanResultImageContainerSaved.fromRawJson(v);
      container = ExportedScanResultImageContainer(saved: _savedContainer);
    }
    _update(WrapperSessionScanResultConfig(
      cleanStrategy: _config.cleanStrategy,
      imageContainer: container,
      imageParameters: _config.imageParameters,
    ));
  }

  void _onParametersChanged(String v) {
    _update(WrapperSessionScanResultConfig(
      cleanStrategy: _config.cleanStrategy,
      imageContainer: _config.imageContainer,
      imageParameters: ExportedScanResultImageParameters.fromRawJson(v),
    ));
  }

  void _onCleanStrategyChanged(String v) {
    final strategy = wrapperSessionScanResultCleanStrategyConfigValues
        .map[json.decode(v) as String];
    _update(WrapperSessionScanResultConfig(
      cleanStrategy: strategy,
      imageContainer: _config.imageContainer,
      imageParameters: _config.imageParameters,
    ));
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 4),
        child: Text(title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                )),
      );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          _sectionHeader('Image Container'),
          Row(
            children: [
              Radio<_ImageContainerMode>(
                value: _ImageContainerMode.encoded,
                groupValue: _mode,
                onChanged: (v) {
                  if (v != _mode) {
                    setState(() {
                      _mode = v!;
                      _containerHeight = 120;
                    });
                  }
                },
              ),
              const Text('Encoded (base64)'),
              Radio<_ImageContainerMode>(
                value: _ImageContainerMode.saved,
                groupValue: _mode,
                onChanged: (v) {
                  if (v != _mode) {
                    setState(() {
                      _mode = v!;
                      _containerHeight = 120;
                    });
                  }
                },
              ),
              const Text('Saved (to path)'),
            ],
          ),
          SizedBox(
            height: _containerHeight,
            child: JsonSchemaEditorWidget(
              key: ValueKey(_mode),
              schema: _mode == _ImageContainerMode.encoded
                  ? _encodedContainerSchema(widget.schemaBase)
                  : _savedContainerSchema(widget.schemaBase),
              value: _containerValue,
              onChanged: _onContainerChanged,
              onHeightChanged: (h) => setState(() => _containerHeight = h),
              onError: widget.onError,
            ),
          ),
          _sectionHeader('Image Parameters'),
          SizedBox(
            height: _parametersHeight,
            child: JsonSchemaEditorWidget(
              schema: _imageParametersSchema(widget.schemaBase),
              value: _parametersValue,
              onChanged: _onParametersChanged,
              onHeightChanged: (h) => setState(() => _parametersHeight = h),
              onError: widget.onError,
            ),
          ),
          _sectionHeader('Clean Strategy'),
          SizedBox(
            height: _cleanStrategyHeight,
            child: JsonSchemaEditorWidget(
              schema: _cleanStrategySchema(widget.schemaBase),
              value: _cleanStrategyValue,
              onChanged: _onCleanStrategyChanged,
              onHeightChanged: (h) => setState(() => _cleanStrategyHeight = h),
              onError: widget.onError,
            ),
          ),
          const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}