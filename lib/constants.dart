/// Needed for communication with the native SDK.
abstract class Constants {
  static const String METHOD_GET_SDK_VERSION = 'METHOD_GET_SDK_VERSION';
  static const String METHOD_SETUP_WRAPPER_SESSION =
      'METHOD_SETUP_WRAPPER_SESSION';
  static const String METHOD_SET_CUSTOM_MODELS_PATH =
      'METHOD_SET_CUSTOM_MODELS_PATH';
  static const String METHOD_SET_VIEW_CONFIGS_PATH =
      'METHOD_SET_VIEW_CONFIGS_PATH';
  static const String METHOD_SET_LICENSE_KEY = 'METHOD_SET_LICENSE_KEY';
  static const String METHOD_START_ANYLINE = 'METHOD_START_ANYLINE';
  static const String METHOD_GET_APPLICATION_CACHE_PATH =
      'METHOD_GET_APPLICATION_CACHE_PATH';
  static const String METHOD_STOP_ANYLINE = 'METHOD_STOP_ANYLINE';
  static const String METHOD_EXPORT_CACHED_EVENTS =
      'METHOD_EXPORT_CACHED_EVENTS';
  static const String METHOD_REPORT_UCR = 'METHOD_REPORT_UCR';

  static const String EXTRA_CONFIG_JSON = 'EXTRA_CONFIG_JSON';
  static const String EXTRA_INITIALIZATION_PARAMETERS =
      'EXTRA_INITIALIZATION_PARAMETERS';
  static const String EXTRA_LICENSE_KEY = 'EXTRA_LICENSE_KEY';
  static const String EXTRA_ENABLE_OFFLINE_CACHE = 'EXTRA_ENABLE_OFFLINE_CACHE';
  static const String EXTRA_PLUGIN_VERSION = 'EXTRA_PLUGIN_VERSION';
  static const String EXTRA_CUSTOM_MODELS_PATH = 'EXTRA_CUSTOM_MODELS_PATH';
  static const String EXTRA_VIEW_CONFIGS_PATH = 'EXTRA_VIEW_CONFIGS_PATH';
  static const String EXTRA_SCAN_CALLBACK_CONFIG = 'EXTRA_SCAN_CALLBACK_CONFIG';
  static const String EXTRA_STOP_CONFIG = 'EXTRA_STOP_CONFIG';
  static const String EXTRA_REPORT_UCR_BLOBKEY = 'EXTRA_REPORT_UCR_BLOBKEY';
  static const String EXTRA_REPORT_UCR_CORRECTED_RESULT =
      'EXTRA_REPORT_UCR_CORRECTED_RESULT';

  static const String EXCEPTION_DEFAULT = 'AnylineException';
  static const String EXCEPTION_LICENSE = 'AnylineLicenseException';
  static const String EXCEPTION_CONFIG = 'AnylineConfigException';
  static const String EXCEPTION_NO_CAMERA_PERMISSION =
      'AnylineCameraPermissionException';
  static const String EXCEPTION_CORE = 'AnylineCoreException';
}
