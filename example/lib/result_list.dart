import 'package:anyline_plugin_example/result.dart';
import 'package:anyline_plugin_example/scan_modes.dart';
import 'package:anyline_plugin_example/styles.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'date_helpers.dart';

import 'result_display.dart';

class ResultList extends StatelessWidget {
  static const routeName = '/resultList';
  final fullDate = DateFormat('d/M/y, HH:mm');
  final time = DateFormat('HH:mm');

  final List<Result> results;

  ResultList(this.results);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: results.length > 0
          ? ListView.builder(
          padding: EdgeInsets.all(10),
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
  final Result result;
  final String timestamp;

  CompositeResultListItem(this.result, this.timestamp);

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    padding: EdgeInsets.zero,
    foregroundColor: Styles.anylineBlue,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextButton(
        style: flatButtonStyle,
          onPressed: () {
            Navigator.pushNamed(context, CompositeResultDisplay.routeName,
                arguments: result);
          },
          child: Stack(
            children: [
              Positioned(
                bottom: -15,
                right: -5,
                child: Opacity(
                  opacity: 0.25,
                  child: Text('Result',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 50,
                        color: Colors.white,
                      )),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                      dense: true,
                      title: Text(
                        result.scanMode.label,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      subtitle: Text(
                        timestamp,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w100),
                      )),
                ],
              ),
            ],
          )),
    );
  }
}

class ResultListItem extends StatelessWidget {
  final Result result;
  final String timestamp;

  ResultListItem(this.result, this.timestamp);

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    padding: EdgeInsets.zero,
    foregroundColor: Styles.anylineBlue,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextButton(
        style: flatButtonStyle,
          onPressed: () {
            Navigator.pushNamed(context, ResultDisplay.routeName,
                arguments: result);
          },
          child: Stack(
            children: [
              Positioned(
                bottom: -15,
                right: -5,
                child: Opacity(
                  opacity: 0.25,
                  child: Text('Result',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 50,
                        color: Colors.white,
                      )),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Image.file(File(result.jsonMap!['imagePath'])),
                  ListTile(
                      dense: true,
                      title: Text(
                        result.scanMode.label,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      subtitle: Text(
                        timestamp,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w100),
                      )),
                ],
              ),
            ],
          )),
    );
  }
}
