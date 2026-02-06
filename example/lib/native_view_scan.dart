import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anyline_plugin/anyline_native_view.dart';
import 'package:anyline_plugin_example/anyline_service.dart';
import 'package:anyline_plugin_example/scan_modes.dart';
import 'package:anyline_plugin_example/result.dart';

class NativeViewScan extends StatefulWidget {
  const NativeViewScan({Key? key}) : super(key: key);

  static const routeName = '/nativeViewScan';

  @override
  State<NativeViewScan> createState() => _NativeViewScanState();
}

class _NativeViewScanState extends State<NativeViewScan> {
  static const String NATIVE_METHOD_ON_RESULT_EVENT =
      'NATIVE_METHOD_ON_RESULT_EVENT';
  static const String NATIVE_METHOD_ON_UI_ELEMENT_CLICKED =
      'NATIVE_METHOD_ON_UI_ELEMENT_CLICKED';

  bool isScanning = false;
  ScanMode? selectedScanMode;
  List<Result> scanResults = [];
  late AnylineService _anylineService;

  // Available scan modes for the segmented buttons
  final List<ScanMode> availableScanModes = [
    ScanMode.NativeViewBarcode,
    ScanMode.NativeViewDrivingLicense,
    ScanMode.NativeViewVIN,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Extract AnylineService from route arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is AnylineService) {
      _anylineService = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final navigator = Navigator.of(context);
          if (await _onBackPressed()) {
            navigator.pop(result);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Native View Scan'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            // Top segmented button bar (horizontally scrollable)
            _buildScanModeSelector(),

            // Native view area (AndroidView or UiKitView)
            // When not scanning, shrink to minimal size to give space to results
            Expanded(
              flex: isScanning ? 5 : 1,
              child: _buildNativeView(),
            ),

            // Bottom sheet for scan results (horizontally scrollable)
            // When not scanning, expand to take most of the space
            if (isScanning)
              _buildScanResultsSheet()
            else
              Expanded(
                flex: 4,
                child: _buildScanResultsSheet(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanModeSelector() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableScanModes.length,
        itemBuilder: (context, index) {
          final scanMode = availableScanModes[index];
          final isSelected = selectedScanMode == scanMode;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(scanMode.label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _onScanModeSelected(scanMode);
                }
              },
              selectedColor: Colors.blue,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNativeView() {
    // Platform-specific native view
    return Container(
      color: Colors.black,
      child: const Center(
        child: Stack(
          children: [
            // This is a placeholder for the native view
            AnylineNativeView(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanResultsSheet() {
    if (scanResults.isEmpty) {
      return Container(
        height: isScanning ? 100 : null,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(top: BorderSide(color: Colors.grey[400]!)),
        ),
        child: const Center(
          child: Text(
            'No scan results yet',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return Container(
      height: isScanning ? 120 : null,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[400]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Scan Results (${scanResults.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: _clearResults,
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                return _buildResultCard(scanResults[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(Result result, int index) {
    // Use larger card when not scanning (expanded view)
    final cardWidth = isScanning ? 150.0 : 200.0;
    final imageHeight = isScanning ? 40.0 : 150.0;
    final labelFontSize = isScanning ? 10.0 : 14.0;
    final resultFontSize = isScanning ? 9.0 : 12.0;

    return Card(
      margin: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image preview
            Container(
              height: imageHeight,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Image.file(
                  File(result.resultInfo.imageMap?['imagePath'] as String),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                      size: 32,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Result info
            Text(
              result.scanMode.label,
              style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  (result.resultInfo.orderedJson?[0].toString() as String),
                  style: TextStyle(
                    fontSize: resultFontSize,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onScanModeSelected(ScanMode scanMode) async {
    setState(() {
      selectedScanMode = scanMode;
    });

    String configJson = await _anylineService.getConfigJson(scanMode);
    if (isScanning) {
      _anylineService.getAnylinePlugin().trySwitchScan(configJson);
    } else {
      _startScanning(configJson);
    }

    if (kDebugMode) {
      print('Selected scan mode: ${scanMode.label}');
    }
  }

  void _startScanning(String configJson) async {
    setState(() {
      isScanning = true;
    });

    _anylineService.ensureSdkIsInitialized();

    _anylineService.getChannel().setMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case NATIVE_METHOD_ON_RESULT_EVENT:

          String stringResult = _anylineService.getAnylinePlugin()
              .convertResultsWithImagePathString(methodCall.arguments.toString(), 0);

          Map<String, dynamic>? jsonResult = jsonDecode('{$stringResult}') as Map<String, dynamic>;

          if (selectedScanMode != null) {
            setState(() {
              Result results = Result(jsonResult, selectedScanMode!, DateTime.now());
              for (var i = 0; (i < results.length); i++) {
                scanResults.insert(0, Result(
                    results.values[i] as Map<String, dynamic>,
                    selectedScanMode!,
                    DateTime.now()));
              }
            });
          }

          break;
        case NATIVE_METHOD_ON_UI_ELEMENT_CLICKED:
        // clicked UI elements clicked events can be handled here
          break;
      }
    });

    String callbackConfigString =
        '{ "onResultEventName": "$NATIVE_METHOD_ON_RESULT_EVENT" }';

    if (kDebugMode) {
      print('Started scanning: ${selectedScanMode?.label}');
    }

    await _anylineService.getAnylinePlugin().startScanning(
        configJson,
        null,
        callbackConfigString);

    setState(() {
      isScanning = false;
      selectedScanMode = null;
    });
  }

  void _stopScanning() {
    _anylineService.getAnylinePlugin().tryStopScan();

    setState(() {
      isScanning = false;
      selectedScanMode = null;
    });

    if (kDebugMode) {
      print('Stopped scanning');
    }
  }

  void _clearResults() {
    setState(() {
      scanResults.clear();
    });
  }

  Future<bool> _onBackPressed() async {
    if (isScanning) {
      // If currently scanning, stop scanning first
      _stopScanning();
      return false; // Don't exit the page
    }
    return true; // Allow back navigation
  }
}