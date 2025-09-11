import 'dart:async';
import 'dart:convert';

import 'package:anyline_plugin/constants.dart';
import 'package:anyline_plugin/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

/// Entrypoint for performing any scans using the Anyline OCR library.
class AnylinePlugin {
  AnylinePlugin() {
    setupWrapperSession();
  }
  static const MethodChannel _channel = MethodChannel('anyline_plugin');

  /// Returns the Anyline SDK version the plugin currently is powered by.
  static Future<String?> get sdkVersion async {
    final String? version =
        await _channel.invokeMethod(Constants.METHOD_GET_SDK_VERSION);
    return version;
  }

  /// Returns the Anyline Plugin version.
  static Future<String> get pluginVersion async {
    final fileContent =
        await rootBundle.loadString('packages/anyline_plugin/pubspec.yaml');
    final pubspec = Pubspec.parse(fileContent);
    return pubspec.version?.toString() ?? '';
  }

  void setupWrapperSession() async {
    final Map<String, String?> params = {
      Constants.EXTRA_PLUGIN_VERSION: await pluginVersion
    };
    _channel.invokeMethod(Constants.METHOD_SETUP_WRAPPER_SESSION, params);
  }

  void setCustomModelsPath(String customModelsPath) {
    final Map<String, String?> params = {
      Constants.EXTRA_CUSTOM_MODELS_PATH: customModelsPath
    };
    _channel.invokeMethod(Constants.METHOD_SET_CUSTOM_MODELS_PATH, params);
  }

  void setViewConfigsPath(String viewConfigsPath) {
    final Map<String, String?> params = {
      Constants.EXTRA_VIEW_CONFIGS_PATH: viewConfigsPath
    };
    _channel.invokeMethod(Constants.METHOD_SET_VIEW_CONFIGS_PATH, params);
  }

  Future<bool?> initSdk(String licenseKey,
      {bool enableOfflineCache = false}) async {
    final String pluginVersion = await AnylinePlugin.pluginVersion;

    final Map<String, dynamic> params = {
      Constants.EXTRA_LICENSE_KEY: licenseKey,
      Constants.EXTRA_ENABLE_OFFLINE_CACHE: enableOfflineCache,
      Constants.EXTRA_PLUGIN_VERSION: pluginVersion
    };
    try {
      final bool? result =
          await _channel.invokeMethod(Constants.METHOD_SET_LICENSE_KEY, params);
      return result;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('${e.message}');
      }
      throw AnylineException.parse(e);
    }
  }

  /// Starts the Anyline SDK and invokes the scanning process with the given [configJson].
  ///
  /// Returns the result as a JSON string which can be parsed into an object of
  /// your choice. For more information about the possible forms of the JSON result
  /// and how to parse it, visit the [Anyline Documentation](https://documentation.anyline.com).
  ///
  /// Uses the third-party-package `permission_handler` to request camera permissions.
  Future<String?> startScanning(String configJson,
      [String? initializationParams, String? callbackConfig]) async {
    final Map<String, String?> config = {
      Constants.EXTRA_CONFIG_JSON: configJson,
      Constants.EXTRA_INITIALIZATION_PARAMETERS: initializationParams,
      Constants.EXTRA_SCAN_CALLBACK_CONFIG: callbackConfig
    };
    try {
      final String? result =
          await _channel.invokeMethod(Constants.METHOD_START_ANYLINE, config);
      return result;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('${e.message}');
      }
      throw AnylineException.parse(e);
    }
  }

  void tryStopScan([String? scanStopRequestParams]) {
    final Map<String, String?> params = {
      Constants.EXTRA_STOP_CONFIG: scanStopRequestParams
    };
    _channel.invokeMethod(Constants.METHOD_STOP_ANYLINE, params);
  }

  // Export all cached events and return the created zip file path.
  // The zip archive will be stored in a temporary folder in order to be copied afterwards.
  //
  // Return null if there are no events.
  //
  static Future<String?> exportCachedEvents() async {
    try {
      final String? result = await _channel.invokeMethod(
          Constants.METHOD_EXPORT_CACHED_EVENTS, null);
      return result;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('${e.message}');
      }
      throw AnylineException.parse(e);
    }
  }

  /// Converts the original JSON string based on its structure and the number of scan results.
  /// - If the decoded JSON is a List and has more than one item, it wraps each item in a key like "result3", "result4", etc.,
  ///   starting from [initialOrdinalResultIndex].
  /// - If it's already a Map or a single-item List, it returns the original string unchanged.
  String convertResultsWithImagePathString(
    String originalResultsWithImagePathString,
    int initialOrdinalResultIndex,
  ) {
    final decodedJson = json.decode(originalResultsWithImagePathString);

    if (decodedJson is List && decodedJson.length > 1) {
      final Map<String, dynamic> jsonResultObject = {};

      for (int i = 0; i < decodedJson.length; i++) {
        jsonResultObject['result${initialOrdinalResultIndex + i}'] =
            decodedJson[i];
      }

      return json.encode(jsonResultObject);
    } else {
      return '"result$initialOrdinalResultIndex": $originalResultsWithImagePathString';
    }
  }
}
