import 'dart:async';
import 'dart:convert';

import 'package:anyline/anyline_plugin.dart';
import 'package:anyline_plugin_example/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'result_display.dart';
import 'result_list.dart';
import 'scan_modes.dart';

const Color anylineBlue = Color(0xFF0099FF);

class AnylineDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ResultDisplay.routeName: (context) => ResultDisplay(),
        FullScreenImage.routeName: (context) => FullScreenImage(),
        CompositeResultDisplay.routeName: (context) => CompositeResultDisplay(),
      },
      home: AnylineDemo(),
      theme: ThemeData.light().copyWith(
        accentColor: Colors.black87,
        scaffoldBackgroundColor: Colors.black87,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
    );
  }
}

class AnylineDemo extends StatefulWidget {
  @override
  _AnylineDemoState createState() => _AnylineDemoState();
}

class _AnylineDemoState extends State<AnylineDemo> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _backButton = false;

  Widget _scanTab;
  Widget _resultsTab;

// LAYOUT PART

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildNavBar(),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100),
      child: AppBar(
        toolbarHeight: 100,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Visibility(
          visible: _backButton,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: IconButton(
              alignment: Alignment.bottomLeft,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Center(
          child: Image.asset(
            'assets/anyline_flutter_appbar.png',
            fit: BoxFit.fitHeight,
            height: 60,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: IconButton(
                alignment: Alignment.bottomRight,
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black87,
      selectedItemColor: anylineBlue,
      unselectedItemColor: Colors.white,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.filter_center_focus), title: Text('Scan')),
        BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('Results')),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  Widget _buildBody() {
    return _selectedIndex == 0 ? _UseCases : ResultList([]);
  }

  Widget _UseCases = Center(
    child: Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                UseCaseButton(
                  text: 'Meter\nScanning',
                  image: AssetImage('assets/Meter.png'),
                ),
                UseCaseButton(
                  text: 'Barcode',
                  image: AssetImage('assets/Barcode.png'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                UseCaseButton(
                  text: 'Identity',
                  image: AssetImage('assets/ID.png'),
                ),
                UseCaseButton(
                  text: 'Vehicle',
                  image: AssetImage('assets/Vehicle.png'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                UseCaseButton(
                  text: 'OCR',
                  image: AssetImage('assets/OCR.png'),
                ),
                UseCaseButton(
                  text: 'Other',
                  image: AssetImage('assets/Other.png'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _MeterReading = Center(
    child: Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          ScanButton(
            text: 'Analog Meter',
          ),
          ScanButton(
            text: 'Digital Meter',
          ),
          ScanButton(
            text: 'Serial Number',
          ),
          ScanButton(
            text: 'Dial Meter',
          ),
          ScanButton(
            text: 'Dot Matrix',
          ),
        ],
      ),
    ),
  );

  Widget _Identity = Center(
    child: Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          ScanButton(
            text: 'Universal ID',
          ),
          ScanButton(
            text: 'Driving License',
          ),
          ScanButton(
            text: 'MRZ',
          ),
          ScanButton(
            text: 'German ID Front',
          ),
          ScanButton(
            text: 'PDF 417',
          ),
        ],
      ),
    ),
  );

  Widget _Vehicle = Center(
    child: Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          ScanButton(
            text: 'License Plate',
          ),
          ScanButton(
            text: 'TIN',
          ),
          ScanButton(
            text: 'VIN',
          ),
        ],
      ),
    ),
  );

  Widget _OCR = Center(
    child: Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          ScanButton(
            text: 'USNR',
          ),
          ScanButton(
            text: 'Shipping Container',
          ),
          ScanButton(
            text: 'IBAN',
          ),
          ScanButton(
            text: 'Voucher Code',
          ),
          ScanButton(
            text: 'Cattle Tag',
          ),
        ],
      ),
    ),
  );

  Widget _Other = Center(
    child: Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          ScanButton(
            text: 'Document Scanner',
          ),
          ScanButton(
            text: 'Serial Scanning',
          ),
          ScanButton(
            text: 'Parallel Scanning',
          ),
        ],
      ),
    ),
  );
}

class ScanButton extends StatelessWidget {
  ScanButton({@required this.text});

  final String text;
  final Function onPressed = () {};

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        child: FlatButton(
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0))),
          textColor: Colors.white,
          color: anylineBlue,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              overflow: Overflow.clip,
              alignment: Alignment.bottomLeft,
              children: [
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(text,
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                ),
                Positioned(
                  bottom: -15,
                  left: -5,
                  child: Opacity(
                    opacity: 0.25,
                    child: Text(text,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 50)),
                  ),
                ),
              ],
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class UseCaseButton extends StatelessWidget {
  UseCaseButton({this.image, @required this.text});

  final ImageProvider image;
  final String text;
  final Function onPressed = () {};

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        child: FlatButton(
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0))),
          textColor: Colors.white,
          color: anylineBlue,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Positioned(
                    top: 10,
                    right: 10,
                    child: Image(
                      image: image,
                      height: 60,
                    )),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(text,
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                ),
                Positioned(
                  bottom: -15,
                  left: -5,
                  child: Opacity(
                    opacity: 0.25,
                    child: Text(text,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 40)),
                  ),
                ),
              ],
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
