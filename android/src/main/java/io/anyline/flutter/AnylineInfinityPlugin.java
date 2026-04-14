package io.anyline.flutter;

import android.content.Context;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.jetbrains.annotations.NotNull;

import io.anyline.flutter.nativeview.NativeViewRegistry;
import io.anyline.plugin.config.UIFeedbackElementConfig;
import io.anyline.wrapper.config.WrapperSessionExportCachedEventsResponse;
import io.anyline.wrapper.config.WrapperSessionScanResponse;
import io.anyline.wrapper.config.WrapperSessionScanResultConfig;
import io.anyline.wrapper.config.WrapperSessionScanResultsResponse;
import io.anyline.wrapper.config.WrapperSessionSdkInitializationResponse;
import io.anyline.wrapper.config.WrapperSessionUCRReportResponse;
import io.anyline2.WrapperInfo;
import io.anyline2.sdk.extension.UIFeedbackElementConfigExtensionKt;
import io.anyline2.wrapper.WrapperSessionClientInterface;
import io.anyline2.wrapper.WrapperSessionProvider;
import io.anyline2.wrapper.extensions.WrapperSessionExportCachedEventsResponseExtensionKt;
import io.anyline2.wrapper.extensions.WrapperSessionScanResponseExtensionKt;
import io.anyline2.wrapper.extensions.WrapperSessionScanResultsResponseExtensionKt;
import io.anyline2.wrapper.extensions.WrapperSessionSdkInitializationResponseExtensionKt;
import io.anyline2.wrapper.extensions.WrapperSessionUCRReportResponseExtensionKt;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * AnylineInfinityPlugin — typed, schema-driven Anyline scanning API for Flutter.
 *
 * Passes JSON strings directly to/from WrapperSessionProvider without
 * LegacyPluginHelper. Type safety is enforced in the Dart layer.
 */
public class AnylineInfinityPlugin implements
        FlutterPlugin,
        MethodCallHandler,
        WrapperSessionClientInterface
{
    // Retain the WrapperSessionProvider instance to prevent GC-related crashes.
    protected static final WrapperSessionProvider wrapperSessionProvider = WrapperSessionProvider.INSTANCE;

    private static final String CHANNEL_NAME = "anyline_infinity_plugin";

    private static final String METHOD_SETUP_WRAPPER_SESSION = "INFINITY_SETUP_WRAPPER_SESSION";
    private static final String METHOD_REQUEST_SDK_INITIALIZATION = "INFINITY_REQUEST_SDK_INITIALIZATION";
    private static final String METHOD_REQUEST_SCAN_START = "INFINITY_REQUEST_SCAN_START";
    private static final String METHOD_REQUEST_SCAN_SWITCH_WITH_SCAN_START_REQUEST_PARAMS = "INFINITY_REQUEST_SCAN_SWITCH_WITH_SCAN_START_REQUEST_PARAMS";
    private static final String METHOD_REQUEST_SCAN_SWITCH_WITH_SCAN_VIEW_CONFIG_CONTENT_STRING = "INFINITY_REQUEST_SCAN_SWITCH_WITH_SCAN_VIEW_CONFIG_CONTENT_STRING";
    private static final String METHOD_REQUEST_SCAN_STOP = "INFINITY_REQUEST_SCAN_STOP";
    private static final String METHOD_REQUEST_UCR_REPORT = "INFINITY_REQUEST_UCR_REPORT";
    private static final String METHOD_REQUEST_EXPORT_CACHED_EVENTS = "INFINITY_REQUEST_EXPORT_CACHED_EVENTS";
    private static final String METHOD_GET_SDK_VERSION = "INFINITY_GET_SDK_VERSION";

    private static final String EVENT_ON_SCAN_RESULTS = "INFINITY_ON_SCAN_RESULTS";
    private static final String EVENT_ON_UI_ELEMENT_CLICKED = "INFINITY_ON_UI_ELEMENT_CLICKED";

    private static final String EXTRA_PLUGIN_VERSION = "EXTRA_PLUGIN_VERSION";
    private static final String EXTRA_REQUEST = "request";

    private MethodChannel channel;
    private Context context;

    private Result initSdkResult;
    private Result scanStartResult;
    private Result ucrReportResult;
    private Result exportCachedEventsResult;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, CHANNEL_NAME);
        channel.setMethodCallHandler(this);
        context = applicationContext;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case METHOD_SETUP_WRAPPER_SESSION:
                setupWrapperSession(call.argument(EXTRA_PLUGIN_VERSION));
                break;
            case METHOD_REQUEST_SDK_INITIALIZATION:
                initSdkResult = result;
                WrapperSessionProvider.requestSdkInitialization(
                        call.argument(EXTRA_REQUEST));
                break;
            case METHOD_REQUEST_SCAN_START:
                scanStartResult = result;
                WrapperSessionProvider.requestScanStart(
                        call.argument(EXTRA_REQUEST));
                break;
            case METHOD_REQUEST_SCAN_SWITCH_WITH_SCAN_START_REQUEST_PARAMS:
                WrapperSessionProvider.requestScanSwitchWithScanStartRequestParams(
                        call.argument(EXTRA_REQUEST));
                break;
            case METHOD_REQUEST_SCAN_SWITCH_WITH_SCAN_VIEW_CONFIG_CONTENT_STRING:
                WrapperSessionProvider.requestScanSwitchWithScanViewConfigContentString(
                        call.argument(EXTRA_REQUEST));
                break;
            case METHOD_REQUEST_SCAN_STOP:
                WrapperSessionProvider.requestScanStop(
                        call.argument(EXTRA_REQUEST));
                break;
            case METHOD_REQUEST_UCR_REPORT:
                ucrReportResult = result;
                WrapperSessionProvider.requestUCRReport(
                        call.argument(EXTRA_REQUEST));
                break;
            case METHOD_REQUEST_EXPORT_CACHED_EVENTS:
                exportCachedEventsResult = result;
                WrapperSessionProvider.requestExportCachedEvents();
                break;
            case METHOD_GET_SDK_VERSION:
                result.success(at.nineyards.anyline.BuildConfig.VERSION_NAME);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void setupWrapperSession(String pluginVersion) {
        WrapperInfo wrapperInfo = new WrapperInfo(
                WrapperInfo.WrapperType.Flutter,
                pluginVersion,
                WrapperInfo.WrapperCodename.Infinity);
        WrapperSessionProvider.setupWrapperSession(wrapperInfo, this);
    }

    @Override
    public @NotNull Context getContext() {
        return context;
    }

    @Override
    public @Nullable ViewGroup getContainerView() {
        return (ViewGroup) NativeViewRegistry.getLastOrNull();
    }

    @Override
    public void onSdkInitializationResponse(
            @NotNull WrapperSessionSdkInitializationResponse initializationResponse) {
        if (initSdkResult != null) {
            initSdkResult.success(
                    WrapperSessionSdkInitializationResponseExtensionKt
                            .toJsonObject(initializationResponse).toString());
            initSdkResult = null;
        }
    }

    @Override
    public void onScanResults(@NotNull WrapperSessionScanResultsResponse scanResultsResponse) {
        channel.invokeMethod(EVENT_ON_SCAN_RESULTS,
                WrapperSessionScanResultsResponseExtensionKt
                        .toJsonObject(scanResultsResponse).toString());
    }

    @Override
    public void onScanResponse(@NotNull WrapperSessionScanResponse scanResponse) {
        if (scanStartResult != null) {
            scanStartResult.success(
                    WrapperSessionScanResponseExtensionKt
                            .toJsonObject(scanResponse).toString());
            scanStartResult = null;
        }
    }

    @Override
    public void onUIElementClicked(
            @NonNull WrapperSessionScanResultConfig scanResultConfig,
            @NonNull UIFeedbackElementConfig uiFeedbackElementConfig) {
        channel.invokeMethod(EVENT_ON_UI_ELEMENT_CLICKED,
                UIFeedbackElementConfigExtensionKt.toJsonObject(uiFeedbackElementConfig).toString());
    }

    @Override
    public void onUCRReportResponse(@NotNull WrapperSessionUCRReportResponse ucrReportResponse) {
        if (ucrReportResult != null) {
            ucrReportResult.success(
                    WrapperSessionUCRReportResponseExtensionKt
                            .toJsonObject(ucrReportResponse).toString());
            ucrReportResult = null;
        }
    }

    @Override
    public void onExportCachedEventsResponse(
            @NotNull WrapperSessionExportCachedEventsResponse exportCachedEventsResponse) {
        if (exportCachedEventsResult != null) {
            exportCachedEventsResult.success(
                    WrapperSessionExportCachedEventsResponseExtensionKt
                            .toJsonObject(exportCachedEventsResponse).toString());
            exportCachedEventsResult = null;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}