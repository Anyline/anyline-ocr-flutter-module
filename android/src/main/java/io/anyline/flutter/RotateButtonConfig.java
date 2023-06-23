package io.anyline.flutter;

import org.json.JSONException;
import org.json.JSONObject;

public class RotateButtonConfig {
    private String alignment = "";
    private Offset offset = null;

    public RotateButtonConfig(JSONObject jsonObject) throws JSONException {
        alignment = jsonObject.optString("alignment", "");
        if (jsonObject.has("offset")) {
            offset = new Offset(jsonObject.getJSONObject("offset"));
        }
    }
    public String getAlignment() {
        return alignment;
    }
    public Offset getOffset() {
        return offset;
    }

    public boolean hasOffset() {
        return offset != null;
    }
}