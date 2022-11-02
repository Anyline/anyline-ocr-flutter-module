# Anyline Flutter Plugin

[![pub package](https://img.shields.io/pub/v/anyline_plugin.svg)](https://pub.dev/packages/anyline_plugin)

[Anyline](https://www.anyline.io) is a mobile OCR SDK, which can be configured by yourself to scan all kinds of numbers, characters, text and codes. 

The plugin enables the connection to the SDK via Flutter.

## Table of Contents
* [Requirements](#requirements)
* [Example](#example)
* [Quick Start Guide](#quick-start-guide)
* [Additional Functions](#additional-functions)
* [Images](#Images)
* [Get Help (Support)](#Get-Help-Support)
* [License](#License)

## Requirements:

| **iOS**           | **Android**  |
|-------------------|--------------|
| baseSDK >= 12     | minSDK >= 21 |

## Example

This is just a minimal example function to show how to use our plugin as quick as possible. For the code of our Flutter example app check out the [example/lib/main.dart](https://github.com/Anyline/anyline-ocr-flutter-module/blob/main/example/lib/main.dart) module.
```dart
void scanWithAnyline() async {
  /// Instantiate the plugin.
  var anylinePlugin = AnylinePlugin();

  /// Load the config file which also includes the license key (for more info
  /// visit documentation.anyline.com).
  var config = await rootBundle.loadString("config/AnalogMeterConfig.json");

  /// Start the scanning process.
  var stringResult = await anylinePlugin.startScanning(config);

  /// Convert the stringResult to a Map to access the result fields. It is
  /// recommended to create result classes that fit your use case. For more
  /// information on that, visit the Flutter Guide on documentation.anyline.com.
  Map<String, dynamic> result = jsonDecode(stringResult);
}
```
	                
## Quick Start Guide

For a more in-depth guide, consider checking out the [Anyline Flutter Guide on documentation.anyline.com](https://documentation.anyline.com/toc/platforms/flutter/getting_started.html#anyline-flutter-guide).

### 1. Get a License
Get your [trial license](https://ocr.anyline.com/request/sdk-trial/) to try Anyline inside your app. 
Reach out to our sales team to get a [commercial license](https://ocr.anyline.com/request/sdk-trial/).

### 2. Get the Anyline flutter plugin

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  anyline_plugin: ^42.0.0
```

Install it with Flutter:

```shell
  $ flutter pub get
```

### 3. Import the plugin into your Dart file
```dart
import 'package:anyline_plugin/anyline_plugin.dart';
```
### 4. Add the config file to the assets in your `pubspec.yaml`
```yaml
flutter:
  assets:
    - path-to-your-json-config
```
Add a JSON file with the proper structure and elements. The JSON config contains: 

1. The license key 
2. Options field with
-	AnylineSDK config parameter
-	“segment”: which contains the scanModes for the UI Segment (e.g. switch between Auto and Dial in Meter) - optional
3. OCR field with (Only if you want to use the OCR module)
-   your custom training data
-   RegEx validation

If you want to get detailed information about the config JSON, check out the official [documentation](https://documentation.anyline.io/toc/view_configuration/index.html).

### 6. Call the Anyline component 

#### Instantiate the Plugin

```dart
var anylinePlugin = AnylinePlugin();
```

#### Load config from file

```dart
var config = await rootBundle.loadString("your/Config/Path.json");
```

#### Start scanning and parse result

```dart
var resultString = await anylinePlugin.startScanning(config);
```

Currently the plugin does not provide seperate result classes, but this may be added in the future. For now feel free to create your own result class which fits your use case best. Alternatively, Flutter/Dart also supports [serializing JSON using code generation libraries](https://flutter.dev/docs/development/data-and-backend/json). To serialize the JSON string manually and convert it to a Map use `jsonDecode()` from `dart:convert`:

```dart
Map<String, dynamic> resultMap = jsonDecode(resultString);
```

From here you can access e.g. the image path of the cutout image at `resultMap['imagePath']`. 

For detailed information on handling results and the result structure, check out our [Anyline Flutter Guide on documentation.anyline.com](https://documentation.anyline.com/toc/platforms/flutter/getting_started.html#anyline-flutter-guide).

### 7. Add TrainData to the OCR Module (optional) 
If you are using the `ANYLINE_OCR` module, you'll have to add some `traineddata`. There are some predefined `traineddata` which
you can find in the example app. Also the OCR Config has to reflect the path. Check the VoucherConfig.json in the [example/config](https://github.com/Anyline/anyline-ocr-flutter-module/blob/main/example/config) folder.

> __IMPORTANT:__ The trainedFiles have to be directly in the Asset folder in Android.

#### iOS
```
ios   
 └─── myTrainedData.traineddata
```

#### Android
```
android   
   └─── app
         └─── src
               └─── main
                      └─── assets
                             └─── myTrainedData.traineddata || myTrainedData.any
```

### Release Builds / ProGuard Config (Android)

When building on release, setting a ProGuard config is required for Android.

#### proguard-rules.pro
```
-keep public class * {
    public protected *;
}
-keep class at.nineyards.anyline.** { *; }
-dontwarn at.nineyards.anyline.**
-keep class org.opencv.** { *; }
-dontwarn org.opencv.**
```


## Additional Functions

#### getLicenseExpiryDate

Get the expiration date of the provided license. Returns a string.


## Images

Keep in mind, all the images are saved in the cache directory of the app. For performance reasons, we only provide the 
path as string, so we don't have to transfer the whole image through the bridge. Please be aware,  that you should not 
use the images in the cache directory for persistent storage, but store the images in a location of your choice for persistence.

## Get Help (Support)

We don't actively monitor the Github Issues, please raise a support request using the [Anyline Helpdesk](https://anyline.atlassian.net/servicedesk/customer/portal/2/group/6).
When raising a support request based on this Github Issue, please fill out and include the following information:

```
Support request concerning Anyline Github Repository: anyline-ocr-flutter-module
```

Thank you!

## License

See LICENSE file.
