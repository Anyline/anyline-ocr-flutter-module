import 'dart:async';
import 'dart:convert';

import 'package:anyline_plugin/anyline_infinity_plugin.dart';
import 'package:anyline_plugin/anyline_native_view.dart';
import 'package:anyline_plugin/models/sdk_config.dart';
import 'package:anyline_plugin/models/wrapper_session_parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:anyline_plugin_example/infinity/config_browser_widget.dart';
import 'package:anyline_plugin_example/infinity/plugin_type_helper.dart';
import 'package:anyline_plugin_example/infinity/result_list_widget.dart';
import 'package:anyline_plugin_example/infinity/scan_config.dart';
import 'package:anyline_plugin_example/infinity/scan_options.dart';
import 'package:anyline_plugin_example/infinity/scan_options_screen.dart';
import 'package:anyline_plugin_example/infinity/user_config_storage.dart';
import 'package:anyline_plugin_example/infinity/view_config_editor_screen.dart';
import 'package:anyline_plugin_example/env_info.dart';

const _kJsonExtension = '.json';

/// Main screen for the Anyline Infinity Plugin examples.
///
/// Demonstrates SDK initialization, config loading, scanning (NativeView and
/// New Screen modes), result accumulation, scan switching, and UCR reporting
/// using the [AnylineInfinityPlugin] API.
class InfinityMainScanScreen extends StatefulWidget {
  static const routeName = '/infinity';

  const InfinityMainScanScreen({Key? key}) : super(key: key);

  @override
  State<InfinityMainScanScreen> createState() =>
      _InfinityMainScanScreenState();
}

class _InfinityMainScanScreenState extends State<InfinityMainScanScreen> {
  // --- Anyline: plugin instance ---
  late final AnylineInfinityPlugin _plugin;
  StreamSubscription<WrapperSessionScanResultsResponse>? _scanResultsSub;

  /// Flutter asset path prefix for custom ML scripts, passed to
  /// [WrapperSessionSdkInitializationRequest.assetPathPrefix] during SDK init.
  final defaultAssetPathPrefix = 'flutter_assets/anyline_assets';

  // SDK init state
  bool _isInitializing = true;
  String? _initError;
  WrapperSessionSdkInitializationResponseInitialized? _sdkInitSucceedInfo;

  // Version info (loaded alongside SDK init)
  String? _pluginVersion;
  String? _sdkVersion;

  // Configs loaded from bundled assets
  Map<ScanGroup, List<ScanConfig>> _configsByGroup = {};

  // Scan session state
  bool _isScanning = false;
  final List<ExportedScanResult> _results = [];

  // UI options
  bool _useNativeView = false;
  ScanOptions _scanOptions = ScanOptions();

  @override
  void initState() {
    super.initState();
    _plugin = AnylineInfinityPlugin();
    _scanResultsSub = _plugin.onScanResults.listen(_onScanResultsReceived);
    _loadConfigs();
    _loadVersionInfo();
    _loadImageSavePath();
    _initializeSdk();
  }

  @override
  void dispose() {
    _scanResultsSub?.cancel();
    _plugin.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Anyline API calls
  // ---------------------------------------------------------------------------

  /// Initializes the Anyline SDK with the license key from the environment.
  Future<void> _initializeSdk() async {
    setState(() {
      _isInitializing = true;
      _initError = null;
    });
    try {
      final licenseKey = EnvInfo.licenseKey ?? '';

      // --- Anyline: requestSdkInitialization ---
      final response = await _plugin.requestSdkInitialization(
        WrapperSessionSdkInitializationRequest(
            assetPathPrefix: defaultAssetPathPrefix,
            licenseKey: licenseKey
        ),
      );

      if (response.initialized == true) {
        setState(() => _sdkInitSucceedInfo = response.succeedInfo);
      } else {
        setState(() =>
            _initError = response.failInfo?.lastError ??
                'SDK initialization failed.');
      }
    } catch (e) {
      setState(() => _initError = e.toString());
    } finally {
      setState(() => _isInitializing = false);
    }
  }

  /// Starts a new scan session for the given [config].
  /// Sets [_isScanning] to true for the duration of the session.
  Future<void> _startScanning(ScanConfig config) async {
    setState(() => _isScanning = true);
    try {
      final request = _scanOptions.toScanStartRequest(config.configJson);

      // --- Anyline: requestScanStart ---
      final response = await _plugin.requestScanStart(request);
      if (response.status == WrapperSessionScanResponseStatus.SCAN_FAILED &&
          mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Scan failed: ${response.failInfo?.lastError ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scan error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  /// Switches to a different scan config during an active session.
  void _switchScanConfig(ScanConfig config) {
    final request = _scanOptions.toScanStartRequest(config.configJson);

    // --- Anyline: requestScanSwitchWithScanStartRequestParams ---
    _plugin.requestScanSwitchWithScanStartRequestParams(request);
  }

  /// Stops the active scan session.
  void _stopScanning() {
    // --- Anyline: requestScanStop ---
    _plugin.requestScanStop();
  }

  /// Reports a User Corrected Result (UCR) for the given blob key.
  Future<void> _reportUCR(String blobKey, String correctedResult) async {
    try {
      // --- Anyline: requestUCRReport ---
      final response = await _plugin.requestUCRReport(
        WrapperSessionUcrReportRequest(
          blobKey: blobKey,
          correctedResult: correctedResult,
        ),
      );
      if (mounted) {
        final succeeded = response.status ==
            WrapperSessionUcrReportResponseStatus.UCR_REPORT_SUCCEEDED;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(succeeded
                ? 'UCR reported successfully'
                : 'UCR report failed: ${response.failInfo?.lastError ?? 'Unknown error'}'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('UCR report failed: $e')),
        );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  void _onScanResultsReceived(WrapperSessionScanResultsResponse response) {
    final incoming = response.exportedScanResults;
    if (incoming != null && incoming.isNotEmpty) {
      setState(() => _results.insertAll(0, incoming.reversed));
    }
  }

  Future<String> _getDefaultImageSavePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/results/';
  }

  Future<void> _loadImageSavePath() async {
    final path = await _getDefaultImageSavePath();
    if (mounted) setState(() => _scanOptions = _scanOptions.copyWith(imageSavePath: path));
  }

  Future<void> _loadVersionInfo() async {
    final plugin = await _plugin.getPluginVersion();
    final sdk = await _plugin.getSDKVersion();
    if (mounted) {
      setState(() {
        _pluginVersion = plugin;
        _sdkVersion = sdk;
      });
    }
  }

  Future<void> _loadConfigs() async {
    try {
      final assetManifest =
          await AssetManifest.loadFromAssetBundle(rootBundle);
      final paths = assetManifest
          .listAssets()
          .where((k) =>
              k.startsWith('anyline_assets/config/infinity/') && k.endsWith(_kJsonExtension))
          .toList()
        ..sort();

      final Map<ScanGroup, List<ScanConfig>> grouped = {};

      // Load asset configs (blue).
      for (final assetPath in paths) {
        try {
          final configJson = await rootBundle.loadString(assetPath);
          final scanViewConfig =
              ScanViewConfiguration.fromRawJson(configJson);
          final filename = assetPath
              .split('/')
              .last
              .replaceAll('_config$_kJsonExtension', '')
              .replaceAll(_kJsonExtension, '');
          final group = groupFromScanViewConfiguration(scanViewConfig);
          final label =
              labelFromScanViewConfiguration(scanViewConfig, filename);
          grouped
              .putIfAbsent(group, () => [])
              .add(ScanConfig(
                label: label,
                group: group,
                configJson: configJson,
                filename: filename,
                source: ScanConfigSource.asset,
              ));
        } catch (e) {
          debugPrint('Failed to parse asset config $assetPath: $e');
        }
      }

      // Load user-saved configs (grey), appended after asset configs.
      try {
        final userFiles = await UserConfigStorage().listConfigs();
        for (final file in userFiles) {
          try {
            final configJson = await file.readAsString();
            final scanViewConfig =
                ScanViewConfiguration.fromRawJson(configJson);
            final filename = file.path
                .split('/')
                .last
                .replaceAll(_kJsonExtension, '');
            final group = groupFromScanViewConfiguration(scanViewConfig);
            final label =
                labelFromScanViewConfiguration(scanViewConfig, filename);
            grouped
                .putIfAbsent(group, () => [])
                .add(ScanConfig(
                  label: label,
                  group: group,
                  configJson: configJson,
                  filename: filename,
                  source: ScanConfigSource.user,
                ));
          } catch (e) {
            debugPrint('Failed to parse user config ${file.path}: $e');
          }
        }
      } catch (e) {
        debugPrint('Failed to load user configs: $e');
      }

      if (mounted) setState(() => _configsByGroup = grouped);
    } catch (_) {
      // Config loading is best-effort; the UI will show an empty browser.
    }
  }

  void _onConfigSelected(ScanConfig config) {
    if (_isScanning) {
      _switchScanConfig(config);
    } else {
      _startScanning(config);
    }
  }

  Future<void> _openViewConfigEditor(ScanConfig config) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => ViewConfigEditorScreen(
              config: config, pluginVersion: _pluginVersion!)),
    );
    if (saved == true) _loadConfigs();
  }

  Future<void> _deleteUserConfig(ScanConfig config) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete config'),
        content: Text('Delete "${config.label}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await UserConfigStorage().deleteConfig(config.filename);
      _loadConfigs();
    }
  }

  Future<void> _openScanOptions() async {
    final updated = await Navigator.push<ScanOptions>(
      context,
      MaterialPageRoute(
        builder: (_) => ScanOptionsScreen(
            initial: _scanOptions, pluginVersion: _pluginVersion!),
      ),
    );
    if (updated != null) {
      final imageContainerSavedPath = updated.scanResultConfig.imageContainer?.saved?.path;
      if (imageContainerSavedPath != null && imageContainerSavedPath.isEmpty) {
        updated.scanResultConfig.imageContainer?.saved?.path = await _getDefaultImageSavePath();
      }
      setState(() => _scanOptions = updated);
    }
  }

  void _showInfoDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plugin version: ${_pluginVersion ?? '…'}'),
            Text('SDK version: ${_sdkVersion ?? '…'}'),
            const SizedBox(height: 8),
            const Text('SDK init info:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              const JsonEncoder.withIndent('  ').convert(_sdkInitSucceedInfo?.toJson() ?? {}),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              ConfigBrowserWidget(
                configsByGroup: _configsByGroup,
                isScanning: _isScanning,
                onConfigSelected: _onConfigSelected,
                onEditSaveAs: _openViewConfigEditor,
                onDelete: _deleteUserConfig,
              ),
              Expanded(child: _buildContentArea()),
            ],
          ),
          if (_isInitializing) _buildLoadingOverlay(),
          if (!_isInitializing && _initError != null) _buildErrorOverlay(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Infinity Plugin Examples'),
      actions: [
        IconButton(
          icon: Icon(_useNativeView ? Icons.view_compact : Icons.open_in_new),
          tooltip: _useNativeView
              ? 'Mode: Native View (tap to switch)'
              : 'Mode: New Screen (tap to switch)',
          onPressed: _isScanning
              ? null
              : () {
                  final next = !_useNativeView;
                  setState(() => _useNativeView = next);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(next
                        ? 'Native View: camera renders inside the app'
                        : 'New Screen: SDK opens its own fullscreen UI'),
                    duration: const Duration(seconds: 2),
                  ));
                },
        ),
        IconButton(
          icon: const Icon(Icons.tune),
          tooltip: 'Scan Options',
          onPressed: _isScanning ? null : _openScanOptions,
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: _showInfoDialog,
          tooltip: 'Info',
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  /// Builds the main content area below the config browser.
  ///
  /// - NativeView mode: [AnylineNativeView] is always present in the widget
  ///   tree (not gated on [_isScanning]) so its platform view is registered in
  ///   [NativeViewRegistry] before [requestScanStart] is called. It expands
  ///   when scanning and shrinks when idle, matching the legacy NativeView
  ///   example pattern.
  /// - New Screen mode: result list fills the space.
  Widget _buildContentArea() {
    if (_useNativeView) {
      return Column(
        children: [
          Expanded(
            flex: _isScanning ? 2 : 1,
            child: const AnylineNativeView(),
          ),
          Expanded(
            flex: 1,
            child: ResultListWidget(
              results: _results,
              isScanning: _isScanning,
              onReportUCR: _reportUCR,
              onStop: _stopScanning,
            ),
          ),
        ],
      );
    }
    return ResultListWidget(
      results: _results,
      isScanning: _isScanning,
      onReportUCR: _reportUCR,
      onStop: _stopScanning,
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Initializing SDK…',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorOverlay() {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            const Text(
              'SDK Initialization Failed',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _initError ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _initializeSdk,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}