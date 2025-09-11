package io.anyline.flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import org.jetbrains.annotations.NotNull;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.List;

import io.anyline.plugin.config.UIFeedbackElementConfig;
import io.anyline.plugin.result.ExportedScanResult;
import io.anyline.wrapper.config.WrapperSessionExportCachedEventsResponse;
import io.anyline.wrapper.config.WrapperSessionExportCachedEventsResponseFail;
import io.anyline.wrapper.config.WrapperSessionExportCachedEventsResponseSucceed;
import io.anyline.wrapper.config.WrapperSessionScanResponse;
import io.anyline.wrapper.config.WrapperSessionScanResultsResponse;
import io.anyline.wrapper.config.WrapperSessionScanResultExtraInfo;
import io.anyline.wrapper.config.WrapperSessionScanResultConfig;
import io.anyline.wrapper.config.WrapperSessionScanStartRequest;
import io.anyline.wrapper.config.WrapperSessionSdkInitializationResponse;
import io.anyline.wrapper.config.WrapperSessionUCRReportRequest;
import io.anyline.wrapper.config.WrapperSessionUCRReportResponse;
import io.anyline2.WrapperInfo;
import io.anyline2.sdk.extension.UIFeedbackElementConfigExtensionKt;
import io.anyline2.wrapper.WrapperSessionClientInterface;
import io.anyline2.wrapper.WrapperSessionProvider;
import io.anyline2.wrapper.extensions.WrapperSessionScanStartRequestExtensionKt;
import io.anyline2.wrapper.extensions.WrapperSessionSdkInitializationResponseExtensionKt;
import io.anyline2.wrapper.extensions.WrapperSessionUCRReportRequestExtensionKt;
import io.anyline2.wrapper.legacy.LegacyPluginHelper;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * AnylinePlugin
 */
public class AnylinePlugin implements
        FlutterPlugin,
        MethodCallHandler,
        WrapperSessionClientInterface,
        ResultReporter.OnResultListener,
        ActivityAware
{

    // We're creating a static variable to retain the WrapperSessionProvider instance in order to prevent crashes due to garbage collection cleaning up the SDK.
    protected static final WrapperSessionProvider wrapperSessionProvider = WrapperSessionProvider.INSTANCE;

    private MethodChannel channel;

    private String customModelsPath = "flutter_assets";
    private String viewConfigsPath = "flutter_assets";

    private MethodChannel.Result initSdkMethodResult;
    private MethodChannel.Result startScanMethodResult;
    private MethodChannel.Result exportCachedEventsMethodResult;
    private MethodChannel.Result reportCorrectedResultMethodResult;

    private Context context;

    /**
     * Plugin registration
     */
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        onAttachedToEngine(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
    }

    private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "anyline_plugin");
        channel.setMethodCallHandler(this);
        context = applicationContext;
    }

    public AnylinePlugin() {
        // Intentionally left blank: no action needed on default constructor
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals(Constants.METHOD_GET_APPLICATION_CACHE_PATH)) {
            result.success("");
        } else if (call.method.equals(Constants.METHOD_SETUP_WRAPPER_SESSION)) {
            setupWrapperSession(call.argument(Constants.EXTRA_PLUGIN_VERSION));
        } else if (call.method.equals(Constants.METHOD_GET_SDK_VERSION)) {
            result.success(at.nineyards.anyline.BuildConfig.VERSION_NAME);
        } else if (call.method.equals(Constants.METHOD_SET_CUSTOM_MODELS_PATH)) {
            customModelsPath = call.argument(Constants.EXTRA_CUSTOM_MODELS_PATH);
        } else if (call.method.equals(Constants.METHOD_SET_VIEW_CONFIGS_PATH)) {
            viewConfigsPath = call.argument(Constants.EXTRA_VIEW_CONFIGS_PATH);
        } else if (call.method.equals(Constants.METHOD_SET_LICENSE_KEY)) {
            initSdkMethodResult = result;
            initSdk(
                    call.argument(Constants.EXTRA_LICENSE_KEY),
                    customModelsPath,
                    Boolean.TRUE.equals(call.argument(Constants.EXTRA_ENABLE_OFFLINE_CACHE)));
        } else if (call.method.equals(Constants.METHOD_START_ANYLINE)) {
            startScanMethodResult =  result;
            routeScanMode(
                    call.argument(Constants.EXTRA_CONFIG_JSON),
                    call.argument(Constants.EXTRA_INITIALIZATION_PARAMETERS),
                    viewConfigsPath,
                    call.argument(Constants.EXTRA_SCAN_CALLBACK_CONFIG));
        } else if (call.method.equals(Constants.METHOD_STOP_ANYLINE)) {
            tryStopScan(call.argument(Constants.EXTRA_STOP_CONFIG));
        } else if (call.method.equals(Constants.METHOD_EXPORT_CACHED_EVENTS)) {
            exportCachedEventsMethodResult = result;
            exportCachedEvents();
        } else if (call.method.equals(Constants.METHOD_REPORT_UCR)) {
            reportCorrectedResultMethodResult = result;
            reportCorrectedResult(
                    call.argument(Constants.EXTRA_REPORT_UCR_BLOBKEY),
                    call.argument(Constants.EXTRA_REPORT_UCR_CORRECTED_RESULT));
        } else {
            result.notImplemented();
        }
    }

    private void setupWrapperSession(final String pluginVersion) {
        WrapperInfo wrapperInfo = new WrapperInfo(WrapperInfo.WrapperType.Flutter, pluginVersion);
        WrapperSessionProvider.setupWrapperSession(wrapperInfo,this);
    }

    @Override
    public @NotNull Context getContext() {
        return this.context;
    }

    private void initSdk(String sdkLicenseKey,
                         String sdkAssetsFolder,
                         boolean enableOfflineCache) {

        JSONObject wrapperSessionSdkInitializationRequestJson =
                LegacyPluginHelper.getWrapperSessionSdkInitializationRequestJson(
                        sdkLicenseKey,
                        enableOfflineCache,
                        sdkAssetsFolder);

        WrapperSessionProvider.requestSdkInitialization(
                wrapperSessionSdkInitializationRequestJson.toString());
    }

    @Override
    public void onSdkInitializationResponse(@NotNull WrapperSessionSdkInitializationResponse initializationResponse) {
        JSONObject json =
                WrapperSessionSdkInitializationResponseExtensionKt.toJsonObject(initializationResponse);

        if (initSdkMethodResult != null) {
            if (initializationResponse.getInitialized() == Boolean.TRUE) {
                initSdkMethodResult.success(true);
            } else {
                returnError(initSdkMethodResult, Constants.EXCEPTION_LICENSE, json.toString());
            }
        }
    }

    private void routeScanMode(
            String scanViewConfigContent,
            String scanViewInitializationParametersString,
            String scanViewConfigPath,
            String scanCallbackConfigString) {
        boolean shouldReturnImages = true;

        WrapperSessionScanStartRequest wrapperSessionScanRequest;
        try {
            wrapperSessionScanRequest = LegacyPluginHelper.getWrapperSessionScanStartRequest(
                    this.context,
                    scanViewConfigContent,
                    scanViewInitializationParametersString,
                    scanViewConfigPath,
                    scanCallbackConfigString,
                    shouldReturnImages);
        } catch (Exception e) {
            returnError(startScanMethodResult, "Could not parse parameters: " + e.getMessage());
            return;
        }

        JSONObject wrapperSessionScanStartRequestJson
                = WrapperSessionScanStartRequestExtensionKt.toJsonObject(wrapperSessionScanRequest);

        WrapperSessionProvider.requestScanStart(wrapperSessionScanStartRequestJson.toString());

        ResultReporter.setListener(this);
    }

    @Override
    public void onScanResults(@NotNull WrapperSessionScanResultsResponse scanResultsResponse) {
        WrapperSessionScanResultConfig scanResultConfig = scanResultsResponse.getScanResultConfig();
        List<ExportedScanResult> scanResultList = scanResultsResponse.getExportedScanResults();
        WrapperSessionScanResultExtraInfo scanResultExtraInfo = scanResultsResponse.getScanResultExtraInfo();

        try {
            String originalResultsWithImagePathString = LegacyPluginHelper
                    .getScanResultsWithImagePath(scanResultList, scanResultExtraInfo.getViewPluginType());

            if (scanResultConfig.getCallbackConfig() != null
                    &&  scanResultConfig.getCallbackConfig().getOnResultEventName() != null) {
                sendEvent(
                        scanResultConfig.getCallbackConfig().getOnResultEventName(),
                        originalResultsWithImagePathString);
            } else {
                /*
                 this implementation keeps the legacy behaviour of the plugin,
                 dispatching the results to the startScanMethodResult when a
                 onResultEventName was not provided on the callbackConfig
                */
                String resultsWithImagePathString;
                if (scanResultExtraInfo.getViewPluginType() == WrapperSessionScanResultExtraInfo.ViewPluginType.VIEW_PLUGIN_COMPOSITE) {
                    JSONArray jsonResultArray = new JSONArray(originalResultsWithImagePathString);
                    JSONObject jsonResultObject = new JSONObject();
                    for (int resultIndex = 0; resultIndex < jsonResultArray.length(); resultIndex++) {
                        JSONObject scanResultJson = jsonResultArray.getJSONObject(resultIndex);
                        String pluginId = scanResultJson.getString("pluginID");
                        jsonResultObject.put(pluginId, scanResultJson);
                    }
                    resultsWithImagePathString = jsonResultObject.toString();
                } else {
                    resultsWithImagePathString = originalResultsWithImagePathString;
                }

                ResultReporter.onResult(resultsWithImagePathString, true);
            }
        } catch (Exception e) {
            //exception will not be handled here
        }
    }

    @Override
    public void onUIElementClicked(@NonNull WrapperSessionScanResultConfig scanResultConfig,
                                   @NonNull UIFeedbackElementConfig uiFeedbackElementConfig) {
        if (scanResultConfig.getCallbackConfig() != null
                &&  scanResultConfig.getCallbackConfig().getOnUIElementClickedEventName() != null) {
            sendEvent(
                    scanResultConfig.getCallbackConfig().getOnUIElementClickedEventName(),
                    UIFeedbackElementConfigExtensionKt.toJsonObject(uiFeedbackElementConfig).toString());
        }
    }

    private void tryStopScan(String scanStopRequestParams) {
        WrapperSessionProvider.requestScanStop(scanStopRequestParams);
    }

    @Override
    public void onScanResponse(@NotNull WrapperSessionScanResponse scanResponse) {
        if (scanResponse.getStatus() != null) {
            switch (scanResponse.getStatus()) {
                case SCAN_SUCCEEDED:
                    WrapperSessionScanResultConfig scanResultConfig = scanResponse.getScanResultConfig();
                    if (scanResultConfig.getCallbackConfig() != null
                            &&  scanResultConfig.getCallbackConfig().getOnResultEventName() != null) {
                        ResultReporter.onResult("", true);
                    }
                    break;
                case SCAN_FAILED:
                    ResultReporter.onError(scanResponse.getFailInfo().getLastError());
                    break;
                case SCAN_ABORTED:
                    ResultReporter.onCancel();
                    break;
            }
        }
    }

    private void sendEvent(String eventName, Object params) {
        channel.invokeMethod(eventName, params);
    }

    private void exportCachedEvents() {
        WrapperSessionProvider.requestExportCachedEvents();
    }

    @Override
    public void onExportCachedEventsResponse(@NotNull WrapperSessionExportCachedEventsResponse exportCachedEventsResponse) {
        if (exportCachedEventsResponse.getStatus() == WrapperSessionExportCachedEventsResponse.WrapperSessionExportCachedEventsResponseStatus.EXPORT_SUCCEEDED) {
            WrapperSessionExportCachedEventsResponseSucceed exportCachedEventsSucceed = exportCachedEventsResponse.getSucceedInfo();
            exportCachedEventsMethodResult.success(exportCachedEventsSucceed.getExportedFile());
        } else {
            WrapperSessionExportCachedEventsResponseFail exportCachedEventsFail = exportCachedEventsResponse.getFailInfo();
            returnError(exportCachedEventsMethodResult, Constants.EXCEPTION_DEFAULT, exportCachedEventsFail.getLastError());
        }
    }

    private void reportCorrectedResult(String blobKey, String correctedResult) {
        WrapperSessionUCRReportRequest wrapperSessionUCRReportRequest = LegacyPluginHelper
                .getWrapperSessionUCRReportRequest(blobKey, correctedResult);

        JSONObject wrapperSessionUCRReportRequestJson = WrapperSessionUCRReportRequestExtensionKt
                .toJsonObject(wrapperSessionUCRReportRequest);

        WrapperSessionProvider.requestUCRReport(wrapperSessionUCRReportRequestJson.toString());
    }

    @Override
    public void onUCRReportResponse(@NotNull WrapperSessionUCRReportResponse ucrReportResponse) {
        if (ucrReportResponse.getStatus() == WrapperSessionUCRReportResponse.WrapperSessionUCRReportResponseStatus.UCR_REPORT_SUCCEEDED) {
            reportCorrectedResultMethodResult.success(ucrReportResponse.getSucceedInfo().getMessage());
        } else {
            returnError(reportCorrectedResultMethodResult, Constants.EXCEPTION_DEFAULT, LegacyPluginHelper
                    .getWrapperSessionUCRReportResponseFailMessage(ucrReportResponse.getFailInfo()));
        }
    }

    @Override
    public void onResult(Object result, boolean isFinalResult) {
        if (isFinalResult) {
            returnSuccess(startScanMethodResult, result.toString());
        }
    }

    @Override
    public void onError(String error) {
        returnDefaultError(startScanMethodResult, error);
    }

    @Override
    public void onCancel() {
        startScanMethodResult.success("Canceled");
    }

    private void returnError(MethodChannel.Result resultListener, String errorCode) {
        resultListener.error(errorCode, null, null);
    }

    private void returnError(MethodChannel.Result resultListener, String errorCode, String errorMessage) {
        resultListener.error(errorCode, errorMessage, null);
    }

    private void returnDefaultError(MethodChannel.Result resultListener, String errorMessage) {
        resultListener.error(Constants.EXCEPTION_DEFAULT, errorMessage, null);
    }

    private void returnSuccess(MethodChannel.Result resultListener, String message) {
        resultListener.success(message);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        // Intentionally left blank: no action needed onAttachedToActivity
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }

}
