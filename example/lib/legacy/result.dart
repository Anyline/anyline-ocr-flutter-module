import 'dart:convert';

import 'scan_modes.dart';

class Result {
  Result.fromJson(Map<String, dynamic> json)
      : timestamp =
            DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
        scanMode = ScanMode.values
            .firstWhere((element) => element.key == json['scanMode']),
        jsonMap = json['jsonMap'] as Map<String, dynamic>,
        resultInfo = ResultInfo(json['jsonMap'] as Map<String, dynamic>);

  Result(this.jsonMap, this.scanMode, this.timestamp) {
    resultInfo = ResultInfo(jsonMap);
  }

  DateTime timestamp;
  ScanMode scanMode;
  Map<String, dynamic>? jsonMap;
  late ResultInfo resultInfo;

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

class ResultInfo {
  ResultInfo(this.json) {
    orderedJson = [];
    imageMap = <String, dynamic>{};
    nativeBarcodesDetected = [];

    var actualResultMap = <String, dynamic>{};

    // NOTE: keep xxxResult on top, nativeBarcodesDetected, imagePath and fullImagePath at the bottom
    json?.forEach((key, value) {
      if (key.toLowerCase().endsWith('imagepath')) {
        imageMap![key] = value;
        return;
      }
      if (key.toLowerCase().endsWith('result')) {
        // but not native barcode results
        actualResultMap[key] = value;
        return;
      }
      if (key.toLowerCase() == 'nativebarcodesdetected') {
        nativeBarcodesDetected?.add(value);
        return;
      }

      orderedJson!.add({key: value});
    });

    actualResultMap.forEach((key, value) {
      var encoder = JsonEncoder.withIndent(' ' * 2);
      var prettyJSON = encoder.convert(value);
      orderedJson!.insert(0, {key: prettyJSON});
    });

    if (nativeBarcodesDetected != null && nativeBarcodesDetected!.isNotEmpty) {
      orderedJson!.add({'nativeBarcodesDetected': nativeBarcodesDetected});
    }

    dynamic imagePath;

    imagePath = imageMap?['imagePath'];
    if (imagePath != null && imagePath.toString().isNotEmpty) {
      orderedJson!.add({'imagePath': imagePath});
    }

    imagePath = imageMap?['fullImagePath'];
    if (imagePath != null && imagePath.toString().isNotEmpty) {
      orderedJson!.add({'fullImagePath': imagePath});
    }
  }
  final Map<String, dynamic>? json;
  late final Map<String, dynamic>? imageMap;
  late final List<Map<String, dynamic>>? orderedJson;
  late final List<dynamic>? nativeBarcodesDetected;
}
