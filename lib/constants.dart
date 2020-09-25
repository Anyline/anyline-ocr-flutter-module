/// Needed for communication with the native SDK.
abstract class Constants {
  static const String METHOD_GET_SDK_VERSION = "METHOD_GET_SDK_VERSION";
  static const String METHOD_SET_LICENSE_KEY = "METHOD_SET_LICENSE_KEY";
  static const String METHOD_START_ANYLINE = "METHOD_START_ANYLINE";

  static const String EXTRA_CONFIG_JSON = "EXTRA_CONFIG_JSON";
  static const String EXTRA_LICENSE_KEY = "EXTRA_LICENSE_KEY";

  static const String EXCEPTION_DEFAULT = "AnylineException";
  static const String EXCEPTION_LICENSE = "AnylineLicenseException";
  static const String EXCEPTION_CONFIG = "AnylineConfigException";
  static const String EXCEPTION_NO_CAMERA_PERMISSION =
      "AnylineCameraPermissionException";
  static const String EXCEPTION_CORE = "AnylineCoreException";
}
