# Anyline Flutter Plugin Demo App

Demonstrates how to use the Anyline Flutter plugin.

If you want to just get the plugin working as quickly as possible, see the example in [`main.dart`](https://github.com/Anyline/anyline-ocr-flutter-module/blob/main/example/lib/main.dart) below.

## Getting Started

This project includes an Anyline Flutter Demo App with configurations for 22+ use cases. You can use the app code located in the [`main.dart`](https://github.com/Anyline/anyline-ocr-flutter-module/blob/main/example/lib/main.dart) file as orientation for your own implementation, but we strongly advise against using the same result processing approach as we did in our demo app. The reason why we only used `Map<String,dynamic>` and not custom model classes for storing results and therefore went without Dart typesafety is because for our purpose of only displaying results this was not really necessary. Creating classes for every single use would have been an overkill for this project, but we strongly encourage you to read our [Anyline Flutter Guide on documentation.anyline.com](https://documentation.anyline.com/flutter-plugin-component/latest/getting-started.html), where we go into detail about result processing and the form of all different possible results.

## Create .env file

- Navigate to path_to_plugin_root_folder/example
- Create .env file and add below line of code
> licenseKey="{REPLACE WITH YOUR LICENSE KEY}"