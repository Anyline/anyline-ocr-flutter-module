import 'dart:async';

import 'package:anyline_plugin/exceptions.dart';
import 'package:anyline_plugin_example/infinity/main_scan_screen.dart';
import 'anyline_service.dart';
import 'native_view_scan.dart';
import 'result.dart';
import 'styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:anyline_plugin_example/app_home.dart';
import 'result_display.dart';
import 'result_list.dart';
import 'scan_modes.dart';
import 'license_state.dart';

class AnylineDemoApp extends StatelessWidget {
  const AnylineDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anyline Flutter Demo',
      routes: {
        Home.routeName: (context) => const Home(),
        ResultDisplay.routeName: (context) => const ResultDisplay(),
        FullScreenImage.routeName: (context) => const FullScreenImage(),
        CompositeResultDisplay.routeName: (context) => const CompositeResultDisplay(),
        NativeViewScan.routeName: (context) => const NativeViewScan(),
        InfinityMainScanScreen.routeName: (context) =>
            const InfinityMainScanScreen(),
      },
      home: const AppHome(),
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Styles.backgroundBlack,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Styles.backgroundBlack),
      ),
    );
  }
}

class Home extends StatefulWidget {
  static const routeName = '/legacy';

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomSelectedIndex = 0;

  bool _scanTabBackButtonVisible = false;
  final bool _resultsTabBackButtonVisible = false;

  Widget? _scanTab;

  late AnylineService _anylineService;

  @override
  void initState() {
    super.initState();

    // Lock to portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    Future(() async {
      try {
        _anylineService = await AnylineServiceImpl.create();
      } catch (e) {
        String errorMessage;
        if (e is AnylineException) {
          errorMessage = e.message ?? '';
        } else {
          errorMessage = e.toString();
        }
        if (mounted) {
          _showErrorDialog(context, errorMessage);
        }
      }
    });
    _scanTab = _buildUseCases();
  }

  @override
  void dispose() {
    // Reset orientation when leaving home screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> scan(ScanMode mode) async {
    try {
      Result? result = await _anylineService.scan(mode);
      if (result != null && mounted) {
        _openResultDisplay(result);
      }
    } catch (e) {
      String message;

      // Print debug information
      if (kDebugMode) {
        print('[ERROR] Caught exception type: ${e.runtimeType}');
        print('[ERROR] Exception details: $e');
      }

      // Handle different exception types
      if (e is AnylineLicenseException) {
        message = LicenseState.LicenseKeyEmptyErrorMessage;
      } else if (e is AnylineException) {
        message = e.message ?? 'Unknown Anyline error';
      } else if (e is AssertionError) {
        message = 'Initialization error: ${e.message ?? e.toString()}';
        if (kDebugMode) {
          print('[ERROR] AssertionError message: ${e.message}');
        }
      } else {
        message = 'Unexpected error: ${e.toString()}';
      }

      if (kDebugMode) {
        print('[ERROR] Final error message: $message');
      }

      if (mounted) {
        _showErrorDialog(context, message);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
              elevation: 0,
              title: const Text(
                'Error',
                style: TextStyle(
                    fontFamily: 'Roboto', fontWeight: FontWeight.bold),
              ),
              content: Text(
                message,
                style: const TextStyle(fontFamily: 'Roboto'),
                textAlign: TextAlign.start,
              ),
              actions: [
                TextButton(
                  child: const Text('OK',
                      style: TextStyle(
                          fontFamily: 'Roboto', fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  void _openResultDisplay(Result result) {
    Navigator.pushNamed(
        context,
        (result.scanMode.isCompositeScan() || result.scanMode.isContinuous())
            ? CompositeResultDisplay.routeName
            : ResultDisplay.routeName,
        arguments: result);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          bool willPopScreen = _scanTabBackButtonVisible ? false : true;
          if (_scanTabBackButtonVisible) {
            setState(() {
              if (_bottomSelectedIndex == 0) {
                _scanTab = _buildUseCases();
              }
              _scanTabBackButtonVisible = false;
            });
          }
          return Future.value(willPopScreen);
        },
        child: Scaffold(
          appBar: _buildAppBar() as PreferredSizeWidget?,
          bottomNavigationBar: _buildNavBar(),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: _buildBody(),
          ),
        ));
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
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
              padding: const EdgeInsets.only(bottom: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (_bottomSelectedIndex == 0) {
                      _scanTab = _buildUseCases();
                    }
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
            padding: const EdgeInsets.only(bottom: 8.0),
            child: IconButton(
              alignment: Alignment.bottomRight,
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog<void>(
                    context: context,
                    builder: (_) => AlertDialog(
                          elevation: 0,
                          title: const FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                'Anyline Flutter Demo App',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          content: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                  'SDK Version ${_anylineService.getSdkVersion()}'
                                  '\n'
                                  'Plugin Version ${_anylineService.getPluginVersion()}')),
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
        const BottomNavigationBarItem(
            icon: Icon(Icons.filter_center_focus), label: 'Scan'),
        const BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Results'),
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

  Widget? _buildBody() {
    return _bottomSelectedIndex == 0 ? _buildScanTab() : _buildResultList();
  }

  Widget? _buildScanTab() {
    return _scanTab;
  }

  Widget _buildResultList() {
    return ResultList(_anylineService.getResultList());
  }

  Widget _buildUseCases() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  UseCaseButton(
                    text: 'Meter\nScanning',
                    image: const AssetImage('assets/Meter.png'),
                    onPressed: () {
                      scan(ScanMode.AnalogDigitalMeter);
                    },
                  ),
                  UseCaseButton(
                    text: 'Barcode',
                    image: const AssetImage('assets/Barcode.png'),
                    onPressed: () {
                      setState(() {
                        _scanTab = _buildBarcode();
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
                    text: 'Identity',
                    image: const AssetImage('assets/ID.png'),
                    onPressed: () {
                      setState(() {
                        _scanTab = _buildIdentity();
                        _scanTabBackButtonVisible = true;
                      });
                    },
                  ),
                  UseCaseButton(
                    text: 'Vehicle',
                    image: const AssetImage('assets/Vehicle.png'),
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
                    image: const AssetImage('assets/OCR.png'),
                    onPressed: () {
                      setState(() {
                        _scanTab = _buildOCR();
                        _scanTabBackButtonVisible = true;
                      });
                    },
                  ),
                  UseCaseButton(
                    text: 'Other',
                    image: const AssetImage('assets/Other.png'),
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
            Expanded(
              child: Row(
                children: [
                  UseCaseButton(
                    text: 'Native View Scan',
                    image: const AssetImage('assets/Other.png'),
                    onPressed: () {
                      Navigator.pushNamed(
                          context,
                          NativeViewScan.routeName,
                          arguments: _anylineService);
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

  Widget _buildIdentity() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ScanButton(
              text: 'Universal ID',
              onPressed: () {
                scan(ScanMode.UniversalId);
              },
            ),
            ScanButton(
              text: 'Arabic ID',
              onPressed: () {
                scan(ScanMode.ArabicId);
              },
            ),
            ScanButton(
              text: 'Cyrillic ID',
              onPressed: () {
                scan(ScanMode.CyrillicId);
              },
            ),
            ScanButton(
              text: 'MRZ',
              onPressed: () {
                scan(ScanMode.MRZ);
              },
            ),
            ScanButton(
              text: 'PDF 417 (AAMVA)',
              onPressed: () {
                scan(ScanMode.Barcode_PDF417);
              },
            ),
            ScanButton(
              text: 'Japanese Landing Permission',
              onPressed: () {
                scan(ScanMode.JapaneseLandingPermission);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcode() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ScanButton(
              text: 'Barcode',
              onPressed: () {
                scan(ScanMode.Barcode);
              },
            ),
            ScanButton(
              text: 'Barcode (Continuous)',
              onPressed: () {
                scan(ScanMode.BarcodeContinuous);
              },
            ),
            ScanButton(
              text: 'PDF 417 (AAMVA)',
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
        padding: const EdgeInsets.all(10),
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
              text: 'TIN DOT with UI Feedback',
              onPressed: () {
                scan(ScanMode.TINDOTWithUIFeedback);
              },
            ),
            ScanButton(
              text: 'Tire Size',
              onPressed: () {
                scan(ScanMode.TireSize);
              },
            ),
            ScanButton(
              text: 'Commercial Tire Id',
              onPressed: () {
                scan(ScanMode.CommercialTireId);
              },
            ),
            ScanButton(
              text: 'VIN',
              onPressed: () {
                scan(ScanMode.VIN);
              },
            ),
            ScanButton(
              text: 'Vehicle Registration Certificate',
              onPressed: () {
                scan(ScanMode.VRC);
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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ScanButton(
              text: 'Universal Serial Number',
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
              text: 'Vertical Shipping Container',
              onPressed: () {
                scan(ScanMode.VerticalContainer);
              },
            ),
            ScanButton(
              text: 'Cow Tag',
              onPressed: () {
                scan(ScanMode.CowTag);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOther() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ScanButton(
              text: 'Serial Scanning (LP → DL → VIN)',
              onPressed: () {
                scan(ScanMode.SerialScanning);
              },
            ),
            ScanButton(
              text: 'Parallel Scanning (Meter + SerialNr)',
              onPressed: () {
                scan(ScanMode.ParallelScanning);
              },
            ),
            ScanButton(
              text: 'Parallel First Scanning (VIN + Barcode)',
              onPressed: () {
                scan(ScanMode.ParallelFirstScanning);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScanButton extends StatelessWidget {
  ScanButton({Key? key, required this.text, this.onPressed}) : super(key: key);

  final String text;
  final Function? onPressed;

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      foregroundColor: Colors.white,
      backgroundColor: Styles.anylineBlue);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: TextButton(
          style: flatButtonStyle,
          onPressed: onPressed as void Function()?,
          child: SizedBox.expand(
            child: Stack(
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.bottomLeft,
              children: [
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(text,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                ),
                Positioned(
                  bottom: -15,
                  left: -5,
                  child: Opacity(
                    opacity: 0.25,
                    child: Text(text,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 50)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UseCaseButton extends StatelessWidget {
  UseCaseButton({Key? key, this.image, required this.text, this.onPressed})
      : super(key: key);

  final ImageProvider? image;
  final String text;
  final Function? onPressed;

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      foregroundColor: Colors.white,
      backgroundColor: Styles.anylineBlue);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: TextButton(
          style: flatButtonStyle,
          onPressed: onPressed as void Function()?,
          child: SizedBox.expand(
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Positioned(
                    top: 10,
                    right: 10,
                    child: Image(
                      image: image!,
                      height: 60,
                    )),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(text,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                ),
                Positioned(
                  bottom: -15,
                  left: -5,
                  child: Opacity(
                    opacity: 0.25,
                    child: Text(text,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 40)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
