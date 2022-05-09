enum ScanMode {
  AnalogMeter,
  DigitalMeter,
  SerialNumber,
  DialMeter,
  DotMatrix,
  ArabicId,
  CyrillicId,
  MRZ,
  JapaneseLandingPermit,
  Barcode_PDF417,
  UniversalId,
  LicensePlate,
  LicensePlateUS,
  TIN,
  TireSize,
  CommercialTireId,
  Iban,
  Voucher,
  VIN,
  USNR,
  ContainerShip,
  VerticalContainer,
  Barcode,
  Document,
  CattleTag,
  SerialScanning,
  ParallelScanning
}

extension ScanModeInfo on ScanMode {
  String get label {
    switch (this) {
      case ScanMode.AnalogMeter:
        return 'Analog Meter';
      case ScanMode.DigitalMeter:
        return 'Digital Meter';
      case ScanMode.SerialNumber:
        return 'Serial Number';
      case ScanMode.DialMeter:
        return 'Dial Meter';
      case ScanMode.DotMatrix:
        return 'Dot Matrix';
      case ScanMode.ArabicId:
        return 'Arabic ID';
      case ScanMode.CyrillicId:
        return 'Cyrillic ID';
      case ScanMode.MRZ:
        return 'MRZ';
      case ScanMode.JapaneseLandingPermit:
        return 'Japanese Landing Permit';
      case ScanMode.Barcode_PDF417:
        return 'Barcode_PDF417';
      case ScanMode.UniversalId:
        return 'Universal ID';
      case ScanMode.LicensePlate:
        return 'License Plate';
      case ScanMode.LicensePlateUS:
        return 'License Plate US';
      case ScanMode.TIN:
        return 'TIN';
      case ScanMode.TireSize:
        return 'Tire Size';
      case ScanMode.CommercialTireId:
        return 'Commercial Tire Id';
      case ScanMode.Iban:
        return 'IBAN';
      case ScanMode.Voucher:
        return 'Voucher Code';
      case ScanMode.VIN:
        return 'Vehicle Identification Number';
      case ScanMode.USNR:
        return 'Universal Serial Number';
      case ScanMode.ContainerShip:
        return 'Container';
      case ScanMode.VerticalContainer:
        return 'Vertical Container';
      case ScanMode.Barcode:
        return 'Barcode';
      case ScanMode.Document:
        return 'Document';
      case ScanMode.CattleTag:
        return 'Cattle Tag';
      case ScanMode.ParallelScanning:
        return 'Parallel Scanning (Meter/USRN)';
      case ScanMode.SerialScanning:
        return 'Serial Scanning (LP>DL>VIN)';
    }
  }

  String get key {
    return this.toString().split('.').last;
  }

  bool isCompositeScan() {
    return this == ScanMode.ParallelScanning || this == ScanMode.SerialScanning;
  }
}
