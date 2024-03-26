package io.anyline.flutter;

public class Constants {
    public static final String METHOD_GET_APPLICATION_CACHE_PATH = "METHOD_GET_APPLICATION_CACHE_PATH";
    public static final String METHOD_GET_SDK_VERSION = "METHOD_GET_SDK_VERSION";
    public static final String METHOD_SET_CUSTOM_MODELS_PATH = "METHOD_SET_CUSTOM_MODELS_PATH";
    public static final String METHOD_SET_VIEW_CONFIGS_PATH = "METHOD_SET_VIEW_CONFIGS_PATH";
    public static final String METHOD_SET_LICENSE_KEY = "METHOD_SET_LICENSE_KEY";
    public static final String METHOD_START_ANYLINE = "METHOD_START_ANYLINE";
    public static final String METHOD_EXPORT_CACHED_EVENTS = "METHOD_EXPORT_CACHED_EVENTS";

    public static final String EXTRA_CONFIG_JSON = "EXTRA_CONFIG_JSON";
    public static final String EXTRA_LICENSE_KEY = "EXTRA_LICENSE_KEY";
    public static final String EXTRA_ENABLE_OFFLINE_CACHE = "EXTRA_ENABLE_OFFLINE_CACHE";
    public static final String EXTRA_PLUGIN_VERSION = "EXTRA_PLUGIN_VERSION";
    public static final String EXTRA_CUSTOM_MODELS_PATH = "EXTRA_CUSTOM_MODELS_PATH";
    public static final String EXTRA_VIEW_CONFIGS_PATH = "EXTRA_VIEW_CONFIGS_PATH";

    public static final String EXTRA_SCAN_MODE = "EXTRA_SCAN_MODE";
    public static final String EXTRA_ERROR_CODE = "EXTRA_ERROR_MESSAGE";

    public static final String EXCEPTION_DEFAULT = "AnylineException";
    public static final String EXCEPTION_LICENSE = "AnylineLicenseException";
    public static final String EXCEPTION_CONFIG = "AnylineConfigException";
    public static final String EXCEPTION_NO_CAMERA_PERMISSION = "AnylineCameraPermissionException";
    public static final String EXCEPTION_CORE = "AnylineCoreException";

    public static final int SCAN_ACTIVITY_REQUEST_CODE = 999;

    public static final int RESULT_CANCELLED = 0;
    public static final int RESULT_OK = 1;
    public static final int RESULT_ERROR = 2;
}
