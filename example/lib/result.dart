import 'package:anyline_plugin_example/scan_modes.dart';

class Result {
  Result.fromJson(Map<String, dynamic> json)
      : timestamp =
            DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
        scanMode = ScanMode.values
            .firstWhere((element) => element.key == json['scanMode']),
        jsonMap = json['jsonMap'] as Map<String, dynamic>;

  Result(this.jsonMap, this.scanMode, this.timestamp);
  DateTime timestamp;
  ScanMode scanMode;
  Map<String, dynamic>? jsonMap;

  int get length {
    return jsonMap!.length;
  }

  List<dynamic> get values {
    return jsonMap!.values.toList();
  }

  List<String> get keys {
    return jsonMap!.keys.toList();
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.millisecondsSinceEpoch,
        'scanMode': scanMode.key,
        'jsonMap': jsonMap,
      };
}
