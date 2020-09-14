import 'dart:async';

import 'package:anyline_plugin/constants.dart';
import 'package:flutter/services.dart';

class AnylinePlugin {
  static const MethodChannel _channel = const MethodChannel('anyline_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get sdkVersion async {
    final String version =
        await _channel.invokeMethod(Constants.METHOD_GET_SDK_VERSION);
    return version;
  }

  static Future<AnylinePlugin> createInstance() async {
    final AnylinePlugin anylinePluginInstance = AnylinePlugin._internal();
    return anylinePluginInstance;
  }

  AnylinePlugin._internal();

  _setLicenseKey(String licenseKey) async {
    final Map<String, String> arguments = {
      Constants.EXTRA_LICENSE_KEY: licenseKey
    };
    try {
      return await _channel.invokeMethod(
          Constants.METHOD_SET_LICENSE_KEY, arguments);
    } catch (exception) {
      // TODO: Exception Handling
      // License Key

    }
  }

  Future<String> startScanning(String configJson) async {
    final Map<String, String> config = {
      Constants.EXTRA_CONFIG_JSON: configJson
    };
    try {
      final String result =
          await _channel.invokeMethod(Constants.METHOD_START_ANYLINE, config);
      return result;
    } catch (exception) {
      // TODO: Exception Handling
      // Camera Permission
      // Invalid Json
      // Core Exceptions
    }
    return '';
  }
}
