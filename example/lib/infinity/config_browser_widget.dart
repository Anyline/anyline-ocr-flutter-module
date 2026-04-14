import 'package:flutter/material.dart';

import 'package:anyline_plugin_example/infinity/scan_config.dart';

/// Displays a horizontally scrollable group tab bar and a chip row for the
/// selected group's configs.
///
/// While scanning the chip row collapses to free screen space for the camera.
/// Tapping a group tab while scanning temporarily reveals the chips so the
/// user can tap one to switch the active scan config.
///
/// Long-pressing a chip shows a context menu with "Edit / Save as" and,
/// for user-saved configs, "Delete".
class ConfigBrowserWidget extends StatefulWidget {
  final Map<ScanGroup, List<ScanConfig>> configsByGroup;
  final bool isScanning;
  final ValueChanged<ScanConfig> onConfigSelected;
  final ValueChanged<ScanConfig>? onEditSaveAs;
  final ValueChanged<ScanConfig>? onDelete;

  const ConfigBrowserWidget({
    Key? key,
    required this.configsByGroup,
    required this.isScanning,
    required this.onConfigSelected,
    this.onEditSaveAs,
    this.onDelete,
  }) : super(key: key);

  @override
  State<ConfigBrowserWidget> createState() => _ConfigBrowserWidgetState();
}

class _ConfigBrowserWidgetState extends State<ConfigBrowserWidget> {
  late ScanGroup _selectedGroup;

  // True when chip row should be visible; auto-managed based on isScanning.
  bool _chipRowExpanded = true;

  static const _groupOrder = [
    ScanGroup.barcode,
    ScanGroup.identityDocuments,
    ScanGroup.vehicle,
    ScanGroup.meterReading,
    ScanGroup.others,
    ScanGroup.multiPlugin,
  ];

  @override
  void initState() {
    super.initState();
    _chipRowExpanded = !widget.isScanning;
    final groups = _availableGroups;
    _selectedGroup = groups.isNotEmpty ? groups.first : ScanGroup.barcode;
  }

  @override
  void didUpdateWidget(ConfigBrowserWidget old) {
    super.didUpdateWidget(old);
    if (widget.isScanning != old.isScanning) {
      setState(() => _chipRowExpanded = !widget.isScanning);
    }
    // When configs are loaded for the first time, select the first available group.
    if (old.configsByGroup.isEmpty && widget.configsByGroup.isNotEmpty) {
      final groups = _availableGroups;
      if (groups.isNotEmpty) setState(() => _selectedGroup = groups.first);
    }
  }

  List<ScanGroup> get _availableGroups => _groupOrder
      .where((g) => widget.configsByGroup[g]?.isNotEmpty == true)
      .toList();

  void _onTabTapped(ScanGroup group) {
    setState(() {
      _selectedGroup = group;
      // While scanning: reveal chip row so the user can switch config.
      if (widget.isScanning) _chipRowExpanded = true;
    });
  }

  void _onChipTapped(ScanConfig config) {
    // Collapse chip row again after selection while scanning.
    if (widget.isScanning) setState(() => _chipRowExpanded = false);
    widget.onConfigSelected(config);
  }

  void _onChipLongPressed(ScanConfig config) {
    final isUser = config.source == ScanConfigSource.user;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit / Save as'),
              onTap: () {
                Navigator.pop(ctx);
                widget.onEditSaveAs?.call(config);
              },
            ),
            if (isUser)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onDelete?.call(config);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGroupTabBar(),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _chipRowExpanded ? 50.0 : 0.0,
          child: _buildChipRow(),
        ),
      ],
    );
  }

  Widget _buildGroupTabBar() {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: _availableGroups.map((group) {
          final selected = group == _selectedGroup;
          return Padding(
            padding: const EdgeInsets.only(right: 6.0, top: 5.0, bottom: 5.0),
            child: ChoiceChip(
              label: Text(group.displayName, style: const TextStyle(fontSize: 13)),
              selected: selected,
              onSelected: (_) => _onTabTapped(group),
              selectedColor: Colors.blue,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChipRow() {
    final configs = widget.configsByGroup[_selectedGroup] ?? [];
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      children: configs.map((config) {
        final isUser = config.source == ScanConfigSource.user;
        return Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: GestureDetector(
            onLongPress: () => _onChipLongPressed(config),
            child: ActionChip(
              label: Text(config.label, style: const TextStyle(fontSize: 12)),
              backgroundColor: isUser ? Colors.grey[300] : Colors.white,
              onPressed: () => _onChipTapped(config),
            ),
          ),
        );
      }).toList(),
    );
  }
}