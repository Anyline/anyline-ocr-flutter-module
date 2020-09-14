import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:photo_view/photo_view.dart';
import 'package:flutter/services.dart';
import 'package:anyline_plugin/anyline_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ResultDisplay.routeName: (context) => ResultDisplay(),
        FullScreenImage.routeName: (context) => FullScreenImage(),
      },
      home: AnylineDemo(),
    );
  }
}

class AnylineDemo extends StatefulWidget {
  @override
  _AnylineDemoState createState() => _AnylineDemoState();
}

class _AnylineDemoState extends State<AnylineDemo> {
  AnylinePlugin anylinePlugin;

  String _sdkVersion = 'Unknown';
  String _result = 'Empty';
  String _configJson = 'Loading...';

  @override
  void initState() {
    super.initState();
    initSdkState();
  }

  Future<void> initSdkState() async {
    String sdkVersion;
    try {
      sdkVersion = await AnylinePlugin.sdkVersion;
      anylinePlugin = await AnylinePlugin.createInstance();
    } on PlatformException {
      sdkVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  Future<void> startAnyline(String config) async {
    try {
      await _loadJsonConfigFromFile(config);
      String result = await anylinePlugin.startScanning(_configJson);
      Navigator.pushNamed(context, ResultDisplay.routeName, arguments: result);

      setState(() {
        _result = result;
      });

      print(result);
    } catch (e) {
      // TODO: Exception Handling
    }
  }

  Future<void> _loadJsonConfigFromFile(String config) async {
    String configJson =
        await rootBundle.loadString("config/${config}Config.json");

    setState(() {
      _configJson = configJson;
    });
  }

  // LAYOUT PART

  Widget _heading6(String text) {
    return Text(text, style: Theme.of(context).textTheme.headline6);
  }

  Widget _scanButton(String label, String configPath) {
    return Container(
      child: MaterialButton(
        onPressed: () {
          startAnyline(configPath);
        },
        child: Text(label),
        color: Colors.black87,
        textColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anyline Plugin Demo'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
              icon: Icon(Icons.folder_special),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ResultDisplay()));
              })
        ],
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
          children: [
            _heading6('METER READING'),
            _scanButton('Analog Meter', 'AnalogMeter'),
            _scanButton('Digital Meter', 'DigitalMeter'),
            _scanButton('Serial Number', 'SerialNumber'),
            _scanButton('Dial Meter', 'DialMeter'),
            _scanButton('Dot Matrix', 'DotMatrix'),
            _heading6('ID'),
            _scanButton('Driving License', 'DrivingLicense'),
            _scanButton('MRZ', 'MRZ'),
            _scanButton('German ID Front', 'GermanIDFront'),
            _scanButton('Barcode PDF417', 'Barcode_PDF417'),
            _scanButton('Universal ID', 'UniversalId'),
            _heading6('VEHICLE'),
            _scanButton('License Plate', 'LicensePlate'),
            _scanButton('TIN', 'TIN'),
            _heading6('OCR'),
            _scanButton('IBAN', 'Iban'),
            _scanButton('Voucher Code', 'Voucher'),
            _heading6('MRO'),
            _scanButton('Vehicle Identification Number', 'VIN'),
            _scanButton('Universal Serial Number', 'USNR'),
            _scanButton('Container', 'ContainerShip'),
            _heading6('OTHER'),
            _scanButton('Barcode', 'Barcode'),
            _scanButton('Document', 'Document'),
            _scanButton('Cattle Tag', 'CattleTag'),
            _scanButton('Serial Scanning (LP>DL>VIN)', 'SerialScanning'),
            _scanButton('Parallel Scanning (Meter/USRN)', 'ParallelScanning'),
            Divider(),
            Text('Running on Anyline SDK Version $_sdkVersion\n'),
          ],
        ),
      ),
    );
  }
}

class ResultDisplay extends StatelessWidget {
  static const routeName = '/resultDisplay';

  @override
  Widget build(BuildContext context) {
    final String data = ModalRoute.of(context).settings.arguments;
    print(data);
    Map<String, dynamic> json = jsonDecode(data);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Result"),
      ),
      body: ListView(
        children: [
          Image.file(File(json['imagePath'])),
          ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: json.length,
              itemBuilder: (BuildContext ctx, int index) {
                return new ListTile(
                  title: Text(json.values.toList()[index].toString()),
                  subtitle: Text(json.keys.toList()[index].toString()),
                );
              }),
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: RaisedButton(
              child: Text('Show Full Image'),
              onPressed: () {
                Navigator.pushNamed(context, FullScreenImage.routeName,
                    arguments: json['fullImagePath']);
              },
              color: Colors.black87,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  static const routeName = '/resultDisplay/fullImage';

  @override
  Widget build(BuildContext context) {
    final String fullImagePath = ModalRoute.of(context).settings.arguments;

    return GestureDetector(
      child: Container(
        child: PhotoView(
          imageProvider: FileImage(File(fullImagePath)),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
