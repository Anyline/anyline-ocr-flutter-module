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
    final List<Map<String, dynamic>> results =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("History"),
      ),
      body: results.length > 0
          ? ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext ctx, int index) {
                DateTime timestamp = results[index]['timestamp'];
                String timestampString = timestamp.isToday()
                    ? 'Today, ${time.format(timestamp)}'
                    : timestamp.isYesterday()
                        ? 'Yesterday, ${time.format(timestamp)}'
                        : fullDate.format(timestamp);

                return Card(
                  child: InkWell(
                      splashColor: Colors.black87.withAlpha(30),
                      onTap: () {
                        Navigator.pushNamed(context, ResultDisplay.routeName,
                            arguments: results[index]);
                      },
                      child: Column(
                        children: [
                          Image.file(File(results[index]['imagePath'])),
                          ListTile(
                            title: Text(results[index]['useCase']),
                            subtitle: Text(timestampString),
                          ),
                        ],
                      )),
                );
              })
          : Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 35),
              child: Text(
                'Empty history',
                style: TextStyle(color: Colors.grey),
              ),
            ),
    );
  }
}
