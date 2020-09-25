import 'package:anyline_plugin/constants.dart';
import 'package:flutter/services.dart';

class AnylineException implements Exception {
    final String message;
    const AnylineException(this.message);

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

class AnylineLicenseException extends AnylineException {
  AnylineLicenseException(String message) : super(message);
}

class AnylineConfigException extends AnylineException {
  AnylineConfigException(String message) : super(message);
}

class AnylineCameraPermissionException extends AnylineException {
  AnylineCameraPermissionException(String message) : super(message);
}

class AnylineCoreException extends AnylineException {
  AnylineCoreException(String message) : super(message);
}
