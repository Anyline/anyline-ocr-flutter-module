import 'dart:convert';

import 'package:anyline_plugin/anyline_plugin.dart';
import 'package:anyline_plugin/constants.dart';
import 'package:anyline_plugin_example/env_info.dart';
import 'package:anyline_plugin_example/license_state.dart';
import 'package:anyline_plugin_example/result.dart';
import 'package:anyline_plugin_example/scan_modes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

abstract class AnylineService {
  Future<Result?> scan(ScanMode mode);

  List<Result> getResultList();

  String? getSdkVersion();

  String? getPluginVersion();
}

class AnylineServiceImpl implements AnylineService {
  AnylineServiceImpl() {
    _initAnylinePlugin();
    _initResultListFromSharedPreferences();
  }

  static const MethodChannel _channel = MethodChannel('anyline_plugin');

  static const String NATIVE_METHOD_ON_RESULT_EVENT =
      'NATIVE_METHOD_ON_RESULT_EVENT';
  static const String NATIVE_METHOD_ON_UI_ELEMENT_CLICKED =
      'NATIVE_METHOD_ON_UI_ELEMENT_CLICKED';
  static const maxContinuousResultCount = 10;

  late String? _cachePath;

  late AnylinePlugin anylinePlugin;
  LicenseState licenseState = LicenseState(false, 'Sdk not initialised');
  List<Result> _results = [];
  String? _sdkVersion = 'Unknown';
  String? _pluginVersion = 'Unknown';

  var _continuousResults = '';
  int _continuousCount = 0;

  Future<LicenseState> _initSdk(String licenseKey) async {
    try {
      await anylinePlugin.initSdk(licenseKey);
      licenseState = LicenseState(true, '');
    } catch (anylineException) {
      licenseState = LicenseState(false, anylineException.toString());
      rethrow;
    }
    return licenseState;
  }

  @override
  Future<Result?> scan(ScanMode mode) async {
    Result? result = await _callAnyline(mode);
    if (result == null) {
      return result;
    }
    _saveResultToResultList(result);
    return result;
  }

  @override
  List<Result> getResultList() {
    return _results;
  }

  @override
  String? getSdkVersion() {
    return _sdkVersion;
  }

  @override
  String? getPluginVersion() {
    return _pluginVersion;
  }

  void _initAnylinePlugin() async {
    String? sdkVersion;
    try {
      sdkVersion = await AnylinePlugin.sdkVersion;
    } on PlatformException {
      sdkVersion = 'Failed to get SDK version.';
    }
    _sdkVersion = sdkVersion;
    _pluginVersion = await AnylinePlugin.pluginVersion;

    anylinePlugin = AnylinePlugin();
    anylinePlugin.setCustomModelsPath('flutter_assets/custom_scripts');
    anylinePlugin.setViewConfigsPath('flutter_assets/config');
  }

  void _initResultListFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('results') ?? [];

    _cachePath = await _channel
        .invokeMethod(Constants.METHOD_GET_APPLICATION_CACHE_PATH);

    List<Result> modifiedResults = [];
    for (final String result in list) {
      Result? res = resultFromJSONString(result);
      if (res != null) {
        modifiedResults.add(res);
      }
    }
    _results = modifiedResults;
  }

  // ACO: get the 2 image file paths for each result. If their directories are
  // different from the current cache directory, fix their paths.
  Result? resultFromJSONString(String result) {
    Result res = Result.fromJson(json.decode(result) as Map<String, dynamic>);
    if (_cachePath == null) {
      return res;
    }
    if (res.jsonMap == null) {
      return res;
    }

    // to avoid an exception, don't list the result that doesn't have an image
    if (res.jsonMap!['fullImagePath'] == null ||
        res.jsonMap!['imagePath'] == null) {
      return null;
    }

    var savedImageDirectory =
        path.dirname(res.jsonMap!['fullImagePath'] as String);

    var fullImageName = path.basename(res.jsonMap!['fullImagePath'] as String);
    var croppedImageName = path.basename(res.jsonMap!['imagePath'] as String);

    if (savedImageDirectory != _cachePath) {
      res.jsonMap!['fullImagePath'] = path.join(_cachePath!, fullImageName);
      res.jsonMap!['imagePath'] = path.join(_cachePath!, croppedImageName);
    }
    return res;
  }

  Future<Result?> _callAnyline(ScanMode mode) async {
    if (!licenseState.initialized) {
      String externalLicenseKey = await _getExternalLicenseKey();
      await _initSdk(externalLicenseKey);
    }

    String configJson = await _getConfigJson(mode);

    String? stringResult;
    if (mode.isContinuous()) {
      _continuousResults = '';
      _continuousCount = 0;

      _channel.setMethodCallHandler((MethodCall methodCall) async {
        switch (methodCall.method) {
          case NATIVE_METHOD_ON_RESULT_EVENT:
            if (_continuousResults.isNotEmpty) {
              _continuousResults += ', ';
            }

            _continuousResults +=
                anylinePlugin.convertResultsWithImagePathString(
                    methodCall.arguments.toString(), _continuousCount);

            _continuousCount++;
            if (_continuousCount > maxContinuousResultCount) {
              anylinePlugin.tryStopScan(null);
            }
            break;
          case NATIVE_METHOD_ON_UI_ELEMENT_CLICKED:
            // clicked UI elements clicked events can be handled here
            break;
        }
      });

      String callbackConfigString =
          '{ "onResultEventName": "$NATIVE_METHOD_ON_RESULT_EVENT" }';

      await anylinePlugin.startScanning(configJson, null, callbackConfigString);
      if (_continuousResults.isEmpty) {
        stringResult = 'Canceled';
      } else {
        stringResult = '{$_continuousResults}';
      }
    } else {
      stringResult = await anylinePlugin.startScanning(configJson);
    }

    if (kDebugMode) {
      print(stringResult);
    }

    if (stringResult == 'Canceled') {
      return null;
    }

    Map<String, dynamic>? jsonResult =
        jsonDecode(stringResult!) as Map<String, dynamic>;

    return Result(jsonResult, mode, DateTime.now());
  }

  Future<String> _loadJsonConfigFromFile(String config) async {
    return rootBundle.loadString('config/${config}Config.json');
  }

  /// Returns the licenseKey stored in associated file from the config folder.
  Future<String> _getExternalLicenseKey() async {
    return EnvInfo.licenseKey ?? '';
  }

  /// Returns the config string for a given scan mode in JSON format, reading the
  /// associated file from the config folder.
  Future<String> _getConfigJson(ScanMode mode) async {
    String configJson = await _loadJsonConfigFromFile(mode.key);
    return configJson;
  }

  void _saveResultToResultList(Result result) {
    _results.insert(0, result);
    _saveResultListToSharedPreferences(_results);
  }

  void _saveResultListToSharedPreferences(List<Result> results) async {
    List<String> results = [
      for (final Result result in _results) json.encode(result.toJson())
    ];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('results', results);
  }
}
