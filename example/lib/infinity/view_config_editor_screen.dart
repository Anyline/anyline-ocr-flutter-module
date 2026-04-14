import 'package:flutter/material.dart';

import 'package:anyline_plugin_example/infinity/json_schema_editor_widget.dart';
import 'package:anyline_plugin_example/infinity/scan_config.dart';
import 'package:anyline_plugin_example/infinity/user_config_storage.dart';

String _schemaBase(String pluginVersion) =>
    'https://documentation.anyline.com/flutter-plugin-component/$pluginVersion/mobile-sdk-common/_attachments/json-schemas';

/// Full-screen editor for creating or customising a ScanView config JSON.
///
/// Schemas are fetched remotely via the json-editor's AJAX support.
/// A network connection is required to open this screen.
/// Returns [true] when the user saves successfully.
class ViewConfigEditorScreen extends StatefulWidget {
  final ScanConfig config;
  final String pluginVersion;

  const ViewConfigEditorScreen({
    Key? key,
    required this.config,
    required this.pluginVersion,
  }) : super(key: key);

  @override
  State<ViewConfigEditorScreen> createState() => _ViewConfigEditorScreenState();
}

class _ViewConfigEditorScreenState extends State<ViewConfigEditorScreen> {
  late final TextEditingController _filenameController;
  late String _currentJson;
  bool _isSaving = false;

  late final JsonSchemaSource _schema = JsonSchemaSource.remote(
    '${_schemaBase(widget.pluginVersion)}/sdk_config.schema.json',
  );
  bool _errorShown = false;

  @override
  void initState() {
    super.initState();
    _currentJson = widget.config.configJson;
    // For asset configs, suggest the filename as a starting point.
    // For user configs, keep the existing filename.
    _filenameController =
        TextEditingController(text: widget.config.filename);
  }

  @override
  void dispose() {
    _filenameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final filename = _filenameController.text.trim();
    if (filename.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a filename.')),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      await UserConfigStorage().saveConfig(filename, _currentJson);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    }
  }

  void _onSchemaError(String message) {
    if (_errorShown) return;
    _errorShown = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Network Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dismiss dialog
              Navigator.pop(context); // pop screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit / Save as'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _filenameController,
              decoration: const InputDecoration(
                labelText: 'Filename',
                hintText: 'e.g. my_barcode_config',
                suffixText: '.json',
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save',
              onPressed: _save,
            ),
        ],
      ),
      body: JsonSchemaEditorWidget(
        schema: _schema,
        value: _currentJson,
        onChanged: (json) => _currentJson = json,
        onError: _onSchemaError,
      ),
    );
  }
}