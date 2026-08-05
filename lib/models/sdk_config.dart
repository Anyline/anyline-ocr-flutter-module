// ignore_for_file: argument_type_not_assignable, inference_failure_on_untyped_parameter, inference_failure_on_collection_literal, avoid_dynamic_calls, sort_constructors_first, prefer_single_quotes, constant_identifier_names, inference_failure_on_instance_creation, comment_references
import 'dart:convert';

///Schema for SDK JSON configurations
class ScanViewConfiguration {
  CameraConfig? cameraConfig;
  FlashConfig? flashConfig;
  Map<String, dynamic>? options;

  ///An optional description for the entire ScanView configuration.
  String? scanViewConfigDescription;
  ViewPluginCompositeConfig? viewPluginCompositeConfig;
  ViewPluginConfig? viewPluginConfig;

  ScanViewConfiguration({
    this.cameraConfig,
    this.flashConfig,
    this.options,
    this.scanViewConfigDescription,
    this.viewPluginCompositeConfig,
    this.viewPluginConfig,
  });

  factory ScanViewConfiguration.fromRawJson(String str) =>
      ScanViewConfiguration.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScanViewConfiguration.fromJson(Map<String, dynamic> json) =>
      ScanViewConfiguration(
        cameraConfig: json["cameraConfig"] == null
            ? null
            : CameraConfig.fromJson(json["cameraConfig"]),
        flashConfig: json["flashConfig"] == null
            ? null
            : FlashConfig.fromJson(json["flashConfig"]),
        options: json["options"] == null
            ? null
            : Map.from(json["options"])
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        scanViewConfigDescription: json["scanViewConfigDescription"],
        viewPluginCompositeConfig: json["viewPluginCompositeConfig"] == null
            ? null
            : ViewPluginCompositeConfig.fromJson(
                json["viewPluginCompositeConfig"]),
        viewPluginConfig: json["viewPluginConfig"] == null
            ? null
            : ViewPluginConfig.fromJson(json["viewPluginConfig"]),
      );

  Map<String, dynamic> toJson() => {
        "cameraConfig": cameraConfig?.toJson(),
        "flashConfig": flashConfig?.toJson(),
        "options": options == null
            ? null
            : Map.from(options!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "scanViewConfigDescription": scanViewConfigDescription,
        "viewPluginCompositeConfig": viewPluginCompositeConfig?.toJson(),
        "viewPluginConfig": viewPluginConfig?.toJson(),
      };
}

///Schema for SDK Camera Configuration
class CameraConfig {
  ///The preferred resolution for video capture (720p, 1080p, 4K). This resolution is used to
  ///process images for scanning. 4K resolution is only supported for barcode scanning.
  String? captureResolution;

  ///Preferred camera to open: FRONT (front-facing), BACK (rear-facing), EXTERNAL (external
  ///rear), EXTERNAL_FRONT (external front), TELE (iOS-only; requests the telephoto lens and
  ///is honored only on devices that have one; on Android or on iOS devices without a tele
  ///lens BACK will be used), ULTRAWIDE (requests the ultra-wide lens and is honored only on
  ///devices that have one; on devices without an ultra-wide lens BACK will be used).
  String? defaultCamera;

  ///(EXPERIMENTAL) Mirrors the frame sideways (left-right) before it is processed, equivalent
  ///to a horizontal flip along the vertical axis. The camera preview on the screen is not
  ///affected. Disabled by default. NOTE: This has no effect when
  ///pluginConfig.barcodeConfig.fastProcessMode is true.
  bool? enableFlipFramesLeftRight;

  ///(EXPERIMENTAL) Turns the frame upside down (top-bottom) before it is processed,
  ///equivalent to a vertical flip along the horizontal axis. The camera preview on the screen
  ///is not affected. Disabled by default. NOTE: This has no effect when
  ///pluginConfig.barcodeConfig.fastProcessMode is true.
  bool? enableFlipFramesTopBottom;

  ///Allow user to tap on the preview to focus the camera on a specific area of the screen
  ///(also known as tap-to-focus). Enabled by default.
  bool? enableTapToFocus;

  ///Optional cameras to fall back if the defaultCamera is not found.
  List<String>? fallbackCameras;

  ///The focal length.
  double? focalLength;

  ///The maximum focal length.
  double? maxFocalLength;

  ///The maximum zoom ratio.
  double? maxZoomRatio;

  ///Deprecated - do not use! The preferred resolution for taking images (720, 720p, 1080,
  ///1080p).
  String? pictureResolution;

  ///(Note: this functionality is experimental - use at your own risk.) Duration in
  ///milliseconds after which tap-to-focus automatically returns to continuous autofocus mode.
  ///Range: 1000-60000ms.
  int? tapToFocusTimeoutMs;

  ///This flag enables or disables the zoom gesture if supported.
  bool? zoomGesture;

  ///The zoom ratio to apply to the camera. When set to a value greater than 0, this property
  ///takes precedence over defaultCamera for determining which physical lens to use. For
  ///example, setting zoomRatio to 0.5 on a device with an ultra-wide lens will select that
  ///lens, regardless of the defaultCamera setting. A value of 0 means no zoom ratio is
  ///applied and the camera selection falls back to defaultCamera.
  double? zoomRatio;

  CameraConfig({
    this.captureResolution,
    this.defaultCamera,
    this.enableFlipFramesLeftRight,
    this.enableFlipFramesTopBottom,
    this.enableTapToFocus,
    this.fallbackCameras,
    this.focalLength,
    this.maxFocalLength,
    this.maxZoomRatio,
    this.pictureResolution,
    this.tapToFocusTimeoutMs,
    this.zoomGesture,
    this.zoomRatio,
  });

  factory CameraConfig.fromRawJson(String str) =>
      CameraConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CameraConfig.fromJson(Map<String, dynamic> json) => CameraConfig(
        captureResolution: json["captureResolution"],
        defaultCamera: json["defaultCamera"],
        enableFlipFramesLeftRight: json["enableFlipFramesLeftRight"],
        enableFlipFramesTopBottom: json["enableFlipFramesTopBottom"],
        enableTapToFocus: json["enableTapToFocus"],
        fallbackCameras: json["fallbackCameras"] == null
            ? []
            : List<String>.from(json["fallbackCameras"]!.map((x) => x)),
        focalLength: json["focalLength"]?.toDouble(),
        maxFocalLength: json["maxFocalLength"]?.toDouble(),
        maxZoomRatio: json["maxZoomRatio"]?.toDouble(),
        pictureResolution: json["pictureResolution"],
        tapToFocusTimeoutMs: json["tapToFocusTimeoutMs"],
        zoomGesture: json["zoomGesture"],
        zoomRatio: json["zoomRatio"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "captureResolution": captureResolution,
        "defaultCamera": defaultCamera,
        "enableFlipFramesLeftRight": enableFlipFramesLeftRight,
        "enableFlipFramesTopBottom": enableFlipFramesTopBottom,
        "enableTapToFocus": enableTapToFocus,
        "fallbackCameras": fallbackCameras == null
            ? []
            : List<dynamic>.from(fallbackCameras!.map((x) => x)),
        "focalLength": focalLength,
        "maxFocalLength": maxFocalLength,
        "maxZoomRatio": maxZoomRatio,
        "pictureResolution": pictureResolution,
        "tapToFocusTimeoutMs": tapToFocusTimeoutMs,
        "zoomGesture": zoomGesture,
        "zoomRatio": zoomRatio,
      };
}

///Schema for SDK Flash Configuration
class FlashConfig {
  ///The alignment of the flash button.
  FlashConfigAlignment? alignment;

  ///The asset name of the icon to be displayed when the flash is set to auto.
  String? imageAuto;

  ///The asset name of the icon to be displayed when the flash is off.
  String? imageOff;

  ///The asset name of the icon to be displayed when the flash is on.
  String? imageOn;

  ///The flash mode.
  Mode? mode;

  ///An optional position offset for the flash button in density-independent pixels (dp).
  Offset? offset;

  FlashConfig({
    this.alignment,
    this.imageAuto,
    this.imageOff,
    this.imageOn,
    this.mode,
    this.offset,
  });

  factory FlashConfig.fromRawJson(String str) =>
      FlashConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FlashConfig.fromJson(Map<String, dynamic> json) => FlashConfig(
        alignment: flashConfigAlignmentValues.map[json["alignment"]],
        imageAuto: json["imageAuto"],
        imageOff: json["imageOff"],
        imageOn: json["imageOn"],
        mode: modeValues.map[json["mode"]],
        offset: json["offset"] == null ? null : Offset.fromJson(json["offset"]),
      );

  Map<String, dynamic> toJson() => {
        "alignment": flashConfigAlignmentValues.reverse[alignment],
        "imageAuto": imageAuto,
        "imageOff": imageOff,
        "imageOn": imageOn,
        "mode": modeValues.reverse[mode],
        "offset": offset?.toJson(),
      };
}

///The alignment of the flash button.
enum FlashConfigAlignment {
  BOTTOM,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
  TOP,
  TOP_LEFT,
  TOP_RIGHT
}

final flashConfigAlignmentValues = EnumValues({
  "bottom": FlashConfigAlignment.BOTTOM,
  "bottom_left": FlashConfigAlignment.BOTTOM_LEFT,
  "bottom_right": FlashConfigAlignment.BOTTOM_RIGHT,
  "top": FlashConfigAlignment.TOP,
  "top_left": FlashConfigAlignment.TOP_LEFT,
  "top_right": FlashConfigAlignment.TOP_RIGHT
});

///The flash mode.
enum Mode { AUTO, MANUAL, MANUAL_OFF, MANUAL_ON, NONE }

final modeValues = EnumValues({
  "auto": Mode.AUTO,
  "manual": Mode.MANUAL,
  "manual_off": Mode.MANUAL_OFF,
  "manual_on": Mode.MANUAL_ON,
  "none": Mode.NONE
});

///An optional position offset for the flash button in density-independent pixels (dp).
///
///An x/y integer value pair. The unit (dp or camera pixels) depends on the property that
///references this definition.
///
///Adjusts the captured region position in camera pixels (px) after cropPadding is applied.
///Positive x shifts right, positive y shifts down.
///
///Position offset of the cutout in camera pixels (px), used in conjunction with alignment.
class Offset {
  int? x;
  int? y;

  Offset({
    this.x,
    this.y,
  });

  factory Offset.fromRawJson(String str) => Offset.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Offset.fromJson(Map<String, dynamic> json) => Offset(
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
      };
}

///Schema for SDK ViewPlugin Configuration
class ViewPluginCompositeConfig {
  ///The ID (name) of the workflow.
  String? id;

  ///The processing mode of the workflow (parallel, sequential, parallelFirstScan).
  ProcessingMode? processingMode;

  ///The ordered list of viewPlugins, each as JSON object with a given viewPluginConfig.
  List<ViewPlugin>? viewPlugins;

  ViewPluginCompositeConfig({
    this.id,
    this.processingMode,
    this.viewPlugins,
  });

  factory ViewPluginCompositeConfig.fromRawJson(String str) =>
      ViewPluginCompositeConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ViewPluginCompositeConfig.fromJson(Map<String, dynamic> json) =>
      ViewPluginCompositeConfig(
        id: json["id"],
        processingMode: processingModeValues.map[json["processingMode"]],
        viewPlugins: json["viewPlugins"] == null
            ? []
            : List<ViewPlugin>.from(
                json["viewPlugins"]!.map((x) => ViewPlugin.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "processingMode": processingModeValues.reverse[processingMode],
        "viewPlugins": viewPlugins == null
            ? []
            : List<dynamic>.from(viewPlugins!.map((x) => x.toJson())),
      };
}

///The processing mode of the workflow (parallel, sequential, parallelFirstScan).
enum ProcessingMode { PARALLEL, PARALLEL_FIRST_SCAN, SEQUENTIAL }

final processingModeValues = EnumValues({
  "parallel": ProcessingMode.PARALLEL,
  "parallelFirstScan": ProcessingMode.PARALLEL_FIRST_SCAN,
  "sequential": ProcessingMode.SEQUENTIAL
});

class ViewPlugin {
  ViewPluginConfig? viewPluginConfig;

  ViewPlugin({
    this.viewPluginConfig,
  });

  factory ViewPlugin.fromRawJson(String str) =>
      ViewPlugin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ViewPlugin.fromJson(Map<String, dynamic> json) => ViewPlugin(
        viewPluginConfig: json["viewPluginConfig"] == null
            ? null
            : ViewPluginConfig.fromJson(json["viewPluginConfig"]),
      );

  Map<String, dynamic> toJson() => {
        "viewPluginConfig": viewPluginConfig?.toJson(),
      };
}

///Schema for SDK ViewPlugin Configuration
class ViewPluginConfig {
  CutoutConfig? cutoutConfig;
  PluginConfig? pluginConfig;
  ScanFeedbackConfig? scanFeedbackConfig;
  UiFeedbackConfig? uiFeedbackConfig;

  ViewPluginConfig({
    this.cutoutConfig,
    this.pluginConfig,
    this.scanFeedbackConfig,
    this.uiFeedbackConfig,
  });

  factory ViewPluginConfig.fromRawJson(String str) =>
      ViewPluginConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ViewPluginConfig.fromJson(Map<String, dynamic> json) =>
      ViewPluginConfig(
        cutoutConfig: json["cutoutConfig"] == null
            ? null
            : CutoutConfig.fromJson(json["cutoutConfig"]),
        pluginConfig: json["pluginConfig"] == null
            ? null
            : PluginConfig.fromJson(json["pluginConfig"]),
        scanFeedbackConfig: json["scanFeedbackConfig"] == null
            ? null
            : ScanFeedbackConfig.fromJson(json["scanFeedbackConfig"]),
        uiFeedbackConfig: json["uiFeedbackConfig"] == null
            ? null
            : UiFeedbackConfig.fromJson(json["uiFeedbackConfig"]),
      );

  Map<String, dynamic> toJson() => {
        "cutoutConfig": cutoutConfig?.toJson(),
        "pluginConfig": pluginConfig?.toJson(),
        "scanFeedbackConfig": scanFeedbackConfig?.toJson(),
        "uiFeedbackConfig": uiFeedbackConfig?.toJson(),
      };
}

///Schema for SDK Cutout Configuration
class CutoutConfig {
  ///The alignment of the cutout area.
  CutoutConfigAlignment? alignment;

  ///Animation type for the cutout when initially displayed. Values: none, fade, zoom
  CutoutConfigAnimation? animation;

  ///The corner radius of the cutout in density-independent pixels (dp).
  int? cornerRadius;

  ///Adjusts the captured region position in camera pixels (px) after cropPadding is applied.
  ///Positive x shifts right, positive y shifts down.
  Offset? cropOffset;

  ///Expands the captured image region beyond the cutout in camera pixels (px). Non-negative
  ///values only — negative values will cause a runtime exception. Example: cutout width=700px
  ///with padding={x:10} → 720px captured.
  NonNegativeOffset? cropPadding;

  ///The hex string (RRGGBB) of the stroke color for visual feedback. (e.g. 00CCFF).
  String? feedbackStrokeColor;

  ///The maximum height in percent (0-100), relating to the size of the view.
  String? maxHeightPercent;

  ///The maximum width in percent (0-100), relating to the size of the view.
  String? maxWidthPercent;

  ///Position offset of the cutout in camera pixels (px), used in conjunction with alignment.
  Offset? offset;

  ///Optional transparency factor for the outer color (0.0 - 1.0).
  double? outerAlpha;

  ///Background color as a 6-digit (RRGGBB) or 8-digit (AARRGGBB) hex string.
  String? outerColor;

  ///A size constraining the ratio of width / height. If set to 0, the ratio will be equal to
  ///the full frame. For the optimal ratio for each technical capability have a look at the
  ///Technical Capabilities section at documentation.anyline.com.
  RatioFromSize? ratioFromSize;

  ///The hex string (RRGGBB) of the stroke color. (e.g. 00CCFF).
  String? strokeColor;

  ///The stroke width of the cutout border in density-independent pixels (dp). If set to 0,
  ///the line will be invisible.
  int? strokeWidth;

  ///The preferred width in pixels, relating to the camera resolution. If not specified or 0,
  ///the maximum possible width will be chosen.
  int? width;

  CutoutConfig({
    this.alignment,
    this.animation,
    this.cornerRadius,
    this.cropOffset,
    this.cropPadding,
    this.feedbackStrokeColor,
    this.maxHeightPercent,
    this.maxWidthPercent,
    this.offset,
    this.outerAlpha,
    this.outerColor,
    this.ratioFromSize,
    this.strokeColor,
    this.strokeWidth,
    this.width,
  });

  factory CutoutConfig.fromRawJson(String str) =>
      CutoutConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CutoutConfig.fromJson(Map<String, dynamic> json) => CutoutConfig(
        alignment: cutoutConfigAlignmentValues.map[json["alignment"]],
        animation: cutoutConfigAnimationValues.map[json["animation"]],
        cornerRadius: json["cornerRadius"],
        cropOffset: json["cropOffset"] == null
            ? null
            : Offset.fromJson(json["cropOffset"]),
        cropPadding: json["cropPadding"] == null
            ? null
            : NonNegativeOffset.fromJson(json["cropPadding"]),
        feedbackStrokeColor: json["feedbackStrokeColor"],
        maxHeightPercent: json["maxHeightPercent"],
        maxWidthPercent: json["maxWidthPercent"],
        offset: json["offset"] == null ? null : Offset.fromJson(json["offset"]),
        outerAlpha: json["outerAlpha"]?.toDouble(),
        outerColor: json["outerColor"],
        ratioFromSize: json["ratioFromSize"] == null
            ? null
            : RatioFromSize.fromJson(json["ratioFromSize"]),
        strokeColor: json["strokeColor"],
        strokeWidth: json["strokeWidth"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "alignment": cutoutConfigAlignmentValues.reverse[alignment],
        "animation": cutoutConfigAnimationValues.reverse[animation],
        "cornerRadius": cornerRadius,
        "cropOffset": cropOffset?.toJson(),
        "cropPadding": cropPadding?.toJson(),
        "feedbackStrokeColor": feedbackStrokeColor,
        "maxHeightPercent": maxHeightPercent,
        "maxWidthPercent": maxWidthPercent,
        "offset": offset?.toJson(),
        "outerAlpha": outerAlpha,
        "outerColor": outerColor,
        "ratioFromSize": ratioFromSize?.toJson(),
        "strokeColor": strokeColor,
        "strokeWidth": strokeWidth,
        "width": width,
      };
}

///The alignment of the cutout area.
enum CutoutConfigAlignment { BOTTOM, BOTTOM_HALF, CENTER, TOP, TOP_HALF }

final cutoutConfigAlignmentValues = EnumValues({
  "bottom": CutoutConfigAlignment.BOTTOM,
  "bottom_half": CutoutConfigAlignment.BOTTOM_HALF,
  "center": CutoutConfigAlignment.CENTER,
  "top": CutoutConfigAlignment.TOP,
  "top_half": CutoutConfigAlignment.TOP_HALF
});

///Animation type for the cutout when initially displayed. Values: none, fade, zoom
enum CutoutConfigAnimation { FADE, NONE, ZOOM }

final cutoutConfigAnimationValues = EnumValues({
  "fade": CutoutConfigAnimation.FADE,
  "none": CutoutConfigAnimation.NONE,
  "zoom": CutoutConfigAnimation.ZOOM
});

///Expands the captured image region beyond the cutout in camera pixels (px). Non-negative
///values only — negative values will cause a runtime exception. Example: cutout width=700px
///with padding={x:10} → 720px captured.
///
///An x/y integer value pair where both values must be >= 0. The unit depends on the
///property that references this definition.
class NonNegativeOffset {
  int? x;
  int? y;

  NonNegativeOffset({
    this.x,
    this.y,
  });

  factory NonNegativeOffset.fromRawJson(String str) =>
      NonNegativeOffset.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NonNegativeOffset.fromJson(Map<String, dynamic> json) =>
      NonNegativeOffset(
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
      };
}

///A size constraining the ratio of width / height. If set to 0, the ratio will be equal to
///the full frame. For the optimal ratio for each technical capability have a look at the
///Technical Capabilities section at documentation.anyline.com.
class RatioFromSize {
  double? height;
  double? width;

  RatioFromSize({
    this.height,
    this.width,
  });

  factory RatioFromSize.fromRawJson(String str) =>
      RatioFromSize.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RatioFromSize.fromJson(Map<String, dynamic> json) => RatioFromSize(
        height: json["height"]?.toDouble(),
        width: json["width"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
      };
}

///General configuration for scan plugins
class PluginConfig {
  BarcodeConfig? barcodeConfig;

  ///Sets whether or not to continue scanning once a result is found.
  bool? cancelOnResult;
  CommercialTireIdConfig? commercialTireIdConfig;

  ///This option allows to finetune the handling results of the same content when scanning
  ///continuously. If the option is set to -1, equal results will not be reported again until
  ///the scanning process is stopped. Setting this option to 0 will report equal results every
  ///time it is found. Setting this option to greater than 0 indicates how much time
  ///(milliseconds) must pass by not detecting the result before it will be detected again.
  ///(This feature is currently only supported in Barcode scanning)
  int? consecutiveEqualResultFilter;
  ContainerConfig? containerConfig;

  ///Sets a name for the scan plugin.
  String? id;
  JapaneseLandingPermissionConfig? japaneseLandingPermissionConfig;
  LicensePlateConfig? licensePlateConfig;
  MeterConfig? meterConfig;
  MrzConfig? mrzConfig;
  OcrConfig? ocrConfig;
  OdometerConfig? odometerConfig;

  ///Sets an initial time period (in milliseconds) where scanned frames are not processed as
  ///results.
  int? startScanDelay;

  ///Allows to fine-tune a list of options for plugins.
  List<StartVariable>? startVariables;
  TinConfig? tinConfig;
  TireMakeConfig? tireMakeConfig;
  TireSizeConfig? tireSizeConfig;
  UniversalIdConfig? universalIdConfig;
  VehicleRegistrationCertificateConfig? vehicleRegistrationCertificateConfig;
  VinConfig? vinConfig;

  PluginConfig({
    this.barcodeConfig,
    this.cancelOnResult,
    this.commercialTireIdConfig,
    this.consecutiveEqualResultFilter,
    this.containerConfig,
    this.id,
    this.japaneseLandingPermissionConfig,
    this.licensePlateConfig,
    this.meterConfig,
    this.mrzConfig,
    this.ocrConfig,
    this.odometerConfig,
    this.startScanDelay,
    this.startVariables,
    this.tinConfig,
    this.tireMakeConfig,
    this.tireSizeConfig,
    this.universalIdConfig,
    this.vehicleRegistrationCertificateConfig,
    this.vinConfig,
  });

  factory PluginConfig.fromRawJson(String str) =>
      PluginConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PluginConfig.fromJson(Map<String, dynamic> json) => PluginConfig(
        barcodeConfig: json["barcodeConfig"] == null
            ? null
            : BarcodeConfig.fromJson(json["barcodeConfig"]),
        cancelOnResult: json["cancelOnResult"],
        commercialTireIdConfig: json["commercialTireIdConfig"] == null
            ? null
            : CommercialTireIdConfig.fromJson(json["commercialTireIdConfig"]),
        consecutiveEqualResultFilter: json["consecutiveEqualResultFilter"],
        containerConfig: json["containerConfig"] == null
            ? null
            : ContainerConfig.fromJson(json["containerConfig"]),
        id: json["id"],
        japaneseLandingPermissionConfig:
            json["japaneseLandingPermissionConfig"] == null
                ? null
                : JapaneseLandingPermissionConfig.fromJson(
                    json["japaneseLandingPermissionConfig"]),
        licensePlateConfig: json["licensePlateConfig"] == null
            ? null
            : LicensePlateConfig.fromJson(json["licensePlateConfig"]),
        meterConfig: json["meterConfig"] == null
            ? null
            : MeterConfig.fromJson(json["meterConfig"]),
        mrzConfig: json["mrzConfig"] == null
            ? null
            : MrzConfig.fromJson(json["mrzConfig"]),
        ocrConfig: json["ocrConfig"] == null
            ? null
            : OcrConfig.fromJson(json["ocrConfig"]),
        odometerConfig: json["odometerConfig"] == null
            ? null
            : OdometerConfig.fromJson(json["odometerConfig"]),
        startScanDelay: json["startScanDelay"],
        startVariables: json["startVariables"] == null
            ? []
            : List<StartVariable>.from(
                json["startVariables"]!.map((x) => StartVariable.fromJson(x))),
        tinConfig: json["tinConfig"] == null
            ? null
            : TinConfig.fromJson(json["tinConfig"]),
        tireMakeConfig: json["tireMakeConfig"] == null
            ? null
            : TireMakeConfig.fromJson(json["tireMakeConfig"]),
        tireSizeConfig: json["tireSizeConfig"] == null
            ? null
            : TireSizeConfig.fromJson(json["tireSizeConfig"]),
        universalIdConfig: json["universalIdConfig"] == null
            ? null
            : UniversalIdConfig.fromJson(json["universalIdConfig"]),
        vehicleRegistrationCertificateConfig:
            json["vehicleRegistrationCertificateConfig"] == null
                ? null
                : VehicleRegistrationCertificateConfig.fromJson(
                    json["vehicleRegistrationCertificateConfig"]),
        vinConfig: json["vinConfig"] == null
            ? null
            : VinConfig.fromJson(json["vinConfig"]),
      );

  Map<String, dynamic> toJson() => {
        "barcodeConfig": barcodeConfig?.toJson(),
        "cancelOnResult": cancelOnResult,
        "commercialTireIdConfig": commercialTireIdConfig?.toJson(),
        "consecutiveEqualResultFilter": consecutiveEqualResultFilter,
        "containerConfig": containerConfig?.toJson(),
        "id": id,
        "japaneseLandingPermissionConfig":
            japaneseLandingPermissionConfig?.toJson(),
        "licensePlateConfig": licensePlateConfig?.toJson(),
        "meterConfig": meterConfig?.toJson(),
        "mrzConfig": mrzConfig?.toJson(),
        "ocrConfig": ocrConfig?.toJson(),
        "odometerConfig": odometerConfig?.toJson(),
        "startScanDelay": startScanDelay,
        "startVariables": startVariables == null
            ? []
            : List<dynamic>.from(startVariables!.map((x) => x.toJson())),
        "tinConfig": tinConfig?.toJson(),
        "tireMakeConfig": tireMakeConfig?.toJson(),
        "tireSizeConfig": tireSizeConfig?.toJson(),
        "universalIdConfig": universalIdConfig?.toJson(),
        "vehicleRegistrationCertificateConfig":
            vehicleRegistrationCertificateConfig?.toJson(),
        "vinConfig": vinConfig?.toJson(),
      };
}

///Configuration for scanning barcodes
class BarcodeConfig {
  ///Set this to filter which barcode formats should be scanned. Setting 'ALL' will enable
  ///scanning all supported formats.
  List<BarcodeFormat>? barcodeFormats;

  ///[DEPRECATED] If this option is set, allows consecutive barcode results of the same
  ///barcode when scanning continuously.
  bool? consecutiveEqualResults;

  ///Sets whether or not to disable advanced barcode scanning even if the license supports it.
  bool? disableAdvancedBarcode;

  ///If this option is set, uses faster image processing for barcode scanning. Note:
  ///fastProcessMode is not available during composite scanning.
  bool? fastProcessMode;

  ///Setting this to 'true' will enable reading multiple barcodes per frame.
  bool? multiBarcode;

  ///If this option is set, barcodes parsed according to the AAMVA standard. This only works
  ///for PDF417 codes on driving licenses.
  bool? parseAamva;

  BarcodeConfig({
    this.barcodeFormats,
    this.consecutiveEqualResults,
    this.disableAdvancedBarcode,
    this.fastProcessMode,
    this.multiBarcode,
    this.parseAamva,
  });

  factory BarcodeConfig.fromRawJson(String str) =>
      BarcodeConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BarcodeConfig.fromJson(Map<String, dynamic> json) => BarcodeConfig(
        barcodeFormats: json["barcodeFormats"] == null
            ? []
            : List<BarcodeFormat>.from(json["barcodeFormats"]!
                .map((x) => barcodeFormatValues.map[x]!)),
        consecutiveEqualResults: json["consecutiveEqualResults"],
        disableAdvancedBarcode: json["disableAdvancedBarcode"],
        fastProcessMode: json["fastProcessMode"],
        multiBarcode: json["multiBarcode"],
        parseAamva: json["parseAAMVA"],
      );

  Map<String, dynamic> toJson() => {
        "barcodeFormats": barcodeFormats == null
            ? []
            : List<dynamic>.from(
                barcodeFormats!.map((x) => barcodeFormatValues.reverse[x])),
        "consecutiveEqualResults": consecutiveEqualResults,
        "disableAdvancedBarcode": disableAdvancedBarcode,
        "fastProcessMode": fastProcessMode,
        "multiBarcode": multiBarcode,
        "parseAAMVA": parseAamva,
      };
}

enum BarcodeFormat {
  ALL,
  AZTEC,
  AZTEC_INVERSE,
  BOOKLAND,
  CODABAR,
  CODE_11,
  CODE_128,
  CODE_32,
  CODE_39,
  CODE_93,
  COUPON,
  DATABAR,
  DATA_MATRIX,
  DISCRETE_25,
  DOT_CODE,
  EAN_13,
  EAN_8,
  GS1_128,
  GS1_QR_CODE,
  ISBT_128,
  ISSN_EAN,
  ITF,
  KIX,
  MATRIX_25,
  MAXICODE,
  MICRO_PDF,
  MICRO_QR,
  MSI,
  ONE_D_INVERSE,
  PDF_417,
  POST_UK,
  QR_CODE,
  QR_INVERSE,
  RSS_14,
  RSS_EXPANDED,
  TRIOPTIC,
  UPC_A,
  UPC_E,
  UPC_EAN_EXTENSION,
  UPU_FICS,
  USPS_4_CB,
  US_PLANET,
  US_POSTNET
}

final barcodeFormatValues = EnumValues({
  "ALL": BarcodeFormat.ALL,
  "AZTEC": BarcodeFormat.AZTEC,
  "AZTEC_INVERSE": BarcodeFormat.AZTEC_INVERSE,
  "BOOKLAND": BarcodeFormat.BOOKLAND,
  "CODABAR": BarcodeFormat.CODABAR,
  "CODE_11": BarcodeFormat.CODE_11,
  "CODE_128": BarcodeFormat.CODE_128,
  "CODE_32": BarcodeFormat.CODE_32,
  "CODE_39": BarcodeFormat.CODE_39,
  "CODE_93": BarcodeFormat.CODE_93,
  "COUPON": BarcodeFormat.COUPON,
  "DATABAR": BarcodeFormat.DATABAR,
  "DATA_MATRIX": BarcodeFormat.DATA_MATRIX,
  "DISCRETE_2_5": BarcodeFormat.DISCRETE_25,
  "DOT_CODE": BarcodeFormat.DOT_CODE,
  "EAN_13": BarcodeFormat.EAN_13,
  "EAN_8": BarcodeFormat.EAN_8,
  "GS1_128": BarcodeFormat.GS1_128,
  "GS1_QR_CODE": BarcodeFormat.GS1_QR_CODE,
  "ISBT_128": BarcodeFormat.ISBT_128,
  "ISSN_EAN": BarcodeFormat.ISSN_EAN,
  "ITF": BarcodeFormat.ITF,
  "KIX": BarcodeFormat.KIX,
  "MATRIX_2_5": BarcodeFormat.MATRIX_25,
  "MAXICODE": BarcodeFormat.MAXICODE,
  "MICRO_PDF": BarcodeFormat.MICRO_PDF,
  "MICRO_QR": BarcodeFormat.MICRO_QR,
  "MSI": BarcodeFormat.MSI,
  "ONE_D_INVERSE": BarcodeFormat.ONE_D_INVERSE,
  "PDF_417": BarcodeFormat.PDF_417,
  "POST_UK": BarcodeFormat.POST_UK,
  "QR_CODE": BarcodeFormat.QR_CODE,
  "QR_INVERSE": BarcodeFormat.QR_INVERSE,
  "RSS_14": BarcodeFormat.RSS_14,
  "RSS_EXPANDED": BarcodeFormat.RSS_EXPANDED,
  "TRIOPTIC": BarcodeFormat.TRIOPTIC,
  "UPC_A": BarcodeFormat.UPC_A,
  "UPC_E": BarcodeFormat.UPC_E,
  "UPC_EAN_EXTENSION": BarcodeFormat.UPC_EAN_EXTENSION,
  "UPU_FICS": BarcodeFormat.UPU_FICS,
  "USPS_4CB": BarcodeFormat.USPS_4_CB,
  "US_PLANET": BarcodeFormat.US_PLANET,
  "US_POSTNET": BarcodeFormat.US_POSTNET
});

///Configuration for scanning commercial Tire IDs
class CommercialTireIdConfig {
  ///Sets a minimum confidence which has to be reached in order to trigger a scan result.
  int? minConfidence;

  ///Sets whether the text shall also be scanned upside-down.
  UpsideDownMode? upsideDownMode;

  ///Sets a regular expression which the commercial tire id text needs to match in order to
  ///trigger a scan result.
  String? validationRegex;

  CommercialTireIdConfig({
    this.minConfidence,
    this.upsideDownMode,
    this.validationRegex,
  });

  factory CommercialTireIdConfig.fromRawJson(String str) =>
      CommercialTireIdConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CommercialTireIdConfig.fromJson(Map<String, dynamic> json) =>
      CommercialTireIdConfig(
        minConfidence: json["minConfidence"],
        upsideDownMode: upsideDownModeValues.map[json["upsideDownMode"]],
        validationRegex: json["validationRegex"],
      );

  Map<String, dynamic> toJson() => {
        "minConfidence": minConfidence,
        "upsideDownMode": upsideDownModeValues.reverse[upsideDownMode],
        "validationRegex": validationRegex,
      };
}

///Sets whether the text shall also be scanned upside-down.
enum UpsideDownMode { AUTO, DISABLED, ENABLED }

final upsideDownModeValues = EnumValues({
  "AUTO": UpsideDownMode.AUTO,
  "DISABLED": UpsideDownMode.DISABLED,
  "ENABLED": UpsideDownMode.ENABLED
});

///Configuration for scanning shipping container numbers
class ContainerConfig {
  ///Sets a minimum confidence which has to be reached in order to trigger a scan result.
  int? minConfidence;

  ///Determines if container numbers shall be scanned horizontally or vertically.
  ContainerConfigScanMode? scanMode;

  ///Sets a regular expression which the scanned text needs to match in order to trigger a
  ///scan result.
  String? validationRegex;

  ContainerConfig({
    this.minConfidence,
    this.scanMode,
    this.validationRegex,
  });

  factory ContainerConfig.fromRawJson(String str) =>
      ContainerConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ContainerConfig.fromJson(Map<String, dynamic> json) =>
      ContainerConfig(
        minConfidence: json["minConfidence"],
        scanMode: containerConfigScanModeValues.map[json["scanMode"]],
        validationRegex: json["validationRegex"],
      );

  Map<String, dynamic> toJson() => {
        "minConfidence": minConfidence,
        "scanMode": containerConfigScanModeValues.reverse[scanMode],
        "validationRegex": validationRegex,
      };
}

///Determines if container numbers shall be scanned horizontally or vertically.
enum ContainerConfigScanMode { HORIZONTAL, VERTICAL }

final containerConfigScanModeValues = EnumValues({
  "HORIZONTAL": ContainerConfigScanMode.HORIZONTAL,
  "VERTICAL": ContainerConfigScanMode.VERTICAL
});

///Configuration for scanning japanese landing permission tickets
class JapaneseLandingPermissionConfig {
  JapaneseLandingPermissionConfigFieldOption? airport;
  JapaneseLandingPermissionConfigFieldOption? dateOfExpiry;
  JapaneseLandingPermissionConfigFieldOption? dateOfIssue;
  JapaneseLandingPermissionConfigFieldOption? duration;
  JapaneseLandingPermissionConfigFieldOption? status;

  JapaneseLandingPermissionConfig({
    this.airport,
    this.dateOfExpiry,
    this.dateOfIssue,
    this.duration,
    this.status,
  });

  factory JapaneseLandingPermissionConfig.fromRawJson(String str) =>
      JapaneseLandingPermissionConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JapaneseLandingPermissionConfig.fromJson(Map<String, dynamic> json) =>
      JapaneseLandingPermissionConfig(
        airport: json["airport"] == null
            ? null
            : JapaneseLandingPermissionConfigFieldOption.fromJson(
                json["airport"]),
        dateOfExpiry: json["dateOfExpiry"] == null
            ? null
            : JapaneseLandingPermissionConfigFieldOption.fromJson(
                json["dateOfExpiry"]),
        dateOfIssue: json["dateOfIssue"] == null
            ? null
            : JapaneseLandingPermissionConfigFieldOption.fromJson(
                json["dateOfIssue"]),
        duration: json["duration"] == null
            ? null
            : JapaneseLandingPermissionConfigFieldOption.fromJson(
                json["duration"]),
        status: json["status"] == null
            ? null
            : JapaneseLandingPermissionConfigFieldOption.fromJson(
                json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "airport": airport?.toJson(),
        "dateOfExpiry": dateOfExpiry?.toJson(),
        "dateOfIssue": dateOfIssue?.toJson(),
        "duration": duration?.toJson(),
        "status": status?.toJson(),
      };
}

///Field option for JLP fields
class JapaneseLandingPermissionConfigFieldOption {
  ///Set the minConfidence between 0 and 100. Otherwise, it's defaulted.
  int? minConfidence;

  ///The scanOption determines whether a field is considered optional, mandatory, disabled or
  ///follows a default behavior. Default behavior is one of the other three that yields the
  ///best recall results with all layouts enabled.
  MrzScanOption? scanOption;

  JapaneseLandingPermissionConfigFieldOption({
    this.minConfidence,
    this.scanOption,
  });

  factory JapaneseLandingPermissionConfigFieldOption.fromRawJson(String str) =>
      JapaneseLandingPermissionConfigFieldOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JapaneseLandingPermissionConfigFieldOption.fromJson(
          Map<String, dynamic> json) =>
      JapaneseLandingPermissionConfigFieldOption(
        minConfidence: json["minConfidence"],
        scanOption: mrzScanOptionValues.map[json["scanOption"]],
      );

  Map<String, dynamic> toJson() => {
        "minConfidence": minConfidence,
        "scanOption": mrzScanOptionValues.reverse[scanOption],
      };
}

///The scanOption determines whether a field is considered optional, mandatory, disabled or
///follows a default behavior. Default behavior is one of the other three that yields the
///best recall results with all layouts enabled.
///
///The mrzScanOption determines whether a field is considered optional, mandatory, disabled
///or follows a default behavior.
enum MrzScanOption { DEFAULT, DISABLED, MANDATORY, OPTIONAL }

final mrzScanOptionValues = EnumValues({
  "default": MrzScanOption.DEFAULT,
  "disabled": MrzScanOption.DISABLED,
  "mandatory": MrzScanOption.MANDATORY,
  "optional": MrzScanOption.OPTIONAL
});

///Configuration for scanning license plates
class LicensePlateConfig {
  ///Sets a minimum confidence which has to be reached in order to trigger a scan result.
  int? minConfidence;

  ///Specifies a country or location of which license plates shall be scanned.
  LicensePlateConfigScanMode? scanMode;

  ///Sets a regular expression per country. Expected format: "'country_code':^regex$,
  ///'other_country_code':^other_regex$". The country code needs to be provided in the
  ///international vehicle registration code format that is visible on the license plate (for
  ///example 'A' for Austria). Note: not available for the scanModes unitedstates and africa.
  String? validationRegex;

  ///Select if the visual inspection sticker should be scanned. If OPTIONAL, the visual
  ///inspection sticker will only be returned if found successfully. If MANDATORY the scan
  ///will only return if found successfully. Not available on africa and unitedstates.
  VehicleInspectionSticker? vehicleInspectionSticker;

  LicensePlateConfig({
    this.minConfidence,
    this.scanMode,
    this.validationRegex,
    this.vehicleInspectionSticker,
  });

  factory LicensePlateConfig.fromRawJson(String str) =>
      LicensePlateConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LicensePlateConfig.fromJson(Map<String, dynamic> json) =>
      LicensePlateConfig(
        minConfidence: json["minConfidence"],
        scanMode: licensePlateConfigScanModeValues.map[json["scanMode"]],
        validationRegex: json["validationRegex"],
        vehicleInspectionSticker: vehicleInspectionStickerValues
            .map[json["vehicleInspectionSticker"]],
      );

  Map<String, dynamic> toJson() => {
        "minConfidence": minConfidence,
        "scanMode": licensePlateConfigScanModeValues.reverse[scanMode],
        "validationRegex": validationRegex,
        "vehicleInspectionSticker":
            vehicleInspectionStickerValues.reverse[vehicleInspectionSticker],
      };
}

///Specifies a country or location of which license plates shall be scanned.
enum LicensePlateConfigScanMode {
  AFRICA,
  ALBANIA,
  ANDORRA,
  ARMENIA,
  AUSTRIA,
  AUTO,
  AZERBAIJAN,
  BELARUS,
  BELGIUM,
  BOSNIAANDHERZEGOVINA,
  BULGARIA,
  CANADA,
  CROATIA,
  CYPRUS,
  CZECH,
  DENMARK,
  ESTONIA,
  FINLAND,
  FRANCE,
  GEORGIA,
  GERMANY,
  GREECE,
  HUNGARY,
  ICELAND,
  IRELAND,
  ITALY,
  LATVIA,
  LIECHTENSTEIN,
  LITHUANIA,
  LUXEMBOURG,
  MALTA,
  MOLDOVA,
  MONACO,
  MONTENEGRO,
  NETHERLANDS,
  NORTHMACEDONIA,
  NORWAY,
  NORWAYSPECIAL,
  POLAND,
  PORTUGAL,
  ROMANIA,
  RUSSIA,
  SERBIA,
  SLOVAKIA,
  SLOVENIA,
  SPAIN,
  SWEDEN,
  SWITZERLAND,
  TURKEY,
  UKRAINE,
  UNITEDKINGDOM,
  UNITEDSTATES
}

final licensePlateConfigScanModeValues = EnumValues({
  "africa": LicensePlateConfigScanMode.AFRICA,
  "albania": LicensePlateConfigScanMode.ALBANIA,
  "andorra": LicensePlateConfigScanMode.ANDORRA,
  "armenia": LicensePlateConfigScanMode.ARMENIA,
  "austria": LicensePlateConfigScanMode.AUSTRIA,
  "auto": LicensePlateConfigScanMode.AUTO,
  "azerbaijan": LicensePlateConfigScanMode.AZERBAIJAN,
  "belarus": LicensePlateConfigScanMode.BELARUS,
  "belgium": LicensePlateConfigScanMode.BELGIUM,
  "bosniaandherzegovina": LicensePlateConfigScanMode.BOSNIAANDHERZEGOVINA,
  "bulgaria": LicensePlateConfigScanMode.BULGARIA,
  "canada": LicensePlateConfigScanMode.CANADA,
  "croatia": LicensePlateConfigScanMode.CROATIA,
  "cyprus": LicensePlateConfigScanMode.CYPRUS,
  "czech": LicensePlateConfigScanMode.CZECH,
  "denmark": LicensePlateConfigScanMode.DENMARK,
  "estonia": LicensePlateConfigScanMode.ESTONIA,
  "finland": LicensePlateConfigScanMode.FINLAND,
  "france": LicensePlateConfigScanMode.FRANCE,
  "georgia": LicensePlateConfigScanMode.GEORGIA,
  "germany": LicensePlateConfigScanMode.GERMANY,
  "greece": LicensePlateConfigScanMode.GREECE,
  "hungary": LicensePlateConfigScanMode.HUNGARY,
  "iceland": LicensePlateConfigScanMode.ICELAND,
  "ireland": LicensePlateConfigScanMode.IRELAND,
  "italy": LicensePlateConfigScanMode.ITALY,
  "latvia": LicensePlateConfigScanMode.LATVIA,
  "liechtenstein": LicensePlateConfigScanMode.LIECHTENSTEIN,
  "lithuania": LicensePlateConfigScanMode.LITHUANIA,
  "luxembourg": LicensePlateConfigScanMode.LUXEMBOURG,
  "malta": LicensePlateConfigScanMode.MALTA,
  "moldova": LicensePlateConfigScanMode.MOLDOVA,
  "monaco": LicensePlateConfigScanMode.MONACO,
  "montenegro": LicensePlateConfigScanMode.MONTENEGRO,
  "netherlands": LicensePlateConfigScanMode.NETHERLANDS,
  "northmacedonia": LicensePlateConfigScanMode.NORTHMACEDONIA,
  "norway": LicensePlateConfigScanMode.NORWAY,
  "norwayspecial": LicensePlateConfigScanMode.NORWAYSPECIAL,
  "poland": LicensePlateConfigScanMode.POLAND,
  "portugal": LicensePlateConfigScanMode.PORTUGAL,
  "romania": LicensePlateConfigScanMode.ROMANIA,
  "russia": LicensePlateConfigScanMode.RUSSIA,
  "serbia": LicensePlateConfigScanMode.SERBIA,
  "slovakia": LicensePlateConfigScanMode.SLOVAKIA,
  "slovenia": LicensePlateConfigScanMode.SLOVENIA,
  "spain": LicensePlateConfigScanMode.SPAIN,
  "sweden": LicensePlateConfigScanMode.SWEDEN,
  "switzerland": LicensePlateConfigScanMode.SWITZERLAND,
  "turkey": LicensePlateConfigScanMode.TURKEY,
  "ukraine": LicensePlateConfigScanMode.UKRAINE,
  "unitedkingdom": LicensePlateConfigScanMode.UNITEDKINGDOM,
  "unitedstates": LicensePlateConfigScanMode.UNITEDSTATES
});

///Select if the visual inspection sticker should be scanned. If OPTIONAL, the visual
///inspection sticker will only be returned if found successfully. If MANDATORY the scan
///will only return if found successfully. Not available on africa and unitedstates.
enum VehicleInspectionSticker { DISABLED, MANDATORY, OPTIONAL }

final vehicleInspectionStickerValues = EnumValues({
  "DISABLED": VehicleInspectionSticker.DISABLED,
  "MANDATORY": VehicleInspectionSticker.MANDATORY,
  "OPTIONAL": VehicleInspectionSticker.OPTIONAL
});

///Configuration for scanning meters
class MeterConfig {
  ///Defines the maximum number of read decimal digits for values >=0. Negative values mean
  ///all decimal digits are read. Currently implemented only for the
  ///"auto_analog_digital_meter" scan mode.
  int? maxNumDecimalDigits;

  ///Sets a minimum confidence which has to be reached in order to trigger a scan result.
  int? minConfidence;

  ///Determines which types of meters to scan.
  MeterConfigScanMode? scanMode;

  ///Sets a regular expression which the scanned text needs to match in order to trigger a
  ///scan result.
  String? validationRegex;

  MeterConfig({
    this.maxNumDecimalDigits,
    this.minConfidence,
    this.scanMode,
    this.validationRegex,
  });

  factory MeterConfig.fromRawJson(String str) =>
      MeterConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MeterConfig.fromJson(Map<String, dynamic> json) => MeterConfig(
        maxNumDecimalDigits: json["maxNumDecimalDigits"],
        minConfidence: json["minConfidence"],
        scanMode: meterConfigScanModeValues.map[json["scanMode"]],
        validationRegex: json["validationRegex"],
      );

  Map<String, dynamic> toJson() => {
        "maxNumDecimalDigits": maxNumDecimalDigits,
        "minConfidence": minConfidence,
        "scanMode": meterConfigScanModeValues.reverse[scanMode],
        "validationRegex": validationRegex,
      };
}

///Determines which types of meters to scan.
enum MeterConfigScanMode {
  AUTO_ANALOG_DIGITAL_METER,
  DIAL_METER,
  DIGITAL_METER_2_EXPERIMENTAL,
  MULTI_FIELD_DIGITAL_METER
}

final meterConfigScanModeValues = EnumValues({
  "auto_analog_digital_meter": MeterConfigScanMode.AUTO_ANALOG_DIGITAL_METER,
  "dial_meter": MeterConfigScanMode.DIAL_METER,
  "digital_meter_2_experimental":
      MeterConfigScanMode.DIGITAL_METER_2_EXPERIMENTAL,
  "multi_field_digital_meter": MeterConfigScanMode.MULTI_FIELD_DIGITAL_METER
});

///Configuration for scanning machine-readable zones (MRZ) of passports and other IDs
class MrzConfig {
  ///The cropAndTransformID determines whether or not the image shall be cropped and
  ///transformed.
  bool? cropAndTransformId;

  ///Sets whether the face detection approach is enabled.
  bool? faceDetectionEnabled;

  ///Sets a minimum confidence which has to be reached in order to trigger a scan result.
  int? minConfidence;

  ///The fieldmrzScanOptions configure which text fields shall be captured mandatory, optional
  ///or not at all.
  MrzFieldScanOptions? mrzFieldScanOptions;

  ///The minFieldConfidences configure which fields must reach which confidence thresholds in
  ///order to be part of the scan result.
  MrzMinFieldConfidences? mrzMinFieldConfidences;

  ///When enabling the strictMode, a result is only returned if all the check digits on the
  ///scanned document are valid.
  bool? strictMode;

  MrzConfig({
    this.cropAndTransformId,
    this.faceDetectionEnabled,
    this.minConfidence,
    this.mrzFieldScanOptions,
    this.mrzMinFieldConfidences,
    this.strictMode,
  });

  factory MrzConfig.fromRawJson(String str) =>
      MrzConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MrzConfig.fromJson(Map<String, dynamic> json) => MrzConfig(
        cropAndTransformId: json["cropAndTransformID"],
        faceDetectionEnabled: json["faceDetectionEnabled"],
        minConfidence: json["minConfidence"],
        mrzFieldScanOptions: json["mrzFieldScanOptions"] == null
            ? null
            : MrzFieldScanOptions.fromJson(json["mrzFieldScanOptions"]),
        mrzMinFieldConfidences: json["mrzMinFieldConfidences"] == null
            ? null
            : MrzMinFieldConfidences.fromJson(json["mrzMinFieldConfidences"]),
        strictMode: json["strictMode"],
      );

  Map<String, dynamic> toJson() => {
        "cropAndTransformID": cropAndTransformId,
        "faceDetectionEnabled": faceDetectionEnabled,
        "minConfidence": minConfidence,
        "mrzFieldScanOptions": mrzFieldScanOptions?.toJson(),
        "mrzMinFieldConfidences": mrzMinFieldConfidences?.toJson(),
        "strictMode": strictMode,
      };
}

///The fieldmrzScanOptions configure which text fields shall be captured mandatory, optional
///or not at all.
class MrzFieldScanOptions {
  MrzScanOption? checkDigitDateOfBirth;
  MrzScanOption? checkDigitDateOfExpiry;
  MrzScanOption? checkDigitDocumentNumber;
  MrzScanOption? checkDigitFinal;
  MrzScanOption? checkDigitPersonalNumber;
  MrzScanOption? dateOfBirth;
  MrzScanOption? dateOfExpiry;
  MrzScanOption? documentNumber;
  MrzScanOption? documentType;
  MrzScanOption? givenNames;
  MrzScanOption? issuingCountryCode;
  MrzScanOption? mrzString;
  MrzScanOption? nationalityCountryCode;
  MrzScanOption? optionalData;
  MrzScanOption? personalNumber;
  MrzScanOption? sex;
  MrzScanOption? surname;
  MrzScanOption? vizAddress;
  MrzScanOption? vizDateOfBirth;
  MrzScanOption? vizDateOfExpiry;
  MrzScanOption? vizDateOfIssue;
  MrzScanOption? vizGivenNames;
  MrzScanOption? vizSurname;

  MrzFieldScanOptions({
    this.checkDigitDateOfBirth,
    this.checkDigitDateOfExpiry,
    this.checkDigitDocumentNumber,
    this.checkDigitFinal,
    this.checkDigitPersonalNumber,
    this.dateOfBirth,
    this.dateOfExpiry,
    this.documentNumber,
    this.documentType,
    this.givenNames,
    this.issuingCountryCode,
    this.mrzString,
    this.nationalityCountryCode,
    this.optionalData,
    this.personalNumber,
    this.sex,
    this.surname,
    this.vizAddress,
    this.vizDateOfBirth,
    this.vizDateOfExpiry,
    this.vizDateOfIssue,
    this.vizGivenNames,
    this.vizSurname,
  });

  factory MrzFieldScanOptions.fromRawJson(String str) =>
      MrzFieldScanOptions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MrzFieldScanOptions.fromJson(Map<String, dynamic> json) =>
      MrzFieldScanOptions(
        checkDigitDateOfBirth:
            mrzScanOptionValues.map[json["checkDigitDateOfBirth"]],
        checkDigitDateOfExpiry:
            mrzScanOptionValues.map[json["checkDigitDateOfExpiry"]],
        checkDigitDocumentNumber:
            mrzScanOptionValues.map[json["checkDigitDocumentNumber"]],
        checkDigitFinal: mrzScanOptionValues.map[json["checkDigitFinal"]],
        checkDigitPersonalNumber:
            mrzScanOptionValues.map[json["checkDigitPersonalNumber"]],
        dateOfBirth: mrzScanOptionValues.map[json["dateOfBirth"]],
        dateOfExpiry: mrzScanOptionValues.map[json["dateOfExpiry"]],
        documentNumber: mrzScanOptionValues.map[json["documentNumber"]],
        documentType: mrzScanOptionValues.map[json["documentType"]],
        givenNames: mrzScanOptionValues.map[json["givenNames"]],
        issuingCountryCode: mrzScanOptionValues.map[json["issuingCountryCode"]],
        mrzString: mrzScanOptionValues.map[json["mrzString"]],
        nationalityCountryCode:
            mrzScanOptionValues.map[json["nationalityCountryCode"]],
        optionalData: mrzScanOptionValues.map[json["optionalData"]],
        personalNumber: mrzScanOptionValues.map[json["personalNumber"]],
        sex: mrzScanOptionValues.map[json["sex"]],
        surname: mrzScanOptionValues.map[json["surname"]],
        vizAddress: mrzScanOptionValues.map[json["vizAddress"]],
        vizDateOfBirth: mrzScanOptionValues.map[json["vizDateOfBirth"]],
        vizDateOfExpiry: mrzScanOptionValues.map[json["vizDateOfExpiry"]],
        vizDateOfIssue: mrzScanOptionValues.map[json["vizDateOfIssue"]],
        vizGivenNames: mrzScanOptionValues.map[json["vizGivenNames"]],
        vizSurname: mrzScanOptionValues.map[json["vizSurname"]],
      );

  Map<String, dynamic> toJson() => {
        "checkDigitDateOfBirth":
            mrzScanOptionValues.reverse[checkDigitDateOfBirth],
        "checkDigitDateOfExpiry":
            mrzScanOptionValues.reverse[checkDigitDateOfExpiry],
        "checkDigitDocumentNumber":
            mrzScanOptionValues.reverse[checkDigitDocumentNumber],
        "checkDigitFinal": mrzScanOptionValues.reverse[checkDigitFinal],
        "checkDigitPersonalNumber":
            mrzScanOptionValues.reverse[checkDigitPersonalNumber],
        "dateOfBirth": mrzScanOptionValues.reverse[dateOfBirth],
        "dateOfExpiry": mrzScanOptionValues.reverse[dateOfExpiry],
        "documentNumber": mrzScanOptionValues.reverse[documentNumber],
        "documentType": mrzScanOptionValues.reverse[documentType],
        "givenNames": mrzScanOptionValues.reverse[givenNames],
        "issuingCountryCode": mrzScanOptionValues.reverse[issuingCountryCode],
        "mrzString": mrzScanOptionValues.reverse[mrzString],
        "nationalityCountryCode":
            mrzScanOptionValues.reverse[nationalityCountryCode],
        "optionalData": mrzScanOptionValues.reverse[optionalData],
        "personalNumber": mrzScanOptionValues.reverse[personalNumber],
        "sex": mrzScanOptionValues.reverse[sex],
        "surname": mrzScanOptionValues.reverse[surname],
        "vizAddress": mrzScanOptionValues.reverse[vizAddress],
        "vizDateOfBirth": mrzScanOptionValues.reverse[vizDateOfBirth],
        "vizDateOfExpiry": mrzScanOptionValues.reverse[vizDateOfExpiry],
        "vizDateOfIssue": mrzScanOptionValues.reverse[vizDateOfIssue],
        "vizGivenNames": mrzScanOptionValues.reverse[vizGivenNames],
        "vizSurname": mrzScanOptionValues.reverse[vizSurname],
      };
}

///The minFieldConfidences configure which fields must reach which confidence thresholds in
///order to be part of the scan result.
class MrzMinFieldConfidences {
  int? checkDigitDateOfBirth;
  int? checkDigitDateOfExpiry;
  int? checkDigitDocumentNumber;
  int? checkDigitFinal;
  int? checkDigitPersonalNumber;
  int? dateOfBirth;
  int? dateOfExpiry;
  int? documentNumber;
  int? documentType;
  int? givenNames;
  int? issuingCountryCode;
  int? mrzString;
  int? nationalityCountryCode;
  int? optionalData;
  int? personalNumber;
  int? sex;
  int? surname;
  int? vizAddress;
  int? vizDateOfBirth;
  int? vizDateOfExpiry;
  int? vizDateOfIssue;
  int? vizGivenNames;
  int? vizSurname;

  MrzMinFieldConfidences({
    this.checkDigitDateOfBirth,
    this.checkDigitDateOfExpiry,
    this.checkDigitDocumentNumber,
    this.checkDigitFinal,
    this.checkDigitPersonalNumber,
    this.dateOfBirth,
    this.dateOfExpiry,
    this.documentNumber,
    this.documentType,
    this.givenNames,
    this.issuingCountryCode,
    this.mrzString,
    this.nationalityCountryCode,
    this.optionalData,
    this.personalNumber,
    this.sex,
    this.surname,
    this.vizAddress,
    this.vizDateOfBirth,
    this.vizDateOfExpiry,
    this.vizDateOfIssue,
    this.vizGivenNames,
    this.vizSurname,
  });

  factory MrzMinFieldConfidences.fromRawJson(String str) =>
      MrzMinFieldConfidences.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MrzMinFieldConfidences.fromJson(Map<String, dynamic> json) =>
      MrzMinFieldConfidences(
        checkDigitDateOfBirth: json["checkDigitDateOfBirth"],
        checkDigitDateOfExpiry: json["checkDigitDateOfExpiry"],
        checkDigitDocumentNumber: json["checkDigitDocumentNumber"],
        checkDigitFinal: json["checkDigitFinal"],
        checkDigitPersonalNumber: json["checkDigitPersonalNumber"],
        dateOfBirth: json["dateOfBirth"],
        dateOfExpiry: json["dateOfExpiry"],
        documentNumber: json["documentNumber"],
        documentType: json["documentType"],
        givenNames: json["givenNames"],
        issuingCountryCode: json["issuingCountryCode"],
        mrzString: json["mrzString"],
        nationalityCountryCode: json["nationalityCountryCode"],
        optionalData: json["optionalData"],
        personalNumber: json["personalNumber"],
        sex: json["sex"],
        surname: json["surname"],
        vizAddress: json["vizAddress"],
        vizDateOfBirth: json["vizDateOfBirth"],
        vizDateOfExpiry: json["vizDateOfExpiry"],
        vizDateOfIssue: json["vizDateOfIssue"],
        vizGivenNames: json["vizGivenNames"],
        vizSurname: json["vizSurname"],
      );

  Map<String, dynamic> toJson() => {
        "checkDigitDateOfBirth": checkDigitDateOfBirth,
        "checkDigitDateOfExpiry": checkDigitDateOfExpiry,
        "checkDigitDocumentNumber": checkDigitDocumentNumber,
        "checkDigitFinal": checkDigitFinal,
        "checkDigitPersonalNumber": checkDigitPersonalNumber,
        "dateOfBirth": dateOfBirth,
        "dateOfExpiry": dateOfExpiry,
        "documentNumber": documentNumber,
        "documentType": documentType,
        "givenNames": givenNames,
        "issuingCountryCode": issuingCountryCode,
        "mrzString": mrzString,
        "nationalityCountryCode": nationalityCountryCode,
        "optionalData": optionalData,
        "personalNumber": personalNumber,
        "sex": sex,
        "surname": surname,
        "vizAddress": vizAddress,
        "vizDateOfBirth": vizDateOfBirth,
        "vizDateOfExpiry": vizDateOfExpiry,
        "vizDateOfIssue": vizDateOfIssue,
        "vizGivenNames": vizGivenNames,
        "vizSurname": vizSurname,
      };
}

///Configuration for general OCR scanning use-cases
class OcrConfig {
  ///Sets the number of characters in each text line for 'grid' mode.
  int? charCountX;

  ///Sets the number of text lines for 'grid' mode.
  int? charCountY;

  ///Defines the average horizontal distance between two characters in 'grid' mode, measured
  ///in percentage of the characters width.
  double? charPaddingXFactor;

  ///Defines the average vertical distance between two characters in 'grid' mode, measured in
  ///percentage of the characters height.
  double? charPaddingYFactor;

  ///Restricts the scanner to a set of characters to be detected.
  String? charWhitelist;

  ///Sets a custom Anyline script. The file has to be located in the project and point to a
  ///path relative from the project root. Please check the official documentation for more
  ///details.
  String? customCmdFile;

  ///Sets a maximum character height (in pixels) to be considered in the scanning process.
  int? maxCharHeight;

  ///Sets a minimum character height (in pixels) to be considered in the scanning process.
  int? minCharHeight;

  ///Sets a minimum confidence which has to be reached in order to trigger a scan result.
  int? minConfidence;

  ///Sets a sharpnes factor (0-100) to rule out blurry images.
  int? minSharpness;

  ///Sets one or more custom Anyline models. The files have to be located in the project and
  ///point to a path relative from the project root. If no customCmdFile is set, only a
  ///maximum of one model is valid. If a customCmdFile is set, it depends whether or not the
  ///customCmdFile requires multiple models or not. Please check the official documentation
  ///for more details.
  List<String>? models;

  ///Sets whether to scan single-line texts, multi-line texts in a grid-formation or finds
  ///text automatically.
  OcrConfigScanMode? scanMode;

  ///Sets a regular expression which the scanned text needs to match in order to trigger a
  ///scan result.
  String? validationRegex;

  OcrConfig({
    this.charCountX,
    this.charCountY,
    this.charPaddingXFactor,
    this.charPaddingYFactor,
    this.charWhitelist,
    this.customCmdFile,
    this.maxCharHeight,
    this.minCharHeight,
    this.minConfidence,
    this.minSharpness,
    this.models,
    this.scanMode,
    this.validationRegex,
  });

  factory OcrConfig.fromRawJson(String str) =>
      OcrConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OcrConfig.fromJson(Map<String, dynamic> json) => OcrConfig(
        charCountX: json["charCountX"],
        charCountY: json["charCountY"],
        charPaddingXFactor: json["charPaddingXFactor"]?.toDouble(),
        charPaddingYFactor: json["charPaddingYFactor"]?.toDouble(),
        charWhitelist: json["charWhitelist"],
        customCmdFile: json["customCmdFile"],
        maxCharHeight: json["maxCharHeight"],
        minCharHeight: json["minCharHeight"],
        minConfidence: json["minConfidence"],
        minSharpness: json["minSharpness"],
        models: json["models"] == null
            ? []
            : List<String>.from(json["models"]!.map((x) => x)),
        scanMode: ocrConfigScanModeValues.map[json["scanMode"]],
        validationRegex: json["validationRegex"],
      );

  Map<String, dynamic> toJson() => {
        "charCountX": charCountX,
        "charCountY": charCountY,
        "charPaddingXFactor": charPaddingXFactor,
        "charPaddingYFactor": charPaddingYFactor,
        "charWhitelist": charWhitelist,
        "customCmdFile": customCmdFile,
        "maxCharHeight": maxCharHeight,
        "minCharHeight": minCharHeight,
        "minConfidence": minConfidence,
        "minSharpness": minSharpness,
        "models":
            models == null ? [] : List<dynamic>.from(models!.map((x) => x)),
        "scanMode": ocrConfigScanModeValues.reverse[scanMode],
        "validationRegex": validationRegex,
      };
}

///Sets whether to scan single-line texts, multi-line texts in a grid-formation or finds
///text automatically.
enum OcrConfigScanMode { AUTO, GRID, LINE }

final ocrConfigScanModeValues = EnumValues({
  "auto": OcrConfigScanMode.AUTO,
  "grid": OcrConfigScanMode.GRID,
  "line": OcrConfigScanMode.LINE
});

///Configuration for scanning odometers
class OdometerConfig {
  ///Sets a minimum confidence which has to be reached in order to trigger a scan result.The
  ///value has to be between 0 and 100. Defaults to 60.
  int? minConfidence;

  ///Sets a regular expression which the scanned text needs to match in order to trigger a
  ///scan result.
  String? validationRegex;

  OdometerConfig({
    this.minConfidence,
    this.validationRegex,
  });

  factory OdometerConfig.fromRawJson(String str) =>
      OdometerConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OdometerConfig.fromJson(Map<String, dynamic> json) => OdometerConfig(
        minConfidence: json["minConfidence"],
        validationRegex: json["validationRegex"],
      );

  Map<String, dynamic> toJson() => {
        "minConfidence": minConfidence,
        "validationRegex": validationRegex,
      };
}

///Describes a start variable for fine-tuning plugins.
class StartVariable {
  ///The key of the variable.
  String? key;

  ///The value of the variable.
  dynamic value;

  StartVariable({
    this.key,
    this.value,
  });

  factory StartVariable.fromRawJson(String str) =>
      StartVariable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StartVariable.fromJson(Map<String, dynamic> json) => StartVariable(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}

///Configuration for scanning TIN numbers
class TinConfig {
  ///Defines the minimum height ratio relative to image height for the detected text region.
  ///Ensures the device is close enough to the tire by requiring detected text to meet a
  ///minimum height requirement. Higher values are more restrictive (text must be taller,
  ///meaning device must be closer). This parameter helps prevent premature scans when the
  ///user is too far away and ensures better image quality.
  double? detectionMinHeightRatio;

  ///Defines the horizontal ratio for text alignment checks relative to image width. Ensures
  ///the detected TIN text starts near the left edge of the cutout (or right edge when
  ///upside-down) to prevent partial captures. Lower values are more restrictive (text must be
  ///closer to the edge). This parameter helps reduce premature results and ensures proper
  ///text alignment.
  double? horizontalAlignmentRatio;

  ///Sets a minimum confidence which has to be reached in order to trigger a scan result.
  int? minConfidence;

  ///Sets the mode to scan universal TIN numbers ('UNIVERSAL') or TIN numbers of any length
  ///starting with DOT ('DOT').
  TinConfigScanMode? scanMode;

  ///Sets whether the text shall also be scanned upside-down.
  UpsideDownMode? upsideDownMode;

  ///Sets whether the production date validation is enabled. If it is set to false the scan
  ///result is also returned for invalid and missing dates.
  bool? validateProductionDate;

  ///Sets a regular expression which the TIN text needs to match in order to trigger a scan
  ///result.
  String? validationRegex;

  TinConfig({
    this.detectionMinHeightRatio,
    this.horizontalAlignmentRatio,
    this.minConfidence,
    this.scanMode,
    this.upsideDownMode,
    this.validateProductionDate,
    this.validationRegex,
  });

  factory TinConfig.fromRawJson(String str) =>
      TinConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TinConfig.fromJson(Map<String, dynamic> json) => TinConfig(
        detectionMinHeightRatio: json["detectionMinHeightRatio"]?.toDouble(),
        horizontalAlignmentRatio: json["horizontalAlignmentRatio"]?.toDouble(),
        minConfidence: json["minConfidence"],
        scanMode: tinConfigScanModeValues.map[json["scanMode"]],
        upsideDownMode: upsideDownModeValues.map[json["upsideDownMode"]],
        validateProductionDate: json["validateProductionDate"],
        validationRegex: json["validationRegex"],
      );

  Map<String, dynamic> toJson() => {
        "detectionMinHeightRatio": detectionMinHeightRatio,
        "horizontalAlignmentRatio": horizontalAlignmentRatio,
        "minConfidence": minConfidence,
        "scanMode": tinConfigScanModeValues.reverse[scanMode],
        "upsideDownMode": upsideDownModeValues.reverse[upsideDownMode],
        "validateProductionDate": validateProductionDate,
        "validationRegex": validationRegex,
      };
}

///Sets the mode to scan universal TIN numbers ('UNIVERSAL') or TIN numbers of any length
///starting with DOT ('DOT').
enum TinConfigScanMode { DOT, UNIVERSAL }

final tinConfigScanModeValues = EnumValues(
    {"DOT": TinConfigScanMode.DOT, "UNIVERSAL": TinConfigScanMode.UNIVERSAL});

///Configuration for scanning Tire Makes
class TireMakeConfig {
  ///Sets a minimum confidence which has to be reached in order to trigger a scan result.
  int? minConfidence;

  ///Sets whether the text shall also be scanned upside-down.
  UpsideDownMode? upsideDownMode;

  ///Sets a regular expression which the tire make text needs to match in order to trigger a
  ///scan result. E.g. "(Continental|Dunlop)" will only trigger on Continental or Dunlop tires.
  String? validationRegex;

  TireMakeConfig({
    this.minConfidence,
    this.upsideDownMode,
    this.validationRegex,
  });

  factory TireMakeConfig.fromRawJson(String str) =>
      TireMakeConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TireMakeConfig.fromJson(Map<String, dynamic> json) => TireMakeConfig(
        minConfidence: json["minConfidence"],
        upsideDownMode: upsideDownModeValues.map[json["upsideDownMode"]],
        validationRegex: json["validationRegex"],
      );

  Map<String, dynamic> toJson() => {
        "minConfidence": minConfidence,
        "upsideDownMode": upsideDownModeValues.reverse[upsideDownMode],
        "validationRegex": validationRegex,
      };
}

///Configuration for scanning Tire Size Specifications
class TireSizeConfig {
  ///Sets a minimum confidence which has to be reached in order to trigger a scan result.
  int? minConfidence;

  ///Sets whether the text shall also be scanned upside-down.
  UpsideDownMode? upsideDownMode;

  ///Sets a regular expression which the tire size text needs to match in order to trigger a
  ///scan result.
  String? validationRegex;

  TireSizeConfig({
    this.minConfidence,
    this.upsideDownMode,
    this.validationRegex,
  });

  factory TireSizeConfig.fromRawJson(String str) =>
      TireSizeConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TireSizeConfig.fromJson(Map<String, dynamic> json) => TireSizeConfig(
        minConfidence: json["minConfidence"],
        upsideDownMode: upsideDownModeValues.map[json["upsideDownMode"]],
        validationRegex: json["validationRegex"],
      );

  Map<String, dynamic> toJson() => {
        "minConfidence": minConfidence,
        "upsideDownMode": upsideDownModeValues.reverse[upsideDownMode],
        "validationRegex": validationRegex,
      };
}

///Configuration for scanning all kinds of identification documents
class UniversalIdConfig {
  ///Specifies the document types to be scanned and optionally further specifies which types
  ///of layout are scanned per type.
  AllowedLayouts? allowedLayouts;

  ///Sets a specific character set.
  Alphabet? alphabet;
  LayoutDrivingLicense? drivingLicense;

  ///Sets whether the face detection approach is enabled.
  bool? faceDetectionEnabled;
  LayoutIdFront? idFront;
  LayoutInsuranceCard? insuranceCard;
  LayoutMrz? mrz;

  UniversalIdConfig({
    this.allowedLayouts,
    this.alphabet,
    this.drivingLicense,
    this.faceDetectionEnabled,
    this.idFront,
    this.insuranceCard,
    this.mrz,
  });

  factory UniversalIdConfig.fromRawJson(String str) =>
      UniversalIdConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UniversalIdConfig.fromJson(Map<String, dynamic> json) =>
      UniversalIdConfig(
        allowedLayouts: json["allowedLayouts"] == null
            ? null
            : AllowedLayouts.fromJson(json["allowedLayouts"]),
        alphabet: alphabetValues.map[json["alphabet"]],
        drivingLicense: json["drivingLicense"] == null
            ? null
            : LayoutDrivingLicense.fromJson(json["drivingLicense"]),
        faceDetectionEnabled: json["faceDetectionEnabled"],
        idFront: json["idFront"] == null
            ? null
            : LayoutIdFront.fromJson(json["idFront"]),
        insuranceCard: json["insuranceCard"] == null
            ? null
            : LayoutInsuranceCard.fromJson(json["insuranceCard"]),
        mrz: json["mrz"] == null ? null : LayoutMrz.fromJson(json["mrz"]),
      );

  Map<String, dynamic> toJson() => {
        "allowedLayouts": allowedLayouts?.toJson(),
        "alphabet": alphabetValues.reverse[alphabet],
        "drivingLicense": drivingLicense?.toJson(),
        "faceDetectionEnabled": faceDetectionEnabled,
        "idFront": idFront?.toJson(),
        "insuranceCard": insuranceCard?.toJson(),
        "mrz": mrz?.toJson(),
      };
}

///Specifies the document types to be scanned and optionally further specifies which types
///of layout are scanned per type.
class AllowedLayouts {
  List<String>? drivingLicense;
  List<String>? idFront;
  List<String>? insuranceCard;
  List<String>? mrz;

  AllowedLayouts({
    this.drivingLicense,
    this.idFront,
    this.insuranceCard,
    this.mrz,
  });

  factory AllowedLayouts.fromRawJson(String str) =>
      AllowedLayouts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllowedLayouts.fromJson(Map<String, dynamic> json) => AllowedLayouts(
        drivingLicense: json["drivingLicense"] == null
            ? []
            : List<String>.from(json["drivingLicense"]!.map((x) => x)),
        idFront: json["idFront"] == null
            ? []
            : List<String>.from(json["idFront"]!.map((x) => x)),
        insuranceCard: json["insuranceCard"] == null
            ? []
            : List<String>.from(json["insuranceCard"]!.map((x) => x)),
        mrz: json["mrz"] == null
            ? []
            : List<String>.from(json["mrz"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "drivingLicense": drivingLicense == null
            ? []
            : List<dynamic>.from(drivingLicense!.map((x) => x)),
        "idFront":
            idFront == null ? [] : List<dynamic>.from(idFront!.map((x) => x)),
        "insuranceCard": insuranceCard == null
            ? []
            : List<dynamic>.from(insuranceCard!.map((x) => x)),
        "mrz": mrz == null ? [] : List<dynamic>.from(mrz!.map((x) => x)),
      };
}

///Sets a specific character set.
enum Alphabet { ARABIC, CYRILLIC, LATIN }

final alphabetValues = EnumValues({
  "arabic": Alphabet.ARABIC,
  "cyrillic": Alphabet.CYRILLIC,
  "latin": Alphabet.LATIN
});

///Contains all the supported field scan options for driving licenses.
class LayoutDrivingLicense {
  UniversalIdField? additionalInformation;
  UniversalIdField? additionalInformation1;
  UniversalIdField? address;
  UniversalIdField? audit;
  UniversalIdField? authority;
  UniversalIdField? cardNumber;
  UniversalIdField? categories;
  UniversalIdField? conditions;
  UniversalIdField? dateOfBirth;
  UniversalIdField? dateOfExpiry;
  UniversalIdField? dateOfIssue;
  UniversalIdField? documentDiscriminator;
  UniversalIdField? documentNumber;
  UniversalIdField? duplicate;
  UniversalIdField? duration;
  UniversalIdField? endorsements;
  UniversalIdField? eyes;
  UniversalIdField? firstIssued;
  UniversalIdField? firstName;
  UniversalIdField? fullName;
  UniversalIdField? givenNames;
  UniversalIdField? hair;
  UniversalIdField? height;
  UniversalIdField? lastName;
  UniversalIdField? licenceNumber;
  UniversalIdField? licenseClass;
  UniversalIdField? licenseNumber;
  UniversalIdField? name;
  UniversalIdField? office;
  UniversalIdField? parish;
  UniversalIdField? personalNumber;
  UniversalIdField? placeOfBirth;
  UniversalIdField? previousType;
  UniversalIdField? restrictions;
  UniversalIdField? revoked;
  UniversalIdField? sex;
  UniversalIdField? surname;
  UniversalIdField? type;
  UniversalIdField? version;
  UniversalIdField? verticalNumber;
  UniversalIdField? weight;

  LayoutDrivingLicense({
    this.additionalInformation,
    this.additionalInformation1,
    this.address,
    this.audit,
    this.authority,
    this.cardNumber,
    this.categories,
    this.conditions,
    this.dateOfBirth,
    this.dateOfExpiry,
    this.dateOfIssue,
    this.documentDiscriminator,
    this.documentNumber,
    this.duplicate,
    this.duration,
    this.endorsements,
    this.eyes,
    this.firstIssued,
    this.firstName,
    this.fullName,
    this.givenNames,
    this.hair,
    this.height,
    this.lastName,
    this.licenceNumber,
    this.licenseClass,
    this.licenseNumber,
    this.name,
    this.office,
    this.parish,
    this.personalNumber,
    this.placeOfBirth,
    this.previousType,
    this.restrictions,
    this.revoked,
    this.sex,
    this.surname,
    this.type,
    this.version,
    this.verticalNumber,
    this.weight,
  });

  factory LayoutDrivingLicense.fromRawJson(String str) =>
      LayoutDrivingLicense.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LayoutDrivingLicense.fromJson(Map<String, dynamic> json) =>
      LayoutDrivingLicense(
        additionalInformation: json["additionalInformation"] == null
            ? null
            : UniversalIdField.fromJson(json["additionalInformation"]),
        additionalInformation1: json["additionalInformation1"] == null
            ? null
            : UniversalIdField.fromJson(json["additionalInformation1"]),
        address: json["address"] == null
            ? null
            : UniversalIdField.fromJson(json["address"]),
        audit: json["audit"] == null
            ? null
            : UniversalIdField.fromJson(json["audit"]),
        authority: json["authority"] == null
            ? null
            : UniversalIdField.fromJson(json["authority"]),
        cardNumber: json["cardNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["cardNumber"]),
        categories: json["categories"] == null
            ? null
            : UniversalIdField.fromJson(json["categories"]),
        conditions: json["conditions"] == null
            ? null
            : UniversalIdField.fromJson(json["conditions"]),
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : UniversalIdField.fromJson(json["dateOfBirth"]),
        dateOfExpiry: json["dateOfExpiry"] == null
            ? null
            : UniversalIdField.fromJson(json["dateOfExpiry"]),
        dateOfIssue: json["dateOfIssue"] == null
            ? null
            : UniversalIdField.fromJson(json["dateOfIssue"]),
        documentDiscriminator: json["documentDiscriminator"] == null
            ? null
            : UniversalIdField.fromJson(json["documentDiscriminator"]),
        documentNumber: json["documentNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["documentNumber"]),
        duplicate: json["duplicate"] == null
            ? null
            : UniversalIdField.fromJson(json["duplicate"]),
        duration: json["duration"] == null
            ? null
            : UniversalIdField.fromJson(json["duration"]),
        endorsements: json["endorsements"] == null
            ? null
            : UniversalIdField.fromJson(json["endorsements"]),
        eyes: json["eyes"] == null
            ? null
            : UniversalIdField.fromJson(json["eyes"]),
        firstIssued: json["firstIssued"] == null
            ? null
            : UniversalIdField.fromJson(json["firstIssued"]),
        firstName: json["firstName"] == null
            ? null
            : UniversalIdField.fromJson(json["firstName"]),
        fullName: json["fullName"] == null
            ? null
            : UniversalIdField.fromJson(json["fullName"]),
        givenNames: json["givenNames"] == null
            ? null
            : UniversalIdField.fromJson(json["givenNames"]),
        hair: json["hair"] == null
            ? null
            : UniversalIdField.fromJson(json["hair"]),
        height: json["height"] == null
            ? null
            : UniversalIdField.fromJson(json["height"]),
        lastName: json["lastName"] == null
            ? null
            : UniversalIdField.fromJson(json["lastName"]),
        licenceNumber: json["licenceNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["licenceNumber"]),
        licenseClass: json["licenseClass"] == null
            ? null
            : UniversalIdField.fromJson(json["licenseClass"]),
        licenseNumber: json["licenseNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["licenseNumber"]),
        name: json["name"] == null
            ? null
            : UniversalIdField.fromJson(json["name"]),
        office: json["office"] == null
            ? null
            : UniversalIdField.fromJson(json["office"]),
        parish: json["parish"] == null
            ? null
            : UniversalIdField.fromJson(json["parish"]),
        personalNumber: json["personalNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["personalNumber"]),
        placeOfBirth: json["placeOfBirth"] == null
            ? null
            : UniversalIdField.fromJson(json["placeOfBirth"]),
        previousType: json["previousType"] == null
            ? null
            : UniversalIdField.fromJson(json["previousType"]),
        restrictions: json["restrictions"] == null
            ? null
            : UniversalIdField.fromJson(json["restrictions"]),
        revoked: json["revoked"] == null
            ? null
            : UniversalIdField.fromJson(json["revoked"]),
        sex:
            json["sex"] == null ? null : UniversalIdField.fromJson(json["sex"]),
        surname: json["surname"] == null
            ? null
            : UniversalIdField.fromJson(json["surname"]),
        type: json["type"] == null
            ? null
            : UniversalIdField.fromJson(json["type"]),
        version: json["version"] == null
            ? null
            : UniversalIdField.fromJson(json["version"]),
        verticalNumber: json["verticalNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["verticalNumber"]),
        weight: json["weight"] == null
            ? null
            : UniversalIdField.fromJson(json["weight"]),
      );

  Map<String, dynamic> toJson() => {
        "additionalInformation": additionalInformation?.toJson(),
        "additionalInformation1": additionalInformation1?.toJson(),
        "address": address?.toJson(),
        "audit": audit?.toJson(),
        "authority": authority?.toJson(),
        "cardNumber": cardNumber?.toJson(),
        "categories": categories?.toJson(),
        "conditions": conditions?.toJson(),
        "dateOfBirth": dateOfBirth?.toJson(),
        "dateOfExpiry": dateOfExpiry?.toJson(),
        "dateOfIssue": dateOfIssue?.toJson(),
        "documentDiscriminator": documentDiscriminator?.toJson(),
        "documentNumber": documentNumber?.toJson(),
        "duplicate": duplicate?.toJson(),
        "duration": duration?.toJson(),
        "endorsements": endorsements?.toJson(),
        "eyes": eyes?.toJson(),
        "firstIssued": firstIssued?.toJson(),
        "firstName": firstName?.toJson(),
        "fullName": fullName?.toJson(),
        "givenNames": givenNames?.toJson(),
        "hair": hair?.toJson(),
        "height": height?.toJson(),
        "lastName": lastName?.toJson(),
        "licenceNumber": licenceNumber?.toJson(),
        "licenseClass": licenseClass?.toJson(),
        "licenseNumber": licenseNumber?.toJson(),
        "name": name?.toJson(),
        "office": office?.toJson(),
        "parish": parish?.toJson(),
        "personalNumber": personalNumber?.toJson(),
        "placeOfBirth": placeOfBirth?.toJson(),
        "previousType": previousType?.toJson(),
        "restrictions": restrictions?.toJson(),
        "revoked": revoked?.toJson(),
        "sex": sex?.toJson(),
        "surname": surname?.toJson(),
        "type": type?.toJson(),
        "version": version?.toJson(),
        "verticalNumber": verticalNumber?.toJson(),
        "weight": weight?.toJson(),
      };
}

///Configures scanning options for ID fields in order to fine-tune the ID scanner.
class UniversalIdField {
  ///Set the minConfidence which has to be reached in order to trigger a scan result. The
  ///value has to be between 0 and 100. Defaults to 60.
  int? minConfidence;

  ///The scanOption determines whether a field is considered optional, mandatory, disabled or
  ///follows a default behavior. Default behavior is one of the other three that yields the
  ///best recall results with all layouts enabled.
  MrzScanOption? scanOption;

  UniversalIdField({
    this.minConfidence,
    this.scanOption,
  });

  factory UniversalIdField.fromRawJson(String str) =>
      UniversalIdField.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UniversalIdField.fromJson(Map<String, dynamic> json) =>
      UniversalIdField(
        minConfidence: json["minConfidence"],
        scanOption: mrzScanOptionValues.map[json["scanOption"]],
      );

  Map<String, dynamic> toJson() => {
        "minConfidence": minConfidence,
        "scanOption": mrzScanOptionValues.reverse[scanOption],
      };
}

///Contains all the supported field scan options for ID front cards.
class LayoutIdFront {
  UniversalIdField? additionalInformation;
  UniversalIdField? additionalInformation1;
  UniversalIdField? address;
  UniversalIdField? age;
  UniversalIdField? authority;
  UniversalIdField? cardAccessNumber;
  UniversalIdField? citizenship;
  UniversalIdField? cityNumber;
  UniversalIdField? dateOfBirth;
  UniversalIdField? dateOfExpiry;
  UniversalIdField? dateOfIssue;
  UniversalIdField? dateOfRegistration;
  UniversalIdField? divisionNumber;
  UniversalIdField? documentNumber;
  UniversalIdField? familyName;
  UniversalIdField? fathersName;
  UniversalIdField? firstName;
  UniversalIdField? folio;
  UniversalIdField? fullName;
  UniversalIdField? givenNames;
  UniversalIdField? height;
  UniversalIdField? lastName;
  UniversalIdField? licenseClass;
  UniversalIdField? licenseType;
  UniversalIdField? municipalityNumber;
  UniversalIdField? nationalId;
  UniversalIdField? nationality;
  UniversalIdField? parentsGivenName;
  UniversalIdField? personalNumber;
  UniversalIdField? placeAndDateOfBirth;
  UniversalIdField? placeOfBirth;
  UniversalIdField? sex;
  UniversalIdField? stateNumber;
  UniversalIdField? supportNumber;
  UniversalIdField? surname;
  UniversalIdField? voterId;

  LayoutIdFront({
    this.additionalInformation,
    this.additionalInformation1,
    this.address,
    this.age,
    this.authority,
    this.cardAccessNumber,
    this.citizenship,
    this.cityNumber,
    this.dateOfBirth,
    this.dateOfExpiry,
    this.dateOfIssue,
    this.dateOfRegistration,
    this.divisionNumber,
    this.documentNumber,
    this.familyName,
    this.fathersName,
    this.firstName,
    this.folio,
    this.fullName,
    this.givenNames,
    this.height,
    this.lastName,
    this.licenseClass,
    this.licenseType,
    this.municipalityNumber,
    this.nationalId,
    this.nationality,
    this.parentsGivenName,
    this.personalNumber,
    this.placeAndDateOfBirth,
    this.placeOfBirth,
    this.sex,
    this.stateNumber,
    this.supportNumber,
    this.surname,
    this.voterId,
  });

  factory LayoutIdFront.fromRawJson(String str) =>
      LayoutIdFront.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LayoutIdFront.fromJson(Map<String, dynamic> json) => LayoutIdFront(
        additionalInformation: json["additionalInformation"] == null
            ? null
            : UniversalIdField.fromJson(json["additionalInformation"]),
        additionalInformation1: json["additionalInformation1"] == null
            ? null
            : UniversalIdField.fromJson(json["additionalInformation1"]),
        address: json["address"] == null
            ? null
            : UniversalIdField.fromJson(json["address"]),
        age:
            json["age"] == null ? null : UniversalIdField.fromJson(json["age"]),
        authority: json["authority"] == null
            ? null
            : UniversalIdField.fromJson(json["authority"]),
        cardAccessNumber: json["cardAccessNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["cardAccessNumber"]),
        citizenship: json["citizenship"] == null
            ? null
            : UniversalIdField.fromJson(json["citizenship"]),
        cityNumber: json["cityNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["cityNumber"]),
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : UniversalIdField.fromJson(json["dateOfBirth"]),
        dateOfExpiry: json["dateOfExpiry"] == null
            ? null
            : UniversalIdField.fromJson(json["dateOfExpiry"]),
        dateOfIssue: json["dateOfIssue"] == null
            ? null
            : UniversalIdField.fromJson(json["dateOfIssue"]),
        dateOfRegistration: json["dateOfRegistration"] == null
            ? null
            : UniversalIdField.fromJson(json["dateOfRegistration"]),
        divisionNumber: json["divisionNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["divisionNumber"]),
        documentNumber: json["documentNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["documentNumber"]),
        familyName: json["familyName"] == null
            ? null
            : UniversalIdField.fromJson(json["familyName"]),
        fathersName: json["fathersName"] == null
            ? null
            : UniversalIdField.fromJson(json["fathersName"]),
        firstName: json["firstName"] == null
            ? null
            : UniversalIdField.fromJson(json["firstName"]),
        folio: json["folio"] == null
            ? null
            : UniversalIdField.fromJson(json["folio"]),
        fullName: json["fullName"] == null
            ? null
            : UniversalIdField.fromJson(json["fullName"]),
        givenNames: json["givenNames"] == null
            ? null
            : UniversalIdField.fromJson(json["givenNames"]),
        height: json["height"] == null
            ? null
            : UniversalIdField.fromJson(json["height"]),
        lastName: json["lastName"] == null
            ? null
            : UniversalIdField.fromJson(json["lastName"]),
        licenseClass: json["licenseClass"] == null
            ? null
            : UniversalIdField.fromJson(json["licenseClass"]),
        licenseType: json["licenseType"] == null
            ? null
            : UniversalIdField.fromJson(json["licenseType"]),
        municipalityNumber: json["municipalityNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["municipalityNumber"]),
        nationalId: json["nationalId"] == null
            ? null
            : UniversalIdField.fromJson(json["nationalId"]),
        nationality: json["nationality"] == null
            ? null
            : UniversalIdField.fromJson(json["nationality"]),
        parentsGivenName: json["parentsGivenName"] == null
            ? null
            : UniversalIdField.fromJson(json["parentsGivenName"]),
        personalNumber: json["personalNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["personalNumber"]),
        placeAndDateOfBirth: json["placeAndDateOfBirth"] == null
            ? null
            : UniversalIdField.fromJson(json["placeAndDateOfBirth"]),
        placeOfBirth: json["placeOfBirth"] == null
            ? null
            : UniversalIdField.fromJson(json["placeOfBirth"]),
        sex:
            json["sex"] == null ? null : UniversalIdField.fromJson(json["sex"]),
        stateNumber: json["stateNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["stateNumber"]),
        supportNumber: json["supportNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["supportNumber"]),
        surname: json["surname"] == null
            ? null
            : UniversalIdField.fromJson(json["surname"]),
        voterId: json["voterId"] == null
            ? null
            : UniversalIdField.fromJson(json["voterId"]),
      );

  Map<String, dynamic> toJson() => {
        "additionalInformation": additionalInformation?.toJson(),
        "additionalInformation1": additionalInformation1?.toJson(),
        "address": address?.toJson(),
        "age": age?.toJson(),
        "authority": authority?.toJson(),
        "cardAccessNumber": cardAccessNumber?.toJson(),
        "citizenship": citizenship?.toJson(),
        "cityNumber": cityNumber?.toJson(),
        "dateOfBirth": dateOfBirth?.toJson(),
        "dateOfExpiry": dateOfExpiry?.toJson(),
        "dateOfIssue": dateOfIssue?.toJson(),
        "dateOfRegistration": dateOfRegistration?.toJson(),
        "divisionNumber": divisionNumber?.toJson(),
        "documentNumber": documentNumber?.toJson(),
        "familyName": familyName?.toJson(),
        "fathersName": fathersName?.toJson(),
        "firstName": firstName?.toJson(),
        "folio": folio?.toJson(),
        "fullName": fullName?.toJson(),
        "givenNames": givenNames?.toJson(),
        "height": height?.toJson(),
        "lastName": lastName?.toJson(),
        "licenseClass": licenseClass?.toJson(),
        "licenseType": licenseType?.toJson(),
        "municipalityNumber": municipalityNumber?.toJson(),
        "nationalId": nationalId?.toJson(),
        "nationality": nationality?.toJson(),
        "parentsGivenName": parentsGivenName?.toJson(),
        "personalNumber": personalNumber?.toJson(),
        "placeAndDateOfBirth": placeAndDateOfBirth?.toJson(),
        "placeOfBirth": placeOfBirth?.toJson(),
        "sex": sex?.toJson(),
        "stateNumber": stateNumber?.toJson(),
        "supportNumber": supportNumber?.toJson(),
        "surname": surname?.toJson(),
        "voterId": voterId?.toJson(),
      };
}

///Contains all the supported field scan options for insurance cards.
class LayoutInsuranceCard {
  UniversalIdField? authority;
  UniversalIdField? dateOfBirth;
  UniversalIdField? dateOfExpiry;
  UniversalIdField? documentNumber;
  UniversalIdField? firstName;
  UniversalIdField? lastName;
  UniversalIdField? nationality;
  UniversalIdField? personalNumber;

  LayoutInsuranceCard({
    this.authority,
    this.dateOfBirth,
    this.dateOfExpiry,
    this.documentNumber,
    this.firstName,
    this.lastName,
    this.nationality,
    this.personalNumber,
  });

  factory LayoutInsuranceCard.fromRawJson(String str) =>
      LayoutInsuranceCard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LayoutInsuranceCard.fromJson(Map<String, dynamic> json) =>
      LayoutInsuranceCard(
        authority: json["authority"] == null
            ? null
            : UniversalIdField.fromJson(json["authority"]),
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : UniversalIdField.fromJson(json["dateOfBirth"]),
        dateOfExpiry: json["dateOfExpiry"] == null
            ? null
            : UniversalIdField.fromJson(json["dateOfExpiry"]),
        documentNumber: json["documentNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["documentNumber"]),
        firstName: json["firstName"] == null
            ? null
            : UniversalIdField.fromJson(json["firstName"]),
        lastName: json["lastName"] == null
            ? null
            : UniversalIdField.fromJson(json["lastName"]),
        nationality: json["nationality"] == null
            ? null
            : UniversalIdField.fromJson(json["nationality"]),
        personalNumber: json["personalNumber"] == null
            ? null
            : UniversalIdField.fromJson(json["personalNumber"]),
      );

  Map<String, dynamic> toJson() => {
        "authority": authority?.toJson(),
        "dateOfBirth": dateOfBirth?.toJson(),
        "dateOfExpiry": dateOfExpiry?.toJson(),
        "documentNumber": documentNumber?.toJson(),
        "firstName": firstName?.toJson(),
        "lastName": lastName?.toJson(),
        "nationality": nationality?.toJson(),
        "personalNumber": personalNumber?.toJson(),
      };
}

///Contains all the supported field scan options for MRZ.
class LayoutMrz {
  UniversalIdField? dateOfBirth;
  UniversalIdField? dateOfExpiry;
  UniversalIdField? vizAddress;
  UniversalIdField? vizDateOfBirth;
  UniversalIdField? vizDateOfExpiry;
  UniversalIdField? vizDateOfIssue;
  UniversalIdField? vizGivenNames;
  UniversalIdField? vizSurname;

  LayoutMrz({
    this.dateOfBirth,
    this.dateOfExpiry,
    this.vizAddress,
    this.vizDateOfBirth,
    this.vizDateOfExpiry,
    this.vizDateOfIssue,
    this.vizGivenNames,
    this.vizSurname,
  });

  factory LayoutMrz.fromRawJson(String str) =>
      LayoutMrz.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LayoutMrz.fromJson(Map<String, dynamic> json) => LayoutMrz(
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : UniversalIdField.fromJson(json["dateOfBirth"]),
        dateOfExpiry: json["dateOfExpiry"] == null
            ? null
            : UniversalIdField.fromJson(json["dateOfExpiry"]),
        vizAddress: json["vizAddress"] == null
            ? null
            : UniversalIdField.fromJson(json["vizAddress"]),
        vizDateOfBirth: json["vizDateOfBirth"] == null
            ? null
            : UniversalIdField.fromJson(json["vizDateOfBirth"]),
        vizDateOfExpiry: json["vizDateOfExpiry"] == null
            ? null
            : UniversalIdField.fromJson(json["vizDateOfExpiry"]),
        vizDateOfIssue: json["vizDateOfIssue"] == null
            ? null
            : UniversalIdField.fromJson(json["vizDateOfIssue"]),
        vizGivenNames: json["vizGivenNames"] == null
            ? null
            : UniversalIdField.fromJson(json["vizGivenNames"]),
        vizSurname: json["vizSurname"] == null
            ? null
            : UniversalIdField.fromJson(json["vizSurname"]),
      );

  Map<String, dynamic> toJson() => {
        "dateOfBirth": dateOfBirth?.toJson(),
        "dateOfExpiry": dateOfExpiry?.toJson(),
        "vizAddress": vizAddress?.toJson(),
        "vizDateOfBirth": vizDateOfBirth?.toJson(),
        "vizDateOfExpiry": vizDateOfExpiry?.toJson(),
        "vizDateOfIssue": vizDateOfIssue?.toJson(),
        "vizGivenNames": vizGivenNames?.toJson(),
        "vizSurname": vizSurname?.toJson(),
      };
}

///Configuration for scanning Vehicle Registration Certificates
class VehicleRegistrationCertificateConfig {
  LayoutVehicleRegistrationCertificate? vehicleRegistrationCertificate;

  VehicleRegistrationCertificateConfig({
    this.vehicleRegistrationCertificate,
  });

  factory VehicleRegistrationCertificateConfig.fromRawJson(String str) =>
      VehicleRegistrationCertificateConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehicleRegistrationCertificateConfig.fromJson(
          Map<String, dynamic> json) =>
      VehicleRegistrationCertificateConfig(
        vehicleRegistrationCertificate:
            json["vehicleRegistrationCertificate"] == null
                ? null
                : LayoutVehicleRegistrationCertificate.fromJson(
                    json["vehicleRegistrationCertificate"]),
      );

  Map<String, dynamic> toJson() => {
        "vehicleRegistrationCertificate":
            vehicleRegistrationCertificate?.toJson(),
      };
}

///Contains all the supported field scan options for vehicle registration certificates.
class LayoutVehicleRegistrationCertificate {
  ///The Address Field
  VehicleRegistrationCertificateField? address;

  ///The Brand Field
  VehicleRegistrationCertificateField? brand;

  ///The Displacement Field
  VehicleRegistrationCertificateField? displacement;

  ///The DocumentNumber Field
  VehicleRegistrationCertificateField? documentNumber;

  ///The FirstIssued Field
  VehicleRegistrationCertificateField? firstIssued;

  ///The FirstName Field
  VehicleRegistrationCertificateField? firstName;

  ///The LastName Field
  VehicleRegistrationCertificateField? lastName;

  ///The LicensePlate Field
  VehicleRegistrationCertificateField? licensePlate;

  ///The ManufacturerCode Field
  VehicleRegistrationCertificateField? manufacturerCode;

  ///The Tire Field
  VehicleRegistrationCertificateField? tire;

  ///The VehicleIdentificationNumber Field
  VehicleRegistrationCertificateField? vehicleIdentificationNumber;

  ///The VehicleType Field
  VehicleRegistrationCertificateField? vehicleType;

  ///The VehicleTypeCode Field
  VehicleRegistrationCertificateField? vehicleTypeCode;

  LayoutVehicleRegistrationCertificate({
    this.address,
    this.brand,
    this.displacement,
    this.documentNumber,
    this.firstIssued,
    this.firstName,
    this.lastName,
    this.licensePlate,
    this.manufacturerCode,
    this.tire,
    this.vehicleIdentificationNumber,
    this.vehicleType,
    this.vehicleTypeCode,
  });

  factory LayoutVehicleRegistrationCertificate.fromRawJson(String str) =>
      LayoutVehicleRegistrationCertificate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LayoutVehicleRegistrationCertificate.fromJson(
          Map<String, dynamic> json) =>
      LayoutVehicleRegistrationCertificate(
        address: json["address"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(json["address"]),
        brand: json["brand"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(json["brand"]),
        displacement: json["displacement"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(
                json["displacement"]),
        documentNumber: json["documentNumber"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(
                json["documentNumber"]),
        firstIssued: json["firstIssued"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(json["firstIssued"]),
        firstName: json["firstName"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(json["firstName"]),
        lastName: json["lastName"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(json["lastName"]),
        licensePlate: json["licensePlate"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(
                json["licensePlate"]),
        manufacturerCode: json["manufacturerCode"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(
                json["manufacturerCode"]),
        tire: json["tire"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(json["tire"]),
        vehicleIdentificationNumber: json["vehicleIdentificationNumber"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(
                json["vehicleIdentificationNumber"]),
        vehicleType: json["vehicleType"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(json["vehicleType"]),
        vehicleTypeCode: json["vehicleTypeCode"] == null
            ? null
            : VehicleRegistrationCertificateField.fromJson(
                json["vehicleTypeCode"]),
      );

  Map<String, dynamic> toJson() => {
        "address": address?.toJson(),
        "brand": brand?.toJson(),
        "displacement": displacement?.toJson(),
        "documentNumber": documentNumber?.toJson(),
        "firstIssued": firstIssued?.toJson(),
        "firstName": firstName?.toJson(),
        "lastName": lastName?.toJson(),
        "licensePlate": licensePlate?.toJson(),
        "manufacturerCode": manufacturerCode?.toJson(),
        "tire": tire?.toJson(),
        "vehicleIdentificationNumber": vehicleIdentificationNumber?.toJson(),
        "vehicleType": vehicleType?.toJson(),
        "vehicleTypeCode": vehicleTypeCode?.toJson(),
      };
}

///The Address Field
///
///Configures scanning options per field
///
///The Brand Field
///
///The Displacement Field
///
///The DocumentNumber Field
///
///The FirstIssued Field
///
///The FirstName Field
///
///The LastName Field
///
///The LicensePlate Field
///
///The ManufacturerCode Field
///
///The Tire Field
///
///The VehicleIdentificationNumber Field
///
///The VehicleType Field
///
///The VehicleTypeCode Field
class VehicleRegistrationCertificateField {
  ///Set the minConfidence between 0 and 100. Otherwise, it's defaulted.
  int? minConfidence;

  ///The scanOption determines whether a field is considered optional, mandatory, disabled or
  ///follows a default behavior. Default behavior is one of the other three that yields the
  ///best recall results with all layouts enabled.
  MrzScanOption? scanOption;

  VehicleRegistrationCertificateField({
    this.minConfidence,
    this.scanOption,
  });

  factory VehicleRegistrationCertificateField.fromRawJson(String str) =>
      VehicleRegistrationCertificateField.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehicleRegistrationCertificateField.fromJson(
          Map<String, dynamic> json) =>
      VehicleRegistrationCertificateField(
        minConfidence: json["minConfidence"],
        scanOption: mrzScanOptionValues.map[json["scanOption"]],
      );

  Map<String, dynamic> toJson() => {
        "minConfidence": minConfidence,
        "scanOption": mrzScanOptionValues.reverse[scanOption],
      };
}

///Configuration for scanning vehicle identification numbers (VIN)
class VinConfig {
  ///Restricts the scanner to a set of characters to be detected.
  String? charWhitelist;

  ///Setting this to 'true' will enforce checking the check digit and only return results if
  ///it is correct.
  bool? validateCheckDigit;

  ///Sets a regular expression which the scanned text needs to match in order to trigger a
  ///scan result.
  String? validationRegex;

  VinConfig({
    this.charWhitelist,
    this.validateCheckDigit,
    this.validationRegex,
  });

  factory VinConfig.fromRawJson(String str) =>
      VinConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VinConfig.fromJson(Map<String, dynamic> json) => VinConfig(
        charWhitelist: json["charWhitelist"],
        validateCheckDigit: json["validateCheckDigit"],
        validationRegex: json["validationRegex"],
      );

  Map<String, dynamic> toJson() => {
        "charWhitelist": charWhitelist,
        "validateCheckDigit": validateCheckDigit,
        "validationRegex": validationRegex,
      };
}

///Schema for SDK ScanFeedback Configuration
class ScanFeedbackConfig {
  ///The animation style of the feedback.
  ScanFeedbackConfigAnimation? animation;

  ///The duration of the animation in milliseconds.
  int? animationDuration;

  ///If true, make a beep sound when a result is found.
  bool? beepOnResult;

  ///If true, flash the view when a result is found.
  bool? blinkAnimationOnResult;

  ///The corner radius in density-independent pixels (dp).
  int? cornerRadius;

  ///The fill color.
  String? fillColor;

  ///The timeout to redraw the visual feedback in milliseconds.
  int? redrawTimeout;

  ///The stroke color.
  String? strokeColor;

  ///The stroke width in density-independent pixels (dp).
  int? strokeWidth;

  ///The style of the feedback.
  Style? style;

  ///If true, vibrate the device when a result is found.
  bool? vibrateOnResult;

  ScanFeedbackConfig({
    this.animation,
    this.animationDuration,
    this.beepOnResult,
    this.blinkAnimationOnResult,
    this.cornerRadius,
    this.fillColor,
    this.redrawTimeout,
    this.strokeColor,
    this.strokeWidth,
    this.style,
    this.vibrateOnResult,
  });

  factory ScanFeedbackConfig.fromRawJson(String str) =>
      ScanFeedbackConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScanFeedbackConfig.fromJson(Map<String, dynamic> json) =>
      ScanFeedbackConfig(
        animation: scanFeedbackConfigAnimationValues.map[json["animation"]],
        animationDuration: json["animationDuration"],
        beepOnResult: json["beepOnResult"],
        blinkAnimationOnResult: json["blinkAnimationOnResult"],
        cornerRadius: json["cornerRadius"],
        fillColor: json["fillColor"],
        redrawTimeout: json["redrawTimeout"],
        strokeColor: json["strokeColor"],
        strokeWidth: json["strokeWidth"],
        style: styleValues.map[json["style"]],
        vibrateOnResult: json["vibrateOnResult"],
      );

  Map<String, dynamic> toJson() => {
        "animation": scanFeedbackConfigAnimationValues.reverse[animation],
        "animationDuration": animationDuration,
        "beepOnResult": beepOnResult,
        "blinkAnimationOnResult": blinkAnimationOnResult,
        "cornerRadius": cornerRadius,
        "fillColor": fillColor,
        "redrawTimeout": redrawTimeout,
        "strokeColor": strokeColor,
        "strokeWidth": strokeWidth,
        "style": styleValues.reverse[style],
        "vibrateOnResult": vibrateOnResult,
      };
}

///The animation style of the feedback.
enum ScanFeedbackConfigAnimation {
  BLINK,
  KITT,
  NONE,
  PULSE,
  PULSE_RANDOM,
  RESIZE,
  TRAVERSE_MULTI,
  TRAVERSE_SINGLE
}

final scanFeedbackConfigAnimationValues = EnumValues({
  "blink": ScanFeedbackConfigAnimation.BLINK,
  "kitt": ScanFeedbackConfigAnimation.KITT,
  "none": ScanFeedbackConfigAnimation.NONE,
  "pulse": ScanFeedbackConfigAnimation.PULSE,
  "pulse_random": ScanFeedbackConfigAnimation.PULSE_RANDOM,
  "resize": ScanFeedbackConfigAnimation.RESIZE,
  "traverse_multi": ScanFeedbackConfigAnimation.TRAVERSE_MULTI,
  "traverse_single": ScanFeedbackConfigAnimation.TRAVERSE_SINGLE
});

///The style of the feedback.
enum Style {
  ANIMATED_RECT,
  CONTOUR_POINT,
  CONTOUR_RECT,
  CONTOUR_UNDERLINE,
  NONE,
  RECT
}

final styleValues = EnumValues({
  "animated_rect": Style.ANIMATED_RECT,
  "contour_point": Style.CONTOUR_POINT,
  "contour_rect": Style.CONTOUR_RECT,
  "contour_underline": Style.CONTOUR_UNDERLINE,
  "none": Style.NONE,
  "rect": Style.RECT
});

///General configuration for UI Feedback elements
class UiFeedbackConfig {
  ///Elements inside UIFeedbackConfig.
  List<UiFeedbackElementConfig>? elements;

  ///Preset definitions inside UIFeedbackConfig.
  List<UiFeedbackPresetDefinitionConfig>? presetDefinitions;

  ///Allows to use presets.
  List<UiFeedbackPresetConfig>? presets;

  UiFeedbackConfig({
    this.elements,
    this.presetDefinitions,
    this.presets,
  });

  factory UiFeedbackConfig.fromRawJson(String str) =>
      UiFeedbackConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackConfig.fromJson(Map<String, dynamic> json) =>
      UiFeedbackConfig(
        elements: json["elements"] == null
            ? []
            : List<UiFeedbackElementConfig>.from(json["elements"]!
                .map((x) => UiFeedbackElementConfig.fromJson(x))),
        presetDefinitions: json["presetDefinitions"] == null
            ? []
            : List<UiFeedbackPresetDefinitionConfig>.from(
                json["presetDefinitions"]!
                    .map((x) => UiFeedbackPresetDefinitionConfig.fromJson(x))),
        presets: json["presets"] == null
            ? []
            : List<UiFeedbackPresetConfig>.from(json["presets"]!
                .map((x) => UiFeedbackPresetConfig.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "elements": elements == null
            ? []
            : List<dynamic>.from(elements!.map((x) => x.toJson())),
        "presetDefinitions": presetDefinitions == null
            ? []
            : List<dynamic>.from(presetDefinitions!.map((x) => x.toJson())),
        "presets": presets == null
            ? []
            : List<dynamic>.from(presets!.map((x) => x.toJson())),
      };
}

///Configuration for uiFeedback element
class UiFeedbackElementConfig {
  ///Sets whether the view is clickable.
  bool? clickable;
  ContentTypeEnum? contentType;
  UiFeedbackElementAttributesConfig? defaultAttributes;
  UiFeedbackElementContentConfig? defaultContent;

  ///Sets the id of the element.
  String? id;
  OverlayConfig? overlay;

  ///Allows to use element presets.
  List<UiFeedbackPresetConfig>? presets;

  ///Sets a tag for the element.
  String? tag;
  UiFeedbackElementTriggerConfig? trigger;

  UiFeedbackElementConfig({
    this.clickable,
    this.contentType,
    this.defaultAttributes,
    this.defaultContent,
    this.id,
    this.overlay,
    this.presets,
    this.tag,
    this.trigger,
  });

  factory UiFeedbackElementConfig.fromRawJson(String str) =>
      UiFeedbackElementConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackElementConfig.fromJson(Map<String, dynamic> json) =>
      UiFeedbackElementConfig(
        clickable: json["clickable"],
        contentType: contentTypeEnumValues.map[json["contentType"]],
        defaultAttributes: json["defaultAttributes"] == null
            ? null
            : UiFeedbackElementAttributesConfig.fromJson(
                json["defaultAttributes"]),
        defaultContent: json["defaultContent"] == null
            ? null
            : UiFeedbackElementContentConfig.fromJson(json["defaultContent"]),
        id: json["id"],
        overlay: json["overlay"] == null
            ? null
            : OverlayConfig.fromJson(json["overlay"]),
        presets: json["presets"] == null
            ? []
            : List<UiFeedbackPresetConfig>.from(json["presets"]!
                .map((x) => UiFeedbackPresetConfig.fromJson(x))),
        tag: json["tag"],
        trigger: json["trigger"] == null
            ? null
            : UiFeedbackElementTriggerConfig.fromJson(json["trigger"]),
      );

  Map<String, dynamic> toJson() => {
        "clickable": clickable,
        "contentType": contentTypeEnumValues.reverse[contentType],
        "defaultAttributes": defaultAttributes?.toJson(),
        "defaultContent": defaultContent?.toJson(),
        "id": id,
        "overlay": overlay?.toJson(),
        "presets": presets == null
            ? []
            : List<dynamic>.from(presets!.map((x) => x.toJson())),
        "tag": tag,
        "trigger": trigger?.toJson(),
      };
}

///Sets the view type of the element.
enum ContentTypeEnum { IMAGE, SOUND, TEXT }

final contentTypeEnumValues = EnumValues({
  "image": ContentTypeEnum.IMAGE,
  "sound": ContentTypeEnum.SOUND,
  "text": ContentTypeEnum.TEXT
});

///Configuration attributes for UI Feedback view elements
class UiFeedbackElementAttributesConfig {
  ///Sets the background color.
  String? backgroundColor;

  ///Sets the image scale type.
  ImageScaleType? imageScaleType;

  ///Sets the text alignment.
  TextAlignment? textAlignment;

  ///Sets the text color.
  String? textColor;

  UiFeedbackElementAttributesConfig({
    this.backgroundColor,
    this.imageScaleType,
    this.textAlignment,
    this.textColor,
  });

  factory UiFeedbackElementAttributesConfig.fromRawJson(String str) =>
      UiFeedbackElementAttributesConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackElementAttributesConfig.fromJson(
          Map<String, dynamic> json) =>
      UiFeedbackElementAttributesConfig(
        backgroundColor: json["backgroundColor"],
        imageScaleType: imageScaleTypeValues.map[json["imageScaleType"]],
        textAlignment: textAlignmentValues.map[json["textAlignment"]],
        textColor: json["textColor"],
      );

  Map<String, dynamic> toJson() => {
        "backgroundColor": backgroundColor,
        "imageScaleType": imageScaleTypeValues.reverse[imageScaleType],
        "textAlignment": textAlignmentValues.reverse[textAlignment],
        "textColor": textColor,
      };
}

///Sets the image scale type.
enum ImageScaleType { CENTER, CENTER_CROP, FIT_CENTER, FIT_XY }

final imageScaleTypeValues = EnumValues({
  "center": ImageScaleType.CENTER,
  "center_crop": ImageScaleType.CENTER_CROP,
  "fit_center": ImageScaleType.FIT_CENTER,
  "fit_xy": ImageScaleType.FIT_XY
});

///Sets the text alignment.
enum TextAlignment { CENTER, LEFT, RIGHT }

final textAlignmentValues = EnumValues({
  "center": TextAlignment.CENTER,
  "left": TextAlignment.LEFT,
  "right": TextAlignment.RIGHT
});

///Configuration for UI Feedback content
class UiFeedbackElementContentConfig {
  ///Sets the content of the element.
  String? contentValue;

  ///Sets the duration of the element.
  int? durationMills;

  ///Sets the priority of the element.
  int? priorityLevel;

  UiFeedbackElementContentConfig({
    this.contentValue,
    this.durationMills,
    this.priorityLevel,
  });

  factory UiFeedbackElementContentConfig.fromRawJson(String str) =>
      UiFeedbackElementContentConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackElementContentConfig.fromJson(Map<String, dynamic> json) =>
      UiFeedbackElementContentConfig(
        contentValue: json["contentValue"],
        durationMills: json["durationMills"],
        priorityLevel: json["priorityLevel"],
      );

  Map<String, dynamic> toJson() => {
        "contentValue": contentValue,
        "durationMills": durationMills,
        "priorityLevel": priorityLevel,
      };
}

///Configuration for UI Feedback overlays
class OverlayConfig {
  ///Sets the anchor of the overlay.
  OverlayAnchorConfig? anchor;

  ///Sets the offset dimension of the overlay.
  OverlayDimensionConfig? offsetDimension;

  ///Allows to use overlay presets.
  List<UiFeedbackPresetConfig>? presets;

  ///Sets the size dimension of the overlay.
  OverlayDimensionConfig? sizeDimension;

  ///Sets the source of the overlay.
  OverlaySource? source;

  OverlayConfig({
    this.anchor,
    this.offsetDimension,
    this.presets,
    this.sizeDimension,
    this.source,
  });

  factory OverlayConfig.fromRawJson(String str) =>
      OverlayConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OverlayConfig.fromJson(Map<String, dynamic> json) => OverlayConfig(
        anchor: overlayAnchorConfigValues.map[json["anchor"]],
        offsetDimension: json["offsetDimension"] == null
            ? null
            : OverlayDimensionConfig.fromJson(json["offsetDimension"]),
        presets: json["presets"] == null
            ? []
            : List<UiFeedbackPresetConfig>.from(json["presets"]!
                .map((x) => UiFeedbackPresetConfig.fromJson(x))),
        sizeDimension: json["sizeDimension"] == null
            ? null
            : OverlayDimensionConfig.fromJson(json["sizeDimension"]),
        source: overlaySourceValues.map[json["source"]],
      );

  Map<String, dynamic> toJson() => {
        "anchor": overlayAnchorConfigValues.reverse[anchor],
        "offsetDimension": offsetDimension?.toJson(),
        "presets": presets == null
            ? []
            : List<dynamic>.from(presets!.map((x) => x.toJson())),
        "sizeDimension": sizeDimension?.toJson(),
        "source": overlaySourceValues.reverse[source],
      };
}

///Sets the anchor of the overlay.
///
///Sets the anchor of the overlay relative to the source defined in the overlaySource.
enum OverlayAnchorConfig {
  BOTTOM_CENTER,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
  CENTER,
  CENTER_LEFT,
  CENTER_RIGHT,
  TOP_CENTER,
  TOP_LEFT,
  TOP_RIGHT
}

final overlayAnchorConfigValues = EnumValues({
  "bottom_center": OverlayAnchorConfig.BOTTOM_CENTER,
  "bottom_left": OverlayAnchorConfig.BOTTOM_LEFT,
  "bottom_right": OverlayAnchorConfig.BOTTOM_RIGHT,
  "center": OverlayAnchorConfig.CENTER,
  "center_left": OverlayAnchorConfig.CENTER_LEFT,
  "center_right": OverlayAnchorConfig.CENTER_RIGHT,
  "top_center": OverlayAnchorConfig.TOP_CENTER,
  "top_left": OverlayAnchorConfig.TOP_LEFT,
  "top_right": OverlayAnchorConfig.TOP_RIGHT
});

///Sets the offset dimension of the overlay.
///
///Sets the dimension of the overlay.
///
///Sets the size dimension of the overlay.
class OverlayDimensionConfig {
  ///Sets the scale for x axis of the overlay.
  OverlayScaleConfig? scaleX;

  ///Sets the scale for y axis of the overlay.
  OverlayScaleConfig? scaleY;

  OverlayDimensionConfig({
    this.scaleX,
    this.scaleY,
  });

  factory OverlayDimensionConfig.fromRawJson(String str) =>
      OverlayDimensionConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OverlayDimensionConfig.fromJson(Map<String, dynamic> json) =>
      OverlayDimensionConfig(
        scaleX: json["scaleX"] == null
            ? null
            : OverlayScaleConfig.fromJson(json["scaleX"]),
        scaleY: json["scaleY"] == null
            ? null
            : OverlayScaleConfig.fromJson(json["scaleY"]),
      );

  Map<String, dynamic> toJson() => {
        "scaleX": scaleX?.toJson(),
        "scaleY": scaleY?.toJson(),
      };
}

///Sets the scale for x axis of the overlay.
///
///Configuration for UI Feedback overlays
///
///Sets the scale for y axis of the overlay.
class OverlayScaleConfig {
  ///Sets the scale type of the overlay.
  OverlayScaleTypeConfig? scaleType;

  ///Sets the scale value of the overlay.
  double? scaleValue;

  OverlayScaleConfig({
    this.scaleType,
    this.scaleValue,
  });

  factory OverlayScaleConfig.fromRawJson(String str) =>
      OverlayScaleConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OverlayScaleConfig.fromJson(Map<String, dynamic> json) =>
      OverlayScaleConfig(
        scaleType: overlayScaleTypeConfigValues.map[json["scaleType"]],
        scaleValue: json["scaleValue"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "scaleType": overlayScaleTypeConfigValues.reverse[scaleType],
        "scaleValue": scaleValue,
      };
}

///Sets the scale type of the overlay.
enum OverlayScaleTypeConfig { FIXED_PX, KEEP_RATIO, NONE, OVERLAY }

final overlayScaleTypeConfigValues = EnumValues({
  "fixed_px": OverlayScaleTypeConfig.FIXED_PX,
  "keep_ratio": OverlayScaleTypeConfig.KEEP_RATIO,
  "none": OverlayScaleTypeConfig.NONE,
  "overlay": OverlayScaleTypeConfig.OVERLAY
});

///Configuration for uiFeedback preset.
class UiFeedbackPresetConfig {
  ///Attributes inside preset.
  List<UiFeedbackPresetAttributeConfig>? presetAttributes;

  ///Name of the preset.
  String? presetName;

  UiFeedbackPresetConfig({
    this.presetAttributes,
    this.presetName,
  });

  factory UiFeedbackPresetConfig.fromRawJson(String str) =>
      UiFeedbackPresetConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackPresetConfig.fromJson(Map<String, dynamic> json) =>
      UiFeedbackPresetConfig(
        presetAttributes: json["presetAttributes"] == null
            ? []
            : List<UiFeedbackPresetAttributeConfig>.from(
                json["presetAttributes"]!
                    .map((x) => UiFeedbackPresetAttributeConfig.fromJson(x))),
        presetName: json["presetName"],
      );

  Map<String, dynamic> toJson() => {
        "presetAttributes": presetAttributes == null
            ? []
            : List<dynamic>.from(presetAttributes!.map((x) => x.toJson())),
        "presetName": presetName,
      };
}

///Configuration for uiFeedback preset attribute.
class UiFeedbackPresetAttributeConfig {
  ///Name of the attribute declared in the preset definition.
  String? attributeName;

  ///Sets the value of the attribute.
  String? attributeValue;

  UiFeedbackPresetAttributeConfig({
    this.attributeName,
    this.attributeValue,
  });

  factory UiFeedbackPresetAttributeConfig.fromRawJson(String str) =>
      UiFeedbackPresetAttributeConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackPresetAttributeConfig.fromJson(Map<String, dynamic> json) =>
      UiFeedbackPresetAttributeConfig(
        attributeName: json["attributeName"],
        attributeValue: json["attributeValue"],
      );

  Map<String, dynamic> toJson() => {
        "attributeName": attributeName,
        "attributeValue": attributeValue,
      };
}

///Sets the source of the overlay.
///
///Sets the source of the overlay. Currently cutout is the only available overlay source.
enum OverlaySource { CUTOUT }

final overlaySourceValues = EnumValues({"cutout": OverlaySource.CUTOUT});

///Trigger configuration for UI Feedback
class UiFeedbackElementTriggerConfig {
  List<UiFeedbackPresetConfig>? presets;

  ///Allows to watch runSkipped events.
  List<UiFeedbackElementTriggerWhenRunSkippedConfig>? runSkipped;

  ///Allows to watch scanInfo events.
  List<UiFeedbackElementTriggerWhenScanInfoConfig>? scanInfo;

  UiFeedbackElementTriggerConfig({
    this.presets,
    this.runSkipped,
    this.scanInfo,
  });

  factory UiFeedbackElementTriggerConfig.fromRawJson(String str) =>
      UiFeedbackElementTriggerConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackElementTriggerConfig.fromJson(Map<String, dynamic> json) =>
      UiFeedbackElementTriggerConfig(
        presets: json["presets"] == null
            ? []
            : List<UiFeedbackPresetConfig>.from(json["presets"]!
                .map((x) => UiFeedbackPresetConfig.fromJson(x))),
        runSkipped: json["runSkipped"] == null
            ? []
            : List<UiFeedbackElementTriggerWhenRunSkippedConfig>.from(
                json["runSkipped"]!.map((x) =>
                    UiFeedbackElementTriggerWhenRunSkippedConfig.fromJson(x))),
        scanInfo: json["scanInfo"] == null
            ? []
            : List<UiFeedbackElementTriggerWhenScanInfoConfig>.from(
                json["scanInfo"]!.map((x) =>
                    UiFeedbackElementTriggerWhenScanInfoConfig.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "presets": presets == null
            ? []
            : List<dynamic>.from(presets!.map((x) => x.toJson())),
        "runSkipped": runSkipped == null
            ? []
            : List<dynamic>.from(runSkipped!.map((x) => x.toJson())),
        "scanInfo": scanInfo == null
            ? []
            : List<dynamic>.from(scanInfo!.map((x) => x.toJson())),
      };
}

///Configuration for triggering UI Feedback on RunSkipped events
class UiFeedbackElementTriggerWhenRunSkippedConfig {
  RunSkippedWhen? when;

  UiFeedbackElementTriggerWhenRunSkippedConfig({
    this.when,
  });

  factory UiFeedbackElementTriggerWhenRunSkippedConfig.fromRawJson(
          String str) =>
      UiFeedbackElementTriggerWhenRunSkippedConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackElementTriggerWhenRunSkippedConfig.fromJson(
          Map<String, dynamic> json) =>
      UiFeedbackElementTriggerWhenRunSkippedConfig(
        when:
            json["when"] == null ? null : RunSkippedWhen.fromJson(json["when"]),
      );

  Map<String, dynamic> toJson() => {
        "when": when?.toJson(),
      };
}

///Configuration for triggering UI Feedback on RunSkipped events
class RunSkippedWhen {
  UiFeedbackElementAttributesConfig? applyAttributesInstead;
  UiFeedbackElementContentConfig? applyContentInstead;

  ///Sets whether the trigger must apply defaultAttributes.
  bool? applyDefaultAttributes;

  ///Sets whether the trigger must apply defaultContent.
  bool? applyDefaultContent;

  ///Sets the runSkipped code to be watched.
  int? codeEquals;

  RunSkippedWhen({
    this.applyAttributesInstead,
    this.applyContentInstead,
    this.applyDefaultAttributes,
    this.applyDefaultContent,
    this.codeEquals,
  });

  factory RunSkippedWhen.fromRawJson(String str) =>
      RunSkippedWhen.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RunSkippedWhen.fromJson(Map<String, dynamic> json) => RunSkippedWhen(
        applyAttributesInstead: json["applyAttributesInstead"] == null
            ? null
            : UiFeedbackElementAttributesConfig.fromJson(
                json["applyAttributesInstead"]),
        applyContentInstead: json["applyContentInstead"] == null
            ? null
            : UiFeedbackElementContentConfig.fromJson(
                json["applyContentInstead"]),
        applyDefaultAttributes: json["applyDefaultAttributes"],
        applyDefaultContent: json["applyDefaultContent"],
        codeEquals: json["codeEquals"],
      );

  Map<String, dynamic> toJson() => {
        "applyAttributesInstead": applyAttributesInstead?.toJson(),
        "applyContentInstead": applyContentInstead?.toJson(),
        "applyDefaultAttributes": applyDefaultAttributes,
        "applyDefaultContent": applyDefaultContent,
        "codeEquals": codeEquals,
      };
}

///Configuration for triggering UI Feedback on ScanInfo events
class UiFeedbackElementTriggerWhenScanInfoConfig {
  ScanInfoWhen? when;

  UiFeedbackElementTriggerWhenScanInfoConfig({
    this.when,
  });

  factory UiFeedbackElementTriggerWhenScanInfoConfig.fromRawJson(String str) =>
      UiFeedbackElementTriggerWhenScanInfoConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackElementTriggerWhenScanInfoConfig.fromJson(
          Map<String, dynamic> json) =>
      UiFeedbackElementTriggerWhenScanInfoConfig(
        when: json["when"] == null ? null : ScanInfoWhen.fromJson(json["when"]),
      );

  Map<String, dynamic> toJson() => {
        "when": when?.toJson(),
      };
}

///Configuration for triggering UI Feedback on ScanInfo events
class ScanInfoWhen {
  UiFeedbackElementAttributesConfig? applyAttributesInstead;
  UiFeedbackElementContentConfig? applyContentInstead;

  ///Sets whether the trigger must apply defaultAttributes.
  bool? applyDefaultAttributes;

  ///Sets whether the trigger must apply defaultContent.
  bool? applyDefaultContent;

  ///Sets the ScanInfo variable name to be watched.
  String? varNameEquals;

  ///Sets the ScanInfo variable value to be watched.
  String? varValueEquals;

  ScanInfoWhen({
    this.applyAttributesInstead,
    this.applyContentInstead,
    this.applyDefaultAttributes,
    this.applyDefaultContent,
    this.varNameEquals,
    this.varValueEquals,
  });

  factory ScanInfoWhen.fromRawJson(String str) =>
      ScanInfoWhen.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScanInfoWhen.fromJson(Map<String, dynamic> json) => ScanInfoWhen(
        applyAttributesInstead: json["applyAttributesInstead"] == null
            ? null
            : UiFeedbackElementAttributesConfig.fromJson(
                json["applyAttributesInstead"]),
        applyContentInstead: json["applyContentInstead"] == null
            ? null
            : UiFeedbackElementContentConfig.fromJson(
                json["applyContentInstead"]),
        applyDefaultAttributes: json["applyDefaultAttributes"],
        applyDefaultContent: json["applyDefaultContent"],
        varNameEquals: json["varNameEquals"],
        varValueEquals: json["varValueEquals"],
      );

  Map<String, dynamic> toJson() => {
        "applyAttributesInstead": applyAttributesInstead?.toJson(),
        "applyContentInstead": applyContentInstead?.toJson(),
        "applyDefaultAttributes": applyDefaultAttributes,
        "applyDefaultContent": applyDefaultContent,
        "varNameEquals": varNameEquals,
        "varValueEquals": varValueEquals,
      };
}

///Configuration for uiFeedback preset definition.
class UiFeedbackPresetDefinitionConfig {
  ///Attributes inside preset definition.
  List<UiFeedbackPresetDefinitionAttributeConfig>? attributes;

  ///Sets the name of the preset definition.
  String? name;

  ///Configuration for uiFeedback preset content definition.
  UiFeedbackPresetContentConfig? presetContent;

  ///Sets the preset definition type.
  Type? type;

  UiFeedbackPresetDefinitionConfig({
    this.attributes,
    this.name,
    this.presetContent,
    this.type,
  });

  factory UiFeedbackPresetDefinitionConfig.fromRawJson(String str) =>
      UiFeedbackPresetDefinitionConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackPresetDefinitionConfig.fromJson(
          Map<String, dynamic> json) =>
      UiFeedbackPresetDefinitionConfig(
        attributes: json["attributes"] == null
            ? []
            : List<UiFeedbackPresetDefinitionAttributeConfig>.from(
                json["attributes"]!.map((x) =>
                    UiFeedbackPresetDefinitionAttributeConfig.fromJson(x))),
        name: json["name"],
        presetContent: json["presetContent"] == null
            ? null
            : UiFeedbackPresetContentConfig.fromJson(json["presetContent"]),
        type: typeValues.map[json["type"]],
      );

  Map<String, dynamic> toJson() => {
        "attributes": attributes == null
            ? []
            : List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "name": name,
        "presetContent": presetContent?.toJson(),
        "type": typeValues.reverse[type],
      };
}

///Configuration for uiFeedback preset definition attribute.
class UiFeedbackPresetDefinitionAttributeConfig {
  ///Sets the name of the element of the attribute.
  String? elementName;

  ///Sets the preset definition attribute element type.
  ElementTypeEnum? elementType;

  ///Sets the name of the attribute.
  String? name;

  UiFeedbackPresetDefinitionAttributeConfig({
    this.elementName,
    this.elementType,
    this.name,
  });

  factory UiFeedbackPresetDefinitionAttributeConfig.fromRawJson(String str) =>
      UiFeedbackPresetDefinitionAttributeConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackPresetDefinitionAttributeConfig.fromJson(
          Map<String, dynamic> json) =>
      UiFeedbackPresetDefinitionAttributeConfig(
        elementName: json["elementName"],
        elementType: elementTypeEnumValues.map[json["elementType"]],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "elementName": elementName,
        "elementType": elementTypeEnumValues.reverse[elementType],
        "name": name,
      };
}

///Sets the preset definition attribute element type.
enum ElementTypeEnum { ANY, BOOLEAN, DOUBLE, INT, LONG, STRING }

final elementTypeEnumValues = EnumValues({
  "any": ElementTypeEnum.ANY,
  "boolean": ElementTypeEnum.BOOLEAN,
  "double": ElementTypeEnum.DOUBLE,
  "int": ElementTypeEnum.INT,
  "long": ElementTypeEnum.LONG,
  "string": ElementTypeEnum.STRING
});

///Configuration for uiFeedback preset content definition.
class UiFeedbackPresetContentConfig {
  UiFeedbackElementConfig? element;
  List<UiFeedbackElementConfig>? elements;
  OverlayConfig? overlay;
  List<UiFeedbackPresetConfig>? presets;
  UiFeedbackElementTriggerConfig? trigger;

  UiFeedbackPresetContentConfig({
    this.element,
    this.elements,
    this.overlay,
    this.presets,
    this.trigger,
  });

  factory UiFeedbackPresetContentConfig.fromRawJson(String str) =>
      UiFeedbackPresetContentConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UiFeedbackPresetContentConfig.fromJson(Map<String, dynamic> json) =>
      UiFeedbackPresetContentConfig(
        element: json["element"] == null
            ? null
            : UiFeedbackElementConfig.fromJson(json["element"]),
        elements: json["elements"] == null
            ? []
            : List<UiFeedbackElementConfig>.from(json["elements"]!
                .map((x) => UiFeedbackElementConfig.fromJson(x))),
        overlay: json["overlay"] == null
            ? null
            : OverlayConfig.fromJson(json["overlay"]),
        presets: json["presets"] == null
            ? []
            : List<UiFeedbackPresetConfig>.from(json["presets"]!
                .map((x) => UiFeedbackPresetConfig.fromJson(x))),
        trigger: json["trigger"] == null
            ? null
            : UiFeedbackElementTriggerConfig.fromJson(json["trigger"]),
      );

  Map<String, dynamic> toJson() => {
        "element": element?.toJson(),
        "elements": elements == null
            ? []
            : List<dynamic>.from(elements!.map((x) => x.toJson())),
        "overlay": overlay?.toJson(),
        "presets": presets == null
            ? []
            : List<dynamic>.from(presets!.map((x) => x.toJson())),
        "trigger": trigger?.toJson(),
      };
}

///Sets the preset definition type.
enum Type {
  PRESET,
  PRESET_ELEMENT,
  PRESET_ELEMENT_OVERLAY,
  PRESET_ELEMENT_TRIGGER
}

final typeValues = EnumValues({
  "preset": Type.PRESET,
  "presetElement": Type.PRESET_ELEMENT,
  "presetElementOverlay": Type.PRESET_ELEMENT_OVERLAY,
  "presetElementTrigger": Type.PRESET_ELEMENT_TRIGGER
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
