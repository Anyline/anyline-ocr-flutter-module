import 'result.dart';
import 'scan_modes.dart';
import 'styles.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:intl/intl.dart';
import 'date_helpers.dart';

import 'result_display.dart';

class ResultList extends StatelessWidget {
  ResultList(this.results, {Key? key}) : super(key: key);
  static const routeName = '/resultList';
  final fullDate = DateFormat('d/M/y, HH:mm');
  final time = DateFormat('HH:mm');

  final List<Result> results;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: results.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: results.length,
              itemBuilder: (BuildContext ctx, int index) {
                DateTime timestamp = results[index].timestamp;
                String timestampString;
                if (timestamp.isToday()) {
                  timestampString = 'Today, ${time.format(timestamp)}';
                } else if (timestamp.isYesterday()) {
                  timestampString = 'Yesterday, ${time.format(timestamp)}';
                } else {
                  timestampString = fullDate.format(timestamp);
                }

                return (results[index].scanMode.isCompositeScan() ||
                        results[index].scanMode.isContinuous())
                    ? CompositeResultListItem(results[index], timestampString)
                    : ResultListItem(results[index], timestampString);
              })
          : ListView(children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 35),
                child: const Text(
                  'Empty history',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ]),
    );
  }
}

class CompositeResultListItem extends StatelessWidget {
  CompositeResultListItem(this.result, this.timestamp, {Key? key})
      : super(key: key);
  final Result result;
  final String timestamp;

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
      padding: const EdgeInsets.all(10),
      child: TextButton(
          style: flatButtonStyle,
          onPressed: () {
            Navigator.pushNamed(context, CompositeResultDisplay.routeName,
                arguments: result);
          },
          child: Stack(
            children: [
              const Positioned(
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
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                      dense: true,
                      title: Text(
                        result.scanMode.label,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      subtitle: Text(
                        timestamp,
                        style: const TextStyle(
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
  ResultListItem(this.result, this.timestamp, {Key? key}) : super(key: key);
  final Result result;
  final String timestamp;

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: const BorderSide(width: 0, color: Styles.anylineBlue)),
    padding: EdgeInsets.zero,
    backgroundColor: Styles.anylineBlue,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextButton(
          style: flatButtonStyle,
          onPressed: () {
            Navigator.pushNamed(context, ResultDisplay.routeName,
                arguments: result);
          },
          child: Stack(
            children: [
              const Positioned(
                bottom: -15,
                right: -5,
                child: Opacity(
                  opacity: 0.2,
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
                  const SizedBox(
                    height: 5,
                  ),
                  Image.file(File(result.jsonMap!['imagePath'] as String)),
                  ListTile(
                      dense: true,
                      title: Text(
                        result.scanMode.label,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      subtitle: Text(
                        timestamp,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w100),
                      )),
                ],
              ),
            ],
          )),
    );
  }
}
