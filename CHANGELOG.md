# Changelog

# 55.5.1

Please find the complete and updated release notes at https://documentation.anyline.com/flutter-plugin-component/latest/release-notes.html.

# 42.2.0

- Update to using Anyline Android SDK 42.2.0
- No change in using Anyline iOS SDK 42.0.0

## New

### User-Corrected Results

- (Android only) Added support for user-corrected results, allowing the reporting of corrected results to our backend

### Tire Size Information

- (Android only) Added Tire Size Detail Information. Refer to [Tire Size Scanning Specifications](https://documentation.anyline.com/toc/products/tire/tire_size/index.html#products-tire-size-scanning) for details and [Android Plugin](https://documentation.anyline.com/toc/platforms/android/plugins/tire.html#android-tire-size-scanning) for implementation help.

## Improved

### Android

- Updated Gradle wrapper version
- Raised target SDK version to 31
- Raised compile SDK version to 31

# 42.0.0

### New

#### Universal ID

- Added support for Polish driving licenses `04001 <https://www.consilium.europa.eu/prado/en/POL-FO-04001/index.html>`_ and `05001 <https://www.consilium.europa.eu/prado/en/POL-FO-05001/index.html>`_
- Added support for Turkey identification card
- Added support for second layout version of Georgia driver's license: ``GA_DVL_O_R381_F``
- Added support for a Colorado identification card
- Added support for the newest Kentucky identification card
- Added support for the newest West Virginia driver's license

### Improved

- Adapted the text message that pops up in case an Anyline license expired

#### Tire Size

- Improved accuracy and now supports the following characters: ``[A-HJ-NP-Z0-9/+-&().]``

#### TIN

- Added stricter checks for valid production date.

### Fixed

- Android: Fix cutout not respecting maxHeightPercent parameter [SDKY-759]
- Android: Fix Flash Mode “AUTO” not working [SDKY-708]


# 41.0.1

### Fixes

- Fixed an asset corruption issue (iOS) in the previous release in which the framework went without a `CFBundleVersion` key in its Info.plist file.

# 41.0.0

### Meter

- Improved accuracy, speed and scanning distance
- NOTE: Meter scan modes `ANALOG_METER`, `DIGITAL_METER`, and `DOT_MATRIX_METER` have been deprecated, and will be removed in a future version. Please use `AUTO_ANALOG_DIGITAL_METER` instead.
- Consequently, the ``segment`` JSON configuration property for the Meter plugin is no longer necessary, and support for it will be removed in a future release.

### Universal ID

- Added support for Turkish driving license and residence permit card

### Tire Size

- Improved scanning detection, accuracy and speed


# 40.0.0

### TIN
- `tinConfig` had been removed as a config for `ocrPlugin` in this release. Please use `tinConfig` from within `tirePlugin` instead.

### Universal ID

- Added support for the latest ID versions of the following US states: New York, Texas, and New Jersey (also Driver License)
- Added support for the following identification cards in Cyrillic: Bulgaria, Serbia
- Improved scanning for France driving license
- Improved scanning for Jordan identification card

### License Plate

- Removed the charWhitelist parameter from the LPT plugin in the SDK

### Tire

- Improved: (Android) the Camera Exposure is now increased for all of the Tire products to improve the scanning capability

### General

- Fixed: (Android) If the License Key allows it, integrating apps that force-remove the Internet Permission via AndroidManifest will not produce a crash anymore

## 39.0.0

- Updated to Anyline 39.0.0
- First public release

### Universal ID

- Added support for additional versions of the following IDs: France, Lesotho, Ukraine, Tunisia, Algeria, Morocco, Utah (US), Nebraska (US)
- Added support for additional versions of the following driver license IDs: Ukraine (2 types), Algeria, Morocco, Iowa (US), Utah (US), Nebraska (US)
- Improved scanning for Netherlands DL and ID
- For non-MRZ documents, the result now contains layout metadata. This includes the country of origin, the category, the type, the version(s) and the side of the document. The ``layoutDefinition`` entry within the result will be deprecated in the future. The layout metadata within the result should be used instead.

### License Plate

- 'charWhitelist' parameter is no longer supported

### Tire

- Added support for `upsideDownMode` for TireSize and CommercialTireID

## 38.0.1-dev.3

- Updated to Anyline 38.0.1

### Universal ID

- Fixed height field scanning issue on US layouts
- Fixed umlaut scanning on some layouts
- Improved scanning of inch unit (”)
- Added support for 3 additional Austrian Army ID layouts
- Added support for the following Austrian IDs: Austrian Health Insurance Card, Austrian ID (new version), Austrian Pensioner ID, Austrian Disability ID
- Added support for 2 Pakistani ID layouts
- Added support for 2nd DVL version of the following states: Oregon, Georgia
- Added support for the following 3 Arabic layouts: Tunisia DVL, Morocco DVL, Morocco IDC
- Fixed maidenName and lastName scanning issues on German IDC

### License Plate

- Fixed a crash when ScanMode is set to a specific country (as opposed to automatic detection).
- Fixed issue scanning white European license plates on white cars
- Fixed issue scanning Euopean license plates partially cast in shadow
- Now correctly scans dashes (“-“) on European license plates instead of returning them as whitespaces
- Now returns the country for Swiss license plates if the Swiss coat of arms is visible on the license plate
- Overall improved accuracy on European license plates

## 37.0.0

Updated to Anyline 37

## Breaking Changes

Anyline License Key

“v2” license keys (used prior to Anyline 37) will not work any more and need to be replaced by “v3” license keys.

## New

### Barcode

Barcode plugin now reads 30 codes at the same time

### Universal ID

Added field scan options and min confidence for MRZ(+) with universalID config
Added support for Oklahoma IDC, Missouri DVL, Maine DVL, Bahrain ID, Qatar ID, Saudi Arabia ID, Oman ID, Pakistani ID front and back, Manitoba, Saskatchewan, Nova Scotia, German new ID

### Tire Size

Added support for scanning Tire Size specifications

### Commercial Tire ID

Added support for scanning Commercial Tire IDs

### Tire Module

The Tire products are now located in a separated tire_module folder.
Please check the deprecation notice above regarding the TINConfig class.

## Improved

### Universal ID

Extended scan capability of french and spanish special characters
Improved scan capability of imperial height and weight units

## 36.0.0

Updated to Anyline 36

## 24.1.0-dev.1 

Updated to Anyline 24.1, document scanner bugfix, redone example-app UI.

## 24.0.0-dev.1.2

Added getLicenseExpiryDate(), refactored example app, added new example in main.dart.

## 24.0.0-dev.1.1

Added dartdoc and updated package description.

## 24.0.0-dev.1

This is a prerelease for Anyline 24 only supporting Android.  
