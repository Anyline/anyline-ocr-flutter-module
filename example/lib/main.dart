import 'dart:async';
import 'dart:convert';

import 'package:anyline_plugin/anyline_plugin.dart';
import 'package:anyline_plugin_example/env_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:anyline_plugin_example/home.dart';

void main() {
  EnvInfo.initialize();
  runApp(AnylineDemoApp());
}

/// This is just a minimal example function to show how to use our plugin as
/// fast as possible. For the complete example app implementation, please refer to
/// the Flutter example app in the documentation.
void scanWithAnyline() async {
  /// Instantiate the plugin.
  var anylinePlugin = AnylinePlugin();

  /// Load the config file which also includes the license key (for more info
  /// visit documentation.anyline.com).
  var config = await rootBundle.loadString('config/AnalogMeterConfig.json');

  /// Start the scanning process.
  var stringResult =
      await (anylinePlugin.startScanning(config) as FutureOr<String>);

  /// Convert the stringResult to a Map to access the result fields. It is
  /// recommended to create result classes that fit your use case. For more
  /// information on that, visit the Flutter Guide on documentation.anyline.com.
  Map<String, dynamic>? result =
      jsonDecode(stringResult) as Map<String, dynamic>;

  if (kDebugMode) {
    print(result);
  }
}
