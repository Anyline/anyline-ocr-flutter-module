import 'dart:async';
import 'dart:convert';

import 'package:anyline_plugin/constants.dart';
import 'package:anyline_plugin/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

/// Entrypoint for performing any scans using the Anyline OCR library.
class AnylinePlugin {
  AnylinePlugin();
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
      [String? initializationParams]) async {
    final Map<String, String?> config = {
      Constants.EXTRA_CONFIG_JSON: configJson,
      Constants.EXTRA_INITIALIZATION_PARAMETERS: initializationParams
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
    return null;
  }

  /// Decodes the license and returns the expiration date.
  ///
  /// Can be provided with a full configJson string or with just the license string.
  static String? getLicenseExpiryDate(String base64License) {
    Map<String, dynamic> licenseMap =
        _decodeBase64LicenseToJsonMap(base64License)!;
    return licenseMap['valid'] as String?;
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

  static Map<String, dynamic>? _decodeBase64LicenseToJsonMap(
      String base64License) {
    Codec<String, String> base64ToString = ascii.fuse(base64);
    String licenseString = base64ToString.decode(base64License);
    String licenseJson = _extractJsonFromLicenseString(licenseString);
    return jsonDecode(licenseJson) as Map<String, dynamic>?;
  }

  static String _extractJsonFromLicenseString(String licenseJson) {
    return licenseJson.substring(0, licenseJson.lastIndexOf('}') + 1);
  }
}
