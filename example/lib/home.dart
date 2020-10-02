import 'dart:async';
import 'dart:ui';

import 'package:anyline_plugin_example/anyline_service.dart';
import 'package:anyline_plugin_example/result.dart';
import 'package:anyline_plugin_example/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'result_display.dart';
import 'result_list.dart';
import 'scan_modes.dart';

class AnylineDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anyline Flutter Demo',
      routes: {
        ResultDisplay.routeName: (context) => ResultDisplay(),
        FullScreenImage.routeName: (context) => FullScreenImage(),
        CompositeResultDisplay.routeName: (context) => CompositeResultDisplay(),
      },
      home: Home(),
      theme: ThemeData.light().copyWith(
        accentColor: Styles.backgroundBlack,
        scaffoldBackgroundColor: Styles.backgroundBlack,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomSelectedIndex = 0;

  bool _scanTabBackButtonVisible = false;
  bool _resultsTabBackButtonVisible = false;

  Widget _scanTab;
  Widget _resultsTab;

  AnylineService _anylineService;

  @override
  void initState() {
    super.initState();
    _anylineService = AnylineServiceImpl();
    _scanTab = _buildUseCases();
    _resultsTab = _buildResultList();
  }

  Future<void> scan(ScanMode mode) async {
    Result result = await _anylineService.scan(mode);
    _openResultDisplay(result);
  }

  _openResultDisplay(Result result) {
    Navigator.pushNamed(
        context,
        result.scanMode.isCompositeScan()
            ? CompositeResultDisplay.routeName
            : ResultDisplay.routeName,
        arguments: result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildNavBar(),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
          visible: _bottomSelectedIndex == 0
              ? _scanTabBackButtonVisible
              : _resultsTabBackButtonVisible,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _bottomSelectedIndex == 0
                        ? _scanTab = _buildUseCases()
                        : _resultsTab = _buildResultList();
                    _scanTabBackButtonVisible = false;
                  });
                },
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
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          elevation: 0,
                          title: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Anyline Flutter Demo App',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          content: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                  'SDK Version ${_anylineService.getSdkVersion()}')),
                        ));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return BottomNavigationBar(
      backgroundColor: Styles.backgroundBlack,
      selectedItemColor: Styles.anylineBlue,
      unselectedItemColor: Colors.white,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.filter_center_focus), title: Text('Scan')),
        BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('Results')),
      ],
      currentIndex: _bottomSelectedIndex,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  Widget _buildBody() {
    return _bottomSelectedIndex == 0 ? _buildScanTab() : _buildResultList();
  }

  Widget _buildScanTab() {
    return _scanTab;
  }

  Widget _buildResultList() {
    return ResultList(_anylineService.getResultList());
  }

  Widget _buildUseCases() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  UseCaseButton(
                    text: 'Meter\nScanning',
                    image: AssetImage('assets/Meter.png'),
                    onPressed: () {
                      setState(() {
                        _scanTab = _buildMeterReading();
                        _scanTabBackButtonVisible = true;
                      });
                    },
                  ),
                  UseCaseButton(
                    text: 'Barcode',
                    image: AssetImage('assets/Barcode.png'),
                    onPressed: () {
                      scan(ScanMode.Barcode);
                    },
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
                    onPressed: () {
                      setState(() {
                        _scanTab = _buildIdentity();
                        _scanTabBackButtonVisible = true;
                      });
                    },
                  ),
                  UseCaseButton(
                    text: 'Vehicle',
                    image: AssetImage('assets/Vehicle.png'),
                    onPressed: () {
                      setState(() {
                        _scanTab = _buildVehicle();
                        _scanTabBackButtonVisible = true;
                      });
                    },
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
                    onPressed: () {
                      setState(() {
                        _scanTab = _buildOCR();
                        _scanTabBackButtonVisible = true;
                      });
                    },
                  ),
                  UseCaseButton(
                    text: 'Other',
                    image: AssetImage('assets/Other.png'),
                    onPressed: () {
                      setState(() {
                        _scanTab = _buildOther();
                        _scanTabBackButtonVisible = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeterReading() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ScanButton(
              text: 'Analog Meter',
              onPressed: () {
                scan(ScanMode.AnalogMeter);
              },
            ),
            ScanButton(
              text: 'Digital Meter',
              onPressed: () {
                scan(ScanMode.DigitalMeter);
              },
            ),
            ScanButton(
              text: 'Serial Number',
              onPressed: () {
                scan(ScanMode.SerialNumber);
              },
            ),
            ScanButton(
              text: 'Dial Meter',
              onPressed: () {
                scan(ScanMode.DialMeter);
              },
            ),
            ScanButton(
              text: 'Dot Matrix',
              onPressed: () {
                scan(ScanMode.DotMatrix);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentity() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ScanButton(
              text: 'Universal ID',
              onPressed: () {
                scan(ScanMode.UniversalId);
              },
            ),
            ScanButton(
              text: 'Driving License',
              onPressed: () {
                scan(ScanMode.DrivingLicense);
              },
            ),
            ScanButton(
              text: 'MRZ',
              onPressed: () {
                scan(ScanMode.MRZ);
              },
            ),
            ScanButton(
              text: 'German ID Front',
              onPressed: () {
                scan(ScanMode.GermanIDFront);
              },
            ),
            ScanButton(
              text: 'PDF 417',
              onPressed: () {
                scan(ScanMode.Barcode_PDF417);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicle() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ScanButton(
              text: 'License Plate',
              onPressed: () {
                scan(ScanMode.LicensePlate);
              },
            ),
            ScanButton(
              text: 'TIN',
              onPressed: () {
                scan(ScanMode.TIN);
              },
            ),
            ScanButton(
              text: 'VIN',
              onPressed: () {
                scan(ScanMode.VIN);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOCR() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ScanButton(
              text: 'USNR',
              onPressed: () {
                scan(ScanMode.USNR);
              },
            ),
            ScanButton(
              text: 'Shipping Container',
              onPressed: () {
                scan(ScanMode.ContainerShip);
              },
            ),
            ScanButton(
              text: 'IBAN',
              onPressed: () {
                scan(ScanMode.Iban);
              },
            ),
            ScanButton(
              text: 'Voucher Code',
              onPressed: () {
                scan(ScanMode.Voucher);
              },
            ),
            ScanButton(
              text: 'Cattle Tag',
              onPressed: () {
                scan(ScanMode.CattleTag);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOther() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ScanButton(
              text: 'Document Scanner',
              onPressed: () {
                scan(ScanMode.Document);
              },
            ),
            ScanButton(
              text: 'Serial Scanning (LP>DL>VIN)',
              onPressed: () {
                scan(ScanMode.SerialScanning);
              },
            ),
            ScanButton(
              text: 'Parallel Scanning (Meter/USRN)',
              onPressed: () {
                scan(ScanMode.ParallelScanning);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScanButton extends StatelessWidget {
  ScanButton({@required this.text, this.onPressed});

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        child: FlatButton(
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textColor: Colors.white,
          color: Styles.anylineBlue,
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
  UseCaseButton({this.image, @required this.text, this.onPressed});

  final ImageProvider image;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        child: FlatButton(
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textColor: Colors.white,
          color: Styles.anylineBlue,
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
