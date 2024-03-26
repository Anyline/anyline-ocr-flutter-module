import 'dart:convert';

import 'package:anyline_plugin/anyline_plugin.dart';
import 'package:anyline_plugin/constants.dart';
import 'package:anyline_plugin_example/license_state.dart';
import 'package:anyline_plugin_example/result.dart';
import 'package:anyline_plugin_example/scan_modes.dart';
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
  static const MethodChannel _channel = const MethodChannel('anyline_plugin');

  late String? _cachePath;

  late AnylinePlugin anylinePlugin;
  LicenseState licenseState = new LicenseState(false, 'Sdk not initialised');
  List<Result> _results = [];
  String? _sdkVersion = 'Unknown';
  String? _pluginVersion = 'Unknown';

  AnylineServiceImpl() {
    _initAnylinePlugin();
    _initResultListFromSharedPreferences();
  }

  Future<LicenseState> _initSdk(String licenseKey) async {
    try {
      await anylinePlugin.initSdk(licenseKey);
      licenseState = new LicenseState(true, "");
    } catch (anylineException) {
      licenseState = new LicenseState(false, anylineException.toString());
      throw anylineException;
    }
    return licenseState;
  }

  Future<Result?> scan(ScanMode mode) async {
    Result? result = await _callAnyline(mode);
    if (result == null) {
      return result;
    }
    _saveResultToResultList(result);
    return result;
  }

  List<Result> getResultList() {
    return _results;
  }

  String? getSdkVersion() {
    return _sdkVersion;
  }

  String? getPluginVersion() {
    return _pluginVersion;
  }

  _initAnylinePlugin() async {
    String? sdkVersion;
    try {
      sdkVersion = await AnylinePlugin.sdkVersion;
    } on PlatformException {
      sdkVersion = 'Failed to get SDK version.';
    }
    _sdkVersion = sdkVersion;
    _pluginVersion = await AnylinePlugin.pluginVersion;

    anylinePlugin = AnylinePlugin();
    anylinePlugin.setCustomModelsPath("flutter_assets/custom_scripts");
    anylinePlugin.setViewConfigsPath("flutter_assets/config");
  }

  _initResultListFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('results') ?? [];

    _cachePath = await _channel
        .invokeMethod(Constants.METHOD_GET_APPLICATION_CACHE_PATH);

    List<Result> modifiedResults = [];
    for (String result in list) {
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
    Result res = Result.fromJson(json.decode(result));
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

    var savedImageDirectory = path.dirname(res.jsonMap!['fullImagePath']);

    var fullImageName = path.basename(res.jsonMap!['fullImagePath']);
    var croppedImageName = path.basename(res.jsonMap!['imagePath']);

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

    String? stringResult = await anylinePlugin.startScanning(configJson);

    print(stringResult);

    if (stringResult == 'Canceled') {
      return null;
    }

    Map<String, dynamic>? jsonResult = jsonDecode(stringResult!);

    return Result(jsonResult, mode, DateTime.now());
  }

  Future<String> _loadJsonConfigFromFile(String config) async {
    return await rootBundle.loadString("config/${config}Config.json");
  }

  /// Returns the licenseKey stored in associated file from the config folder.
  Future<String> _getExternalLicenseKey() async {
    Map<String, dynamic>? licenseKeyMap;
    String externalLicenseKeyJson = "";
    try {
      externalLicenseKeyJson =
          await rootBundle.loadString("config/license.json");
      licenseKeyMap = jsonDecode(externalLicenseKeyJson);
    } catch (e) {
      print("exception: $e");
    }
    return licenseKeyMap?["licenseKey"] ?? "";
  }

  /// Returns the config string for a given scan mode in JSON format, reading the
  /// associated file from the config folder.
  Future<String> _getConfigJson(ScanMode mode) async {
    String configJson = await _loadJsonConfigFromFile(mode.key);
    return configJson;
  }

  _saveResultToResultList(Result result) {
    _results.insert(0, result);
    _saveResultListToSharedPreferences(_results);
  }

  _saveResultListToSharedPreferences(List<Result> results) async {
    List<String> results = [
      for (Result result in _results) json.encode(result.toJson())
    ];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('results', results);
  }
}
