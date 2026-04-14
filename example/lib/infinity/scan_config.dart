enum ScanConfigSource { asset, user }

enum ScanGroup {
  barcode,
  identityDocuments,
  vehicle,
  meterReading,
  others,
  multiPlugin,
}

extension ScanGroupLabel on ScanGroup {
  String get displayName {
    switch (this) {
      case ScanGroup.barcode:           return 'Barcode';
      case ScanGroup.identityDocuments: return 'Identity Documents';
      case ScanGroup.vehicle:           return 'Vehicle';
      case ScanGroup.meterReading:      return 'Meter Reading';
      case ScanGroup.others:            return 'Others';
      case ScanGroup.multiPlugin:       return 'Multi-Plugin';
    }
  }
}

/// A parsed and labelled ScanViewConfig ready to be used in scan requests.
class ScanConfig {
  final String label;
  final ScanGroup group;

  /// Raw JSON string of the ScanViewConfig — passed directly to requestScanStart.
  final String configJson;

  final String filename;

  /// Whether this config came from a bundled asset or was saved by the user.
  final ScanConfigSource source;

  const ScanConfig({
    required this.label,
    required this.group,
    required this.configJson,
    required this.filename,
    this.source = ScanConfigSource.asset,
  });
}