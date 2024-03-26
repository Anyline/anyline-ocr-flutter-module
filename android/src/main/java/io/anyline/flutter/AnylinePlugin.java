package io.anyline.flutter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import io.anyline2.AnylineSdk;
import io.anyline2.CacheConfig;
import io.anyline2.WrapperConfig;
import io.anyline2.WrapperInfo;
import io.anyline2.core.LicenseException;
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
        PluginRegistry.ActivityResultListener,
        ResultReporter.OnResultListener,
        ActivityAware
{

    private MethodChannel channel;

    private String licenseKey;
    private String pluginVersion = "";
    private boolean enableOfflineCache = false;
    private String customModelsPath = "flutter_assets";
    private String viewConfigsPath = "flutter_assets";

    private String configJson;
    private JSONObject configObject;
    private Activity activity;
    private MethodChannel.Result result;

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
    }

    public AnylinePlugin() {
        this.activity = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        this.result = result;
        if (call.method.equals(Constants.METHOD_GET_APPLICATION_CACHE_PATH)) {
            result.success("");
        } else if (call.method.equals(Constants.METHOD_GET_SDK_VERSION)) {
            result.success(at.nineyards.anyline.BuildConfig.VERSION_NAME);
        } else if (call.method.equals(Constants.METHOD_SET_CUSTOM_MODELS_PATH)) {
            customModelsPath = call.argument(Constants.EXTRA_CUSTOM_MODELS_PATH);
        } else if (call.method.equals(Constants.METHOD_SET_VIEW_CONFIGS_PATH)) {
            viewConfigsPath = call.argument(Constants.EXTRA_VIEW_CONFIGS_PATH);
        } else if (call.method.equals(Constants.METHOD_SET_LICENSE_KEY)) {
            licenseKey = call.argument(Constants.EXTRA_LICENSE_KEY);
            pluginVersion = call.argument(Constants.EXTRA_PLUGIN_VERSION);
            enableOfflineCache = Boolean.TRUE.equals(call.argument(Constants.EXTRA_ENABLE_OFFLINE_CACHE));
            try {
                initSdk(licenseKey, customModelsPath, pluginVersion, enableOfflineCache);
                result.success(true);
            }
            catch (LicenseException le) {
                returnError(Constants.EXCEPTION_LICENSE, le.getLocalizedMessage());
            }
        } else if (call.method.equals(Constants.METHOD_START_ANYLINE)) {
            this.configJson = call.argument(Constants.EXTRA_CONFIG_JSON);
            scanAnyline4();
        } else if (call.method.equals(Constants.METHOD_EXPORT_CACHED_EVENTS)) {
            exportCachedEvents();
        } else {
            result.notImplemented();
        }
    }

    private void initSdk(String sdkLicenseKey,
                         String sdkAssetsFolder,
                         String pluginVersion,
                         boolean enableOfflineCache)
            throws LicenseException {
        WrapperConfig wrapperConfig = new WrapperConfig.Wrapper(
                new WrapperInfo(WrapperInfo.WrapperType.Flutter, pluginVersion));

        CacheConfig.Preset cacheConfig = CacheConfig.Preset.Default.INSTANCE;
        if (enableOfflineCache) {
            cacheConfig = CacheConfig.Preset.OfflineLicenseEventCachingEnabled.INSTANCE;
        }

        AnylineSdk.init(sdkLicenseKey, activity, sdkAssetsFolder, cacheConfig, wrapperConfig);
    }

    private void scanAnyline4() {
        try {
            configObject = new JSONObject(this.configJson);
            scan();
        } catch (JSONException e) {
            e.printStackTrace();
            returnError(Constants.EXCEPTION_CONFIG, e.getLocalizedMessage());
        }
    }

    private void scan() {
        Intent intent = new Intent(activity, ScanActivity.class);
        intent.putExtra(Constants.EXTRA_VIEW_CONFIGS_PATH, viewConfigsPath);
        intent.putExtra(Constants.EXTRA_CONFIG_JSON, configObject.toString());
        ResultReporter.setListener(this);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        activity.startActivityForResult(intent, Constants.SCAN_ACTIVITY_REQUEST_CODE, intent.getExtras());

    }

    private void exportCachedEvents() {
        try {
            String exportedFile = AnylineSdk.exportCachedEvents();
            if (exportedFile != null) {
                result.success(exportedFile);
            } else {
                returnError(Constants.EXCEPTION_DEFAULT, "Event cache is empty.");
            }
        }
        catch (IOException e) {
            returnError(Constants.EXCEPTION_DEFAULT, e.getLocalizedMessage());
        }
    }

    @Override
    public void onResult(Object result, boolean isFinalResult) {
        if (isFinalResult) {
            returnSuccess(result.toString());
        }
    }

    @Override
    public void onError(String error) {
        returnDefaultError(error);
    }

    @Override
    public void onCancel() {
        result.success("Canceled");
    }

    private void returnError(String errorCode) {
        result.error(errorCode, null, null);
    }

    private void returnError(String errorCode, String errorMessage) {
        result.error(errorCode, errorMessage, null);
    }

    private void returnDefaultError(String errorMessage) {
        result.error(Constants.EXCEPTION_DEFAULT, errorMessage, null);
    }

    private void returnSuccess(String scanResult) {
        result.success(scanResult);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        return false;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
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
