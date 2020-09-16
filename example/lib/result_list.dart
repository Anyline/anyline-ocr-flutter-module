import 'package:anyline_plugin_example/result.dart';
import 'package:anyline_plugin_example/scan_modes.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'date_helpers.dart';

import 'result_display.dart';

class ResultList extends StatelessWidget {
  static const routeName = '/resultList';
  var fullDate = DateFormat('d/M/y, HH:mm');
  var time = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    final List<Result> results = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("History"),
      ),
      body: results.length > 0
          ? ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext ctx, int index) {
                DateTime timestamp = results[index].timestamp;
                String timestampString = timestamp.isToday()
                    ? 'Today, ${time.format(timestamp)}'
                    : timestamp.isYesterday()
                        ? 'Yesterday, ${time.format(timestamp)}'
                        : fullDate.format(timestamp);

                return results[index].scanMode.isCompositeScan()
                    ? CompositeResultListItem(results[index], timestampString)
                    : ResultListItem(results[index], timestampString);
              })
          : ListView(children: [
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 35),
                child: Text(
                  'Empty history',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ]),
    );
  }
}

class CompositeResultListItem extends StatelessWidget {
  Result result;
  String timestamp;

  CompositeResultListItem(this.result, this.timestamp);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          splashColor: Colors.black87.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, CompositeResultDisplay.routeName,
                arguments: result);
          },
          child: Column(
            children: [
              ListTile(
                title: Text(result.scanMode.label),
                subtitle: Text(timestamp),
              ),
            ],
          )),
    );
  }
}

class ResultListItem extends StatelessWidget {
  Result result;
  String timestamp;

  ResultListItem(this.result, this.timestamp);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
          splashColor: Colors.black87.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, ResultDisplay.routeName,
                arguments: result);
          },
          child: Column(
            children: [
              Image.file(File(result.jsonMap['imagePath'])),

              ListTile(
                title: Text(result.scanMode.label),
                subtitle: Text(timestamp),
              ),
            ],
          )),
    );
  }
}
