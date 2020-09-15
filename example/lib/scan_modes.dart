enum ScanMode {
  AnalogMeter,
  DigitalMeter,
  SerialNumber,
  DialMeter,
  DotMatrix,
  DrivingLicense,
  MRZ,
  GermanIDFront,
  Barcode_PDF417,
  UniversalId,
  LicensePlate,
  TIN,
  Iban,
  Voucher,
  VIN,
  USNR,
  ContainerShip,
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
      case ScanMode.DrivingLicense:
        return 'Driving License';
      case ScanMode.MRZ:
        return 'MRZ';
      case ScanMode.GermanIDFront:
        return 'German ID Front';
      case ScanMode.Barcode_PDF417:
        return 'Barcode_PDF417';
      case ScanMode.UniversalId:
        return 'Universal ID';
      case ScanMode.LicensePlate:
        return 'License Plate';
      case ScanMode.TIN:
        return 'TIN';
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
