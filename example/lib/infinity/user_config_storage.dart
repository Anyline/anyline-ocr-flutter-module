import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Manages user-saved ScanView config JSON files on the local file system.
///
/// Files are stored in:
///   <applicationDocumentsDirectory>/user_viewconfigs/<filename>.json
class UserConfigStorage {
  static const _folderName = 'user_viewconfigs';
  static const _jsonExtension = '.json';

  Future<Directory> _folder() async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/$_folderName');
    if (!await folder.exists()) await folder.create(recursive: true);
    return folder;
  }

  /// Returns all saved config files, sorted by name.
  Future<List<File>> listConfigs() async {
    final folder = await _folder();
    final files = await folder
        .list()
        .where((e) => e is File && e.path.endsWith(_jsonExtension))
        .cast<File>()
        .toList();
    files.sort((a, b) => a.path.compareTo(b.path));
    return files;
  }

  /// Saves [json] under [filename] (`.json` suffix added if absent).
  Future<void> saveConfig(String filename, String json) async {
    final name = filename.endsWith(_jsonExtension) ? filename : '$filename$_jsonExtension';
    final folder = await _folder();
    await File('${folder.path}/$name').writeAsString(json);
  }

  /// Deletes the config with [filename] (`.json` suffix added if absent).
  Future<void> deleteConfig(String filename) async {
    final name = filename.endsWith(_jsonExtension) ? filename : '$filename$_jsonExtension';
    final folder = await _folder();
    final file = File('${folder.path}/$name');
    if (await file.exists()) await file.delete();
  }
}