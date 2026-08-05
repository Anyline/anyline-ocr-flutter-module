import 'package:anyline_plugin/models/sdk_config.dart';
import 'package:anyline_plugin/models/wrapper_session_parameters.dart';

import 'package:anyline_plugin_example/infinity/scan_config.dart';

/// Returns the [ScanGroup] for a [ScanViewConfiguration] by inspecting which
/// typed sub-config field is non-null in [PluginConfig].
ScanGroup groupFromScanViewConfiguration(ScanViewConfiguration config) {
  if (config.viewPluginCompositeConfig != null) return ScanGroup.multiPlugin;

  final p = config.viewPluginConfig?.pluginConfig;
  if (p == null) return ScanGroup.others;

  if (p.barcodeConfig != null) return ScanGroup.barcode;

  if (p.mrzConfig != null ||
      p.universalIdConfig != null ||
      p.japaneseLandingPermissionConfig != null) {
    return ScanGroup.identityDocuments;
  }

  if (p.licensePlateConfig != null ||
      p.vinConfig != null ||
      p.vehicleRegistrationCertificateConfig != null ||
      p.odometerConfig != null ||
      p.tinConfig != null ||
      p.tireSizeConfig != null ||
      p.tireMakeConfig != null ||
      p.commercialTireIdConfig != null) {
    return ScanGroup.vehicle;
  }

  if (p.meterConfig != null) return ScanGroup.meterReading;

  return ScanGroup.others;
}

/// Returns the display label for a [ScanViewConfiguration].
/// Prefers scanViewConfigDescription, then viewPluginCompositeConfig.id,
/// then viewPluginConfig.pluginConfig.id, then falls back to the filename.
String labelFromScanViewConfiguration(ScanViewConfiguration config, String filename) {
  return config.scanViewConfigDescription
      ?? config.viewPluginCompositeConfig?.id
      ?? config.viewPluginConfig?.pluginConfig?.id
      ?? filename;
}

/// Returns a human-readable label for the first non-null result type in [result].
String pluginTypeLabel(PluginResult result) {
  if (result.barcodeResult != null)                        return 'Barcode';
  if (result.mrzResult != null)                            return 'MRZ';
  if (result.licensePlateResult != null)                   return 'License Plate';
  if (result.vinResult != null)                            return 'VIN';
  if (result.vehicleRegistrationCertificateResult != null) return 'VRC';
  if (result.meterResult != null)                          return 'Meter';
  if (result.odometerResult != null)                       return 'Odometer';
  if (result.tinResult != null)                            return 'TIN';
  if (result.tireSizeResult != null)                       return 'Tire Size';
  if (result.tireMakeResult != null)                       return 'Tire Make';
  if (result.commercialTireIdResult != null)               return 'Commercial Tire ID';
  if (result.containerResult != null)                      return 'Container';
  if (result.ocrResult != null)                            return 'OCR';
  if (result.japaneseLandingPermissionResult != null)      return 'JLP';
  if (result.universalIdResult != null)                    return 'Universal ID';
  return 'Unknown';
}

/// Returns a map for the first non-null result type in [result].
Map<String, dynamic>? pluginResultMap(PluginResult result) {
  if (result.barcodeResult != null)                        return result.barcodeResult!.toJson();
  if (result.mrzResult != null)                            return result.mrzResult!.toJson();
  if (result.licensePlateResult != null)                   return result.licensePlateResult!.toJson();
  if (result.vinResult != null)                            return result.vinResult!.toJson();
  if (result.vehicleRegistrationCertificateResult != null) return result.vehicleRegistrationCertificateResult!.toJson();
  if (result.meterResult != null)                          return result.meterResult!.toJson();
  if (result.odometerResult != null)                       return result.odometerResult!.toJson();
  if (result.tinResult != null)                            return result.tinResult!.toJson();
  if (result.tireSizeResult != null)                       return result.tireSizeResult!.toJson();
  if (result.tireMakeResult != null)                       return result.tireMakeResult!.toJson();
  if (result.commercialTireIdResult != null)               return result.commercialTireIdResult!.toJson();
  if (result.containerResult != null)                      return result.containerResult!.toJson();
  if (result.ocrResult != null)                            return result.ocrResult!.toJson();
  if (result.japaneseLandingPermissionResult != null)      return result.japaneseLandingPermissionResult!.toJson();
  if (result.universalIdResult != null)                    return result.universalIdResult!.toJson();
  return null;
}