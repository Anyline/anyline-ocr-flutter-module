import 'dart:convert';

import 'package:anyline_plugin_example/result.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'scan_modes.dart';

class ResultDisplay extends StatelessWidget {
  static const routeName = '/resultDisplay';

  @override
  Widget build(BuildContext context) {
    final Result result = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("${result.scanMode.label} Result"),
      ),
      body: ResultDetails(result.jsonMap),
    );
  }
}

class CompositeResultDisplay extends StatelessWidget {
  static const routeName = '/compositeResultDisplay';

  @override
  Widget build(BuildContext context) {
    final Result result = ModalRoute.of(context).settings.arguments;

    var subResults = result.jsonMap.values.take(3);

    List<Map<String, dynamic>> results = [
      for (Map<String, dynamic> j in subResults) j,
    ];

    return DefaultTabController(
      length: results.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          bottom: TabBar(
            tabs: createResultTabs(results),
          ),
          title: Text(result.scanMode.label),
        ),
        body: TabBarView(
          children: createResultTabViews(results),
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
  final Map<String, dynamic> json;

  ResultDetails(this.json);

  @override
  Widget build(BuildContext context) {
    return ListView(
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
