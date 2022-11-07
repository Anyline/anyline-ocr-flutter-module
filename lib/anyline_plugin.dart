import 'dart:async';
import 'dart:convert';

import 'package:anyline_plugin/constants.dart';
import 'package:anyline_plugin/exceptions.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Entrypoint for perfoming any scans using the Anyline OCR library.
class AnylinePlugin {
  static const MethodChannel _channel = const MethodChannel('anyline_plugin');

  AnylinePlugin();

  /// Returns the Anyline SDK version the plugin currently is powered by.
  static Future<String?> get sdkVersion async {
    final String? version =
        await _channel.invokeMethod(Constants.METHOD_GET_SDK_VERSION);
    return version;
  }

  /// Starts the Anyline SDK and invokes the scanning process with the given [configJson].
  ///
  /// Returns the result as a JSON string which can be parsed into an object of
  /// your choice. For more information about the possible forms of the JSON result
  /// and how to parse it, visit the [Anyline Documentation](https://documentation.anyline.com).
  ///
  /// Uses the third-party-package `permission_handler` to request camera permissions.
  Future<String?> startScanning(String configJson) async {
    if (await Permission.camera.isPermanentlyDenied) {
      openAppSettings();
    } else if (await Permission.camera.request().isGranted) {
      final Map<String, String> config = {
        Constants.EXTRA_CONFIG_JSON: configJson
      };
      try {
        final String? result =
            await _channel.invokeMethod(Constants.METHOD_START_ANYLINE, config);
        return result;
      } on PlatformException catch (e) {
        throw AnylineException.parse(e);
      }
    } else {
      throw AnylineCameraPermissionException('Camera permission missing.');
    }
    return null;
  }

  /// Decodes the license and returns the expiration date.
  ///
  /// Can be provided with a full configJson string or with just the license string.
  static String? getLicenseExpiryDate(String base64License) {
    Map<String, dynamic> licenseMap =
        _decodeBase64LicenseToJsonMap(base64License)!;
    return licenseMap['valid'];
  }

  static Map<String, dynamic>? _decodeBase64LicenseToJsonMap(
      String base64License) {
    Codec<String, String> base64ToString = ascii.fuse(base64);
    String licenseString = base64ToString.decode(base64License);
    String licenseJson = _extractJsonFromLicenseString(licenseString);
    return jsonDecode(licenseJson);
  }

  static String _extractJsonFromLicenseString(String licenseJson) {
    return licenseJson.substring(0, licenseJson.lastIndexOf('}') + 1);
  }
}
