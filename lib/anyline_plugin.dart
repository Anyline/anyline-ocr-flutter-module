import 'dart:async';

import 'package:anyline_plugin/constants.dart';
import 'package:anyline_plugin/exceptions.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AnylinePlugin {
  static const MethodChannel _channel = const MethodChannel('anyline_plugin');

  static Future<String> get sdkVersion async {
    final String version =
        await _channel.invokeMethod(Constants.METHOD_GET_SDK_VERSION);
    return version;
  }

  AnylinePlugin();

  Future<String> startScanning(String configJson) async {
    if (await Permission.camera.isPermanentlyDenied) {
      openAppSettings();
    } else if (await Permission.camera.request().isGranted) {
      final Map<String, String> config = {
        Constants.EXTRA_CONFIG_JSON: configJson
      };
      try {
        final String result =
            await _channel.invokeMethod(Constants.METHOD_START_ANYLINE, config);
        return result;
      } on PlatformException catch (e) {
        throw AnylineException.parse(e);
      }
    } else {
      throw AnylineCameraPermissionException('Camera permission missing.');
    }
  }
}
