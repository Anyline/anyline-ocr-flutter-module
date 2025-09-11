enum ScanMode {
  AnalogDigitalMeter,
  ArabicId,
  Barcode_PDF417,
  Barcode,
  BarcodeContinuous,
  CommercialTireId,
  ContainerShip,
  CyrillicId,
  LicensePlate,
  JapaneseLandingPermission,
  MRZ,
  Odometer,
  ParallelScanning,
  ParallelFirstScanning,
  SerialNumber,
  SerialScanning,
  TIN,
  TINDOTWithUIFeedback,
  TireSize,
  UniversalId,
  USNR,
  VerticalContainer,
  VIN,
  VRC,
  CowTag
}

extension ScanModeInfo on ScanMode {
  String get label {
    switch (this) {
      case ScanMode.AnalogDigitalMeter:
        return 'Analog / Digital Meter';
      case ScanMode.SerialNumber:
        return 'Meter Serial Number';
      case ScanMode.ArabicId:
        return 'Arabic ID';
      case ScanMode.CyrillicId:
        return 'Cyrillic ID';
      case ScanMode.MRZ:
        return 'MRZ';
      case ScanMode.Barcode_PDF417:
        return 'Barcode_PDF417';
      case ScanMode.UniversalId:
        return 'Universal ID';
      case ScanMode.LicensePlate:
        return 'License Plate';
      case ScanMode.JapaneseLandingPermission:
        return 'Japanese Landing Permission';
      case ScanMode.Odometer:
        return 'Odometer';
      case ScanMode.TIN:
        return 'TIN';
      case ScanMode.TINDOTWithUIFeedback:
        return 'TIN DOT With UI Feedback';
      case ScanMode.TireSize:
        return 'Tire Size';
      case ScanMode.CommercialTireId:
        return 'Commercial Tire Id';
      case ScanMode.VIN:
        return 'Vehicle Identification Number';
      case ScanMode.USNR:
        return 'Meter Serial Number';
      case ScanMode.ContainerShip:
        return 'Container';
      case ScanMode.VerticalContainer:
        return 'Vertical Container';
      case ScanMode.Barcode:
        return 'Barcode';
      case ScanMode.BarcodeContinuous:
        return 'Barcode (Continuous)';
      case ScanMode.ParallelScanning:
        return 'Parallel Scanning (Meter/USRN)';
      case ScanMode.ParallelFirstScanning:
        return 'Parallel First Scanning (VIN/Barcode)';
      case ScanMode.SerialScanning:
        return 'Serial Scanning (LP>DL>VIN)';
      case ScanMode.VRC:
        return 'Vehicle Registration Certificate';
      case ScanMode.CowTag:
        return 'Cow Tag';
    }
  }

  String get key {
    return toString().split('.').last;
  }

  bool isCompositeScan() {
    return this == ScanMode.ParallelScanning ||
        this == ScanMode.ParallelFirstScanning ||
        this == ScanMode.SerialScanning;
  }

  bool isContinuous() {
    return this == ScanMode.BarcodeContinuous;
  }
}
