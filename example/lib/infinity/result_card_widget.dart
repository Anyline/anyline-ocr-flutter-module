import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:anyline_plugin/models/wrapper_session_parameters.dart';

import 'package:anyline_plugin_example/infinity/plugin_type_helper.dart';
import 'package:anyline_plugin_example/infinity/ucr_helper.dart';

/// Displays a single [ExportedScanResult] with its plugin type, cutout image,
/// result JSON, and a "Report UCR" button.
///
/// Designed for use in a horizontal scrolling list — fixed width card.
class ResultCard extends StatelessWidget {
  static const _reportUcrLabel = 'Report UCR';

  final ExportedScanResult result;
  final void Function(String blobKey, String correctedResult) onReportUCR;

  const ResultCard({
    Key? key,
    required this.result,
    required this.onReportUCR,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typeLabel = result.pluginResult != null
        ? pluginTypeLabel(result.pluginResult!)
        : 'Unknown';
    final pluginResultJson = result.pluginResult != null
        ? pluginResultMap(result.pluginResult!)
        : null;
    final resultJson = pluginResultJson != null
        ? const JsonEncoder.withIndent('  ').convert(pluginResultJson)
        : '{}';

    return Card(
      margin: const EdgeInsets.only(right: 8.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showExpandedCard(context, typeLabel, resultJson),
        child: SizedBox(
        width: 200.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(typeLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 100),
                child: _buildImage(),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    resultJson,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[700],
                        fontFamily: 'monospace'),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showUCRDialog(context),
                  child: const Text(_reportUcrLabel),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  void _showExpandedCard(BuildContext context, String typeLabel, String resultJson) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(typeLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              SizedBox(height: 200, child: _buildImage()),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    resultJson,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[800],
                        fontFamily: 'monospace'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showUCRDialog(context);
                  },
                  child: const Text(_reportUcrLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Prefer saved file path, fall back to base64-encoded cutout image.
    final savedDir     = result.imageContainer?.saved?.path;
    final savedName    = result.imageContainer?.saved?.images?.cutoutImage;
    final savedPath    = (savedDir != null && savedName != null)
        ? '$savedDir/$savedName'
        : null;
    final encodedB64   = result.imageContainer?.encoded?.images?.cutoutImage;

    Widget imageWidget;
    if (savedPath != null && savedPath.isNotEmpty) {
      imageWidget = Image.file(
        File(savedPath),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    } else if (encodedB64 != null && encodedB64.isNotEmpty) {
      try {
        imageWidget = Image.memory(
          base64Decode(encodedB64.replaceAll(RegExp(r'\s'), '')),
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _placeholder(),
        );
      } catch (_) {
        imageWidget = _placeholder();
      }
    } else {
      imageWidget = _placeholder();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: imageWidget,
      ),
    );
  }

  Widget _placeholder() => Center(
    child: Icon(Icons.image_not_supported, color: Colors.grey[500], size: 28),
  );

  void _showUCRDialog(BuildContext context) {
    final initial = result.pluginResult != null
        ? getPluginResultValueForUCR(result.pluginResult!)
        : '';
    final controller = TextEditingController(text: initial);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(_reportUcrLabel),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Corrected result',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onReportUCR(
                result.pluginResult?.blobKey ?? '',
                controller.text,
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }
}