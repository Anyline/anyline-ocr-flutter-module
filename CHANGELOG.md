## 38.0.1-dev.2

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
