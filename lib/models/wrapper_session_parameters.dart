// ignore_for_file: argument_type_not_assignable, inference_failure_on_untyped_parameter, inference_failure_on_collection_literal, avoid_dynamic_calls, sort_constructors_first, prefer_single_quotes, constant_identifier_names
import 'dart:convert';


///Top-level schema encompassing all request and response types exchanged between the
///wrapper plugin and the Anyline SDK during a scanning session.
class WrapperSessionParameters {
    WrapperSessionExportCachedEventsResponse? exportCachedEventsResponse;
    WrapperSessionScanResponse? scanResponse;
    WrapperSessionScanResultsResponse? scanResultsResponse;
    WrapperSessionScanStartRequest? scanStartRequest;
    WrapperSessionScanStopRequest? scanStopRequest;
    WrapperSessionScanViewConfigOptions? scanViewConfigOptions;
    WrapperSessionSdkInitializationRequest? sdkInitializationRequest;
    WrapperSessionSdkInitializationResponse? sdkInitializationResponse;
    WrapperSessionUcrReportRequest? ucrReportRequest;
    WrapperSessionUcrReportResponse? ucrReportResponse;

    WrapperSessionParameters({
        this.exportCachedEventsResponse,
        this.scanResponse,
        this.scanResultsResponse,
        this.scanStartRequest,
        this.scanStopRequest,
        this.scanViewConfigOptions,
        this.sdkInitializationRequest,
        this.sdkInitializationResponse,
        this.ucrReportRequest,
        this.ucrReportResponse,
    });

    factory WrapperSessionParameters.fromRawJson(String str) => WrapperSessionParameters.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionParameters.fromJson(Map<String, dynamic> json) => WrapperSessionParameters(
        exportCachedEventsResponse: json["exportCachedEventsResponse"] == null ? null : WrapperSessionExportCachedEventsResponse.fromJson(json["exportCachedEventsResponse"]),
        scanResponse: json["scanResponse"] == null ? null : WrapperSessionScanResponse.fromJson(json["scanResponse"]),
        scanResultsResponse: json["scanResultsResponse"] == null ? null : WrapperSessionScanResultsResponse.fromJson(json["scanResultsResponse"]),
        scanStartRequest: json["scanStartRequest"] == null ? null : WrapperSessionScanStartRequest.fromJson(json["scanStartRequest"]),
        scanStopRequest: json["scanStopRequest"] == null ? null : WrapperSessionScanStopRequest.fromJson(json["scanStopRequest"]),
        scanViewConfigOptions: json["scanViewConfigOptions"] == null ? null : WrapperSessionScanViewConfigOptions.fromJson(json["scanViewConfigOptions"]),
        sdkInitializationRequest: json["sdkInitializationRequest"] == null ? null : WrapperSessionSdkInitializationRequest.fromJson(json["sdkInitializationRequest"]),
        sdkInitializationResponse: json["sdkInitializationResponse"] == null ? null : WrapperSessionSdkInitializationResponse.fromJson(json["sdkInitializationResponse"]),
        ucrReportRequest: json["ucrReportRequest"] == null ? null : WrapperSessionUcrReportRequest.fromJson(json["ucrReportRequest"]),
        ucrReportResponse: json["ucrReportResponse"] == null ? null : WrapperSessionUcrReportResponse.fromJson(json["ucrReportResponse"]),
    );

    Map<String, dynamic> toJson() => {
        "exportCachedEventsResponse": exportCachedEventsResponse?.toJson(),
        "scanResponse": scanResponse?.toJson(),
        "scanResultsResponse": scanResultsResponse?.toJson(),
        "scanStartRequest": scanStartRequest?.toJson(),
        "scanStopRequest": scanStopRequest?.toJson(),
        "scanViewConfigOptions": scanViewConfigOptions?.toJson(),
        "sdkInitializationRequest": sdkInitializationRequest?.toJson(),
        "sdkInitializationResponse": sdkInitializationResponse?.toJson(),
        "ucrReportRequest": ucrReportRequest?.toJson(),
        "ucrReportResponse": ucrReportResponse?.toJson(),
    };
}


///Response from cached events export operation. Includes either failInfo (if export failed)
///or succeedInfo (if successful), corresponding to the status field.
class WrapperSessionExportCachedEventsResponse {
    
    ///Populated when status is exportFailed. Contains the error that caused the failure.
    WrapperSessionExportCachedEventsResponseFail? failInfo;
    
    ///The final status of the export operation.
    WrapperSessionExportCachedEventsResponseStatus? status;
    
    ///Populated when status is exportSucceeded. Contains the path to the exported file.
    WrapperSessionExportCachedEventsResponseSucceed? succeedInfo;

    WrapperSessionExportCachedEventsResponse({
        this.failInfo,
        this.status,
        this.succeedInfo,
    });

    factory WrapperSessionExportCachedEventsResponse.fromRawJson(String str) => WrapperSessionExportCachedEventsResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionExportCachedEventsResponse.fromJson(Map<String, dynamic> json) => WrapperSessionExportCachedEventsResponse(
        failInfo: json["failInfo"] == null ? null : WrapperSessionExportCachedEventsResponseFail.fromJson(json["failInfo"]),
        status: wrapperSessionExportCachedEventsResponseStatusValues.map[json["status"]],
        succeedInfo: json["succeedInfo"] == null ? null : WrapperSessionExportCachedEventsResponseSucceed.fromJson(json["succeedInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "failInfo": failInfo?.toJson(),
        "status": wrapperSessionExportCachedEventsResponseStatusValues.reverse[status],
        "succeedInfo": succeedInfo?.toJson(),
    };
}


///Populated when status is exportFailed. Contains the error that caused the failure.
///
///Details about a failed cached events export.
class WrapperSessionExportCachedEventsResponseFail {
    
    ///The last error received while exporting cached events.
    String? lastError;

    WrapperSessionExportCachedEventsResponseFail({
        this.lastError,
    });

    factory WrapperSessionExportCachedEventsResponseFail.fromRawJson(String str) => WrapperSessionExportCachedEventsResponseFail.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionExportCachedEventsResponseFail.fromJson(Map<String, dynamic> json) => WrapperSessionExportCachedEventsResponseFail(
        lastError: json["lastError"],
    );

    Map<String, dynamic> toJson() => {
        "lastError": lastError,
    };
}


///The final status of the export operation.
///
///Final status of a cached events export operation.
enum WrapperSessionExportCachedEventsResponseStatus {
    EXPORT_FAILED,
    EXPORT_SUCCEEDED
}

final wrapperSessionExportCachedEventsResponseStatusValues = EnumValues({
    "exportFailed": WrapperSessionExportCachedEventsResponseStatus.EXPORT_FAILED,
    "exportSucceeded": WrapperSessionExportCachedEventsResponseStatus.EXPORT_SUCCEEDED
});


///Populated when status is exportSucceeded. Contains the path to the exported file.
///
///Details about a successful cached events export.
class WrapperSessionExportCachedEventsResponseSucceed {
    
    ///Path to the generated file containing the exported cached events.
    String? exportedFile;

    WrapperSessionExportCachedEventsResponseSucceed({
        this.exportedFile,
    });

    factory WrapperSessionExportCachedEventsResponseSucceed.fromRawJson(String str) => WrapperSessionExportCachedEventsResponseSucceed.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionExportCachedEventsResponseSucceed.fromJson(Map<String, dynamic> json) => WrapperSessionExportCachedEventsResponseSucceed(
        exportedFile: json["exportedFile"],
    );

    Map<String, dynamic> toJson() => {
        "exportedFile": exportedFile,
    };
}


///Response indicating scan session completion status. Includes exactly one info object
///(failInfo, abortInfo, or succeedInfo) corresponding to the status field value.
class WrapperSessionScanResponse {
    
    ///Populated when status is scanAborted. Contains the reason for the abort.
    WrapperSessionScanResponseAbort? abortInfo;
    
    ///Populated when status is scanFailed. Contains the error that caused the failure.
    WrapperSessionScanResponseFail? failInfo;
    
    ///The result configuration that was active during the completed scan session.
    WrapperSessionScanResultConfig? scanResultConfig;
    
    ///The final status of the scan session.
    WrapperSessionScanResponseStatus? status;
    
    ///Populated when status is scanSucceeded. Contains an optional completion message.
    WrapperSessionScanResponseSucceed? succeedInfo;

    WrapperSessionScanResponse({
        this.abortInfo,
        this.failInfo,
        this.scanResultConfig,
        this.status,
        this.succeedInfo,
    });

    factory WrapperSessionScanResponse.fromRawJson(String str) => WrapperSessionScanResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanResponse.fromJson(Map<String, dynamic> json) => WrapperSessionScanResponse(
        abortInfo: json["abortInfo"] == null ? null : WrapperSessionScanResponseAbort.fromJson(json["abortInfo"]),
        failInfo: json["failInfo"] == null ? null : WrapperSessionScanResponseFail.fromJson(json["failInfo"]),
        scanResultConfig: json["scanResultConfig"] == null ? null : WrapperSessionScanResultConfig.fromJson(json["scanResultConfig"]),
        status: wrapperSessionScanResponseStatusValues.map[json["status"]],
        succeedInfo: json["succeedInfo"] == null ? null : WrapperSessionScanResponseSucceed.fromJson(json["succeedInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "abortInfo": abortInfo?.toJson(),
        "failInfo": failInfo?.toJson(),
        "scanResultConfig": scanResultConfig?.toJson(),
        "status": wrapperSessionScanResponseStatusValues.reverse[status],
        "succeedInfo": succeedInfo?.toJson(),
    };
}


///Populated when status is scanAborted. Contains the reason for the abort.
///
///Details about an aborted scan session.
class WrapperSessionScanResponseAbort {
    
    ///Optional message provided when the scan session was aborted.
    String? message;

    WrapperSessionScanResponseAbort({
        this.message,
    });

    factory WrapperSessionScanResponseAbort.fromRawJson(String str) => WrapperSessionScanResponseAbort.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanResponseAbort.fromJson(Map<String, dynamic> json) => WrapperSessionScanResponseAbort(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}


///Populated when status is scanFailed. Contains the error that caused the failure.
///
///Details about a failed scan session.
class WrapperSessionScanResponseFail {
    
    ///The last error received while trying to scan.
    String? lastError;

    WrapperSessionScanResponseFail({
        this.lastError,
    });

    factory WrapperSessionScanResponseFail.fromRawJson(String str) => WrapperSessionScanResponseFail.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanResponseFail.fromJson(Map<String, dynamic> json) => WrapperSessionScanResponseFail(
        lastError: json["lastError"],
    );

    Map<String, dynamic> toJson() => {
        "lastError": lastError,
    };
}


///The result configuration that was active during the completed scan session.
///
///Configuration for how scan results are returned and stored during a scanning session.
///
///The result configuration that was active when these results were produced.
///
///Configuration for how scan results are returned and stored during the session.
class WrapperSessionScanResultConfig {
    
    ///Deprecated. Used only by the legacy plugin. Custom callback method names for scan result
    ///and UI element click events.
    WrapperSessionScanResultCallbackConfig? callbackConfig;
    
    ///Controls when previously generated result files are removed from storage.
    WrapperSessionScanResultCleanStrategyConfig? cleanStrategy;
    
    ///Specifies how scan result images are delivered — either saved to a file path or encoded
    ///as base64 strings.
    ExportedScanResultImageContainer? imageContainer;
    
    ///Output format and quality settings for scan result images.
    ExportedScanResultImageParameters? imageParameters;

    WrapperSessionScanResultConfig({
        this.callbackConfig,
        this.cleanStrategy,
        this.imageContainer,
        this.imageParameters,
    });

    factory WrapperSessionScanResultConfig.fromRawJson(String str) => WrapperSessionScanResultConfig.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanResultConfig.fromJson(Map<String, dynamic> json) => WrapperSessionScanResultConfig(
        callbackConfig: json["callbackConfig"] == null ? null : WrapperSessionScanResultCallbackConfig.fromJson(json["callbackConfig"]),
        cleanStrategy: wrapperSessionScanResultCleanStrategyConfigValues.map[json["cleanStrategy"]],
        imageContainer: json["imageContainer"] == null ? null : ExportedScanResultImageContainer.fromJson(json["imageContainer"]),
        imageParameters: json["imageParameters"] == null ? null : ExportedScanResultImageParameters.fromJson(json["imageParameters"]),
    );

    Map<String, dynamic> toJson() => {
        "callbackConfig": callbackConfig?.toJson(),
        "cleanStrategy": wrapperSessionScanResultCleanStrategyConfigValues.reverse[cleanStrategy],
        "imageContainer": imageContainer?.toJson(),
        "imageParameters": imageParameters?.toJson(),
    };
}


///Deprecated. Used only by the legacy plugin. Custom callback method names for scan result
///and UI element click events.
///
///Deprecated. Used only by the legacy plugin. Configuration for callback method names
///invoked during scanning events.
class WrapperSessionScanResultCallbackConfig {
    
    ///Name of the callback method to invoke when scan results are available. Method will
    ///receive a list of ExportedScanResult as parameter.
    String? onResultEventName;
    
    ///Name of the callback method to invoke when user taps a UI feedback element during
    ///scanning. Method receives a UIFeedbackElementConfig as parameter.
    String? onUiElementClickedEventName;

    WrapperSessionScanResultCallbackConfig({
        this.onResultEventName,
        this.onUiElementClickedEventName,
    });

    factory WrapperSessionScanResultCallbackConfig.fromRawJson(String str) => WrapperSessionScanResultCallbackConfig.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanResultCallbackConfig.fromJson(Map<String, dynamic> json) => WrapperSessionScanResultCallbackConfig(
        onResultEventName: json["onResultEventName"],
        onUiElementClickedEventName: json["onUIElementClickedEventName"],
    );

    Map<String, dynamic> toJson() => {
        "onResultEventName": onResultEventName,
        "onUIElementClickedEventName": onUiElementClickedEventName,
    };
}


///Controls when previously generated result files are removed from storage.
enum WrapperSessionScanResultCleanStrategyConfig {
    CLEAN_FOLDER_ON_START_SCANNING,
    DELETE_RESULT_FILES_ON_FINISH_SCANNING,
    KEEP_RESULT_FILES
}

final wrapperSessionScanResultCleanStrategyConfigValues = EnumValues({
    "cleanFolderOnStartScanning": WrapperSessionScanResultCleanStrategyConfig.CLEAN_FOLDER_ON_START_SCANNING,
    "deleteResultFilesOnFinishScanning": WrapperSessionScanResultCleanStrategyConfig.DELETE_RESULT_FILES_ON_FINISH_SCANNING,
    "keepResultFiles": WrapperSessionScanResultCleanStrategyConfig.KEEP_RESULT_FILES
});


///Specifies how scan result images are delivered — either saved to a file path or encoded
///as base64 strings.
///
///Specifies how and where the scan result images are delivered.
///
///Specifies how and where scan result images are delivered. Use saved to store images to
///disk, or encoded to receive them as base64 strings in the result.
class ExportedScanResultImageContainer {
    
    ///Deliver images as base64-encoded strings embedded in the result JSON.
    ExportedScanResultImageContainerEncoded? encoded;
    
    ///Deliver images as files saved to the specified directory path.
    ExportedScanResultImageContainerSaved? saved;

    ExportedScanResultImageContainer({
        this.encoded,
        this.saved,
    });

    factory ExportedScanResultImageContainer.fromRawJson(String str) => ExportedScanResultImageContainer.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ExportedScanResultImageContainer.fromJson(Map<String, dynamic> json) => ExportedScanResultImageContainer(
        encoded: json["encoded"] == null ? null : ExportedScanResultImageContainerEncoded.fromJson(json["encoded"]),
        saved: json["saved"] == null ? null : ExportedScanResultImageContainerSaved.fromJson(json["saved"]),
    );

    Map<String, dynamic> toJson() => {
        "encoded": encoded?.toJson(),
        "saved": saved?.toJson(),
    };
}


///Deliver images as base64-encoded strings embedded in the result JSON.
///
///Image container that encodes scan result images as base64 strings in the result JSON.
class ExportedScanResultImageContainerEncoded {
    
    ///The base64-encoded image data for each image type.
    ExportedScanResultImages? images;

    ExportedScanResultImageContainerEncoded({
        this.images,
    });

    factory ExportedScanResultImageContainerEncoded.fromRawJson(String str) => ExportedScanResultImageContainerEncoded.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ExportedScanResultImageContainerEncoded.fromJson(Map<String, dynamic> json) => ExportedScanResultImageContainerEncoded(
        images: json["images"] == null ? null : ExportedScanResultImages.fromJson(json["images"]),
    );

    Map<String, dynamic> toJson() => {
        "images": images?.toJson(),
    };
}


///The base64-encoded image data for each image type.
///
///References to the images captured during scanning. Each field is a file path (saved
///container) or base64 string (encoded container). Fields are only populated for image
///types the active plugin produces.
///
///The image filenames saved in the specified path.
class ExportedScanResultImages {
    
    ///The cropped cutout image corresponding to the scanned region.
    String? cutoutImage;
    
    ///The face image extracted from the scanned document, if available.
    String? faceImage;
    
    ///The full frame image captured at the moment of the scan result.
    String? image;

    ExportedScanResultImages({
        this.cutoutImage,
        this.faceImage,
        this.image,
    });

    factory ExportedScanResultImages.fromRawJson(String str) => ExportedScanResultImages.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ExportedScanResultImages.fromJson(Map<String, dynamic> json) => ExportedScanResultImages(
        cutoutImage: json["cutoutImage"],
        faceImage: json["faceImage"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "cutoutImage": cutoutImage,
        "faceImage": faceImage,
        "image": image,
    };
}


///Deliver images as files saved to the specified directory path.
///
///Image container that saves scan result images to a local file path.
class ExportedScanResultImageContainerSaved {
    
    ///The image filenames saved in the specified path.
    ExportedScanResultImages? images;
    
    ///Directory path where scan result images are saved.
    String? path;

    ExportedScanResultImageContainerSaved({
        this.images,
        this.path,
    });

    factory ExportedScanResultImageContainerSaved.fromRawJson(String str) => ExportedScanResultImageContainerSaved.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ExportedScanResultImageContainerSaved.fromJson(Map<String, dynamic> json) => ExportedScanResultImageContainerSaved(
        images: json["images"] == null ? null : ExportedScanResultImages.fromJson(json["images"]),
        path: json["path"],
    );

    Map<String, dynamic> toJson() => {
        "images": images?.toJson(),
        "path": path,
    };
}


///Output format and quality settings for scan result images.
///
///Output format and quality settings applied to all images exported with this scan result.
class ExportedScanResultImageParameters {
    
    ///Image format used when exporting scan result images.
    ExportedScanResultImageFormat? format;
    
    ///Compression quality for exported images, from 1 (lowest) to 100 (highest).
    int? quality;

    ExportedScanResultImageParameters({
        this.format,
        this.quality,
    });

    factory ExportedScanResultImageParameters.fromRawJson(String str) => ExportedScanResultImageParameters.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ExportedScanResultImageParameters.fromJson(Map<String, dynamic> json) => ExportedScanResultImageParameters(
        format: exportedScanResultImageFormatValues.map[json["format"]],
        quality: json["quality"],
    );

    Map<String, dynamic> toJson() => {
        "format": exportedScanResultImageFormatValues.reverse[format],
        "quality": quality,
    };
}


///Image format used when exporting scan result images.
enum ExportedScanResultImageFormat {
    JPG,
    PNG
}

final exportedScanResultImageFormatValues = EnumValues({
    "jpg": ExportedScanResultImageFormat.JPG,
    "png": ExportedScanResultImageFormat.PNG
});


///The final status of the scan session.
///
///Final status of a scan session.
enum WrapperSessionScanResponseStatus {
    SCAN_ABORTED,
    SCAN_FAILED,
    SCAN_SUCCEEDED
}

final wrapperSessionScanResponseStatusValues = EnumValues({
    "scanAborted": WrapperSessionScanResponseStatus.SCAN_ABORTED,
    "scanFailed": WrapperSessionScanResponseStatus.SCAN_FAILED,
    "scanSucceeded": WrapperSessionScanResponseStatus.SCAN_SUCCEEDED
});


///Populated when status is scanSucceeded. Contains an optional completion message.
///
///Details about a successfully completed scan session.
class WrapperSessionScanResponseSucceed {
    
    ///Optional informational message from the completed scan session.
    String? message;

    WrapperSessionScanResponseSucceed({
        this.message,
    });

    factory WrapperSessionScanResponseSucceed.fromRawJson(String str) => WrapperSessionScanResponseSucceed.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanResponseSucceed.fromJson(Map<String, dynamic> json) => WrapperSessionScanResponseSucceed(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}


///Information about the results collected during the scanning process.
class WrapperSessionScanResultsResponse {
    
    ///List of scan results produced in this scanning event, one per detected item.
    List<ExportedScanResult>? exportedScanResults;
    
    ///The result configuration that was active when these results were produced.
    WrapperSessionScanResultConfig? scanResultConfig;
    
    ///Additional metadata about the source plugin that produced these results.
    WrapperSessionScanResultExtraInfo? scanResultExtraInfo;

    WrapperSessionScanResultsResponse({
        this.exportedScanResults,
        this.scanResultConfig,
        this.scanResultExtraInfo,
    });

    factory WrapperSessionScanResultsResponse.fromRawJson(String str) => WrapperSessionScanResultsResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanResultsResponse.fromJson(Map<String, dynamic> json) => WrapperSessionScanResultsResponse(
        exportedScanResults: json["exportedScanResults"] == null ? [] : List<ExportedScanResult>.from(json["exportedScanResults"]!.map((x) => ExportedScanResult.fromJson(x))),
        scanResultConfig: json["scanResultConfig"] == null ? null : WrapperSessionScanResultConfig.fromJson(json["scanResultConfig"]),
        scanResultExtraInfo: json["scanResultExtraInfo"] == null ? null : WrapperSessionScanResultExtraInfo.fromJson(json["scanResultExtraInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "exportedScanResults": exportedScanResults == null ? [] : List<dynamic>.from(exportedScanResults!.map((x) => x.toJson())),
        "scanResultConfig": scanResultConfig?.toJson(),
        "scanResultExtraInfo": scanResultExtraInfo?.toJson(),
    };
}


///A single scan result exported from the Anyline SDK, containing the plugin-specific result
///data together with the associated scan images.
class ExportedScanResult {
    
    ///Specifies how and where the scan result images are delivered.
    ExportedScanResultImageContainer? imageContainer;
    
    ///Output format and quality settings applied to all images exported with this scan result.
    ExportedScanResultImageParameters? imageParameters;
    
    ///The plugin-specific scan result produced by the Anyline SDK.
    PluginResult? pluginResult;

    ExportedScanResult({
        this.imageContainer,
        this.imageParameters,
        this.pluginResult,
    });

    factory ExportedScanResult.fromRawJson(String str) => ExportedScanResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ExportedScanResult.fromJson(Map<String, dynamic> json) => ExportedScanResult(
        imageContainer: json["imageContainer"] == null ? null : ExportedScanResultImageContainer.fromJson(json["imageContainer"]),
        imageParameters: json["imageParameters"] == null ? null : ExportedScanResultImageParameters.fromJson(json["imageParameters"]),
        pluginResult: json["pluginResult"] == null ? null : PluginResult.fromJson(json["pluginResult"]),
    );

    Map<String, dynamic> toJson() => {
        "imageContainer": imageContainer?.toJson(),
        "imageParameters": imageParameters?.toJson(),
        "pluginResult": pluginResult?.toJson(),
    };
}


///The plugin-specific scan result produced by the Anyline SDK.
///
///Describes all kinds of scan results
class PluginResult {
    BarcodeResult? barcodeResult;
    
    ///The blobKey (provided optionally, depending on the Anyline license settings)
    String? blobKey;
    CommercialTireIdResult? commercialTireIdResult;
    
    ///Provides a general confidence value between 0 and 100 if applicable. -1 if no confidence
    ///was calculated
    int? confidence;
    ContainerResult? containerResult;
    
    ///The rect information of the region that was processed within the image
    CropRect? cropRect;
    JapaneseLandingPermissionResult? japaneseLandingPermissionResult;
    LicensePlateResult? licensePlateResult;
    MeterResult? meterResult;
    MrzResult? mrzResult;
    OcrResult? ocrResult;
    OdometerResult? odometerResult;
    
    ///representing time measurements for different parts of the process.
    PerformanceMetrics? performanceMetrics;
    
    ///The ID of the ScanPlugin that processed the result
    String? pluginId;
    TinResult? tinResult;
    TireMakeResult? tireMakeResult;
    TireSizeResult? tireSizeResult;
    
    ///A unique UUIDv4 generated for each scan controller process run.
    String? transactionId;
    UniversalIdResult? universalIdResult;
    VehicleRegistrationCertificateResult? vehicleRegistrationCertificateResult;
    VinResult? vinResult;

    PluginResult({
        this.barcodeResult,
        this.blobKey,
        this.commercialTireIdResult,
        this.confidence,
        this.containerResult,
        this.cropRect,
        this.japaneseLandingPermissionResult,
        this.licensePlateResult,
        this.meterResult,
        this.mrzResult,
        this.ocrResult,
        this.odometerResult,
        this.performanceMetrics,
        this.pluginId,
        this.tinResult,
        this.tireMakeResult,
        this.tireSizeResult,
        this.transactionId,
        this.universalIdResult,
        this.vehicleRegistrationCertificateResult,
        this.vinResult,
    });

    factory PluginResult.fromRawJson(String str) => PluginResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PluginResult.fromJson(Map<String, dynamic> json) => PluginResult(
        barcodeResult: json["barcodeResult"] == null ? null : BarcodeResult.fromJson(json["barcodeResult"]),
        blobKey: json["blobKey"],
        commercialTireIdResult: json["commercialTireIdResult"] == null ? null : CommercialTireIdResult.fromJson(json["commercialTireIdResult"]),
        confidence: json["confidence"],
        containerResult: json["containerResult"] == null ? null : ContainerResult.fromJson(json["containerResult"]),
        cropRect: json["cropRect"] == null ? null : CropRect.fromJson(json["cropRect"]),
        japaneseLandingPermissionResult: json["japaneseLandingPermissionResult"] == null ? null : JapaneseLandingPermissionResult.fromJson(json["japaneseLandingPermissionResult"]),
        licensePlateResult: json["licensePlateResult"] == null ? null : LicensePlateResult.fromJson(json["licensePlateResult"]),
        meterResult: json["meterResult"] == null ? null : MeterResult.fromJson(json["meterResult"]),
        mrzResult: json["mrzResult"] == null ? null : MrzResult.fromJson(json["mrzResult"]),
        ocrResult: json["ocrResult"] == null ? null : OcrResult.fromJson(json["ocrResult"]),
        odometerResult: json["odometerResult"] == null ? null : OdometerResult.fromJson(json["odometerResult"]),
        performanceMetrics: json["performanceMetrics"] == null ? null : PerformanceMetrics.fromJson(json["performanceMetrics"]),
        pluginId: json["pluginID"],
        tinResult: json["tinResult"] == null ? null : TinResult.fromJson(json["tinResult"]),
        tireMakeResult: json["tireMakeResult"] == null ? null : TireMakeResult.fromJson(json["tireMakeResult"]),
        tireSizeResult: json["tireSizeResult"] == null ? null : TireSizeResult.fromJson(json["tireSizeResult"]),
        transactionId: json["transactionId"],
        universalIdResult: json["universalIdResult"] == null ? null : UniversalIdResult.fromJson(json["universalIdResult"]),
        vehicleRegistrationCertificateResult: json["vehicleRegistrationCertificateResult"] == null ? null : VehicleRegistrationCertificateResult.fromJson(json["vehicleRegistrationCertificateResult"]),
        vinResult: json["vinResult"] == null ? null : VinResult.fromJson(json["vinResult"]),
    );

    Map<String, dynamic> toJson() => {
        "barcodeResult": barcodeResult?.toJson(),
        "blobKey": blobKey,
        "commercialTireIdResult": commercialTireIdResult?.toJson(),
        "confidence": confidence,
        "containerResult": containerResult?.toJson(),
        "cropRect": cropRect?.toJson(),
        "japaneseLandingPermissionResult": japaneseLandingPermissionResult?.toJson(),
        "licensePlateResult": licensePlateResult?.toJson(),
        "meterResult": meterResult?.toJson(),
        "mrzResult": mrzResult?.toJson(),
        "ocrResult": ocrResult?.toJson(),
        "odometerResult": odometerResult?.toJson(),
        "performanceMetrics": performanceMetrics?.toJson(),
        "pluginID": pluginId,
        "tinResult": tinResult?.toJson(),
        "tireMakeResult": tireMakeResult?.toJson(),
        "tireSizeResult": tireSizeResult?.toJson(),
        "transactionId": transactionId,
        "universalIdResult": universalIdResult?.toJson(),
        "vehicleRegistrationCertificateResult": vehicleRegistrationCertificateResult?.toJson(),
        "vinResult": vinResult?.toJson(),
    };
}


///Describes result information of scanning barcodes
class BarcodeResult {
    
    ///Contains a list of one or more barcodes found on the processed image
    List<Barcode>? barcodes;

    BarcodeResult({
        this.barcodes,
    });

    factory BarcodeResult.fromRawJson(String str) => BarcodeResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BarcodeResult.fromJson(Map<String, dynamic> json) => BarcodeResult(
        barcodes: json["barcodes"] == null ? [] : List<Barcode>.from(json["barcodes"]!.map((x) => Barcode.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "barcodes": barcodes == null ? [] : List<dynamic>.from(barcodes!.map((x) => x.toJson())),
    };
}


///Describes barcode information
class Barcode {
    Aamva? aamva;
    
    ///Contains the base64-encoded value
    String? base64Value;
    
    ///Corner points of a polygon surrounding the discovered barcode, starting from the
    ///bottom-left coordinate going counter-clockwise. The coordinates are in reference to the
    ///image of the plugin result.
    List<int>? coordinates;
    
    ///The barcode format
    String? format;
    
    ///The value of the barcode
    String? value;

    Barcode({
        this.aamva,
        this.base64Value,
        this.coordinates,
        this.format,
        this.value,
    });

    factory Barcode.fromRawJson(String str) => Barcode.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
        aamva: json["aamva"] == null ? null : Aamva.fromJson(json["aamva"]),
        base64Value: json["base64value"],
        coordinates: json["coordinates"] == null ? [] : List<int>.from(json["coordinates"]!.map((x) => x)),
        format: json["format"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "aamva": aamva?.toJson(),
        "base64value": base64Value,
        "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
        "format": format,
        "value": value,
    };
}


///Holds all encoded barcode information according to the AAMVA standard
class Aamva {
    int? aamvaVersion;
    BodyPart? bodyPart;

    Aamva({
        this.aamvaVersion,
        this.bodyPart,
    });

    factory Aamva.fromRawJson(String str) => Aamva.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Aamva.fromJson(Map<String, dynamic> json) => Aamva(
        aamvaVersion: json["AAMVA_version"],
        bodyPart: json["body-part"] == null ? null : BodyPart.fromJson(json["body-part"]),
    );

    Map<String, dynamic> toJson() => {
        "AAMVA_version": aamvaVersion,
        "body-part": bodyPart?.toJson(),
    };
}

class BodyPart {
    String? auditInformation;
    String? cardRevisionDate;
    String? city;
    String? complianceType;
    String? countryId;
    String? customerIdNumber;
    String? dateOfBirth;
    String? dateOfExpiry;
    String? dateOfIssue;
    String? documentDiscriminator;
    String? drivingPrivilege;
    String? endorsementCode;
    String? eyes;
    String? firstName;
    String? firstNameTruncated;
    String? hair;
    String? height;
    String? inventoryControlNumber;
    String? jurisdictionCode;
    String? lastName;
    String? lastNameTruncated;
    String? licenseClass;
    String? middleName;
    String? middleNameTruncated;
    String? postalCode;
    String? sex;
    String? street;

    BodyPart({
        this.auditInformation,
        this.cardRevisionDate,
        this.city,
        this.complianceType,
        this.countryId,
        this.customerIdNumber,
        this.dateOfBirth,
        this.dateOfExpiry,
        this.dateOfIssue,
        this.documentDiscriminator,
        this.drivingPrivilege,
        this.endorsementCode,
        this.eyes,
        this.firstName,
        this.firstNameTruncated,
        this.hair,
        this.height,
        this.inventoryControlNumber,
        this.jurisdictionCode,
        this.lastName,
        this.lastNameTruncated,
        this.licenseClass,
        this.middleName,
        this.middleNameTruncated,
        this.postalCode,
        this.sex,
        this.street,
    });

    factory BodyPart.fromRawJson(String str) => BodyPart.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BodyPart.fromJson(Map<String, dynamic> json) => BodyPart(
        auditInformation: json["auditInformation"],
        cardRevisionDate: json["cardRevisionDate"],
        city: json["city"],
        complianceType: json["complianceType"],
        countryId: json["countryID"],
        customerIdNumber: json["customerIDNumber"],
        dateOfBirth: json["dateOfBirth"],
        dateOfExpiry: json["dateOfExpiry"],
        dateOfIssue: json["dateOfIssue"],
        documentDiscriminator: json["documentDiscriminator"],
        drivingPrivilege: json["drivingPrivilege"],
        endorsementCode: json["endorsementCode"],
        eyes: json["eyes"],
        firstName: json["firstName"],
        firstNameTruncated: json["firstNameTruncated"],
        hair: json["hair"],
        height: json["height"],
        inventoryControlNumber: json["inventoryControlNumber"],
        jurisdictionCode: json["jurisdictionCode"],
        lastName: json["lastName"],
        lastNameTruncated: json["lastNameTruncated"],
        licenseClass: json["licenseClass"],
        middleName: json["middleName"],
        middleNameTruncated: json["middleNameTruncated"],
        postalCode: json["postalCode"],
        sex: json["sex"],
        street: json["street"],
    );

    Map<String, dynamic> toJson() => {
        "auditInformation": auditInformation,
        "cardRevisionDate": cardRevisionDate,
        "city": city,
        "complianceType": complianceType,
        "countryID": countryId,
        "customerIDNumber": customerIdNumber,
        "dateOfBirth": dateOfBirth,
        "dateOfExpiry": dateOfExpiry,
        "dateOfIssue": dateOfIssue,
        "documentDiscriminator": documentDiscriminator,
        "drivingPrivilege": drivingPrivilege,
        "endorsementCode": endorsementCode,
        "eyes": eyes,
        "firstName": firstName,
        "firstNameTruncated": firstNameTruncated,
        "hair": hair,
        "height": height,
        "inventoryControlNumber": inventoryControlNumber,
        "jurisdictionCode": jurisdictionCode,
        "lastName": lastName,
        "lastNameTruncated": lastNameTruncated,
        "licenseClass": licenseClass,
        "middleName": middleName,
        "middleNameTruncated": middleNameTruncated,
        "postalCode": postalCode,
        "sex": sex,
        "street": street,
    };
}


///Describes result information of scanning commercial tire IDs
class CommercialTireIdResult {
    
    ///The text value of the commercial tire ID
    String? text;

    CommercialTireIdResult({
        this.text,
    });

    factory CommercialTireIdResult.fromRawJson(String str) => CommercialTireIdResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CommercialTireIdResult.fromJson(Map<String, dynamic> json) => CommercialTireIdResult(
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
    };
}


///Describes result information of scanning shipping containers
class ContainerResult {
    
    ///The text value of the shipping container
    String? text;

    ContainerResult({
        this.text,
    });

    factory ContainerResult.fromRawJson(String str) => ContainerResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ContainerResult.fromJson(Map<String, dynamic> json) => ContainerResult(
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
    };
}


///The rect information of the region that was processed within the image
class CropRect {
    
    ///The height
    int? height;
    
    ///The width
    int? width;
    
    ///The X value
    int? x;
    
    ///The Y value
    int? y;

    CropRect({
        this.height,
        this.width,
        this.x,
        this.y,
    });

    factory CropRect.fromRawJson(String str) => CropRect.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CropRect.fromJson(Map<String, dynamic> json) => CropRect(
        height: json["height"],
        width: json["width"],
        x: json["x"],
        y: json["y"],
    );

    Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
        "x": x,
        "y": y,
    };
}


///Describes result information of scanning japanese landing permission tickets
class JapaneseLandingPermissionResult {
    
    ///Yields field information of a japanese landing permission ticket
    JlpResult? result;

    JapaneseLandingPermissionResult({
        this.result,
    });

    factory JapaneseLandingPermissionResult.fromRawJson(String str) => JapaneseLandingPermissionResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory JapaneseLandingPermissionResult.fromJson(Map<String, dynamic> json) => JapaneseLandingPermissionResult(
        result: json["result"] == null ? null : JlpResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
    };
}


///Yields field information of a japanese landing permission ticket
class JlpResult {
    JapaneseLandingPermissionResultField? airport;
    JapaneseLandingPermissionResultField? dateOfExpiry;
    JapaneseLandingPermissionResultField? dateOfIssue;
    JapaneseLandingPermissionResultField? duration;
    JapaneseLandingPermissionResultField? status;

    JlpResult({
        this.airport,
        this.dateOfExpiry,
        this.dateOfIssue,
        this.duration,
        this.status,
    });

    factory JlpResult.fromRawJson(String str) => JlpResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory JlpResult.fromJson(Map<String, dynamic> json) => JlpResult(
        airport: json["airport"] == null ? null : JapaneseLandingPermissionResultField.fromJson(json["airport"]),
        dateOfExpiry: json["dateOfExpiry"] == null ? null : JapaneseLandingPermissionResultField.fromJson(json["dateOfExpiry"]),
        dateOfIssue: json["dateOfIssue"] == null ? null : JapaneseLandingPermissionResultField.fromJson(json["dateOfIssue"]),
        duration: json["duration"] == null ? null : JapaneseLandingPermissionResultField.fromJson(json["duration"]),
        status: json["status"] == null ? null : JapaneseLandingPermissionResultField.fromJson(json["status"]),
    );

    Map<String, dynamic> toJson() => {
        "airport": airport?.toJson(),
        "dateOfExpiry": dateOfExpiry?.toJson(),
        "dateOfIssue": dateOfIssue?.toJson(),
        "duration": duration?.toJson(),
        "status": status?.toJson(),
    };
}


///Provides result information for japanese landing permission fields
class JapaneseLandingPermissionResultField {
    
    ///The confidence information of the field
    int? confidence;
    
    ///The text information of the field
    String? text;

    JapaneseLandingPermissionResultField({
        this.confidence,
        this.text,
    });

    factory JapaneseLandingPermissionResultField.fromRawJson(String str) => JapaneseLandingPermissionResultField.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory JapaneseLandingPermissionResultField.fromJson(Map<String, dynamic> json) => JapaneseLandingPermissionResultField(
        confidence: json["confidence"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "confidence": confidence,
        "text": text,
    };
}


///Describes result information of scanning license plates
class LicensePlateResult {
    
    ///The area information
    Area? area;
    
    ///The country information
    String? country;
    
    ///The plate text
    String? plateText;
    
    ///(Optional) If vehicleInspectionSticker config is OPTIONAL, this is true if a Visual
    ///Inspection Sticker was found, false otherwise. If the config is MANDATORY, this field is
    ///always true.
    bool? vehicleInspectionFound;
    
    ///(Optional) The month depicted on the Visual Inspection Sticker.
    String? vehicleInspectionMonth;
    
    ///(Optional) This is true, if the Visual Inspection Sticker depicts a date in the future.
    bool? vehicleInspectionValid;
    
    ///(Optional) The year depicted on the Visual Inspection Sticker.
    String? vehicleInspectionYear;

    LicensePlateResult({
        this.area,
        this.country,
        this.plateText,
        this.vehicleInspectionFound,
        this.vehicleInspectionMonth,
        this.vehicleInspectionValid,
        this.vehicleInspectionYear,
    });

    factory LicensePlateResult.fromRawJson(String str) => LicensePlateResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LicensePlateResult.fromJson(Map<String, dynamic> json) => LicensePlateResult(
        area: areaValues.map[json["area"]],
        country: json["country"],
        plateText: json["plateText"],
        vehicleInspectionFound: json["vehicleInspectionFound"],
        vehicleInspectionMonth: json["vehicleInspectionMonth"],
        vehicleInspectionValid: json["vehicleInspectionValid"],
        vehicleInspectionYear: json["vehicleInspectionYear"],
    );

    Map<String, dynamic> toJson() => {
        "area": areaValues.reverse[area],
        "country": country,
        "plateText": plateText,
        "vehicleInspectionFound": vehicleInspectionFound,
        "vehicleInspectionMonth": vehicleInspectionMonth,
        "vehicleInspectionValid": vehicleInspectionValid,
        "vehicleInspectionYear": vehicleInspectionYear,
    };
}


///The area information
enum Area {
    ALABAMA,
    ALASKA,
    ALBERTA,
    AMERICAN_SAMOA,
    ARIZONA,
    ARKANSAS,
    BRITISH_COLUMBIA,
    CALIFORNIA,
    COLORADO,
    CONNECTICUT,
    DELAWARE,
    DISTRICT_OF_COLUMBIA,
    FLORIDA,
    GEORGIA,
    GUAM,
    HAWAII,
    IDAHO,
    ILLINOIS,
    INDIANA,
    IOWA,
    KANSAS,
    KENTUCKY,
    LOUISIANA,
    MAINE,
    MANITOBA,
    MARYLAND,
    MASSACHUSETTS,
    MICHIGAN,
    MINNESOTA,
    MISSISSIPPI,
    MISSOURI,
    MONTANA,
    NEBRASKA,
    NEVADA,
    NEW_BRUNSWICK,
    NEW_HAMPSHIRE,
    NEW_JERSEY,
    NEW_MEXICO,
    NEW_YORK,
    NORTH_CAROLINA,
    NORTH_DAKOTA,
    NOVA_SCOTIA,
    OHIO,
    OKLAHOMA,
    ONTARIO,
    OREGON,
    PENNSYLVANIA,
    PUERTO_RICO,
    QUEBEC,
    RHODE_ISLAND,
    SASKATCHEWAN,
    SOUTH_CAROLINA,
    SOUTH_DAKOTA,
    TENNESSEE,
    TEXAS,
    UTAH,
    VERMONT,
    VIRGINIA,
    WASHINGTON,
    WEST_VIRGINIA,
    WISCONSIN,
    WYOMING
}

final areaValues = EnumValues({
    "Alabama": Area.ALABAMA,
    "Alaska": Area.ALASKA,
    "Alberta": Area.ALBERTA,
    "American Samoa": Area.AMERICAN_SAMOA,
    "Arizona": Area.ARIZONA,
    "Arkansas": Area.ARKANSAS,
    "British Columbia": Area.BRITISH_COLUMBIA,
    "California": Area.CALIFORNIA,
    "Colorado": Area.COLORADO,
    "Connecticut": Area.CONNECTICUT,
    "Delaware": Area.DELAWARE,
    "District of Columbia": Area.DISTRICT_OF_COLUMBIA,
    "Florida": Area.FLORIDA,
    "Georgia": Area.GEORGIA,
    "Guam": Area.GUAM,
    "Hawaii": Area.HAWAII,
    "Idaho": Area.IDAHO,
    "Illinois": Area.ILLINOIS,
    "Indiana": Area.INDIANA,
    "Iowa": Area.IOWA,
    "Kansas": Area.KANSAS,
    "Kentucky": Area.KENTUCKY,
    "Louisiana": Area.LOUISIANA,
    "Maine": Area.MAINE,
    "Manitoba": Area.MANITOBA,
    "Maryland": Area.MARYLAND,
    "Massachusetts": Area.MASSACHUSETTS,
    "Michigan": Area.MICHIGAN,
    "Minnesota": Area.MINNESOTA,
    "Mississippi": Area.MISSISSIPPI,
    "Missouri": Area.MISSOURI,
    "Montana": Area.MONTANA,
    "Nebraska": Area.NEBRASKA,
    "Nevada": Area.NEVADA,
    "New Brunswick": Area.NEW_BRUNSWICK,
    "New Hampshire": Area.NEW_HAMPSHIRE,
    "New Jersey": Area.NEW_JERSEY,
    "New Mexico": Area.NEW_MEXICO,
    "New York": Area.NEW_YORK,
    "North Carolina": Area.NORTH_CAROLINA,
    "North Dakota": Area.NORTH_DAKOTA,
    "Nova Scotia": Area.NOVA_SCOTIA,
    "Ohio": Area.OHIO,
    "Oklahoma": Area.OKLAHOMA,
    "Ontario": Area.ONTARIO,
    "Oregon": Area.OREGON,
    "Pennsylvania": Area.PENNSYLVANIA,
    "Puerto Rico": Area.PUERTO_RICO,
    "Quebec": Area.QUEBEC,
    "Rhode Island": Area.RHODE_ISLAND,
    "Saskatchewan": Area.SASKATCHEWAN,
    "South Carolina": Area.SOUTH_CAROLINA,
    "South Dakota": Area.SOUTH_DAKOTA,
    "Tennessee": Area.TENNESSEE,
    "Texas": Area.TEXAS,
    "Utah": Area.UTAH,
    "Vermont": Area.VERMONT,
    "Virginia": Area.VIRGINIA,
    "Washington": Area.WASHINGTON,
    "West Virginia": Area.WEST_VIRGINIA,
    "Wisconsin": Area.WISCONSIN,
    "Wyoming": Area.WYOMING
});


///Describes result information of scanning meters
class MeterResult {
    
    ///The position. Only applicable for OBIS meters - see https://onemeter.com/docs/device/obis/
    String? position;
    
    ///The unit value. Only applicable for multi-field meter scanning.
    String? unit;
    
    ///The meter value.
    String? value;

    MeterResult({
        this.position,
        this.unit,
        this.value,
    });

    factory MeterResult.fromRawJson(String str) => MeterResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MeterResult.fromJson(Map<String, dynamic> json) => MeterResult(
        position: json["position"],
        unit: json["unit"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "position": position,
        "unit": unit,
        "value": value,
    };
}


///Describes result information of scanning MRZ
class MrzResult {
    
    ///True if all check digits are valid
    bool? allCheckDigitsValid;
    
    ///The CheckDigitDateOfBirth
    String? checkDigitDateOfBirth;
    
    ///The CheckDigitDateOfExpiry
    String? checkDigitDateOfExpiry;
    
    ///The CheckDigitDocumentNumber
    String? checkDigitDocumentNumber;
    
    ///The CheckDigitFinal
    String? checkDigitFinal;
    
    ///The CheckDigitPersonalNumber
    String? checkDigitPersonalNumber;
    
    ///The DateOfBirth
    String? dateOfBirth;
    
    ///The DateOfBirthObject
    String? dateOfBirthObject;
    
    ///The DateOfExpiry
    String? dateOfExpiry;
    
    ///The DateOfExpiryObject
    String? dateOfExpiryObject;
    
    ///The DocumentNumber
    String? documentNumber;
    
    ///The DocumentType
    String? documentType;
    
    ///The confidence values of each field
    FieldConfidences? fieldConfidences;
    
    ///The FirstName
    String? firstName;
    
    ///The GivenNames
    String? givenNames;
    
    ///The IssuingCountryCode
    String? issuingCountryCode;
    
    ///The LastName
    String? lastName;
    
    ///The MRZString
    String? mrzString;
    
    ///The NationalityCountryCode
    String? nationalityCountryCode;
    
    ///The OptionalData
    String? optionalData;
    
    ///The PersonalNumber
    String? personalNumber;
    
    ///The Sex
    String? sex;
    
    ///The Surname
    String? surname;
    
    ///The Adress of the Visual Inspection Zone
    String? vizAddress;
    
    ///The DateOfBirth of the Visual Inspection Zone
    String? vizDateOfBirth;
    
    ///The DateOfBirthObject of the Visual Inspection Zone
    String? vizDateOfBirthObject;
    
    ///The DateOfExpiry of the Visual Inspection Zone
    String? vizDateOfExpiry;
    
    ///The DateOfExpiryObject of the Visual Inspection Zone
    String? vizDateOfExpiryObject;
    
    ///The DateOfIssue of the Visual Inspection Zone
    String? vizDateOfIssue;
    
    ///The DateOfIssueObject of the Visual Inspection Zone
    String? vizDateOfIssueObject;
    
    ///The GivenNames of the Visual Inspection Zone
    String? vizGivenNames;
    
    ///The Surname of the Visual Inspection Zone
    String? vizSurname;

    MrzResult({
        this.allCheckDigitsValid,
        this.checkDigitDateOfBirth,
        this.checkDigitDateOfExpiry,
        this.checkDigitDocumentNumber,
        this.checkDigitFinal,
        this.checkDigitPersonalNumber,
        this.dateOfBirth,
        this.dateOfBirthObject,
        this.dateOfExpiry,
        this.dateOfExpiryObject,
        this.documentNumber,
        this.documentType,
        this.fieldConfidences,
        this.firstName,
        this.givenNames,
        this.issuingCountryCode,
        this.lastName,
        this.mrzString,
        this.nationalityCountryCode,
        this.optionalData,
        this.personalNumber,
        this.sex,
        this.surname,
        this.vizAddress,
        this.vizDateOfBirth,
        this.vizDateOfBirthObject,
        this.vizDateOfExpiry,
        this.vizDateOfExpiryObject,
        this.vizDateOfIssue,
        this.vizDateOfIssueObject,
        this.vizGivenNames,
        this.vizSurname,
    });

    factory MrzResult.fromRawJson(String str) => MrzResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MrzResult.fromJson(Map<String, dynamic> json) => MrzResult(
        allCheckDigitsValid: json["allCheckDigitsValid"],
        checkDigitDateOfBirth: json["checkDigitDateOfBirth"],
        checkDigitDateOfExpiry: json["checkDigitDateOfExpiry"],
        checkDigitDocumentNumber: json["checkDigitDocumentNumber"],
        checkDigitFinal: json["checkDigitFinal"],
        checkDigitPersonalNumber: json["checkDigitPersonalNumber"],
        dateOfBirth: json["dateOfBirth"],
        dateOfBirthObject: json["dateOfBirthObject"],
        dateOfExpiry: json["dateOfExpiry"],
        dateOfExpiryObject: json["dateOfExpiryObject"],
        documentNumber: json["documentNumber"],
        documentType: json["documentType"],
        fieldConfidences: json["fieldConfidences"] == null ? null : FieldConfidences.fromJson(json["fieldConfidences"]),
        firstName: json["firstName"],
        givenNames: json["givenNames"],
        issuingCountryCode: json["issuingCountryCode"],
        lastName: json["lastName"],
        mrzString: json["mrzString"],
        nationalityCountryCode: json["nationalityCountryCode"],
        optionalData: json["optionalData"],
        personalNumber: json["personalNumber"],
        sex: json["sex"],
        surname: json["surname"],
        vizAddress: json["vizAddress"],
        vizDateOfBirth: json["vizDateOfBirth"],
        vizDateOfBirthObject: json["vizDateOfBirthObject"],
        vizDateOfExpiry: json["vizDateOfExpiry"],
        vizDateOfExpiryObject: json["vizDateOfExpiryObject"],
        vizDateOfIssue: json["vizDateOfIssue"],
        vizDateOfIssueObject: json["vizDateOfIssueObject"],
        vizGivenNames: json["vizGivenNames"],
        vizSurname: json["vizSurname"],
    );

    Map<String, dynamic> toJson() => {
        "allCheckDigitsValid": allCheckDigitsValid,
        "checkDigitDateOfBirth": checkDigitDateOfBirth,
        "checkDigitDateOfExpiry": checkDigitDateOfExpiry,
        "checkDigitDocumentNumber": checkDigitDocumentNumber,
        "checkDigitFinal": checkDigitFinal,
        "checkDigitPersonalNumber": checkDigitPersonalNumber,
        "dateOfBirth": dateOfBirth,
        "dateOfBirthObject": dateOfBirthObject,
        "dateOfExpiry": dateOfExpiry,
        "dateOfExpiryObject": dateOfExpiryObject,
        "documentNumber": documentNumber,
        "documentType": documentType,
        "fieldConfidences": fieldConfidences?.toJson(),
        "firstName": firstName,
        "givenNames": givenNames,
        "issuingCountryCode": issuingCountryCode,
        "lastName": lastName,
        "mrzString": mrzString,
        "nationalityCountryCode": nationalityCountryCode,
        "optionalData": optionalData,
        "personalNumber": personalNumber,
        "sex": sex,
        "surname": surname,
        "vizAddress": vizAddress,
        "vizDateOfBirth": vizDateOfBirth,
        "vizDateOfBirthObject": vizDateOfBirthObject,
        "vizDateOfExpiry": vizDateOfExpiry,
        "vizDateOfExpiryObject": vizDateOfExpiryObject,
        "vizDateOfIssue": vizDateOfIssue,
        "vizDateOfIssueObject": vizDateOfIssueObject,
        "vizGivenNames": vizGivenNames,
        "vizSurname": vizSurname,
    };
}


///The confidence values of each field
class FieldConfidences {
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

    FieldConfidences({
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

    factory FieldConfidences.fromRawJson(String str) => FieldConfidences.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory FieldConfidences.fromJson(Map<String, dynamic> json) => FieldConfidences(
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


///Describes result information of scanning general OCR
class OcrResult {
    
    ///The OCR text value.
    String? text;

    OcrResult({
        this.text,
    });

    factory OcrResult.fromRawJson(String str) => OcrResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory OcrResult.fromJson(Map<String, dynamic> json) => OcrResult(
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
    };
}


///Describes result information of scanning odometers
class OdometerResult {
    
    ///The odometer value.
    String? value;

    OdometerResult({
        this.value,
    });

    factory OdometerResult.fromRawJson(String str) => OdometerResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory OdometerResult.fromJson(Map<String, dynamic> json) => OdometerResult(
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
    };
}


///representing time measurements for different parts of the process.
class PerformanceMetrics {
    
    ///The total duration of the scan controller process, in milliseconds
    int? scanControllerProcessInMs;

    PerformanceMetrics({
        this.scanControllerProcessInMs,
    });

    factory PerformanceMetrics.fromRawJson(String str) => PerformanceMetrics.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PerformanceMetrics.fromJson(Map<String, dynamic> json) => PerformanceMetrics(
        scanControllerProcessInMs: json["scanControllerProcessInMs"],
    );

    Map<String, dynamic> toJson() => {
        "scanControllerProcessInMs": scanControllerProcessInMs,
    };
}


///Describes result information of scanning tire identification numbers (TIN)
class TinResult {
    
    ///The production date on the TIN reformatted to YYYY/MM.
    String? productionDate;
    
    ///The TIN text split by context with spaces as delimiter.
    String? resultPrettified;
    
    ///The TIN text value.
    String? text;
    
    ///The computed tire age in years rounded down.
    int? tireAgeInYearsRoundedDown;

    TinResult({
        this.productionDate,
        this.resultPrettified,
        this.text,
        this.tireAgeInYearsRoundedDown,
    });

    factory TinResult.fromRawJson(String str) => TinResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TinResult.fromJson(Map<String, dynamic> json) => TinResult(
        productionDate: json["productionDate"],
        resultPrettified: json["resultPrettified"],
        text: json["text"],
        tireAgeInYearsRoundedDown: json["tireAgeInYearsRoundedDown"],
    );

    Map<String, dynamic> toJson() => {
        "productionDate": productionDate,
        "resultPrettified": resultPrettified,
        "text": text,
        "tireAgeInYearsRoundedDown": tireAgeInYearsRoundedDown,
    };
}


///Describes result information of scanning tire makes
class TireMakeResult {
    
    ///The text value of the tire make
    String? text;

    TireMakeResult({
        this.text,
    });

    factory TireMakeResult.fromRawJson(String str) => TireMakeResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TireMakeResult.fromJson(Map<String, dynamic> json) => TireMakeResult(
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
    };
}


///Describes result information of scanning tire size specifications
class TireSizeResult {
    TireSizeResultField? commercialTire;
    TireSizeResultField? construction;
    TireSizeResultField? diameter;
    TireSizeResultField? extraLoad;
    TireSizeResultField? loadIndex;
    TireSizeResultField? prettifiedString;
    TireSizeResultField? prettifiedStringWithMeta;
    TireSizeResultField? ratio;
    TireSizeResultField? speedRating;
    TireSizeResultField? text;
    TireSizeResultField? vehicleType;
    TireSizeResultField? width;
    TireSizeResultField? winter;

    TireSizeResult({
        this.commercialTire,
        this.construction,
        this.diameter,
        this.extraLoad,
        this.loadIndex,
        this.prettifiedString,
        this.prettifiedStringWithMeta,
        this.ratio,
        this.speedRating,
        this.text,
        this.vehicleType,
        this.width,
        this.winter,
    });

    factory TireSizeResult.fromRawJson(String str) => TireSizeResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TireSizeResult.fromJson(Map<String, dynamic> json) => TireSizeResult(
        commercialTire: json["commercialTire"] == null ? null : TireSizeResultField.fromJson(json["commercialTire"]),
        construction: json["construction"] == null ? null : TireSizeResultField.fromJson(json["construction"]),
        diameter: json["diameter"] == null ? null : TireSizeResultField.fromJson(json["diameter"]),
        extraLoad: json["extraLoad"] == null ? null : TireSizeResultField.fromJson(json["extraLoad"]),
        loadIndex: json["loadIndex"] == null ? null : TireSizeResultField.fromJson(json["loadIndex"]),
        prettifiedString: json["prettifiedString"] == null ? null : TireSizeResultField.fromJson(json["prettifiedString"]),
        prettifiedStringWithMeta: json["prettifiedStringWithMeta"] == null ? null : TireSizeResultField.fromJson(json["prettifiedStringWithMeta"]),
        ratio: json["ratio"] == null ? null : TireSizeResultField.fromJson(json["ratio"]),
        speedRating: json["speedRating"] == null ? null : TireSizeResultField.fromJson(json["speedRating"]),
        text: json["text"] == null ? null : TireSizeResultField.fromJson(json["text"]),
        vehicleType: json["vehicleType"] == null ? null : TireSizeResultField.fromJson(json["vehicleType"]),
        width: json["width"] == null ? null : TireSizeResultField.fromJson(json["width"]),
        winter: json["winter"] == null ? null : TireSizeResultField.fromJson(json["winter"]),
    );

    Map<String, dynamic> toJson() => {
        "commercialTire": commercialTire?.toJson(),
        "construction": construction?.toJson(),
        "diameter": diameter?.toJson(),
        "extraLoad": extraLoad?.toJson(),
        "loadIndex": loadIndex?.toJson(),
        "prettifiedString": prettifiedString?.toJson(),
        "prettifiedStringWithMeta": prettifiedStringWithMeta?.toJson(),
        "ratio": ratio?.toJson(),
        "speedRating": speedRating?.toJson(),
        "text": text?.toJson(),
        "vehicleType": vehicleType?.toJson(),
        "width": width?.toJson(),
        "winter": winter?.toJson(),
    };
}

class TireSizeResultField {
    
    ///The confidence value of the tire size field.
    int? confidence;
    
    ///The text value of the tire size field.
    String? text;

    TireSizeResultField({
        this.confidence,
        this.text,
    });

    factory TireSizeResultField.fromRawJson(String str) => TireSizeResultField.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TireSizeResultField.fromJson(Map<String, dynamic> json) => TireSizeResultField(
        confidence: json["confidence"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "confidence": confidence,
        "text": text,
    };
}


///Describes result information of scanning different kinds of IDs
class UniversalIdResult {
    
    ///Yields field information of the ID
    IdResult? result;
    Visualization? visualization;

    UniversalIdResult({
        this.result,
        this.visualization,
    });

    factory UniversalIdResult.fromRawJson(String str) => UniversalIdResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UniversalIdResult.fromJson(Map<String, dynamic> json) => UniversalIdResult(
        result: json["result"] == null ? null : IdResult.fromJson(json["result"]),
        visualization: json["visualization"] == null ? null : Visualization.fromJson(json["visualization"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
        "visualization": visualization?.toJson(),
    };
}


///Yields field information of the ID
class IdResult {
    UniversalIdResultField? additionalInformation;
    UniversalIdResultField? additionalInformation1;
    UniversalIdResultField? additionalInformation2;
    UniversalIdResultField? additionalInformation3;
    UniversalIdResultField? address;
    UniversalIdResultField? age;
    UniversalIdResultField? airport;
    UniversalIdResultField? allCheckDigitsValid;
    UniversalIdResultField? audit;
    UniversalIdResultField? authority;
    UniversalIdResultField? barcode;
    UniversalIdResultField? bloodType;
    UniversalIdResultField? cardAccessNumber;
    UniversalIdResultField? checkDigitDateOfBirth;
    UniversalIdResultField? checkDigitDateOfExpiry;
    UniversalIdResultField? checkDigitDocumentNumber;
    UniversalIdResultField? checkDigitFinal;
    UniversalIdResultField? checkDigitPersonalNumber;
    UniversalIdResultField? cityNumber;
    UniversalIdResultField? conditions;
    UniversalIdResultField? country;
    UniversalIdResultField? dateOfBirth;
    UniversalIdResultField? dateOfBirthObject;
    UniversalIdResultField? dateOfExpiry;
    UniversalIdResultField? dateOfExpiryObject;
    UniversalIdResultField? dateOfIssue;
    UniversalIdResultField? dateOfRegistration;
    UniversalIdResultField? degreeOfDisability;
    UniversalIdResultField? divisionNumber;
    UniversalIdResultField? documentCategoryDefinition;
    UniversalIdResultField? documentDiscriminator;
    UniversalIdResultField? documentNumber;
    UniversalIdResultField? documentRegionDefinition;
    UniversalIdResultField? documentSideDefinition;
    UniversalIdResultField? documentType;
    UniversalIdResultField? documentTypeDefinition;
    UniversalIdResultField? documentVersionsDefinition;
    UniversalIdResultField? duplicate;
    UniversalIdResultField? duration;
    UniversalIdResultField? educationalInstitution;
    UniversalIdResultField? employer;
    UniversalIdResultField? endorsements;
    UniversalIdResultField? eyes;
    UniversalIdResultField? face;
    UniversalIdResultField? familyNumber;
    UniversalIdResultField? familyRelation;
    UniversalIdResultField? fathersName;
    UniversalIdResultField? firstIssued;
    UniversalIdResultField? firstName;
    UniversalIdResultField? folio;
    UniversalIdResultField? formattedDateOfBirth;
    UniversalIdResultField? formattedDateOfExpiry;
    UniversalIdResultField? formattedDateOfIssue;
    UniversalIdResultField? fullName;
    UniversalIdResultField? givenNames;
    UniversalIdResultField? hair;
    UniversalIdResultField? headOfFamily;
    UniversalIdResultField? height;
    UniversalIdResultField? hologram;
    UniversalIdResultField? initials;
    UniversalIdResultField? initialsAndDateOfBirth;
    UniversalIdResultField? issuingCountryCode;
    UniversalIdResultField? lastName;
    UniversalIdResultField? licenseClass;
    UniversalIdResultField? licenseType;
    UniversalIdResultField? maidenName;
    UniversalIdResultField? militaryRank;
    UniversalIdResultField? mirrorNumber;
    UniversalIdResultField? mothersName;
    UniversalIdResultField? mrz;
    UniversalIdResultField? mrzString;
    UniversalIdResultField? municipalityNumber;
    UniversalIdResultField? nationality;
    UniversalIdResultField? nationalityCountryCode;
    UniversalIdResultField? occupation;
    UniversalIdResultField? office;
    UniversalIdResultField? optionalData;
    UniversalIdResultField? parentsFirstName;
    UniversalIdResultField? parish;
    UniversalIdResultField? personalNumber;
    UniversalIdResultField? placeAndDateOfBirth;
    UniversalIdResultField? placeOfBirth;
    UniversalIdResultField? previousType;
    UniversalIdResultField? pseudonym;
    UniversalIdResultField? religion;
    UniversalIdResultField? restrictions;
    UniversalIdResultField? sex;
    UniversalIdResultField? signature;
    UniversalIdResultField? socialSecurityNumber;
    UniversalIdResultField? state;
    UniversalIdResultField? stateNumber;
    UniversalIdResultField? status;
    UniversalIdResultField? surname;
    UniversalIdResultField? vizAddress;
    UniversalIdResultField? vizDateOfBirth;
    UniversalIdResultField? vizDateOfBirthObject;
    UniversalIdResultField? vizDateOfExpiry;
    UniversalIdResultField? vizDateOfExpiryObject;
    UniversalIdResultField? vizDateOfIssue;
    UniversalIdResultField? vizDateOfIssueObject;
    UniversalIdResultField? vizGivenNames;
    UniversalIdResultField? vizSurname;
    UniversalIdResultField? voterId;
    UniversalIdResultField? weight;
    UniversalIdResultField? workPermitNumber;

    IdResult({
        this.additionalInformation,
        this.additionalInformation1,
        this.additionalInformation2,
        this.additionalInformation3,
        this.address,
        this.age,
        this.airport,
        this.allCheckDigitsValid,
        this.audit,
        this.authority,
        this.barcode,
        this.bloodType,
        this.cardAccessNumber,
        this.checkDigitDateOfBirth,
        this.checkDigitDateOfExpiry,
        this.checkDigitDocumentNumber,
        this.checkDigitFinal,
        this.checkDigitPersonalNumber,
        this.cityNumber,
        this.conditions,
        this.country,
        this.dateOfBirth,
        this.dateOfBirthObject,
        this.dateOfExpiry,
        this.dateOfExpiryObject,
        this.dateOfIssue,
        this.dateOfRegistration,
        this.degreeOfDisability,
        this.divisionNumber,
        this.documentCategoryDefinition,
        this.documentDiscriminator,
        this.documentNumber,
        this.documentRegionDefinition,
        this.documentSideDefinition,
        this.documentType,
        this.documentTypeDefinition,
        this.documentVersionsDefinition,
        this.duplicate,
        this.duration,
        this.educationalInstitution,
        this.employer,
        this.endorsements,
        this.eyes,
        this.face,
        this.familyNumber,
        this.familyRelation,
        this.fathersName,
        this.firstIssued,
        this.firstName,
        this.folio,
        this.formattedDateOfBirth,
        this.formattedDateOfExpiry,
        this.formattedDateOfIssue,
        this.fullName,
        this.givenNames,
        this.hair,
        this.headOfFamily,
        this.height,
        this.hologram,
        this.initials,
        this.initialsAndDateOfBirth,
        this.issuingCountryCode,
        this.lastName,
        this.licenseClass,
        this.licenseType,
        this.maidenName,
        this.militaryRank,
        this.mirrorNumber,
        this.mothersName,
        this.mrz,
        this.mrzString,
        this.municipalityNumber,
        this.nationality,
        this.nationalityCountryCode,
        this.occupation,
        this.office,
        this.optionalData,
        this.parentsFirstName,
        this.parish,
        this.personalNumber,
        this.placeAndDateOfBirth,
        this.placeOfBirth,
        this.previousType,
        this.pseudonym,
        this.religion,
        this.restrictions,
        this.sex,
        this.signature,
        this.socialSecurityNumber,
        this.state,
        this.stateNumber,
        this.status,
        this.surname,
        this.vizAddress,
        this.vizDateOfBirth,
        this.vizDateOfBirthObject,
        this.vizDateOfExpiry,
        this.vizDateOfExpiryObject,
        this.vizDateOfIssue,
        this.vizDateOfIssueObject,
        this.vizGivenNames,
        this.vizSurname,
        this.voterId,
        this.weight,
        this.workPermitNumber,
    });

    factory IdResult.fromRawJson(String str) => IdResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory IdResult.fromJson(Map<String, dynamic> json) => IdResult(
        additionalInformation: json["additionalInformation"] == null ? null : UniversalIdResultField.fromJson(json["additionalInformation"]),
        additionalInformation1: json["additionalInformation1"] == null ? null : UniversalIdResultField.fromJson(json["additionalInformation1"]),
        additionalInformation2: json["additionalInformation2"] == null ? null : UniversalIdResultField.fromJson(json["additionalInformation2"]),
        additionalInformation3: json["additionalInformation3"] == null ? null : UniversalIdResultField.fromJson(json["additionalInformation3"]),
        address: json["address"] == null ? null : UniversalIdResultField.fromJson(json["address"]),
        age: json["age"] == null ? null : UniversalIdResultField.fromJson(json["age"]),
        airport: json["airport"] == null ? null : UniversalIdResultField.fromJson(json["airport"]),
        allCheckDigitsValid: json["allCheckDigitsValid"] == null ? null : UniversalIdResultField.fromJson(json["allCheckDigitsValid"]),
        audit: json["audit"] == null ? null : UniversalIdResultField.fromJson(json["audit"]),
        authority: json["authority"] == null ? null : UniversalIdResultField.fromJson(json["authority"]),
        barcode: json["barcode"] == null ? null : UniversalIdResultField.fromJson(json["barcode"]),
        bloodType: json["bloodType"] == null ? null : UniversalIdResultField.fromJson(json["bloodType"]),
        cardAccessNumber: json["cardAccessNumber"] == null ? null : UniversalIdResultField.fromJson(json["cardAccessNumber"]),
        checkDigitDateOfBirth: json["checkDigitDateOfBirth"] == null ? null : UniversalIdResultField.fromJson(json["checkDigitDateOfBirth"]),
        checkDigitDateOfExpiry: json["checkDigitDateOfExpiry"] == null ? null : UniversalIdResultField.fromJson(json["checkDigitDateOfExpiry"]),
        checkDigitDocumentNumber: json["checkDigitDocumentNumber"] == null ? null : UniversalIdResultField.fromJson(json["checkDigitDocumentNumber"]),
        checkDigitFinal: json["checkDigitFinal"] == null ? null : UniversalIdResultField.fromJson(json["checkDigitFinal"]),
        checkDigitPersonalNumber: json["checkDigitPersonalNumber"] == null ? null : UniversalIdResultField.fromJson(json["checkDigitPersonalNumber"]),
        cityNumber: json["cityNumber"] == null ? null : UniversalIdResultField.fromJson(json["cityNumber"]),
        conditions: json["conditions"] == null ? null : UniversalIdResultField.fromJson(json["conditions"]),
        country: json["country"] == null ? null : UniversalIdResultField.fromJson(json["country"]),
        dateOfBirth: json["dateOfBirth"] == null ? null : UniversalIdResultField.fromJson(json["dateOfBirth"]),
        dateOfBirthObject: json["dateOfBirthObject"] == null ? null : UniversalIdResultField.fromJson(json["dateOfBirthObject"]),
        dateOfExpiry: json["dateOfExpiry"] == null ? null : UniversalIdResultField.fromJson(json["dateOfExpiry"]),
        dateOfExpiryObject: json["dateOfExpiryObject"] == null ? null : UniversalIdResultField.fromJson(json["dateOfExpiryObject"]),
        dateOfIssue: json["dateOfIssue"] == null ? null : UniversalIdResultField.fromJson(json["dateOfIssue"]),
        dateOfRegistration: json["dateOfRegistration"] == null ? null : UniversalIdResultField.fromJson(json["dateOfRegistration"]),
        degreeOfDisability: json["degreeOfDisability"] == null ? null : UniversalIdResultField.fromJson(json["degreeOfDisability"]),
        divisionNumber: json["divisionNumber"] == null ? null : UniversalIdResultField.fromJson(json["divisionNumber"]),
        documentCategoryDefinition: json["documentCategoryDefinition"] == null ? null : UniversalIdResultField.fromJson(json["documentCategoryDefinition"]),
        documentDiscriminator: json["documentDiscriminator"] == null ? null : UniversalIdResultField.fromJson(json["documentDiscriminator"]),
        documentNumber: json["documentNumber"] == null ? null : UniversalIdResultField.fromJson(json["documentNumber"]),
        documentRegionDefinition: json["documentRegionDefinition"] == null ? null : UniversalIdResultField.fromJson(json["documentRegionDefinition"]),
        documentSideDefinition: json["documentSideDefinition"] == null ? null : UniversalIdResultField.fromJson(json["documentSideDefinition"]),
        documentType: json["documentType"] == null ? null : UniversalIdResultField.fromJson(json["documentType"]),
        documentTypeDefinition: json["documentTypeDefinition"] == null ? null : UniversalIdResultField.fromJson(json["documentTypeDefinition"]),
        documentVersionsDefinition: json["documentVersionsDefinition"] == null ? null : UniversalIdResultField.fromJson(json["documentVersionsDefinition"]),
        duplicate: json["duplicate"] == null ? null : UniversalIdResultField.fromJson(json["duplicate"]),
        duration: json["duration"] == null ? null : UniversalIdResultField.fromJson(json["duration"]),
        educationalInstitution: json["educationalInstitution"] == null ? null : UniversalIdResultField.fromJson(json["educationalInstitution"]),
        employer: json["employer"] == null ? null : UniversalIdResultField.fromJson(json["employer"]),
        endorsements: json["endorsements"] == null ? null : UniversalIdResultField.fromJson(json["endorsements"]),
        eyes: json["eyes"] == null ? null : UniversalIdResultField.fromJson(json["eyes"]),
        face: json["face"] == null ? null : UniversalIdResultField.fromJson(json["face"]),
        familyNumber: json["familyNumber"] == null ? null : UniversalIdResultField.fromJson(json["familyNumber"]),
        familyRelation: json["familyRelation"] == null ? null : UniversalIdResultField.fromJson(json["familyRelation"]),
        fathersName: json["fathersName"] == null ? null : UniversalIdResultField.fromJson(json["fathersName"]),
        firstIssued: json["firstIssued"] == null ? null : UniversalIdResultField.fromJson(json["firstIssued"]),
        firstName: json["firstName"] == null ? null : UniversalIdResultField.fromJson(json["firstName"]),
        folio: json["folio"] == null ? null : UniversalIdResultField.fromJson(json["folio"]),
        formattedDateOfBirth: json["formattedDateOfBirth"] == null ? null : UniversalIdResultField.fromJson(json["formattedDateOfBirth"]),
        formattedDateOfExpiry: json["formattedDateOfExpiry"] == null ? null : UniversalIdResultField.fromJson(json["formattedDateOfExpiry"]),
        formattedDateOfIssue: json["formattedDateOfIssue"] == null ? null : UniversalIdResultField.fromJson(json["formattedDateOfIssue"]),
        fullName: json["fullName"] == null ? null : UniversalIdResultField.fromJson(json["fullName"]),
        givenNames: json["givenNames"] == null ? null : UniversalIdResultField.fromJson(json["givenNames"]),
        hair: json["hair"] == null ? null : UniversalIdResultField.fromJson(json["hair"]),
        headOfFamily: json["headOfFamily"] == null ? null : UniversalIdResultField.fromJson(json["headOfFamily"]),
        height: json["height"] == null ? null : UniversalIdResultField.fromJson(json["height"]),
        hologram: json["hologram"] == null ? null : UniversalIdResultField.fromJson(json["hologram"]),
        initials: json["initials"] == null ? null : UniversalIdResultField.fromJson(json["initials"]),
        initialsAndDateOfBirth: json["initialsAndDateOfBirth"] == null ? null : UniversalIdResultField.fromJson(json["initialsAndDateOfBirth"]),
        issuingCountryCode: json["issuingCountryCode"] == null ? null : UniversalIdResultField.fromJson(json["issuingCountryCode"]),
        lastName: json["lastName"] == null ? null : UniversalIdResultField.fromJson(json["lastName"]),
        licenseClass: json["licenseClass"] == null ? null : UniversalIdResultField.fromJson(json["licenseClass"]),
        licenseType: json["licenseType"] == null ? null : UniversalIdResultField.fromJson(json["licenseType"]),
        maidenName: json["maidenName"] == null ? null : UniversalIdResultField.fromJson(json["maidenName"]),
        militaryRank: json["militaryRank"] == null ? null : UniversalIdResultField.fromJson(json["militaryRank"]),
        mirrorNumber: json["mirrorNumber"] == null ? null : UniversalIdResultField.fromJson(json["mirrorNumber"]),
        mothersName: json["mothersName"] == null ? null : UniversalIdResultField.fromJson(json["mothersName"]),
        mrz: json["mrz"] == null ? null : UniversalIdResultField.fromJson(json["mrz"]),
        mrzString: json["mrzString"] == null ? null : UniversalIdResultField.fromJson(json["mrzString"]),
        municipalityNumber: json["municipalityNumber"] == null ? null : UniversalIdResultField.fromJson(json["municipalityNumber"]),
        nationality: json["nationality"] == null ? null : UniversalIdResultField.fromJson(json["nationality"]),
        nationalityCountryCode: json["nationalityCountryCode"] == null ? null : UniversalIdResultField.fromJson(json["nationalityCountryCode"]),
        occupation: json["occupation"] == null ? null : UniversalIdResultField.fromJson(json["occupation"]),
        office: json["office"] == null ? null : UniversalIdResultField.fromJson(json["office"]),
        optionalData: json["optionalData"] == null ? null : UniversalIdResultField.fromJson(json["optionalData"]),
        parentsFirstName: json["parentsFirstName"] == null ? null : UniversalIdResultField.fromJson(json["parentsFirstName"]),
        parish: json["parish"] == null ? null : UniversalIdResultField.fromJson(json["parish"]),
        personalNumber: json["personalNumber"] == null ? null : UniversalIdResultField.fromJson(json["personalNumber"]),
        placeAndDateOfBirth: json["placeAndDateOfBirth"] == null ? null : UniversalIdResultField.fromJson(json["placeAndDateOfBirth"]),
        placeOfBirth: json["placeOfBirth"] == null ? null : UniversalIdResultField.fromJson(json["placeOfBirth"]),
        previousType: json["previousType"] == null ? null : UniversalIdResultField.fromJson(json["previousType"]),
        pseudonym: json["pseudonym"] == null ? null : UniversalIdResultField.fromJson(json["pseudonym"]),
        religion: json["religion"] == null ? null : UniversalIdResultField.fromJson(json["religion"]),
        restrictions: json["restrictions"] == null ? null : UniversalIdResultField.fromJson(json["restrictions"]),
        sex: json["sex"] == null ? null : UniversalIdResultField.fromJson(json["sex"]),
        signature: json["signature"] == null ? null : UniversalIdResultField.fromJson(json["signature"]),
        socialSecurityNumber: json["socialSecurityNumber"] == null ? null : UniversalIdResultField.fromJson(json["socialSecurityNumber"]),
        state: json["state"] == null ? null : UniversalIdResultField.fromJson(json["state"]),
        stateNumber: json["stateNumber"] == null ? null : UniversalIdResultField.fromJson(json["stateNumber"]),
        status: json["status"] == null ? null : UniversalIdResultField.fromJson(json["status"]),
        surname: json["surname"] == null ? null : UniversalIdResultField.fromJson(json["surname"]),
        vizAddress: json["vizAddress"] == null ? null : UniversalIdResultField.fromJson(json["vizAddress"]),
        vizDateOfBirth: json["vizDateOfBirth"] == null ? null : UniversalIdResultField.fromJson(json["vizDateOfBirth"]),
        vizDateOfBirthObject: json["vizDateOfBirthObject"] == null ? null : UniversalIdResultField.fromJson(json["vizDateOfBirthObject"]),
        vizDateOfExpiry: json["vizDateOfExpiry"] == null ? null : UniversalIdResultField.fromJson(json["vizDateOfExpiry"]),
        vizDateOfExpiryObject: json["vizDateOfExpiryObject"] == null ? null : UniversalIdResultField.fromJson(json["vizDateOfExpiryObject"]),
        vizDateOfIssue: json["vizDateOfIssue"] == null ? null : UniversalIdResultField.fromJson(json["vizDateOfIssue"]),
        vizDateOfIssueObject: json["vizDateOfIssueObject"] == null ? null : UniversalIdResultField.fromJson(json["vizDateOfIssueObject"]),
        vizGivenNames: json["vizGivenNames"] == null ? null : UniversalIdResultField.fromJson(json["vizGivenNames"]),
        vizSurname: json["vizSurname"] == null ? null : UniversalIdResultField.fromJson(json["vizSurname"]),
        voterId: json["voterId"] == null ? null : UniversalIdResultField.fromJson(json["voterId"]),
        weight: json["weight"] == null ? null : UniversalIdResultField.fromJson(json["weight"]),
        workPermitNumber: json["workPermitNumber"] == null ? null : UniversalIdResultField.fromJson(json["workPermitNumber"]),
    );

    Map<String, dynamic> toJson() => {
        "additionalInformation": additionalInformation?.toJson(),
        "additionalInformation1": additionalInformation1?.toJson(),
        "additionalInformation2": additionalInformation2?.toJson(),
        "additionalInformation3": additionalInformation3?.toJson(),
        "address": address?.toJson(),
        "age": age?.toJson(),
        "airport": airport?.toJson(),
        "allCheckDigitsValid": allCheckDigitsValid?.toJson(),
        "audit": audit?.toJson(),
        "authority": authority?.toJson(),
        "barcode": barcode?.toJson(),
        "bloodType": bloodType?.toJson(),
        "cardAccessNumber": cardAccessNumber?.toJson(),
        "checkDigitDateOfBirth": checkDigitDateOfBirth?.toJson(),
        "checkDigitDateOfExpiry": checkDigitDateOfExpiry?.toJson(),
        "checkDigitDocumentNumber": checkDigitDocumentNumber?.toJson(),
        "checkDigitFinal": checkDigitFinal?.toJson(),
        "checkDigitPersonalNumber": checkDigitPersonalNumber?.toJson(),
        "cityNumber": cityNumber?.toJson(),
        "conditions": conditions?.toJson(),
        "country": country?.toJson(),
        "dateOfBirth": dateOfBirth?.toJson(),
        "dateOfBirthObject": dateOfBirthObject?.toJson(),
        "dateOfExpiry": dateOfExpiry?.toJson(),
        "dateOfExpiryObject": dateOfExpiryObject?.toJson(),
        "dateOfIssue": dateOfIssue?.toJson(),
        "dateOfRegistration": dateOfRegistration?.toJson(),
        "degreeOfDisability": degreeOfDisability?.toJson(),
        "divisionNumber": divisionNumber?.toJson(),
        "documentCategoryDefinition": documentCategoryDefinition?.toJson(),
        "documentDiscriminator": documentDiscriminator?.toJson(),
        "documentNumber": documentNumber?.toJson(),
        "documentRegionDefinition": documentRegionDefinition?.toJson(),
        "documentSideDefinition": documentSideDefinition?.toJson(),
        "documentType": documentType?.toJson(),
        "documentTypeDefinition": documentTypeDefinition?.toJson(),
        "documentVersionsDefinition": documentVersionsDefinition?.toJson(),
        "duplicate": duplicate?.toJson(),
        "duration": duration?.toJson(),
        "educationalInstitution": educationalInstitution?.toJson(),
        "employer": employer?.toJson(),
        "endorsements": endorsements?.toJson(),
        "eyes": eyes?.toJson(),
        "face": face?.toJson(),
        "familyNumber": familyNumber?.toJson(),
        "familyRelation": familyRelation?.toJson(),
        "fathersName": fathersName?.toJson(),
        "firstIssued": firstIssued?.toJson(),
        "firstName": firstName?.toJson(),
        "folio": folio?.toJson(),
        "formattedDateOfBirth": formattedDateOfBirth?.toJson(),
        "formattedDateOfExpiry": formattedDateOfExpiry?.toJson(),
        "formattedDateOfIssue": formattedDateOfIssue?.toJson(),
        "fullName": fullName?.toJson(),
        "givenNames": givenNames?.toJson(),
        "hair": hair?.toJson(),
        "headOfFamily": headOfFamily?.toJson(),
        "height": height?.toJson(),
        "hologram": hologram?.toJson(),
        "initials": initials?.toJson(),
        "initialsAndDateOfBirth": initialsAndDateOfBirth?.toJson(),
        "issuingCountryCode": issuingCountryCode?.toJson(),
        "lastName": lastName?.toJson(),
        "licenseClass": licenseClass?.toJson(),
        "licenseType": licenseType?.toJson(),
        "maidenName": maidenName?.toJson(),
        "militaryRank": militaryRank?.toJson(),
        "mirrorNumber": mirrorNumber?.toJson(),
        "mothersName": mothersName?.toJson(),
        "mrz": mrz?.toJson(),
        "mrzString": mrzString?.toJson(),
        "municipalityNumber": municipalityNumber?.toJson(),
        "nationality": nationality?.toJson(),
        "nationalityCountryCode": nationalityCountryCode?.toJson(),
        "occupation": occupation?.toJson(),
        "office": office?.toJson(),
        "optionalData": optionalData?.toJson(),
        "parentsFirstName": parentsFirstName?.toJson(),
        "parish": parish?.toJson(),
        "personalNumber": personalNumber?.toJson(),
        "placeAndDateOfBirth": placeAndDateOfBirth?.toJson(),
        "placeOfBirth": placeOfBirth?.toJson(),
        "previousType": previousType?.toJson(),
        "pseudonym": pseudonym?.toJson(),
        "religion": religion?.toJson(),
        "restrictions": restrictions?.toJson(),
        "sex": sex?.toJson(),
        "signature": signature?.toJson(),
        "socialSecurityNumber": socialSecurityNumber?.toJson(),
        "state": state?.toJson(),
        "stateNumber": stateNumber?.toJson(),
        "status": status?.toJson(),
        "surname": surname?.toJson(),
        "vizAddress": vizAddress?.toJson(),
        "vizDateOfBirth": vizDateOfBirth?.toJson(),
        "vizDateOfBirthObject": vizDateOfBirthObject?.toJson(),
        "vizDateOfExpiry": vizDateOfExpiry?.toJson(),
        "vizDateOfExpiryObject": vizDateOfExpiryObject?.toJson(),
        "vizDateOfIssue": vizDateOfIssue?.toJson(),
        "vizDateOfIssueObject": vizDateOfIssueObject?.toJson(),
        "vizGivenNames": vizGivenNames?.toJson(),
        "vizSurname": vizSurname?.toJson(),
        "voterId": voterId?.toJson(),
        "weight": weight?.toJson(),
        "workPermitNumber": workPermitNumber?.toJson(),
    };
}


///Describes scanned parameters of an ID field
class UniversalIdResultField {
    
    ///Describes the date value of an ID field
    DateValue? dateValue;
    
    ///Describes the text values of an ID field
    TextValues? textValues;

    UniversalIdResultField({
        this.dateValue,
        this.textValues,
    });

    factory UniversalIdResultField.fromRawJson(String str) => UniversalIdResultField.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UniversalIdResultField.fromJson(Map<String, dynamic> json) => UniversalIdResultField(
        dateValue: json["dateValue"] == null ? null : DateValue.fromJson(json["dateValue"]),
        textValues: json["textValues"] == null ? null : TextValues.fromJson(json["textValues"]),
    );

    Map<String, dynamic> toJson() => {
        "dateValue": dateValue?.toJson(),
        "textValues": textValues?.toJson(),
    };
}


///Describes the date value of an ID field
class DateValue {
    
    ///The confidence value
    int? confidence;
    
    ///The day
    int? day;
    
    ///The formatted text value
    String? formattedText;
    
    ///The month
    int? month;
    
    ///The text value
    String? text;
    
    ///The year
    int? year;

    DateValue({
        this.confidence,
        this.day,
        this.formattedText,
        this.month,
        this.text,
        this.year,
    });

    factory DateValue.fromRawJson(String str) => DateValue.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DateValue.fromJson(Map<String, dynamic> json) => DateValue(
        confidence: json["confidence"],
        day: json["day"],
        formattedText: json["formattedText"],
        month: json["month"],
        text: json["text"],
        year: json["year"],
    );

    Map<String, dynamic> toJson() => {
        "confidence": confidence,
        "day": day,
        "formattedText": formattedText,
        "month": month,
        "text": text,
        "year": year,
    };
}


///Describes the text values of an ID field
class TextValues {
    
    ///The text parameters
    Arabic? arabic;
    
    ///The text parameters
    Cyrillic? cyrillic;
    
    ///The text parameters
    Latin? latin;

    TextValues({
        this.arabic,
        this.cyrillic,
        this.latin,
    });

    factory TextValues.fromRawJson(String str) => TextValues.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TextValues.fromJson(Map<String, dynamic> json) => TextValues(
        arabic: json["arabic"] == null ? null : Arabic.fromJson(json["arabic"]),
        cyrillic: json["cyrillic"] == null ? null : Cyrillic.fromJson(json["cyrillic"]),
        latin: json["latin"] == null ? null : Latin.fromJson(json["latin"]),
    );

    Map<String, dynamic> toJson() => {
        "arabic": arabic?.toJson(),
        "cyrillic": cyrillic?.toJson(),
        "latin": latin?.toJson(),
    };
}


///The text parameters
class Arabic {
    
    ///The confidence value
    int? confidence;
    
    ///The text value
    String? text;

    Arabic({
        this.confidence,
        this.text,
    });

    factory Arabic.fromRawJson(String str) => Arabic.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Arabic.fromJson(Map<String, dynamic> json) => Arabic(
        confidence: json["confidence"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "confidence": confidence,
        "text": text,
    };
}


///The text parameters
class Cyrillic {
    
    ///The confidence value
    int? confidence;
    
    ///The text value
    String? text;

    Cyrillic({
        this.confidence,
        this.text,
    });

    factory Cyrillic.fromRawJson(String str) => Cyrillic.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Cyrillic.fromJson(Map<String, dynamic> json) => Cyrillic(
        confidence: json["confidence"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "confidence": confidence,
        "text": text,
    };
}


///The text parameters
class Latin {
    
    ///The confidence value
    int? confidence;
    
    ///The text value
    String? text;

    Latin({
        this.confidence,
        this.text,
    });

    factory Latin.fromRawJson(String str) => Latin.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Latin.fromJson(Map<String, dynamic> json) => Latin(
        confidence: json["confidence"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "confidence": confidence,
        "text": text,
    };
}


///Information about the visualization data of the scanned ID
class Visualization {
    
    ///The found contour points of the fields on the ID
    List<List<List<int>>>? contourPoints;
    
    ///The found contours of the fields on the ID
    List<List<int>>? contours;
    
    ///The found bounding rect of the text fields on the ID
    List<int>? textRect;

    Visualization({
        this.contourPoints,
        this.contours,
        this.textRect,
    });

    factory Visualization.fromRawJson(String str) => Visualization.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Visualization.fromJson(Map<String, dynamic> json) => Visualization(
        contourPoints: json["contourPoints"] == null ? [] : List<List<List<int>>>.from(json["contourPoints"]!.map((x) => List<List<int>>.from(x.map((x) => List<int>.from(x.map((x) => x)))))),
        contours: json["contours"] == null ? [] : List<List<int>>.from(json["contours"]!.map((x) => List<int>.from(x.map((x) => x)))),
        textRect: json["textRect"] == null ? [] : List<int>.from(json["textRect"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "contourPoints": contourPoints == null ? [] : List<dynamic>.from(contourPoints!.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
        "contours": contours == null ? [] : List<dynamic>.from(contours!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "textRect": textRect == null ? [] : List<dynamic>.from(textRect!.map((x) => x)),
    };
}


///Describes result information of scanning vehicle registration certificates
class VehicleRegistrationCertificateResult {
    
    ///Yields field information of the vehicle registration certificate
    VrcResult? result;
    Visualization? visualization;

    VehicleRegistrationCertificateResult({
        this.result,
        this.visualization,
    });

    factory VehicleRegistrationCertificateResult.fromRawJson(String str) => VehicleRegistrationCertificateResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory VehicleRegistrationCertificateResult.fromJson(Map<String, dynamic> json) => VehicleRegistrationCertificateResult(
        result: json["result"] == null ? null : VrcResult.fromJson(json["result"]),
        visualization: json["visualization"] == null ? null : Visualization.fromJson(json["visualization"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result?.toJson(),
        "visualization": visualization?.toJson(),
    };
}


///Yields field information of the vehicle registration certificate
class VrcResult {
    VehicleRegistrationCertificateResultField? address;
    VehicleRegistrationCertificateResultField? brand;
    VehicleRegistrationCertificateResultField? displacement;
    VehicleRegistrationCertificateResultField? documentCategoryDefinition;
    VehicleRegistrationCertificateResultField? documentNumber;
    VehicleRegistrationCertificateResultField? documentRegionDefinition;
    VehicleRegistrationCertificateResultField? documentSideDefinition;
    VehicleRegistrationCertificateResultField? documentTypeDefinition;
    VehicleRegistrationCertificateResultField? documentVersionsDefinition;
    VehicleRegistrationCertificateResultField? firstIssued;
    VehicleRegistrationCertificateResultField? firstName;
    VehicleRegistrationCertificateResultField? formattedFirstIssued;
    VehicleRegistrationCertificateResultField? lastName;
    VehicleRegistrationCertificateResultField? licensePlate;
    VehicleRegistrationCertificateResultField? manufacturerCode;
    VehicleRegistrationCertificateResultField? tire;
    VehicleRegistrationCertificateResultField? vehicleIdentificationNumber;
    VehicleRegistrationCertificateResultField? vehicleType;
    VehicleRegistrationCertificateResultField? vehicleTypeCode;

    VrcResult({
        this.address,
        this.brand,
        this.displacement,
        this.documentCategoryDefinition,
        this.documentNumber,
        this.documentRegionDefinition,
        this.documentSideDefinition,
        this.documentTypeDefinition,
        this.documentVersionsDefinition,
        this.firstIssued,
        this.firstName,
        this.formattedFirstIssued,
        this.lastName,
        this.licensePlate,
        this.manufacturerCode,
        this.tire,
        this.vehicleIdentificationNumber,
        this.vehicleType,
        this.vehicleTypeCode,
    });

    factory VrcResult.fromRawJson(String str) => VrcResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory VrcResult.fromJson(Map<String, dynamic> json) => VrcResult(
        address: json["address"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["address"]),
        brand: json["brand"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["brand"]),
        displacement: json["displacement"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["displacement"]),
        documentCategoryDefinition: json["documentCategoryDefinition"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["documentCategoryDefinition"]),
        documentNumber: json["documentNumber"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["documentNumber"]),
        documentRegionDefinition: json["documentRegionDefinition"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["documentRegionDefinition"]),
        documentSideDefinition: json["documentSideDefinition"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["documentSideDefinition"]),
        documentTypeDefinition: json["documentTypeDefinition"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["documentTypeDefinition"]),
        documentVersionsDefinition: json["documentVersionsDefinition"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["documentVersionsDefinition"]),
        firstIssued: json["firstIssued"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["firstIssued"]),
        firstName: json["firstName"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["firstName"]),
        formattedFirstIssued: json["formattedFirstIssued"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["formattedFirstIssued"]),
        lastName: json["lastName"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["lastName"]),
        licensePlate: json["licensePlate"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["licensePlate"]),
        manufacturerCode: json["manufacturerCode"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["manufacturerCode"]),
        tire: json["tire"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["tire"]),
        vehicleIdentificationNumber: json["vehicleIdentificationNumber"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["vehicleIdentificationNumber"]),
        vehicleType: json["vehicleType"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["vehicleType"]),
        vehicleTypeCode: json["vehicleTypeCode"] == null ? null : VehicleRegistrationCertificateResultField.fromJson(json["vehicleTypeCode"]),
    );

    Map<String, dynamic> toJson() => {
        "address": address?.toJson(),
        "brand": brand?.toJson(),
        "displacement": displacement?.toJson(),
        "documentCategoryDefinition": documentCategoryDefinition?.toJson(),
        "documentNumber": documentNumber?.toJson(),
        "documentRegionDefinition": documentRegionDefinition?.toJson(),
        "documentSideDefinition": documentSideDefinition?.toJson(),
        "documentTypeDefinition": documentTypeDefinition?.toJson(),
        "documentVersionsDefinition": documentVersionsDefinition?.toJson(),
        "firstIssued": firstIssued?.toJson(),
        "firstName": firstName?.toJson(),
        "formattedFirstIssued": formattedFirstIssued?.toJson(),
        "lastName": lastName?.toJson(),
        "licensePlate": licensePlate?.toJson(),
        "manufacturerCode": manufacturerCode?.toJson(),
        "tire": tire?.toJson(),
        "vehicleIdentificationNumber": vehicleIdentificationNumber?.toJson(),
        "vehicleType": vehicleType?.toJson(),
        "vehicleTypeCode": vehicleTypeCode?.toJson(),
    };
}


///Describes scanned parameters of a vehicle registration certificate field
class VehicleRegistrationCertificateResultField {
    
    ///The confidence value
    int? confidence;
    
    ///The text value
    String? text;

    VehicleRegistrationCertificateResultField({
        this.confidence,
        this.text,
    });

    factory VehicleRegistrationCertificateResultField.fromRawJson(String str) => VehicleRegistrationCertificateResultField.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory VehicleRegistrationCertificateResultField.fromJson(Map<String, dynamic> json) => VehicleRegistrationCertificateResultField(
        confidence: json["confidence"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "confidence": confidence,
        "text": text,
    };
}


///Describes result information of scanning vehicle identification numbers (VIN)
class VinResult {
    
    ///The VIN text value
    String? text;

    VinResult({
        this.text,
    });

    factory VinResult.fromRawJson(String str) => VinResult.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory VinResult.fromJson(Map<String, dynamic> json) => VinResult(
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
    };
}


///Additional metadata about the source plugin that produced these results.
///
///Extra information returned by a scanning session.
class WrapperSessionScanResultExtraInfo {
    
    ///The type of the source ViewPlugin that generated result(s).
    ViewPluginType? viewPluginType;

    WrapperSessionScanResultExtraInfo({
        this.viewPluginType,
    });

    factory WrapperSessionScanResultExtraInfo.fromRawJson(String str) => WrapperSessionScanResultExtraInfo.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanResultExtraInfo.fromJson(Map<String, dynamic> json) => WrapperSessionScanResultExtraInfo(
        viewPluginType: viewPluginTypeValues.map[json["viewPluginType"]],
    );

    Map<String, dynamic> toJson() => {
        "viewPluginType": viewPluginTypeValues.reverse[viewPluginType],
    };
}


///The type of the source ViewPlugin that generated result(s).
enum ViewPluginType {
    VIEW_PLUGIN,
    VIEW_PLUGIN_COMPOSITE
}

final viewPluginTypeValues = EnumValues({
    "viewPlugin": ViewPluginType.VIEW_PLUGIN,
    "viewPluginComposite": ViewPluginType.VIEW_PLUGIN_COMPOSITE
});


///Request to start a scanning session. Requires both scanViewConfigContentString (defining
///what to scan) and scanResultConfig (defining how to handle results). Optional
///scanViewInitializationParameters for workflow correlation.
class WrapperSessionScanStartRequest {
    
    ///Platform-specific options applied when starting a scan session.
    WrapperSessionScanStartPlatformOptions? platformOptions;
    
    ///Configuration for how scan results are returned and stored during the session.
    WrapperSessionScanResultConfig? scanResultConfig;
    
    ///ScanViewConfig JSON string defining the scanner configuration.
    String? scanViewConfigContentString;
    
    ///Path relative to the assets folder used to resolve ScanViewConfig JSON files when a
    ///SegmentControl references them by filename.
    String? scanViewConfigPath;
    
    ///Optional initialization parameters applied when the ScanView is created.
    ScanViewInitializationParameters? scanViewInitializationParameters;

    WrapperSessionScanStartRequest({
        this.platformOptions,
        this.scanResultConfig,
        this.scanViewConfigContentString,
        this.scanViewConfigPath,
        this.scanViewInitializationParameters,
    });

    factory WrapperSessionScanStartRequest.fromRawJson(String str) => WrapperSessionScanStartRequest.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanStartRequest.fromJson(Map<String, dynamic> json) => WrapperSessionScanStartRequest(
        platformOptions: json["platformOptions"] == null ? null : WrapperSessionScanStartPlatformOptions.fromJson(json["platformOptions"]),
        scanResultConfig: json["scanResultConfig"] == null ? null : WrapperSessionScanResultConfig.fromJson(json["scanResultConfig"]),
        scanViewConfigContentString: json["scanViewConfigContentString"],
        scanViewConfigPath: json["scanViewConfigPath"],
        scanViewInitializationParameters: json["scanViewInitializationParameters"] == null ? null : ScanViewInitializationParameters.fromJson(json["scanViewInitializationParameters"]),
    );

    Map<String, dynamic> toJson() => {
        "platformOptions": platformOptions?.toJson(),
        "scanResultConfig": scanResultConfig?.toJson(),
        "scanViewConfigContentString": scanViewConfigContentString,
        "scanViewConfigPath": scanViewConfigPath,
        "scanViewInitializationParameters": scanViewInitializationParameters?.toJson(),
    };
}


///Platform-specific options applied when starting a scan session.
class WrapperSessionScanStartPlatformOptions {
    
    ///Android-specific ScanView attributes for layout and behavior customization.
    AndroidScanViewAttributesConfig? androidScanViewAttributes;

    WrapperSessionScanStartPlatformOptions({
        this.androidScanViewAttributes,
    });

    factory WrapperSessionScanStartPlatformOptions.fromRawJson(String str) => WrapperSessionScanStartPlatformOptions.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanStartPlatformOptions.fromJson(Map<String, dynamic> json) => WrapperSessionScanStartPlatformOptions(
        androidScanViewAttributes: json["androidScanViewAttributes"] == null ? null : AndroidScanViewAttributesConfig.fromJson(json["androidScanViewAttributes"]),
    );

    Map<String, dynamic> toJson() => {
        "androidScanViewAttributes": androidScanViewAttributes?.toJson(),
    };
}


///Android-specific ScanView attributes for layout and behavior customization.
///
///Android ScanView attributes config
class AndroidScanViewAttributesConfig {
    
    ///Enable or disable camera permission handling from ScanView loading process.
    bool? enableCameraPermissionHandling;
    
    ///Enable or disable usage of CameraX API instead of Camera1 API. Default is true.
    bool? useCameraX;

    AndroidScanViewAttributesConfig({
        this.enableCameraPermissionHandling,
        this.useCameraX,
    });

    factory AndroidScanViewAttributesConfig.fromRawJson(String str) => AndroidScanViewAttributesConfig.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AndroidScanViewAttributesConfig.fromJson(Map<String, dynamic> json) => AndroidScanViewAttributesConfig(
        enableCameraPermissionHandling: json["enableCameraPermissionHandling"],
        useCameraX: json["useCameraX"],
    );

    Map<String, dynamic> toJson() => {
        "enableCameraPermissionHandling": enableCameraPermissionHandling,
        "useCameraX": useCameraX,
    };
}


///Optional initialization parameters applied when the ScanView is created.
///
///Schema for ScanView JSON initialization parameters
class ScanViewInitializationParameters {
    
    ///An optional uuid (v4) to correlate scans and data points within a workflow.
    String? correlationId;
    
    ///Data contained within the QR code that's required to unlock scanning with the Showcase
    ///Apps.
    Demo? demo;

    ScanViewInitializationParameters({
        this.correlationId,
        this.demo,
    });

    factory ScanViewInitializationParameters.fromRawJson(String str) => ScanViewInitializationParameters.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ScanViewInitializationParameters.fromJson(Map<String, dynamic> json) => ScanViewInitializationParameters(
        correlationId: json["correlationId"],
        demo: json["demo"] == null ? null : Demo.fromJson(json["demo"]),
    );

    Map<String, dynamic> toJson() => {
        "correlationId": correlationId,
        "demo": demo?.toJson(),
    };
}


///Data contained within the QR code that's required to unlock scanning with the Showcase
///Apps.
class Demo {
    int? qrVersion;
    Sfdc? sfdc;
    String? validityDate;

    Demo({
        this.qrVersion,
        this.sfdc,
        this.validityDate,
    });

    factory Demo.fromRawJson(String str) => Demo.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Demo.fromJson(Map<String, dynamic> json) => Demo(
        qrVersion: json["qrVersion"],
        sfdc: json["sfdc"] == null ? null : Sfdc.fromJson(json["sfdc"]),
        validityDate: json["validityDate"],
    );

    Map<String, dynamic> toJson() => {
        "qrVersion": qrVersion,
        "sfdc": sfdc?.toJson(),
        "validityDate": validityDate,
    };
}

class Sfdc {
    String? accountId;
    String? accountName;
    String? oppId;

    Sfdc({
        this.accountId,
        this.accountName,
        this.oppId,
    });

    factory Sfdc.fromRawJson(String str) => Sfdc.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Sfdc.fromJson(Map<String, dynamic> json) => Sfdc(
        accountId: json["accountId"],
        accountName: json["accountName"],
        oppId: json["oppId"],
    );

    Map<String, dynamic> toJson() => {
        "accountId": accountId,
        "accountName": accountName,
        "oppId": oppId,
    };
}


///Request to stop the current scanning session with optional message explaining the reason
///for termination.
class WrapperSessionScanStopRequest {
    
    ///Optional message describing the reason for stopping the scan session.
    String? message;

    WrapperSessionScanStopRequest({
        this.message,
    });

    factory WrapperSessionScanStopRequest.fromRawJson(String str) => WrapperSessionScanStopRequest.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanStopRequest.fromJson(Map<String, dynamic> json) => WrapperSessionScanStopRequest(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}


///UI configuration options for the scan view, controlling optional controls, orientation,
///and overlays.
class WrapperSessionScanViewConfigOptions {
    
    ///Initial screen orientation when the scan view is presented.
    WrapperSessionScanViewConfigOptionDefaultOrientation? defaultOrientation;
    
    ///Deprecated. iOS only. Button that dismisses the scan view. Use toolbarTitle instead.
    WrapperSessionScanViewConfigOptionDoneButton? doneButtonConfig;
    
    ///Deprecated. iOS only. Static text label on the scan view. Use the Simple Instruction
    ///Label UI Feedback preset instead.
    WrapperSessionScanViewConfigOptionLabel? label;
    
    ///Optional button that lets users toggle between portrait and landscape orientations.
    WrapperSessionScanViewConfigOptionRotateButton? rotateButton;
    
    ///Optional multi-mode segment control for switching between scanning configurations.
    WrapperSessionScanViewConfigOptionSegmentConfig? segmentConfig;
    
    ///Title shown on the toolbar with a back button. Fullscreen scanning only; ignored when
    ///using a ContainerView.
    String? toolbarTitle;

    WrapperSessionScanViewConfigOptions({
        this.defaultOrientation,
        this.doneButtonConfig,
        this.label,
        this.rotateButton,
        this.segmentConfig,
        this.toolbarTitle,
    });

    factory WrapperSessionScanViewConfigOptions.fromRawJson(String str) => WrapperSessionScanViewConfigOptions.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanViewConfigOptions.fromJson(Map<String, dynamic> json) => WrapperSessionScanViewConfigOptions(
        defaultOrientation: wrapperSessionScanViewConfigOptionDefaultOrientationValues.map[json["defaultOrientation"]],
        doneButtonConfig: json["doneButtonConfig"] == null ? null : WrapperSessionScanViewConfigOptionDoneButton.fromJson(json["doneButtonConfig"]),
        label: json["label"] == null ? null : WrapperSessionScanViewConfigOptionLabel.fromJson(json["label"]),
        rotateButton: json["rotateButton"] == null ? null : WrapperSessionScanViewConfigOptionRotateButton.fromJson(json["rotateButton"]),
        segmentConfig: json["segmentConfig"] == null ? null : WrapperSessionScanViewConfigOptionSegmentConfig.fromJson(json["segmentConfig"]),
        toolbarTitle: json["toolbarTitle"],
    );

    Map<String, dynamic> toJson() => {
        "defaultOrientation": wrapperSessionScanViewConfigOptionDefaultOrientationValues.reverse[defaultOrientation],
        "doneButtonConfig": doneButtonConfig?.toJson(),
        "label": label?.toJson(),
        "rotateButton": rotateButton?.toJson(),
        "segmentConfig": segmentConfig?.toJson(),
        "toolbarTitle": toolbarTitle,
    };
}


///Initial screen orientation when the scan view is presented.
///
///Initial screen orientation when scanning starts.
enum WrapperSessionScanViewConfigOptionDefaultOrientation {
    LANDSCAPE,
    PORTRAIT
}

final wrapperSessionScanViewConfigOptionDefaultOrientationValues = EnumValues({
    "landscape": WrapperSessionScanViewConfigOptionDefaultOrientation.LANDSCAPE,
    "portrait": WrapperSessionScanViewConfigOptionDefaultOrientation.PORTRAIT
});


///Deprecated. iOS only. Button that dismisses the scan view. Use toolbarTitle instead.
///
///Deprecated. iOS only. A button that dismisses the scan view screen when pressed. Use
///toolbarTitle instead.
class WrapperSessionScanViewConfigOptionDoneButton {
    
    ///A color, denoted by a hex string of the button background. The default is empty (clear
    ///color).
    String? backgroundColor;
    
    ///A Float value indicating the corner rounding of the Done button.
    double? cornerRadius;
    
    ///The preset used for width fill.
    FillType? fillType;
    
    ///The name of the font (note: the font must be available for the device).
    String? fontName;
    
    ///Button title font size in points (typically 8-72).
    int? fontSize;
    double? offsetX;
    double? offsetY;
    
    ///The preset locations for the button along the x-axis.
    PositionXAlignment? positionXAlignment;
    
    ///The preset locations for the button along the y-axis.
    PositionYAlignment? positionYAlignment;
    
    ///A color, denoted by a hex string of the button title.
    String? textColor;
    
    ///A color, denoted by a hex string used by the button title when pressed.
    String? textColorHighlighted;
    
    ///The text displayed for the button.
    String? title;

    WrapperSessionScanViewConfigOptionDoneButton({
        this.backgroundColor,
        this.cornerRadius,
        this.fillType,
        this.fontName,
        this.fontSize,
        this.offsetX,
        this.offsetY,
        this.positionXAlignment,
        this.positionYAlignment,
        this.textColor,
        this.textColorHighlighted,
        this.title,
    });

    factory WrapperSessionScanViewConfigOptionDoneButton.fromRawJson(String str) => WrapperSessionScanViewConfigOptionDoneButton.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanViewConfigOptionDoneButton.fromJson(Map<String, dynamic> json) => WrapperSessionScanViewConfigOptionDoneButton(
        backgroundColor: json["backgroundColor"],
        cornerRadius: json["cornerRadius"]?.toDouble(),
        fillType: fillTypeValues.map[json["fillType"]],
        fontName: json["fontName"],
        fontSize: json["fontSize"],
        offsetX: json["offset.x"]?.toDouble(),
        offsetY: json["offset.y"]?.toDouble(),
        positionXAlignment: positionXAlignmentValues.map[json["positionXAlignment"]],
        positionYAlignment: positionYAlignmentValues.map[json["positionYAlignment"]],
        textColor: json["textColor"],
        textColorHighlighted: json["textColorHighlighted"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "backgroundColor": backgroundColor,
        "cornerRadius": cornerRadius,
        "fillType": fillTypeValues.reverse[fillType],
        "fontName": fontName,
        "fontSize": fontSize,
        "offset.x": offsetX,
        "offset.y": offsetY,
        "positionXAlignment": positionXAlignmentValues.reverse[positionXAlignment],
        "positionYAlignment": positionYAlignmentValues.reverse[positionYAlignment],
        "textColor": textColor,
        "textColorHighlighted": textColorHighlighted,
        "title": title,
    };
}


///The preset used for width fill.
enum FillType {
    FULLWIDTH,
    RECT
}

final fillTypeValues = EnumValues({
    "fullwidth": FillType.FULLWIDTH,
    "rect": FillType.RECT
});


///The preset locations for the button along the x-axis.
enum PositionXAlignment {
    CENTER,
    LEFT,
    RIGHT
}

final positionXAlignmentValues = EnumValues({
    "center": PositionXAlignment.CENTER,
    "left": PositionXAlignment.LEFT,
    "right": PositionXAlignment.RIGHT
});


///The preset locations for the button along the y-axis.
enum PositionYAlignment {
    BOTTOM,
    CENTER,
    TOP
}

final positionYAlignmentValues = EnumValues({
    "bottom": PositionYAlignment.BOTTOM,
    "center": PositionYAlignment.CENTER,
    "top": PositionYAlignment.TOP
});


///Deprecated. iOS only. Static text label on the scan view. Use the Simple Instruction
///Label UI Feedback preset instead.
///
///Deprecated. iOS only. A static text label displayed on the scan view. Use the Simple
///Instruction Label UI Feedback preset instead.
class WrapperSessionScanViewConfigOptionLabel {
    
    ///Hex color string for the label text.
    String? color;
    double? offsetX;
    double? offsetY;
    
    ///The font size of the label.
    int? size;
    
    ///The text to display.
    String? text;

    WrapperSessionScanViewConfigOptionLabel({
        this.color,
        this.offsetX,
        this.offsetY,
        this.size,
        this.text,
    });

    factory WrapperSessionScanViewConfigOptionLabel.fromRawJson(String str) => WrapperSessionScanViewConfigOptionLabel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanViewConfigOptionLabel.fromJson(Map<String, dynamic> json) => WrapperSessionScanViewConfigOptionLabel(
        color: json["color"],
        offsetX: json["offset.x"]?.toDouble(),
        offsetY: json["offset.y"]?.toDouble(),
        size: json["size"],
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "color": color,
        "offset.x": offsetX,
        "offset.y": offsetY,
        "size": size,
        "text": text,
    };
}


///Optional button that lets users toggle between portrait and landscape orientations.
///
///Button that toggles between portrait and landscape orientations when tapped. Positioned
///according to alignment and optional offset settings.
class WrapperSessionScanViewConfigOptionRotateButton {
    
    ///Corner of the screen where the rotate button is positioned.
    WrapperSessionScanViewConfigOptionElementAlignment? alignment;
    
    ///Optional pixel offset from the aligned corner position.
    WrapperSessionScanViewConfigOptionElementOffset? offset;

    WrapperSessionScanViewConfigOptionRotateButton({
        this.alignment,
        this.offset,
    });

    factory WrapperSessionScanViewConfigOptionRotateButton.fromRawJson(String str) => WrapperSessionScanViewConfigOptionRotateButton.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanViewConfigOptionRotateButton.fromJson(Map<String, dynamic> json) => WrapperSessionScanViewConfigOptionRotateButton(
        alignment: wrapperSessionScanViewConfigOptionElementAlignmentValues.map[json["alignment"]],
        offset: json["offset"] == null ? null : WrapperSessionScanViewConfigOptionElementOffset.fromJson(json["offset"]),
    );

    Map<String, dynamic> toJson() => {
        "alignment": wrapperSessionScanViewConfigOptionElementAlignmentValues.reverse[alignment],
        "offset": offset?.toJson(),
    };
}


///Corner of the screen where the rotate button is positioned.
///
///Screen corner where the UI element will be positioned. Element will align to the
///specified corner before applying any offset.
enum WrapperSessionScanViewConfigOptionElementAlignment {
    BOTTOM_LEFT,
    BOTTOM_RIGHT,
    TOP_LEFT,
    TOP_RIGHT
}

final wrapperSessionScanViewConfigOptionElementAlignmentValues = EnumValues({
    "bottom_left": WrapperSessionScanViewConfigOptionElementAlignment.BOTTOM_LEFT,
    "bottom_right": WrapperSessionScanViewConfigOptionElementAlignment.BOTTOM_RIGHT,
    "top_left": WrapperSessionScanViewConfigOptionElementAlignment.TOP_LEFT,
    "top_right": WrapperSessionScanViewConfigOptionElementAlignment.TOP_RIGHT
});


///Optional pixel offset from the aligned corner position.
///
///Optional pixel offset from the element's aligned position. Use positive/negative values
///to fine-tune positioning.
class WrapperSessionScanViewConfigOptionElementOffset {
    
    ///Horizontal offset in pixels. Positive values move the element right, negative values move
    ///it left.
    int? x;
    
    ///Vertical offset in pixels. Positive values move the element down, negative values move it
    ///up.
    int? y;

    WrapperSessionScanViewConfigOptionElementOffset({
        this.x,
        this.y,
    });

    factory WrapperSessionScanViewConfigOptionElementOffset.fromRawJson(String str) => WrapperSessionScanViewConfigOptionElementOffset.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanViewConfigOptionElementOffset.fromJson(Map<String, dynamic> json) => WrapperSessionScanViewConfigOptionElementOffset(
        x: json["x"],
        y: json["y"],
    );

    Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
    };
}


///Optional multi-mode segment control for switching between scanning configurations.
///
///Multi-mode segment control allowing users to switch between different scanning
///configurations (e.g., MRZ, Barcode, License Plate modes). Requires equal numbers of
///titles and viewConfigs.
class WrapperSessionScanViewConfigOptionSegmentConfig {
    double? offsetX;
    double? offsetY;
    
    ///Hex color code (e.g., 'FF0000' for red) applied to the selected segment and control
    ///tinting.
    String? tintColor;
    
    ///Zero-based index indicating which segment should be initially selected. Must be within
    ///the bounds of the titles array.
    int? titleIndex;
    
    ///Array of display names for each scanning mode shown to users in the segment control.
    List<String>? titles;
    
    ///Array of ScanView configuration filenames located in the assets folder. Each file defines
    ///a complete scanning mode configuration.
    List<String>? viewConfigs;

    WrapperSessionScanViewConfigOptionSegmentConfig({
        this.offsetX,
        this.offsetY,
        this.tintColor,
        this.titleIndex,
        this.titles,
        this.viewConfigs,
    });

    factory WrapperSessionScanViewConfigOptionSegmentConfig.fromRawJson(String str) => WrapperSessionScanViewConfigOptionSegmentConfig.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionScanViewConfigOptionSegmentConfig.fromJson(Map<String, dynamic> json) => WrapperSessionScanViewConfigOptionSegmentConfig(
        offsetX: json["offset.x"]?.toDouble(),
        offsetY: json["offset.y"]?.toDouble(),
        tintColor: json["tintColor"],
        titleIndex: json["titleIndex"],
        titles: json["titles"] == null ? [] : List<String>.from(json["titles"]!.map((x) => x)),
        viewConfigs: json["viewConfigs"] == null ? [] : List<String>.from(json["viewConfigs"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "offset.x": offsetX,
        "offset.y": offsetY,
        "tintColor": tintColor,
        "titleIndex": titleIndex,
        "titles": titles == null ? [] : List<dynamic>.from(titles!.map((x) => x)),
        "viewConfigs": viewConfigs == null ? [] : List<dynamic>.from(viewConfigs!.map((x) => x)),
    };
}


///General information to be used for SDK initialization.
class WrapperSessionSdkInitializationRequest {
    
    ///Root folder path the SDK uses when resolving asset files. Leave empty to use the default
    ///asset location.
    String? assetPathPrefix;
    
    ///Optional cache settings applied during initialization.
    WrapperSessionSdkInitializationCacheConfig? cacheConfig;
    
    ///Anyline license key to be used for SDK initialization.
    String? licenseKey;

    WrapperSessionSdkInitializationRequest({
        this.assetPathPrefix,
        this.cacheConfig,
        this.licenseKey,
    });

    factory WrapperSessionSdkInitializationRequest.fromRawJson(String str) => WrapperSessionSdkInitializationRequest.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionSdkInitializationRequest.fromJson(Map<String, dynamic> json) => WrapperSessionSdkInitializationRequest(
        assetPathPrefix: json["assetPathPrefix"],
        cacheConfig: json["cacheConfig"] == null ? null : WrapperSessionSdkInitializationCacheConfig.fromJson(json["cacheConfig"]),
        licenseKey: json["licenseKey"],
    );

    Map<String, dynamic> toJson() => {
        "assetPathPrefix": assetPathPrefix,
        "cacheConfig": cacheConfig?.toJson(),
        "licenseKey": licenseKey,
    };
}


///Optional cache settings applied during initialization.
///
///Cache configuration to be applied on SDK initialization.
class WrapperSessionSdkInitializationCacheConfig {
    
    ///Whether offline license caching is enabled.
    bool? offlineLicenseCachingEnabled;

    WrapperSessionSdkInitializationCacheConfig({
        this.offlineLicenseCachingEnabled,
    });

    factory WrapperSessionSdkInitializationCacheConfig.fromRawJson(String str) => WrapperSessionSdkInitializationCacheConfig.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionSdkInitializationCacheConfig.fromJson(Map<String, dynamic> json) => WrapperSessionSdkInitializationCacheConfig(
        offlineLicenseCachingEnabled: json["offlineLicenseCachingEnabled"],
    );

    Map<String, dynamic> toJson() => {
        "offlineLicenseCachingEnabled": offlineLicenseCachingEnabled,
    };
}


///Response containing SDK initialization result. Must include either failInfo (if
///initialization failed) or succeedInfo (if successful). The 'initialized' boolean
///indicates the overall status.
class WrapperSessionSdkInitializationResponse {
    
    ///Populated when initialized is false. Contains the error that prevented SDK initialization.
    WrapperSessionSdkInitializationResponseNotInitialized? failInfo;
    
    ///True if SDK initialization succeeded and scanning is available, false if initialization
    ///failed.
    bool? initialized;
    
    ///Populated when initialized is true. Contains license details from the successful
    ///initialization.
    WrapperSessionSdkInitializationResponseInitialized? succeedInfo;

    WrapperSessionSdkInitializationResponse({
        this.failInfo,
        this.initialized,
        this.succeedInfo,
    });

    factory WrapperSessionSdkInitializationResponse.fromRawJson(String str) => WrapperSessionSdkInitializationResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionSdkInitializationResponse.fromJson(Map<String, dynamic> json) => WrapperSessionSdkInitializationResponse(
        failInfo: json["failInfo"] == null ? null : WrapperSessionSdkInitializationResponseNotInitialized.fromJson(json["failInfo"]),
        initialized: json["initialized"],
        succeedInfo: json["succeedInfo"] == null ? null : WrapperSessionSdkInitializationResponseInitialized.fromJson(json["succeedInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "failInfo": failInfo?.toJson(),
        "initialized": initialized,
        "succeedInfo": succeedInfo?.toJson(),
    };
}


///Populated when initialized is false. Contains the error that prevented SDK
///initialization.
///
///Details about a failed SDK initialization attempt.
class WrapperSessionSdkInitializationResponseNotInitialized {
    
    ///The last error received while trying to initialize the SDK.
    String? lastError;

    WrapperSessionSdkInitializationResponseNotInitialized({
        this.lastError,
    });

    factory WrapperSessionSdkInitializationResponseNotInitialized.fromRawJson(String str) => WrapperSessionSdkInitializationResponseNotInitialized.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionSdkInitializationResponseNotInitialized.fromJson(Map<String, dynamic> json) => WrapperSessionSdkInitializationResponseNotInitialized(
        lastError: json["lastError"],
    );

    Map<String, dynamic> toJson() => {
        "lastError": lastError,
    };
}


///Populated when initialized is true. Contains license details from the successful
///initialization.
///
///Details about a successful SDK initialization.
class WrapperSessionSdkInitializationResponseInitialized {
    
    ///License expiry date in ISO 8601 format (YYYY-MM-DD).
    String? expiryDate;

    WrapperSessionSdkInitializationResponseInitialized({
        this.expiryDate,
    });

    factory WrapperSessionSdkInitializationResponseInitialized.fromRawJson(String str) => WrapperSessionSdkInitializationResponseInitialized.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionSdkInitializationResponseInitialized.fromJson(Map<String, dynamic> json) => WrapperSessionSdkInitializationResponseInitialized(
        expiryDate: json["expiryDate"],
    );

    Map<String, dynamic> toJson() => {
        "expiryDate": expiryDate,
    };
}


///Request to submit a User Corrected Result (UCR) for a previously scanned item.
class WrapperSessionUcrReportRequest {
    
    ///Unique identifier for the scan event, taken from PluginResult.blobKey. Used to correlate
    ///the correction with the original scan on the server.
    String? blobKey;
    
    ///The corrected result value to report.
    String? correctedResult;

    WrapperSessionUcrReportRequest({
        this.blobKey,
        this.correctedResult,
    });

    factory WrapperSessionUcrReportRequest.fromRawJson(String str) => WrapperSessionUcrReportRequest.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionUcrReportRequest.fromJson(Map<String, dynamic> json) => WrapperSessionUcrReportRequest(
        blobKey: json["blobKey"],
        correctedResult: json["correctedResult"],
    );

    Map<String, dynamic> toJson() => {
        "blobKey": blobKey,
        "correctedResult": correctedResult,
    };
}


///Response from UCR (User Corrected Result) reporting. Must include either failInfo (if
///reporting failed) or succeedInfo (if successful), corresponding to the status field.
class WrapperSessionUcrReportResponse {
    
    ///Populated when status is ucrReportFailed. Contains the error details.
    WrapperSessionUcrReportResponseFail? failInfo;
    
    ///The final status of the UCR report submission.
    WrapperSessionUcrReportResponseStatus? status;
    
    ///Populated when status is ucrReportSucceeded. Contains the server confirmation message.
    WrapperSessionUcrReportResponseSucceed? succeedInfo;

    WrapperSessionUcrReportResponse({
        this.failInfo,
        this.status,
        this.succeedInfo,
    });

    factory WrapperSessionUcrReportResponse.fromRawJson(String str) => WrapperSessionUcrReportResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionUcrReportResponse.fromJson(Map<String, dynamic> json) => WrapperSessionUcrReportResponse(
        failInfo: json["failInfo"] == null ? null : WrapperSessionUcrReportResponseFail.fromJson(json["failInfo"]),
        status: wrapperSessionUcrReportResponseStatusValues.map[json["status"]],
        succeedInfo: json["succeedInfo"] == null ? null : WrapperSessionUcrReportResponseSucceed.fromJson(json["succeedInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "failInfo": failInfo?.toJson(),
        "status": wrapperSessionUcrReportResponseStatusValues.reverse[status],
        "succeedInfo": succeedInfo?.toJson(),
    };
}


///Populated when status is ucrReportFailed. Contains the error details.
///
///Details about a failed UCR report submission.
class WrapperSessionUcrReportResponseFail {
    
    ///The last error received while reporting UCR.
    String? lastError;
    
    ///The error code received while connecting to server.
    int? responseErrorCode;
    
    ///The error message received while connecting to server.
    String? responseErrorMessage;

    WrapperSessionUcrReportResponseFail({
        this.lastError,
        this.responseErrorCode,
        this.responseErrorMessage,
    });

    factory WrapperSessionUcrReportResponseFail.fromRawJson(String str) => WrapperSessionUcrReportResponseFail.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionUcrReportResponseFail.fromJson(Map<String, dynamic> json) => WrapperSessionUcrReportResponseFail(
        lastError: json["lastError"],
        responseErrorCode: json["responseErrorCode"],
        responseErrorMessage: json["responseErrorMessage"],
    );

    Map<String, dynamic> toJson() => {
        "lastError": lastError,
        "responseErrorCode": responseErrorCode,
        "responseErrorMessage": responseErrorMessage,
    };
}


///The final status of the UCR report submission.
///
///Final status of a UCR report submission.
enum WrapperSessionUcrReportResponseStatus {
    UCR_REPORT_FAILED,
    UCR_REPORT_SUCCEEDED
}

final wrapperSessionUcrReportResponseStatusValues = EnumValues({
    "ucrReportFailed": WrapperSessionUcrReportResponseStatus.UCR_REPORT_FAILED,
    "ucrReportSucceeded": WrapperSessionUcrReportResponseStatus.UCR_REPORT_SUCCEEDED
});


///Populated when status is ucrReportSucceeded. Contains the server confirmation message.
///
///Details about a successful UCR report submission.
class WrapperSessionUcrReportResponseSucceed {
    
    ///The confirmation message returned from the server.
    String? message;

    WrapperSessionUcrReportResponseSucceed({
        this.message,
    });

    factory WrapperSessionUcrReportResponseSucceed.fromRawJson(String str) => WrapperSessionUcrReportResponseSucceed.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory WrapperSessionUcrReportResponseSucceed.fromJson(Map<String, dynamic> json) => WrapperSessionUcrReportResponseSucceed(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
