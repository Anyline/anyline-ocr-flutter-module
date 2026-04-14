import 'package:anyline_plugin/models/wrapper_session_parameters.dart';
import 'package:flutter/material.dart';

import 'package:anyline_plugin_example/infinity/result_card_widget.dart';

/// Displays accumulated scan results in a horizontal scrolling list.
///
/// A header row shows the result count and, while scanning, a Stop button.
class ResultListWidget extends StatelessWidget {
  final List<ExportedScanResult> results;
  final bool isScanning;
  final void Function(String blobKey, String correctedResult) onReportUCR;
  final VoidCallback onStop;

  const ResultListWidget({
    Key? key,
    required this.results,
    required this.isScanning,
    required this.onReportUCR,
    required this.onStop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emptyText = isScanning
        ? 'No results yet'
        : 'No results yet.\nTap a config chip to start scanning.';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              Text(
                'Results (${results.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const Spacer(),
              if (isScanning)
                ElevatedButton.icon(
                  onPressed: onStop,
                  icon: const Icon(Icons.stop, size: 16),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? Center(
                  child: Text(
                    emptyText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  itemCount: results.length,
                  itemBuilder: (_, i) => ResultCard(
                    result: results[i],
                    onReportUCR: onReportUCR,
                  ),
                ),
        ),
      ],
    );
  }
}