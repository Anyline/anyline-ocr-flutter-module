import 'dart:async';
import 'dart:convert';

import 'package:anyline_plugin/anyline_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home.dart';

void main() {
  runApp(AnylineDemoApp());
}

/// This is just a minimal example function to show how to use our plugin as
/// fast as possible. For the code of our Flutter example app check out the
/// [anyline_demo] module.
void scanWithAnyline() async {
  /// Instantiate the plugin.
  var anylinePlugin = AnylinePlugin();

  /// Load the config file which also includes the license key (for more info
  /// visit documentation.anyline.com).
  var config = await rootBundle.loadString("config/AnalogMeterConfig.json");

  /// Start the scanning process.
  var stringResult =
      await (anylinePlugin.startScanning(config) as FutureOr<String>);

  /// Convert the stringResult to a Map to access the result fields. It is
  /// recommended to create result classes that fit your use case. For more
  /// information on that, visit the Flutter Guide on documentation.anyline.com.
  Map<String, dynamic>? result = jsonDecode(stringResult);

  print(result);
}
