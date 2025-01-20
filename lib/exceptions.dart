import 'package:anyline_plugin/constants.dart';
import 'package:flutter/services.dart';

/// Custom exception including parser to correctly interpret and propagate errors
/// coming from the native SDK.
class AnylineException implements Exception {
  const AnylineException(this.message);
  final String? message;

  static AnylineException parse(Exception e) {
    if (e is PlatformException) {
      if (e.code == Constants.EXCEPTION_LICENSE) {
        return AnylineLicenseException(e.message);
      } else if (e.code == Constants.EXCEPTION_CONFIG) {
        return AnylineConfigException(e.message);
      } else if (e.code == Constants.EXCEPTION_NO_CAMERA_PERMISSION) {
        return AnylineCameraPermissionException(e.message);
      } else if (e.code == Constants.EXCEPTION_CORE) {
        return AnylineCoreException(e.message);
      } else {
        return AnylineException(e.message);
      }
    }
    return AnylineException(e.toString());
  }
}

/// License is invalid or expired.
class AnylineLicenseException extends AnylineException {
  AnylineLicenseException(String? message) : super(message);
}

/// Config JSON is malformed or missing necessary parts.
class AnylineConfigException extends AnylineException {
  AnylineConfigException(String? message) : super(message);
}

/// Camera Permission is not granted.
class AnylineCameraPermissionException extends AnylineException {
  AnylineCameraPermissionException(String? message) : super(message);
}

/// Anyline OCR Core threw an exception.
class AnylineCoreException extends AnylineException {
  AnylineCoreException(String? message) : super(message);
}
