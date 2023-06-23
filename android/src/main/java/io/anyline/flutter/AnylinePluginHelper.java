package io.anyline.flutter;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.Map;

import io.anyline.plugin.result.Barcode;
import io.anyline2.ScanResult;

public class AnylinePluginHelper {

    private static final String TAG = AnylinePluginHelper.class.getSimpleName();

    private static Toast notificationToast;

    public static JSONObject wrapBarcodeInJson(Barcode b) {
        JSONObject json = new JSONObject();

        try {
            json.put("value", b.getValue());
            json.put("format", b.getFormat());
        } catch (JSONException jsonException) {
            // should not be possible
            Log.e(TAG, "Error while putting image path to json.", jsonException);
        }
        return json;
    }

    public static JSONObject jsonHelper(ScanResult scanResult, Map<String, Barcode> barcodeMap) {
        JSONObject jsonObject = scanResult.getResult();
        try {
            jsonObject.put("imagePath", scanResult.getCutoutImage().save());

            jsonObject.put("fullImagePath", scanResult.getImage().save());

            if (scanResult.getPluginResult().getConfidence() != null) {
                jsonObject.put("confidence", scanResult.getPluginResult().getConfidence());
            }

            if (barcodeMap != null) {
                JSONArray barcodeArray = new JSONArray();
                for (Barcode barcode: barcodeMap.values()) {
                    barcodeArray.put(wrapBarcodeInJson(barcode));
                }
                if (barcodeArray.length() > 0) {
                    jsonObject.put("detectedBarcodes", barcodeArray);
                }
            }
        } catch (IOException e) {
            Log.e(TAG, "Image file could not be saved.", e);

        } catch (JSONException jsonException) {
            // should not be possible
            Log.e(TAG, "Error while putting image path to json.", jsonException);
        }
        return jsonObject;
    }

    protected static void showToast(String st, Context context) {
        try {
            notificationToast.getView().isShown();
            notificationToast.setText(st);
        } catch (Exception e) {
            notificationToast = Toast.makeText(context, st, Toast.LENGTH_SHORT);
        }
        notificationToast.show();
    }

}
