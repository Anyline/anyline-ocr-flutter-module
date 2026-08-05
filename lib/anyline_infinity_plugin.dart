import 'dart:async';

import 'package:anyline_plugin/models/sdk_config.dart';
import 'package:anyline_plugin/models/wrapper_session_parameters.dart';
import 'package:flutter/services.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:flutter/foundation.dart';

const String _channelName = 'anyline_infinity_plugin';

const String _methodSetupWrapperSession = 'INFINITY_SETUP_WRAPPER_SESSION';
const String _methodRequestSdkInitialization =
    'INFINITY_REQUEST_SDK_INITIALIZATION';
const String _methodRequestScanStart = 'INFINITY_REQUEST_SCAN_START';
const String _methodRequestScanSwitchWithScanStartRequestParams =
    'INFINITY_REQUEST_SCAN_SWITCH_WITH_SCAN_START_REQUEST_PARAMS';
const String _methodRequestScanSwitchWithScanViewConfigContentString =
    'INFINITY_REQUEST_SCAN_SWITCH_WITH_SCAN_VIEW_CONFIG_CONTENT_STRING';
const String _methodRequestScanStop = 'INFINITY_REQUEST_SCAN_STOP';
const String _methodRequestUcrReport = 'INFINITY_REQUEST_UCR_REPORT';
const String _methodRequestExportCachedEvents =
    'INFINITY_REQUEST_EXPORT_CACHED_EVENTS';
const String _methodGetSDKVersion = 'INFINITY_GET_SDK_VERSION';

const String _eventOnScanResults = 'INFINITY_ON_SCAN_RESULTS';
const String _eventOnUiElementClicked = 'INFINITY_ON_UI_ELEMENT_CLICKED';

const String _extraPluginVersion = 'EXTRA_PLUGIN_VERSION';
const String _extraRequest = 'request';

/// Entrypoint for the Anyline Infinity scanning API.
///
/// Exposes a typed, schema-driven interface that mirrors WrapperSessionProvider
/// directly. JSON serialization/deserialization is handled in this Dart layer;
/// the native bridge only passes raw JSON strings.
class AnylineInfinityPlugin {
  static const MethodChannel _channel = MethodChannel(_channelName);

  final StreamController<WrapperSessionScanResultsResponse>
      _scanResultsController =
      StreamController<WrapperSessionScanResultsResponse>.broadcast();

  final StreamController<UiFeedbackElementConfig> _uiElementClickedController =
      StreamController<UiFeedbackElementConfig>.broadcast();

  /// Completes when [_setupWrapperSession] has finished sending the session
  /// setup request to the native side. Awaited by all public API methods to
  /// guarantee they run after the wrapper session is set up.
  late final Future<void> _wrapperSessionSetup;

  // ignore: sort_constructors_first
  AnylineInfinityPlugin() {
    _channel.setMethodCallHandler(_handleMethodCall);
    _wrapperSessionSetup = _setupWrapperSession();
  }

  /// Emits one result per detected item during the active scan session (0..N).
  Stream<WrapperSessionScanResultsResponse> get onScanResults =>
      _scanResultsController.stream;

  /// Emits when the user taps a UI feedback element during scanning (0..N).
  Stream<UiFeedbackElementConfig> get onUIElementClicked =>
      _uiElementClickedController.stream;

  static Future<String> get _pluginVersion async {
    final fileContent =
        await rootBundle.loadString('packages/anyline_plugin/pubspec.yaml');
    final pubspec = Pubspec.parse(fileContent);
    return pubspec.version?.toString() ?? '';
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case _eventOnScanResults:
        _handleScanResults(call.arguments);
        break;
      case _eventOnUiElementClicked:
        _handleUiElementClicked(call.arguments);
        break;
    }
  }

  void _handleScanResults(dynamic arguments) {
    if (arguments is! String) return;
    try {
      _scanResultsController
          .add(WrapperSessionScanResultsResponse.fromRawJson(arguments));
    } catch (e) {
      if (kDebugMode) {
        print('AnylineInfinityPlugin: failed to parse onScanResults: $e');
      }
    }
  }

  void _handleUiElementClicked(dynamic arguments) {
    if (arguments is! String) return;
    try {
      _uiElementClickedController
          .add(UiFeedbackElementConfig.fromRawJson(arguments));
    } catch (e) {
      if (kDebugMode) {
        print('AnylineInfinityPlugin: failed to parse onUIElementClicked: $e');
      }
    }
  }

  Future<void> _setupWrapperSession() async {
    final version = await _pluginVersion;
    _channel.invokeMethod(_methodSetupWrapperSession, {
      _extraPluginVersion: version,
    });
  }

  /// Returns the plugin version string.
  Future<String> getPluginVersion() => _pluginVersion;

  /// Returns the native SDK version string.
  Future<String?> getSDKVersion() async {
    await _wrapperSessionSetup;
    return _channel.invokeMethod(_methodGetSDKVersion);
  }

  /// Initializes the Anyline SDK with the supplied request parameters.
  Future<WrapperSessionSdkInitializationResponse> requestSdkInitialization(
      WrapperSessionSdkInitializationRequest request) async {
    await _wrapperSessionSetup;
    final String? resultJson = await _channel.invokeMethod(
        _methodRequestSdkInitialization, {_extraRequest: request.toRawJson()});
    return WrapperSessionSdkInitializationResponse.fromRawJson(resultJson!);
  }

  /// Starts a scanning session.
  ///
  /// Resolves with the lifecycle response when the session ends
  /// (success / failure / abort). Intermediate scan results and UI element
  /// click events arrive via [onScanResults] and [onUIElementClicked].
  Future<WrapperSessionScanResponse> requestScanStart(
      WrapperSessionScanStartRequest request) async {
    await _wrapperSessionSetup;
    final String? resultJson = await _channel.invokeMethod(
        _methodRequestScanStart, {_extraRequest: request.toRawJson()});
    return WrapperSessionScanResponse.fromRawJson(resultJson!);
  }

  /// Switches to a new scan mode using the provided scan-start request.
  Future<void> requestScanSwitchWithScanStartRequestParams(
      WrapperSessionScanStartRequest request) async {
    await _wrapperSessionSetup;
    _channel.invokeMethod(_methodRequestScanSwitchWithScanStartRequestParams,
        {_extraRequest: request.toRawJson()});
  }

  /// Switches to a new scan mode using a raw ScanViewConfig JSON string.
  Future<void> requestScanSwitchWithScanViewConfigContentString(
      String scanViewConfigContentString) async {
    await _wrapperSessionSetup;
    _channel.invokeMethod(
        _methodRequestScanSwitchWithScanViewConfigContentString,
        {_extraRequest: scanViewConfigContentString});
  }

  /// Stops the active scanning session.
  Future<void> requestScanStop([WrapperSessionScanStopRequest? request]) async {
    await _wrapperSessionSetup;
    _channel.invokeMethod(_methodRequestScanStop,
        request != null ? {_extraRequest: request.toRawJson()} : null);
  }

  /// Submits a User Corrected Result (UCR) report.
  Future<WrapperSessionUcrReportResponse> requestUCRReport(
      WrapperSessionUcrReportRequest request) async {
    await _wrapperSessionSetup;
    final String? resultJson = await _channel.invokeMethod(
        _methodRequestUcrReport, {_extraRequest: request.toRawJson()});
    return WrapperSessionUcrReportResponse.fromRawJson(resultJson!);
  }

  /// Exports all cached scan events as a ZIP archive.
  ///
  /// Returns null if there are no cached events.
  Future<WrapperSessionExportCachedEventsResponse>
      requestExportCachedEvents() async {
    await _wrapperSessionSetup;
    final String? resultJson =
        await _channel.invokeMethod(_methodRequestExportCachedEvents);
    return WrapperSessionExportCachedEventsResponse.fromRawJson(resultJson!);
  }

  /// Releases stream resources. Call when the plugin instance is no longer needed.
  void dispose() {
    _scanResultsController.close();
    _uiElementClickedController.close();
  }
}
