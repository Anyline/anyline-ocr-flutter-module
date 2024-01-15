package io.anyline.flutter;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.ColorStateList;
import android.graphics.Rect;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.util.Pair;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import androidx.coordinatorlayout.widget.CoordinatorLayout;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import io.anyline.plugin.barcode.BarcodeFormat;
import io.anyline.plugin.result.Barcode;
import io.anyline.plugin.result.BarcodeResult;
import io.anyline2.Event;
import io.anyline2.ScanResult;
import io.anyline2.camera.CameraController;
import io.anyline2.camera.CameraOpenListener;
import io.anyline2.model.AnylineYuvImage;
import io.anyline2.view.ScanView;
import io.anyline2.viewplugin.ScanViewPlugin;
import io.anyline2.viewplugin.ViewPluginBase;


public class ScanActivity extends Activity implements CameraOpenListener,
        Thread.UncaughtExceptionHandler,
        Event<Pair<AnylineYuvImage, BarcodeResult>> {
    private static final String TAG = ScanActivity.class.getSimpleName();

    protected String viewConfigsPath = "";
    protected String configString;

    private ScanView anylineScanView;
    private RadioGroup radioGroup = null;
    private LinearLayout layoutChangeOrientation = null;
    private AnylineUIConfig anylineUIConfig;
    private boolean defaultOrientationApplied;
    private static final String KEY_DEFAULT_ORIENTATION_APPLIED = "default_orientation_applied";

    private JSONObject configJson;
    private JSONObject optionsJson = null;

    private Map<String, Barcode> nativeBarcodeMap = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        viewConfigsPath = getIntent().getStringExtra(Constants.EXTRA_VIEW_CONFIGS_PATH);
        configString = getIntent().getStringExtra(Constants.EXTRA_CONFIG_JSON);

        setContentView(R.layout.activity_scan_scanview);

        anylineScanView = findViewById(R.id.anyline_scan_view);
        radioGroup = findViewById(R.id.radiogroup_segment);
        layoutChangeOrientation = findViewById(R.id.layout_change_orientation);

        if (savedInstanceState != null) {
            defaultOrientationApplied = savedInstanceState.getBoolean(KEY_DEFAULT_ORIENTATION_APPLIED);
        }

        try {
            initScanView();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        setDebugListener();
    }

    /**
     * Always set this like this after the initScanView: <br/>
     * scanView.getAnylineController().setWorkerThreadUncaughtExceptionHandler(this);<br/>
     * <br/>
     * This will forward background errors back to the plugin (and back to javascript from there)
     */
    @Override
    public void uncaughtException(Thread thread, Throwable e) {
        String msg = e.getMessage();
        Log.e(TAG, "Cached uncaught exception", e);

        String errorMessage;
        if (msg.contains("license") || msg.contains("License")) {
            errorMessage = "error_licence_invalid";
        } else {
            errorMessage = "error_occured";
        }

        finishWithError(errorMessage);
    }

    protected void finishWithError(String errorMessage) {
        Intent data = new Intent();
        data.putExtra(Constants.EXTRA_ERROR_CODE, errorMessage);
        setResult(Constants.RESULT_ERROR, data);
        ResultReporter.onError(errorMessage);
        finish();
    }

    @Override
    public void onCameraOpened(CameraController cameraController, int width, int height) {
        Log.d(TAG, "Camera opened. Frame size " + width + " x " + height + ".");
    }

    @Override
    public void onCameraError(Exception e) {
        finishWithError("error_accessing_camera");
    }


    @Override
    public void onBackPressed() {
        ResultReporter.onCancel();
        super.onBackPressed();
    }

    protected void setResult(ScanViewPlugin scanViewPlugin, String jsonResult) {
        boolean isCancelOnResult = scanViewPlugin.scanPlugin.getScanPluginConfig().shouldCancelOnResult();

        if (scanViewPlugin != null && isCancelOnResult) {
            ResultReporter.onResult(jsonResult, true);
            setResult(Constants.RESULT_OK);
            finish();
        } else {
            ResultReporter.onResult(jsonResult, false);
        }

    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putBoolean(KEY_DEFAULT_ORIENTATION_APPLIED, defaultOrientationApplied);
    }

    @Override
    protected void onResume() {
        super.onResume();
        // start scanning
        anylineScanView.start();
    }

    @Override
    protected void onPause() {
        // stop scanning
        anylineScanView.stop();
        super.onPause();
    }

    private void setDebugListener() {
        ViewPluginBase scanViewPlugin = anylineScanView.getScanViewPlugin();
        if (scanViewPlugin != null) {
            scanViewPlugin.scanInfoReceived = jsonObject -> {
                Log.d(TAG, "info received: " + jsonObject.toString());
            };
            scanViewPlugin.runSkippedReceived = jsonObject -> {
                Log.d(TAG, "run skipped: " + jsonObject.toString());
            };
            scanViewPlugin.errorReceived = jsonObject -> {
                Log.w(TAG, "error received: " + jsonObject.toString());
            };
        }
    }

    private void initScanView() {
        try {
            setScanConfig(new JSONObject(configString), null);
        } catch (Exception e) {
            // JSONException or IllegalArgumentException is possible for errors in json
            // IOException is possible for errors during asset copying
            finishWithError(
                    getString(getResources().getIdentifier("error_invalid_json_data", "string", getPackageName()))
                            + "\n" + e.getLocalizedMessage());
        }
    }

    @Override
    public void eventReceived(Pair<AnylineYuvImage, BarcodeResult> anylineYuvImageBarcodeResultPair) {
        if (nativeBarcodeMap == null) {
            nativeBarcodeMap = new HashMap<>();
        }
        for (Barcode barcode: anylineYuvImageBarcodeResultPair.second.getBarcodes()) {
            nativeBarcodeMap.put(barcode.getValue(), barcode);
        }
    }

    private void setScanConfig(String viewConfigAssetFileName) {
        try {
            InputStream is = getAssets().open(viewConfigsPath + "/" + viewConfigAssetFileName);
            int size = is.available();
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();
            String viewConfigContent = new String(buffer, StandardCharsets.UTF_8);

            setScanConfig(new JSONObject(viewConfigContent), viewConfigAssetFileName);
        } catch (Exception e) {
            finishWithError(
                    getString(getResources().getIdentifier("error_invalid_json_data", "string", getPackageName()))
                            + "\n" + e.getLocalizedMessage());
        }
    }

    private void setScanConfig(JSONObject scanConfigJson, String viewConfigAssetFileName) {
        configJson = scanConfigJson;
        optionsJson = configJson.optJSONObject("options");

        anylineScanView.getCameraView().removeNativeBarcodeReceivedEventListener(this);
        nativeBarcodeMap = null;

        anylineScanView.init(scanConfigJson);

        ViewPluginBase viewPluginBase = anylineScanView.getScanViewPlugin();
        if (viewPluginBase != null) {

            ScanViewPlugin scanViewPlugin = viewPluginBase.getFirstActiveScanViewPlugin();

            viewPluginBase.resultReceived = scanResult -> {
                setResult(scanViewPlugin, AnylinePluginHelper.jsonHelper(scanResult, nativeBarcodeMap).toString());
            };

            viewPluginBase.resultsReceived = scanResults -> {
                JSONObject jsonResult = new JSONObject();
                for (ScanResult scanResult: scanResults) {
                    try {
                        jsonResult.put(scanResult.getPluginId(), AnylinePluginHelper.jsonHelper(scanResult, nativeBarcodeMap));
                    } catch (JSONException e) {
                        throw new RuntimeException(e);
                    }
                }
                setResult(scanViewPlugin, jsonResult.toString());
            };

            anylineScanView.onCutoutChanged = pairs -> {
                if (anylineUIConfig != null && anylineUIConfig.hasSegmentConfig) {
                    if (!pairs.isEmpty()) {
                        Rect rect = pairs.get(0).second;

                        CoordinatorLayout.LayoutParams segmentLayoutParams =
                                new CoordinatorLayout.LayoutParams(rect.width(),  anylineScanView.getHeight() - rect.bottom);
                        segmentLayoutParams.setMargins(rect.left, rect.bottom, rect.right, anylineScanView.getBottom());
                        radioGroup.setLayoutParams(segmentLayoutParams);

                        radioGroup.setVisibility(View.VISIBLE);
                    }
                    else {
                        radioGroup.setVisibility(View.GONE);
                    }
                }
            };

            if (optionsJson != null) {
                if (optionsJson.has("nativeBarcodeScanningFormats")) {
                    List<BarcodeFormat> barcodeFormatsList = new ArrayList<>();
                    JSONArray barcodeFormatsJsonArray = optionsJson.optJSONArray("nativeBarcodeScanningFormats");
                    for (int i = 0; i < barcodeFormatsJsonArray.length(); i++) {
                        try {
                            barcodeFormatsList.add(BarcodeFormat.valueOf(barcodeFormatsJsonArray.getString(i)));
                        } catch (Exception e) {

                        }
                    }
                    anylineScanView.getCameraView().addNativeBarcodeReceivedEventListener(this, barcodeFormatsList);
                }
            }
        }

        layoutChangeOrientation.setVisibility(View.GONE);
        if (optionsJson != null) {
            if (shouldShowRotateButton(optionsJson)) {
                try {
                    RotateButtonConfig rotateButtonConfig = new RotateButtonConfig(optionsJson.getJSONObject("rotateButton"));
                    configRotateButtonInView(rotateButtonConfig);
                } catch (JSONException e) {

                }
            }

            setDefaultOrientation();

            if (optionsJson.has("segmentConfig")) {
                // create the radio button for the UI
                addSegmentRadioButtonUI(optionsJson, viewConfigAssetFileName);
            }
            else {
                radioGroup.setVisibility(View.GONE);
            }
        }
    }

    private void setDefaultOrientation() {
        if (defaultOrientationApplied) return;

        if (optionsJson.has("defaultOrientation")
                && optionsJson.optString("defaultOrientation").equals("landscape")
                && getRequestedOrientation() != ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE) {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        }
        defaultOrientationApplied = true;
    }

    private void addSegmentRadioButtonUI(JSONObject optionsJson, String currentSegment) {
        anylineUIConfig = new AnylineUIConfig(this, optionsJson);
        setupRadioGroup(anylineUIConfig, currentSegment);
    }

    private void setupRadioGroup(AnylineUIConfig anylineUIConfig, String scanModeString) {
        ArrayList<String> titles = anylineUIConfig.getTitles();
        final ArrayList<String> viewConfigs = anylineUIConfig.getViewConfigs();

        if (titles != null && titles.size() > 0) {

            if (titles.size() != viewConfigs.size()) {
                finishWithError(getString(getResources().getIdentifier("error_invalid_segment_config", "string",
                        getPackageName() + "Titles not matching with modes")));
            }

            if (scanModeString == null) {
                scanModeString = viewConfigs.get(0);
            }

            radioGroup.setOnCheckedChangeListener(null);
            radioGroup.removeAllViews();


            RadioButton[] radioButtons = new RadioButton[titles.size()];
            int currentApiVersion = android.os.Build.VERSION.SDK_INT;
            for (int i = 0; i < titles.size(); i++) {
                radioButtons[i] = new RadioButton(this);
                radioButtons[i].setText(titles.get(i));

                if (currentApiVersion >= Build.VERSION_CODES.LOLLIPOP) {
                    radioButtons[i].setButtonTintList(ColorStateList.valueOf(anylineUIConfig.getTintColor()));
                }

                radioGroup.addView(radioButtons[i]);
            }

            int modeIndex = viewConfigs.indexOf(scanModeString);
            RadioButton button = radioButtons[modeIndex];
            button.setChecked(true);

            radioGroup.setOnCheckedChangeListener((group, checkedId) -> {
                View button1 = group.findViewById(checkedId);
                String newViewConfig = viewConfigs.get(group.indexOfChild(button1));

                anylineScanView.stop();
                setScanConfig(newViewConfig);
                anylineScanView.start();
            });
        }
    }

    private void configRotateButtonInView(RotateButtonConfig rotateButtonConfig) {
        CoordinatorLayout.LayoutParams buttonLayoutParams = new CoordinatorLayout.LayoutParams(
                CoordinatorLayout.LayoutParams.WRAP_CONTENT,
                CoordinatorLayout.LayoutParams.WRAP_CONTENT);

        buttonLayoutParams.gravity = Gravity.TOP | Gravity.RIGHT;
        String alignment = rotateButtonConfig.getAlignment();
        if (alignment.length() > 0) {
            if (alignment.equals("top_left")) {
                buttonLayoutParams.gravity = Gravity.TOP | Gravity.LEFT;
            }
            if (alignment.equals("top_right")) {
                buttonLayoutParams.gravity = Gravity.TOP | Gravity.RIGHT;
            }
            if (alignment.equals("bottom_left")) {
                buttonLayoutParams.gravity = Gravity.BOTTOM | Gravity.LEFT;
            }
            if (alignment.equals("bottom_right")) {
                buttonLayoutParams.gravity = Gravity.BOTTOM | Gravity.RIGHT;
            }
        }
        if (rotateButtonConfig.hasOffset()) {
            buttonLayoutParams.setMargins(rotateButtonConfig.getOffset().getX(), rotateButtonConfig.getOffset().getY(), 0, 0);
        }
        layoutChangeOrientation.setLayoutParams(buttonLayoutParams);
        layoutChangeOrientation.requestLayout();

        layoutChangeOrientation.setVisibility(View.VISIBLE);
        layoutChangeOrientation.setOnClickListener(v -> {
            if (getRequestedOrientation() == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT) {
                setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
            } else {
                setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
            }
        });
    }

    private boolean shouldShowRotateButton(JSONObject jsonObject) {
        return jsonObject.has("rotateButton");
    }
}
