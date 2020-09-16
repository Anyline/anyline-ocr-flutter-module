	 _____         _ _         
	|  _  |___ _ _| |_|___ ___ 
	|     |   | | | | |   | -_|
	|__|__|_|_|_  |_|_|_|_|___|
	          |___|            
	          
# Anyline Flutter Plugin

[Anyline](https://www.anyline.io) is mobile OCR SDK, which can be configured by yourself to scan all kinds of numbers, characters, text and codes. 

The plugin enables the connection to the SDK via Flutter.

### **This plugin is still in development, it is currently functional for Android only!**

## Requirements:

### iOS

not supported yet


### Android 

minSDK >= 19

## Example

Take a look into  [example/lib/main.dart](https://github.com/Anyline/anyline-ocr-flutter-module/blob/058474e8391b35c75e39924ef42236ed773b182e/example/lib/main.dart#L91) to see the implementation.
	                
## Quick Start Guide

### 1. Get a License
Get your [trial license](https://anyline.com/free-demos/) to try Anyline inside your app. 
Reach out to our sales team to get a [commercial license](https://anyline.com/contact-sales/).

### 2. Get the Anyline react-native plugin

Via pub.dev:

```bash
Coming soon!
``` 

[Follow the instructions given on using unpublished packages](https://flutter.dev/docs/development/packages-and-plugins/using-packages#dependencies-on-unpublished-packages) and add the following lines to your `pubspec.yaml`:

```yaml
dependencies:
  anyline-ocr-flutter-module:
    git:
      url: git://github.com/Anyline/anyline-ocr-flutter-module.git
```

### 3. Import the plugin into your Dart file
```dart
import 'package:anyline-ocr-flutter-module/anyline_plugin.dart';
```
### 4. Add the config file to the assets in your `pubspec.yaml`
```yaml
flutter:
  assets:
    - path-to-your-json-config
```
Add and import a JSON file with the proper structure and elements. The JSON config contains: 

1. The license key 
2. Options field with
-	AnylineSDK config parameter
-	“segment”: which contains the scanModes for the UI Segment (e.g. switch between Analog and Digital) - optional
3. OCR field with (Only if you want to use the OCR module)
-   your custom training data
-   RegEx validation

If you want to get detailed information about the config JSON, check out the official [documentation](https://documentation.anyline.io/toc/view_configuration/index.html).

### 6. Call the Anyline component 

#### Instantiate the Plugin

```dart
anylinePlugin = AnylinePlugin();
```

#### Load config from file

```dart
var config = await rootBundle.loadString("your/Config/Path.json");
```

#### Start scanning and parse result

```dart
String resultString = await anylinePlugin.startScanning(config);
```

Currently the plugin does not provide seperate result classes, but this may be added in the future. For now feel free to create your own result class which fits your use case best. Alternatively, Flutter/Dart also supports [serializing JSON using code generation libraries](https://flutter.dev/docs/development/data-and-backend/json). To serialize the JSON string manually and convert it to a Map use `jsonDecode()` from `dart:convert`:

```dart
Map<String, dynamic> resultMap = jsonDecode(resultString);
```

From here you can access e.g. the image path of the cutout image at `resultMap['imagePath']`. 

For detailed information about the result structure, check out the platform-specific documentation for [Android](https://documentation.anyline.com/api/android/index.html) and [iOS](https://documentation.anyline.com/api/ios/index.html).


### 7. Add TrainData to the OCR Module (optional) 
If you are using the `ANYLINE_OCR` module, you'll have to add some `traineddata`. There are some predefined `traineddata` which
you can find in the example app. Also the OCR Config has to reflect the path. Check the VoucherConfig.js in the [example/RNExampleApp/config](https://github.com/Anyline/anyline-ocr-react-native-module/tree/master/example/RNExampleApp/config) folder.

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


## Additional Functions

#### getLicenseExpiryDate

> To be implemented


## Images

Keep in mind, all the images are saved in the cache directory of the app. For performance reasons, we only provide the 
path as string, so we don't have to transfer the whole image through the bridge. Please be aware,  that you should not 
use the images in the cache directory for persistent storage, but store the images in a location of your choice for persistence. 

## License

See LICENSE file.
