package io.anyline.anyline_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static io.anyline.anyline_plugin.Constants.REQUEST_ANYLINE_4;

/**
 * AnylinePlugin
 */
public class AnylinePlugin implements FlutterPlugin, MethodCallHandler, PluginRegistry.ActivityResultListener, ResultReporter.OnResultListener, ActivityAware {

    private MethodChannel channel;
    private Context applicationContext;

    private String licenseKey;
    private String configJson;
    private JSONObject configObject;
    private JSONObject options;
    private Activity activity;
    private MethodChannel.Result result;

    /**
     * Plugin registration
     */
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        onAttachedToEngine(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
    }

    public static void registerWith(Registrar registrar) {
        final AnylinePlugin instance = new AnylinePlugin(registrar.activity());
        instance.onAttachedToEngine(registrar.context(), registrar.messenger());
    }

    private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
        this.applicationContext = applicationContext;
        channel = new MethodChannel(messenger, "anyline_plugin");
        channel.setMethodCallHandler(this);
    }

    private AnylinePlugin(Activity activity) {
        this.activity = activity;
    }

    public AnylinePlugin() {
        this.activity = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        this.result = result;
        if (call.method.equals(Constants.METHOD_GET_SDK_VERSION)) {
            result.success(at.nineyards.anyline.BuildConfig.VERSION_NAME);
        } else if (call.method.equals(Constants.METHOD_START_ANYLINE)) {
            this.configJson = call.argument(Constants.EXTRA_CONFIG_JSON);
            scanAnyline4();
        } else {
            result.notImplemented();
        }
    }

    private void scanAnyline4() {
        try {
            configObject = new JSONObject(this.configJson);
            JSONObject options = configObject.getJSONObject("options");
            if (options.has("viewPlugin")) {
                JSONObject viewPlugin = options.getJSONObject("viewPlugin");
                if (viewPlugin != null && viewPlugin.has("plugin")) {
                    JSONObject plugin = viewPlugin.getJSONObject("plugin");
                    if (plugin != null && plugin.has("documentPlugin")) {
                        scan(Document4Activity.class, null, REQUEST_ANYLINE_4);
                    } else {
                        scan(Anyline4Activity.class, null, REQUEST_ANYLINE_4);
                    }
                } else {
                    returnError("No Plugin in config. Please check your configuration.");
                }
            } else if (options.has("serialViewPluginComposite") || options.has("parallelViewPluginComposite")) {
                scan(Anyline4Activity.class, null, REQUEST_ANYLINE_4);
            } else {
                returnError("No ViewPlugin in config. Please check your configuration.");
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private void scan(Class<?> activityToStart, String scanMode, int requestCode) {

        Intent intent = new Intent(activity, activityToStart);

        try {
            configObject = new JSONObject(this.configJson);

            // Hacky -> force cancelOnResult = true
            options = configObject.getJSONObject("options");
            options.put("cancelOnResult", true);

            licenseKey = configObject.get("license").toString();
            if (configObject.has("nativeBarcodeEnabled")) {
                intent.putExtra(Constants.EXTRA_ENABLE_BARCODE_SCANNING, configObject.getBoolean("nativeBarcodeEnabled"));
            }

        } catch (JSONException e) {
            returnError("JSON ERROR: " + e.getMessage());
        }

        intent.putExtra(Constants.EXTRA_LICENSE_KEY, licenseKey);
        intent.putExtra(Constants.EXTRA_CONFIG_JSON, options.toString());

        // Check if OCR
        if (configObject.has("ocr")) {
            try {
                intent.putExtra(Constants.EXTRA_OCR_CONFIG_JSON, configObject.get("ocr").toString());
            } catch (JSONException e) {
                returnError(e.getMessage());
            }
        }

        if (scanMode != null) {
            intent.putExtra(Constants.EXTRA_SCAN_MODE, scanMode);
        }
        ResultReporter.setListener(this);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        activity.startActivityForResult(intent, requestCode, intent.getExtras());

    }

    @Override
    public void onResult(Object result, boolean isFinalResult) {
        if (isFinalResult) {
            returnSuccess(result.toString());
        }
    }

    @Override
    public void onError(String error) {
        returnError(error);
    }

    @Override
    public void onCancel() {
        returnError("Cancelled");
    }

    private void returnError(String message) {
        result.error(message, null, null);
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
