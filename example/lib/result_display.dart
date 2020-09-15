import 'package:flutter/material.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';

class ResultDisplay extends StatelessWidget {
  static const routeName = '/resultDisplay';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> json = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("${json['useCase']} Result"),
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
