import 'dart:io';

import 'package:anyline_plugin_example/result.dart';
import 'package:anyline_plugin_example/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

import 'scan_modes.dart';

class ResultDisplay extends StatelessWidget {
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
          "${result.scanMode.label} Result",
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
  static const routeName = '/compositeResultDisplay';

  @override
  Widget build(BuildContext context) {
    final Result result = ModalRoute.of(context)!.settings.arguments as Result;

    var subResults = result.jsonMap!.values.take(3);

    List<Map<String, dynamic>> results = [
      for (Map<String, dynamic> j in subResults as Iterable<Map<String, dynamic>>) j,
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
                "${result.scanMode.label}",
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
    for (var i = 1; (i <= results.length) && (i <= 3); i++) {
      resultTabs.add(Tab(
        text: 'Result $i',
      ));
    }
    return resultTabs;
  }

  List<ResultDetails> createResultTabViews(List<Map<String, dynamic>> results) {
    List<ResultDetails> resultTabViews = [];
    for (var i = 0; (i < results.length) && (i < 3); i++) {
      resultTabViews.add(ResultDetails(results[i]));
    }
    return resultTabViews;
  }
}

class ResultDetails extends StatelessWidget {
  final Map<String, dynamic>? json;

  ResultDetails(this.json);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Container(
              child: Image.file(
                File(json!['imagePath']),
                fit: BoxFit.scaleDown,
                height:
                    240, // prevents weird display of tall images (e.g. vertical shipping containers)
              ),
              color: Colors.black87),
          ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: json!.length,
              itemBuilder: (BuildContext ctx, int index) {
                return new ListTile(
                  title: Text(json!.values.toList()[index].toString()),
                  subtitle: Text(json!.keys.toList()[index].toString()),
                );
              }),
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: TextButton(
              child: Text('Show Full Image'),
              onPressed: () {
                Navigator.pushNamed(context, FullScreenImage.routeName,
                    arguments: json!['fullImagePath']);
              },

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
    final String fullImagePath = ModalRoute.of(context)!.settings.arguments as String;

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
