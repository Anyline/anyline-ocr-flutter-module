import 'package:anyline_plugin_example/scan_modes.dart';

class Result {
  DateTime timestamp;
  ScanMode scanMode;
  Map<String, dynamic> jsonMap;

  Result(this.jsonMap, this.scanMode, this.timestamp);

  int get length {
    return jsonMap.length;
  }

  get values {
    return jsonMap.values.toList();
  }

  get keys {
    return jsonMap.keys.toList();
  }
}

class CompositeResult {}
