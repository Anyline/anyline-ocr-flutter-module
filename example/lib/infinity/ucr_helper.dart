import 'package:anyline_plugin/models/wrapper_session_parameters.dart';

/// Returns the primary text value from [result] to pre-fill a UCR report.
/// Mirrors the Android reference implementation in ExportedScanResultExtension.kt.
String getPluginResultValueForUCR(PluginResult result) {
  return (result.barcodeResult?.barcodes?.isEmpty == false
          ? result.barcodeResult!.barcodes!.first.value
          : null)
      ?? result.mrzResult?.mrzString
      ?? result.licensePlateResult?.plateText
      ?? result.japaneseLandingPermissionResult?.result?.status?.text
      ?? result.meterResult?.value
      ?? result.odometerResult?.value
      ?? result.ocrResult?.text
      ?? result.tinResult?.text
      ?? result.tireSizeResult?.text?.text
      ?? result.tireMakeResult?.text
      ?? result.commercialTireIdResult?.text
      ?? result.containerResult?.text
      ?? result.vinResult?.text
      ?? '';
}