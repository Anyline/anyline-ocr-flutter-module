class LicenseState {

  LicenseState(this.initialized, this.reason);
  static const LicenseKeyEmptyErrorMessage =
      'Please ensure that your license key is valid and set correctly in .env.\n\nFor more information, please check https://documentation.anyline.com/main-component/license-key-generation.html';

  late bool initialized;
  late String reason;
}
