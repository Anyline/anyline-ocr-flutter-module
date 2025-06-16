package io.anyline.flutter;

import android.graphics.Color;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class AnylineUIConfig {

    public static final String TOOLBAR_TITLE = "toolbarTitle";
    public final boolean hasToolbarTitle;
    private String toolbarTitle = null;

    public static final String SEGMENT = "segmentConfig";
    public static final String SEGMENT_TITLES = "titles";
    public static final String SEGMENT_VIEWCONFIGS = "viewConfigs";
    public static final String SEGMENT_TINT_COLOR = "tintColor";
    public static final String SEGMENT_OFFSET = "offset";
    public static final String SEGMENT_X = "x";
    public static final String SEGMENT_Y = "y";

    public final boolean hasSegmentConfig;
    private ArrayList<String> titles = null;
    private ArrayList<String> viewConfigs = null;

    private int tintColor = 0;

    private int offsetX = 0;
    private int offsetY = 0;

    /**
     * Create config from the given json object.
     *
     * @param json the json object with the settings
     */
    public AnylineUIConfig(JSONObject json) {
        if (json.has(TOOLBAR_TITLE)) {
            hasToolbarTitle = true;
            toolbarTitle = json.optString(TOOLBAR_TITLE);
        } else {
            hasToolbarTitle = false;
        }

        JSONObject segment = json.optJSONObject(SEGMENT);

        if (segment != null) {
            hasSegmentConfig = true;
            try {
                JSONArray titlesJson = segment.getJSONArray(SEGMENT_TITLES);
                JSONArray viewConfigsJson = segment.getJSONArray(SEGMENT_VIEWCONFIGS);

                titles = new ArrayList<>();
                viewConfigs = new ArrayList<>();
                for (int i = 0; i < titlesJson.length(); i++) {
                    titles.add(titlesJson.get(i).toString());
                    viewConfigs.add(viewConfigsJson.get(i).toString());
                }

                tintColor = Color.parseColor("#" + segment.optString(SEGMENT_TINT_COLOR));

                JSONObject offsetJson = segment.optJSONObject(SEGMENT_OFFSET);
                if (offsetJson != null) {
                    offsetX = offsetJson.optInt(SEGMENT_X);
                    offsetY = offsetJson.optInt(SEGMENT_Y);
                }

            } catch (JSONException e) {
                e.printStackTrace();
            }
        } else {
            hasSegmentConfig = false;
        }
    }

    public String getToolbarTitle() {
        return toolbarTitle;
    }

    public ArrayList<String> getTitles() {
        return titles;
    }

    public ArrayList<String> getViewConfigs() {
        return viewConfigs;
    }

    public int getTintColor() {
        return tintColor;
    }

    public int getOffsetX() {
        return offsetX;
    }

    public int getOffsetY() {
        return offsetY;
    }
}