import 'dart:convert';

import 'package:anyline_plugin/anyline_plugin.dart';
import 'package:anyline_plugin_example/result.dart';
import 'package:anyline_plugin_example/scan_modes.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AnylineService {
  Future<Result> scan(ScanMode mode);

  List<Result> getResultList();

  String getSdkVersion();
}

class AnylineServiceImpl implements AnylineService {
  AnylinePlugin anylinePlugin;
  List<Result> _results = [];
  String _sdkVersion = 'Unknown';

  Future<Result> scan(ScanMode mode) async {
    try {
      Result result = await _callAnyline(mode);
      _saveResultToResultList(result);
      return result;
    } catch (e, s) {
      print('$e, $s');
      return null;
    }
  }

  List<Result> getResultList() {
    return _results;
  }

  AnylineServiceImpl() {
    _initAnylinePlugin();
    _initResultListFromSharedPreferences();
  }

  String getSdkVersion() {
    return _sdkVersion;
  }

  _initAnylinePlugin() async {
    String sdkVersion;
    try {
      sdkVersion = await AnylinePlugin.sdkVersion;
      anylinePlugin = AnylinePlugin();
    } on PlatformException {
      sdkVersion = 'Failed to get SDK version.';
    }
    _sdkVersion = sdkVersion;
  }

  _initResultListFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('results') ?? [];
    List<Result> results = [
      for (String result in list) Result.fromJson(json.decode(result))
    ];
    _results = results;
  }

  Future<Result> _callAnyline(ScanMode mode) async {
    String configJson = await _loadJsonConfigFromFile(mode.key);

    String stringResult = await anylinePlugin.startScanning(configJson);

    Map<String, dynamic> jsonResult = jsonDecode(stringResult);
    return Result(jsonResult, mode, DateTime.now());
  }

  Future<String> _loadJsonConfigFromFile(String config) async {
    return await rootBundle.loadString("config/${config}Config.json");
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
