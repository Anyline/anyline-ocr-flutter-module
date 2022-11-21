package io.anyline.flutter;

import android.content.pm.ActivityInfo;
import android.content.res.ColorStateList;
import android.graphics.Rect;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;

import at.nineyards.anyline.core.LicenseException;
import at.nineyards.anyline.core.RunFailure;
import at.nineyards.anyline.core.Vector_Contour;
import at.nineyards.anyline.core.exception_error_codes;
import io.anyline.AnylineDebugListener;
import io.anyline.AnylineSDK;
import io.anyline.camera.CameraController;
import io.anyline.plugin.ScanResult;
import io.anyline.plugin.ScanResultListener;
import io.anyline.plugin.barcode.Barcode;
import io.anyline.plugin.barcode.BarcodeScanPlugin;
import io.anyline.plugin.barcode.BarcodeScanResult;
import io.anyline.plugin.barcode.BarcodeScanViewPlugin;
import io.anyline.plugin.barcode.PDF417;
import io.anyline.plugin.id.ID;
import io.anyline.plugin.id.IdScanPlugin;
import io.anyline.plugin.id.IdScanViewPlugin;
import io.anyline.plugin.id.Identification;
import io.anyline.plugin.id.MrzConfig;
import io.anyline.plugin.id.MrzIdentification;
import io.anyline.plugin.id.UniversalIdConfig;
import io.anyline.plugin.licenseplate.LicensePlateScanResult;
import io.anyline.plugin.licenseplate.LicensePlateScanViewPlugin;
import io.anyline.plugin.meter.MeterScanMode;
import io.anyline.plugin.meter.MeterScanResult;
import io.anyline.plugin.meter.MeterScanViewPlugin;
import io.anyline.plugin.ocr.OcrScanResult;
import io.anyline.plugin.ocr.OcrScanViewPlugin;
import io.anyline.plugin.tire.TireScanResult;
import io.anyline.plugin.tire.TireScanViewPlugin;
import io.anyline.plugin.tire.TireSizeScanResult;
import io.anyline.view.AbstractBaseScanViewPlugin;
import io.anyline.view.CutoutRect;
import io.anyline.view.ParallelScanViewComposite;
import io.anyline.view.ScanView;
import io.anyline.view.SerialScanViewComposite;


public class Anyline4Activity extends AnylineBaseActivity {
    private static final String TAG = Anyline4Activity.class.getSimpleName();

    private ScanView anylineScanView;
    private AbstractBaseScanViewPlugin scanViewPlugin;
    private RadioGroup radioGroup;
    private AnylineUIConfig anylineUIConfig;
    private String cropAndTransformError;
    private Boolean isFirstCameraOpen; // only if camera is opened the first time get coordinates of the cutout to avoid flickering when switching between analog and digital
    private RelativeLayout parentLayout;
    private boolean defaultOrientationApplied;
    private static final String KEY_DEFAULT_ORIENTATION_APPLIED = "default_orientation_applied";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        isFirstCameraOpen = true;

        // init the scan view
        anylineScanView = new ScanView(this, null);
        parentLayout = new RelativeLayout(this);

        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.MATCH_PARENT);
        parentLayout.addView(anylineScanView, layoutParams);
        setContentView(parentLayout, layoutParams);

        if (savedInstanceState != null) {
            defaultOrientationApplied = savedInstanceState.getBoolean(KEY_DEFAULT_ORIENTATION_APPLIED);
        }

        try {
            // start initialize anyline
            initAnyline();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        setDebugListener();
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
        super.onPause();

        // stop scanning
        anylineScanView.stop();
        anylineScanView.releaseCameraInBackground();
    }

    private void setDebugListener() {
        if (scanViewPlugin != null) {
            scanViewPlugin.setDebugListener(new AnylineDebugListener() {
                @Override
                public void onDebug(String name, Object value) {

                    if (name.equals(AnylineDebugListener.BRIGHTNESS_VARIABLE_NAME)
                            && value.getClass().equals(AnylineDebugListener.BRIGHTNESS_VARIABLE_CLASS)) {
                        Double val = AnylineDebugListener.BRIGHTNESS_VARIABLE_CLASS.cast(value);

                        Log.d(TAG, name + ": " + val);
                    }
                    if (name.equals(CONTOURS_VARIABLE_NAME) && value.getClass().equals(CONTOURS_VARIABLE_CLASS)) {
                        Vector_Contour contour = CONTOURS_VARIABLE_CLASS.cast(value);
                        Log.d(TAG, name + ": " + contour.toString());
                    }

                }

                @Override
                public void onRunSkipped(RunFailure runFailure) {
                    // Show Toast, if cropAndTransform is on true, but not all corners are detected
                    if (runFailure != null
                            && runFailure.errorCode() == exception_error_codes.PointsOutOfCutout.swigValue()) {
                        AnylinePluginHelper.showToast(cropAndTransformError, getApplicationContext());
                    }
                    Log.w(TAG, "run skipped: " + runFailure);
                }
            });
        }
    }

    private void initAnyline() {
        try {
            JSONObject json = new JSONObject(configJson);
            // this is used for the OCR Plugin, when languages has to be added
            AnylinePluginHelper.setLanguages(json, getApplicationContext());

            try {
                AnylineSDK.init(licenseKey, this);
            } catch (LicenseException e) {
                finishWithError(getString(getResources().getIdentifier("error_license_init", "string", getPackageName())));
            }

            if (json.has("serialViewPluginComposite") || json.has("parallelViewPluginComposite")) {
                anylineScanView.initComposite(json); // for composite
                scanViewPlugin = anylineScanView.getScanViewPlugin();
            } else {
                anylineScanView.setScanConfig(json); // for non-composite
            }
            if (anylineScanView != null) {
                scanViewPlugin = anylineScanView.getScanViewPlugin();
            }

            if (shouldShowRotateButton(json)) {
                RotateButtonConfig rotateButtonConfig = new RotateButtonConfig(json.getJSONObject("rotateButton"));
                addRotateButtonToView(rotateButtonConfig);
            }

            setDefaultOrientation(json);

            if (scanViewPlugin != null) {
                //set nativeBarcodeMode
                AnylinePluginHelper.setNativeBarcodeMode(json, anylineScanView);

                if (scanViewPlugin instanceof SerialScanViewComposite || scanViewPlugin instanceof ParallelScanViewComposite) {
                    scanViewPlugin.addScanResultListener(new ScanResultListener() {
                        @Override
                        public void onResult(ScanResult result) {
                            // only triggered if all plugins reached a result
                            JSONObject jsonResult = new JSONObject();

                            for (ScanResult<?> subResult : (Collection<ScanResult>) result.getResult()) {
                                if (subResult instanceof LicensePlateScanResult) {
                                    JSONObject jsonLPResult = new JSONObject();
                                    try {
                                        LicensePlateScanResult licensePlateResult = (LicensePlateScanResult) subResult;
                                        jsonLPResult.put("country", licensePlateResult.getCountry());
                                        jsonLPResult.put("licensePlate", licensePlateResult.getResult());
                                        jsonLPResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, licensePlateResult,
                                                jsonLPResult);

                                        jsonResult.put(subResult.getPluginId(), jsonLPResult);
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                } else if (subResult.getResult() instanceof MrzIdentification) {
                                    JSONObject jsonIdResult = ((MrzIdentification) subResult.getResult()).toJSONObject();
                                    try {
                                        if (jsonIdResult.get("issuingCountryCode").equals("D")
                                                && jsonIdResult.get("documentType").equals("ID")) {
                                            if (jsonIdResult.get("issuingCountryCode").equals("D")) {
                                                jsonIdResult.put("address", jsonResult.get("address"));
                                            } else {
                                                jsonIdResult.remove("address");
                                            }
                                        }
                                        jsonIdResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, subResult,
                                                jsonIdResult);

                                        jsonResult.put(subResult.getPluginId(), jsonIdResult);
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                } else if (subResult instanceof OcrScanResult) {
                                    JSONObject jsonOcrResult = new JSONObject();
                                    try {
                                        jsonOcrResult.put("text", (((OcrScanResult) subResult).getResult()).trim());
                                        jsonOcrResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, subResult,
                                                jsonOcrResult);
                                        jsonResult.put(subResult.getPluginId(), jsonOcrResult);
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                } else if (subResult instanceof BarcodeScanResult) {
                                    jsonResult = extractBarcodeResult(jsonResult, (ScanResult<List<Barcode>>) subResult);
                                } else if (subResult instanceof MeterScanResult) {
                                    JSONObject jsonMeterResult = new JSONObject();
                                    try {
                                        jsonMeterResult = AnylinePluginHelper.setMeterScanMode(
                                                ((MeterScanResult) subResult).getScanMode(), jsonMeterResult);
                                        jsonMeterResult.put("reading", subResult.getResult());
                                        jsonMeterResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, subResult,
                                                jsonMeterResult);
                                        jsonResult.put(subResult.getPluginId(), jsonMeterResult);
                                        AnylinePluginHelper.clearFinalBarcodeList();    // otherwise result from previous scan could be shown if new scan does not include barcode

                                    } catch (Exception e) {
                                        Log.e(TAG, "EXCEPTION", e);
                                    }
                                }
                            }

                            setResult(scanViewPlugin, jsonResult);
                        }
                    });
                } else if (scanViewPlugin instanceof LicensePlateScanViewPlugin) {
                    scanViewPlugin.addScanResultListener(new ScanResultListener<LicensePlateScanResult>() {
                        @Override
                        public void onResult(LicensePlateScanResult licensePlateResult) {
                            JSONObject jsonResult = new JSONObject();
                            try {
                                jsonResult.put("country", licensePlateResult.getCountry());
                                jsonResult.put("licensePlate", licensePlateResult.getResult());

                                jsonResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, licensePlateResult,
                                        jsonResult);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                            setResult(scanViewPlugin, jsonResult);
                        }

                    });
                } else if (scanViewPlugin instanceof IdScanViewPlugin) {
                    if (((IdScanPlugin) ((IdScanViewPlugin) scanViewPlugin).getScanPlugin()).getIdConfig() instanceof MrzConfig) {

                        if (json.has("cropAndTransformErrorMessage")) {
                            setDebugListener();
                            cropAndTransformError = json.getString("cropAndTransformErrorMessage");
                        }

                        scanViewPlugin.addScanResultListener(new ScanResultListener<ScanResult<ID>>() {
                            @Override
                            public void onResult(ScanResult<ID> idScanResult) {
                                JSONObject jsonResult = ((MrzIdentification) idScanResult.getResult()).toJSONObject();
                                try {
                                    if (jsonResult.get("issuingCountryCode").equals("D")
                                            && jsonResult.get("documentType").equals("ID")) {
                                        if (jsonResult.get("issuingCountryCode").equals("D")) {
                                            jsonResult.put("address", jsonResult.get("address"));
                                        } else {
                                            jsonResult.remove("address");
                                        }

                                    }
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }

                                try {
                                    jsonResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, idScanResult,
                                            jsonResult);
                                } catch (Exception e) {
                                    Log.e(TAG, "Exception is: ", e);

                                }

                                setResult(scanViewPlugin, jsonResult);

                            }

                        });
                    } else if (((IdScanPlugin) ((IdScanViewPlugin) scanViewPlugin).getScanPlugin()).getIdConfig() instanceof UniversalIdConfig) {
                        scanViewPlugin.addScanResultListener(new ScanResultListener<ScanResult<ID>>() {
                            @Override
                            public void onResult(ScanResult<ID> idScanResult) {
                                Identification identification = (Identification) idScanResult.getResult();
                                HashMap<String, String> data = (HashMap<String, String>) identification.getResultData();

                                JSONObject jsonResult = new JSONObject(data);

                                try {
                                    jsonResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, idScanResult,
                                            jsonResult);
                                } catch (Exception e) {
                                    Log.e(TAG, "Exception is: ", e);

                                }
                                setResult(scanViewPlugin, jsonResult);
                            }
                        });
                    }
                } else if (scanViewPlugin instanceof OcrScanViewPlugin) {
                    scanViewPlugin.addScanResultListener(new ScanResultListener<OcrScanResult>() {
                        @Override
                        public void onResult(OcrScanResult ocrScanResult) {
                            JSONObject jsonResult = new JSONObject();
                            try {
                                jsonResult.put("text", ocrScanResult.getResult().trim());
                                jsonResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, ocrScanResult,
                                        jsonResult);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            setResult(scanViewPlugin, jsonResult);

                        }

                    });

                } else if (scanViewPlugin instanceof TireScanViewPlugin) {
                    scanViewPlugin.addScanResultListener(new ScanResultListener<TireScanResult>() {
                        @Override
                        public void onResult(TireScanResult tireScanResult) {
                            JSONObject jsonResult = new JSONObject();
                            try {
                                jsonResult.put("text", tireScanResult.getResult().trim());
                                jsonResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, tireScanResult,
                                        jsonResult);
                                if (tireScanResult instanceof TireSizeScanResult) {
                                    String tireScanDetailedResult = ((TireSizeScanResult) tireScanResult).getResult().toJson();
                                    jsonResult.put("tireScanDetailedResult", tireScanDetailedResult);
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            setResult(scanViewPlugin, jsonResult);

                        }

                    });

                } else if (scanViewPlugin instanceof BarcodeScanViewPlugin) {

                    if (shouldEnablePDF417(json)) {
                        ((BarcodeScanPlugin) ((BarcodeScanViewPlugin) scanViewPlugin).getScanPlugin()).enablePDF417Parsing();
                    }
                    scanViewPlugin.addScanResultListener(new ScanResultListener<BarcodeScanResult>() {
                        @Override
                        public void onResult(BarcodeScanResult barcodeScanResult) {
                            JSONObject jsonResult = new JSONObject();
                            try {
                                List<Barcode> barcodeList = barcodeScanResult.getResult();

                                JSONArray barcodeArray = new JSONArray();
                                if (barcodeList != null && barcodeList.size() > 0) {
                                    for (int i = 0; i < barcodeList.size(); i++) {
                                        JSONObject barcode = new JSONObject();
                                        barcode.put("value", barcodeList.get(i).getValue());
                                        barcode.put("barcodeFormat", barcodeList.get(i).getBarcodeFormat());

                                        PDF417 pdf417 = barcodeList.get(i).getParsedPDF417();

                                        if (pdf417 != null) {
                                            barcode.put("parsedPDF417", pdf417.toJSONObject());
                                        }
                                        barcodeArray.put(barcode);
                                    }
                                    JSONObject finalObject = new JSONObject();
                                    finalObject.put("barcodes", barcodeArray);
                                    jsonResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, barcodeScanResult, finalObject);
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                            setResult(scanViewPlugin, jsonResult);

                        }


                    });

                } else if (scanViewPlugin instanceof MeterScanViewPlugin) {
                    // create the radio button for the UI
                    addSegmentRadioButtonUI(json);

                    anylineScanView.setCameraOpenListener(this);
                    scanViewPlugin.addScanResultListener(new ScanResultListener<MeterScanResult>() {
                        @Override
                        public void onResult(MeterScanResult meterScanResult) {
                            JSONObject jsonResult = new JSONObject();
                            try {
                                jsonResult = AnylinePluginHelper.setMeterScanMode(meterScanResult.getScanMode(),
                                        jsonResult);
                                jsonResult.put("reading", meterScanResult.getResult());

                                jsonResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, meterScanResult,
                                        jsonResult);

                            } catch (Exception e) {
                                Log.e(TAG, "EXCEPTION", e);
                            }

                            setResult(scanViewPlugin, jsonResult);
                            AnylinePluginHelper.clearFinalBarcodeList();    // otherwise result from previous scan could be shown if new scan does not include barcode
                        }
                    });
                }
            }

        } catch (Exception e) {
            // JSONException or IllegalArgumentException is possible for errors in json
            // IOException is possible for errors during asset copying
            finishWithError(
                    getString(getResources().getIdentifier("error_invalid_json_data", "string", getPackageName()))
                            + "\n" + e.getLocalizedMessage());
        }
    }

    private void setDefaultOrientation(JSONObject jsonObject) {
        if (defaultOrientationApplied) return;

        if (jsonObject.has("defaultOrientation")
                && jsonObject.optString("defaultOrientation").equals("landscape")
                && getRequestedOrientation() != ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE) {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        }
        defaultOrientationApplied = true;
    }

    private boolean shouldEnablePDF417(JSONObject jsonObject) {
        JSONObject viewPlugin = jsonObject.optJSONObject("viewPlugin");

        if (viewPlugin != null) {
            JSONObject plugin = viewPlugin.optJSONObject("plugin");

            if (plugin != null) {
                JSONObject barcodePlugin = plugin.optJSONObject("barcodePlugin");
                return barcodePlugin != null && barcodePlugin.optBoolean("enablePDF417Parsing");
            }
        }
        return false;
    }

    private JSONObject extractBarcodeResult(JSONObject jsonResult, ScanResult<List<Barcode>> subResult) {
        try {
            List<Barcode> barcodeList = subResult.getResult();

            JSONArray barcodeArray = new JSONArray();
            if (barcodeList.size() > 1) {
                for (int i = 0; i < barcodeList.size(); i++) {
                    barcodeArray.put(barcodeList.get(i).toJSONObject());
                }
                JSONObject finalObject = new JSONObject();
                finalObject.put("multiBarcodes", barcodeArray);
                jsonResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, subResult, finalObject);
            } else {
                jsonResult = AnylinePluginHelper.jsonHelper(Anyline4Activity.this, subResult, barcodeList.get(0).toJSONObject());

            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonResult;
    }

    // this method is used only for the meter scanning which contains radio buttons
    @Override
    public void onCameraOpened(CameraController cameraController, int width, int height) {
        super.onCameraOpened(cameraController, width, height);
        anylineScanView.post(new Runnable() {
            @Override
            public void run() {
                if (radioGroup != null) {
                    Handler handler = new Handler();
                    handler.postDelayed(new Runnable() {
                        public void run() {
                            CutoutRect cutoutRect = ((MeterScanViewPlugin) scanViewPlugin).getCutoutRect();

                            if (isFirstCameraOpen && cutoutRect != null) {
                                isFirstCameraOpen = false;
                                Rect rect = cutoutRect.rectOnVisibleView;

                                RelativeLayout.LayoutParams lp = (RelativeLayout.LayoutParams) radioGroup.getLayoutParams();
                                lp.setMargins(rect.left + anylineUIConfig.getOffsetX(), rect.top + anylineUIConfig.getOffsetY(), 0, 0);
                                radioGroup.setLayoutParams(lp);

                                radioGroup.setVisibility(View.VISIBLE);
                            }
                        }
                    }, 600);

                }
            }
        });
    }

    private void addSegmentRadioButtonUI(JSONObject json) {
        final String scanModeString = ((MeterScanViewPlugin) scanViewPlugin).getScanMode().toString();
        anylineUIConfig = new AnylineUIConfig(this, json);

        RadioGroup radioGroup = createRadioGroup(anylineUIConfig, scanModeString);

        if (radioGroup != null) {
            RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT,
                    RelativeLayout.LayoutParams.WRAP_CONTENT);
            lp.addRule(RelativeLayout.ALIGN_PARENT_TOP);
            parentLayout.addView(radioGroup, lp);
        }
    }

    private RadioGroup createRadioGroup(AnylineUIConfig anylineUIConfig, String scanModeString) {
        ArrayList<String> titles = anylineUIConfig.getTitles();
        final ArrayList<String> modes = anylineUIConfig.getModes();

        if (titles != null && titles.size() > 0) {

            if (titles.size() != modes.size()) {
                finishWithError(getString(getResources().getIdentifier("error_invalid_segment_config", "string",
                        getPackageName() + "Titles not mathcing with modes")));
            }

            RadioButton[] radioButtons = new RadioButton[titles.size()];
            radioGroup = new RadioGroup(this);
            radioGroup.setOrientation(RadioGroup.VERTICAL);

            int currentApiVersion = android.os.Build.VERSION.SDK_INT;
            for (int i = 0; i < titles.size(); i++) {
                radioButtons[i] = new RadioButton(this);
                radioButtons[i].setText(titles.get(i));

                if (currentApiVersion >= Build.VERSION_CODES.LOLLIPOP) {
                    radioButtons[i].setButtonTintList(ColorStateList.valueOf(anylineUIConfig.getTintColor()));
                }

                radioGroup.addView(radioButtons[i]);
            }

            Integer modeIndex = modes.indexOf(scanModeString);
            RadioButton button = radioButtons[modeIndex];
            button.setChecked(true);

            radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(RadioGroup group, int checkedId) {
                    View button = group.findViewById(checkedId);
                    String mode = modes.get(group.indexOfChild(button));
                    ((MeterScanViewPlugin) scanViewPlugin).setScanMode(MeterScanMode.valueOf(mode));
                    anylineScanView.stop();
                    try {
                        Thread.sleep(100);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    anylineScanView.start();
                }
            });

            radioGroup.setVisibility(View.INVISIBLE);
            return radioGroup;
        }
        return null;
    }

    private void addRotateButtonToView(RotateButtonConfig rotateButtonConfig) {
        Button button = new Button(this);
        button.setText("Rotate");
        button.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                if (getRequestedOrientation() == ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE) {
                    setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
                } else if (getRequestedOrientation() == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT) {
                    setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
                }
            }
        });

        RelativeLayout.LayoutParams buttonLayoutParams = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.WRAP_CONTENT,
                RelativeLayout.LayoutParams.WRAP_CONTENT);

        if (rotateButtonConfig.hasOffset()) {
            Offset offset = rotateButtonConfig.getOffset();
            buttonLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
            buttonLayoutParams.setMargins(offset.getX(), offset.getY(), 0, 0);
        } else {
            buttonLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
            buttonLayoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
        }

        parentLayout.addView(button, buttonLayoutParams);
    }

    private boolean shouldShowRotateButton(JSONObject jsonObject) {
        return jsonObject.has("rotateButton");
    }
}
