import 'package:anyline_plugin/models/wrapper_session_parameters.dart';

const _absent = Object();

/// Flutter asset path prefix for the Infinity DevExample ScanView configs.
///
/// Passed as [WrapperSessionScanStartRequest.scanViewConfigPath] on every scan
/// start so the native SDK can resolve config file references used by
/// SegmentControl (e.g. `"dial_meter_config.json"` inside a segmentConfig).
const defaultScanViewConfigPath = 'flutter_assets/anyline_assets/config/infinity';

final defaultImageParameters = ExportedScanResultImageParameters(
  format: ExportedScanResultImageFormat.PNG,
  quality: 50,
);

final imageContainerEncoded = ExportedScanResultImageContainer(
    encoded: ExportedScanResultImageContainerEncoded(),
);

ExportedScanResultImageContainer imageContainerSavedWithPath(String path) =>
    ExportedScanResultImageContainer(
      saved: ExportedScanResultImageContainerSaved(path: path),
    );

/// Builds a [WrapperSessionScanResultConfig] with the given [imageSavePath].
///
/// - cleanStrategy: CLEAN_FOLDER_ON_START_SCANNING
/// - imageParameters: PNG, quality 100
/// - imageContainer: saved to [imageSavePath]
WrapperSessionScanResultConfig defaultScanResultConfig(String? imageSavePath) =>
    WrapperSessionScanResultConfig(
      cleanStrategy: WrapperSessionScanResultCleanStrategyConfig
          .CLEAN_FOLDER_ON_START_SCANNING,
      imageContainer: imageSavePath != null
          ? imageContainerSavedWithPath(imageSavePath)
          : imageContainerEncoded,
      imageParameters: defaultImageParameters,
    );

/// Holds all user-configurable options applied to each scan request.
///
/// Typed fields mirror the top-level parameters of [WrapperSessionScanStartRequest]
/// (excluding [scanViewConfigContentString], which is provided per-scan).
/// Edited as JSON in [ScanOptionsScreen].
class ScanOptions {
  final ScanViewInitializationParameters? initializationParameters;
  final WrapperSessionScanStartPlatformOptions? platformOptions;

  /// Platform-specific directory for saving scan result images, obtained from
  /// [path_provider]'s getApplicationDocumentsDirectory. When null, the native
  /// SDK uses its own platform default path.
  final String? imageSavePath;

  /// Always non-null. Defaults to [defaultScanResultConfig] built from
  /// [imageSavePath]. Can be overridden explicitly via [ScanOptionsScreen].
  final WrapperSessionScanResultConfig scanResultConfig;

  ScanOptions({
    this.initializationParameters,
    this.platformOptions,
    this.imageSavePath,
    WrapperSessionScanResultConfig? scanResultConfig,
  }) : scanResultConfig = scanResultConfig ?? defaultScanResultConfig(imageSavePath);

  /// When [imageSavePath] changes and no explicit [scanResultConfig] is
  /// provided, [scanResultConfig] is rebuilt from the new path.
  ScanOptions copyWith({
    Object? initializationParameters = _absent,
    Object? platformOptions = _absent,
    Object? imageSavePath = _absent,
    Object? scanResultConfig = _absent,
  }) {
    final newImageSavePath = identical(imageSavePath, _absent)
        ? this.imageSavePath
        : imageSavePath as String?;
    final WrapperSessionScanResultConfig newScanResultConfig;
    if (!identical(scanResultConfig, _absent)) {
      newScanResultConfig = scanResultConfig as WrapperSessionScanResultConfig;
    } else if (!identical(imageSavePath, _absent)) {
      newScanResultConfig = defaultScanResultConfig(newImageSavePath);
    } else {
      newScanResultConfig = this.scanResultConfig;
    }
    return ScanOptions(
      initializationParameters: identical(initializationParameters, _absent)
          ? this.initializationParameters
          : initializationParameters as ScanViewInitializationParameters?,
      platformOptions: identical(platformOptions, _absent)
          ? this.platformOptions
          : platformOptions as WrapperSessionScanStartPlatformOptions?,
      imageSavePath: newImageSavePath,
      scanResultConfig: newScanResultConfig,
    );
  }

  WrapperSessionScanStartRequest toScanStartRequest(String configJson) =>
      WrapperSessionScanStartRequest(
        scanViewConfigContentString: configJson,
        scanViewConfigPath: defaultScanViewConfigPath,
        scanViewInitializationParameters: initializationParameters,
        platformOptions: platformOptions,
        scanResultConfig: scanResultConfig,
      );
}