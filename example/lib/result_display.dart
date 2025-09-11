import 'dart:convert';
import 'dart:io';

import 'package:anyline_plugin_example/result.dart';
import 'package:anyline_plugin_example/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

import 'package:anyline_plugin_example/scan_modes.dart';

class ResultDisplay extends StatelessWidget {
  const ResultDisplay({Key? key}) : super(key: key);

  static const routeName = '/resultDisplay';

  @override
  Widget build(BuildContext context) {
    final Result result = ModalRoute.of(context)!.settings.arguments as Result;

    return Scaffold(
      backgroundColor: Styles.backgroundBlack,
      appBar: AppBar(
        backgroundColor: Styles.backgroundBlack,
        centerTitle: true,
        title: Text(
          '${result.scanMode.label} Result',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w400),
        ),
        elevation: 0,
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          color: Colors.white,
          child: ResultDetails(result.jsonMap),
        ),
      ),
    );
  }
}

class CompositeResultDisplay extends StatelessWidget {
  const CompositeResultDisplay({Key? key}) : super(key: key);

  static const routeName = '/compositeResultDisplay';
  static const displayResultMax = 10;

  @override
  Widget build(BuildContext context) {
    final Result result = ModalRoute.of(context)!.settings.arguments as Result;

    var subResults = result.jsonMap!.values.take(displayResultMax);

    List<Map<String, dynamic>> results = [
      for (final j in subResults) j as Map<String, dynamic>
    ];

    return DefaultTabController(
      length: results.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Styles.backgroundBlack,
          bottom: TabBar(
            tabs: createResultTabs(results),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Styles.anylineBlue,
            labelStyle: GoogleFonts.montserrat(),
          ),
          title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                result.scanMode.label,
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w400),
              )),
        ),
        body: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: TabBarView(
            children: createResultTabViews(results),
          ),
        ),
      ),
    );
  }

  List<Tab> createResultTabs(List<Map<String, dynamic>> results) {
    List<Tab> resultTabs = [];
    for (var i = 1; (i <= results.length) && (i <= displayResultMax); i++) {
      resultTabs.add(Tab(
        text: 'Result $i',
      ));
    }
    return resultTabs;
  }

  List<ResultDetails> createResultTabViews(List<Map<String, dynamic>> results) {
    List<ResultDetails> resultTabViews = [];
    for (var i = 0; (i < results.length) && (i < displayResultMax); i++) {
      resultTabViews.add(ResultDetails(results[i]));
    }
    return resultTabViews;
  }
}

class ResultDetails extends StatelessWidget {
  ResultDetails(Map<String, dynamic>? json, {Key? key})
      : json = json,
        super(key: key) {
    orderedJson = [];
    imageMap = Map<String, dynamic>();
    nativeBarcodesDetected = [];

    var actualResultMap = Map<String, dynamic>();

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Container(
              color: Colors.black87,
              child: Image.file(
                File(imageMap!['imagePath'] as String),
                fit: BoxFit.scaleDown,
                height:
                    240, // prevents weird display of tall images (e.g. vertical shipping containers)
              )),
          ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: orderedJson!.length,
              itemBuilder: (BuildContext ctx, int index) {
                Map<String, dynamic> resultMap = orderedJson![index];
                var title = resultMap.keys.first.toString();
                var subTitle = resultMap.values.first.toString();
                return ListTile(
                  title: Text(title),
                  subtitle: Text(
                    subTitle,
                    style: TextStyle(
                        fontFamily: 'Courier',
                        fontFamilyFallback: <String>[
                          // specify a list here that the system
                          // will try in order
                          // "American Typewriter",
                          // "Avenir Book",
                          'Roboto Mono'
                        ]),
                  ),
                  contentPadding: EdgeInsets.all(4),
                );
              }),
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: TextButton(
              child: Text('Show Full Image'),
              onPressed: () {
                Navigator.pushNamed(context, FullScreenImage.routeName,
                    arguments: imageMap!['fullImagePath']);
              },
            ),
          )
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({Key? key}) : super(key: key);

  static const routeName = '/resultDisplay/fullImage';

  @override
  Widget build(BuildContext context) {
    final String fullImagePath =
        ModalRoute.of(context)!.settings.arguments as String;

    return GestureDetector(
      child: PhotoView(
        imageProvider: FileImage(File(fullImagePath)),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
