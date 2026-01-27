# Anyline Flutter Plugin Demo App

Demonstrates how to use the Anyline Flutter plugin.

If you want to just get the plugin working as quickly as possible, see the example in [`main.dart`](https://github.com/Anyline/anyline-ocr-flutter-module/blob/main/example/lib/main.dart) below.

## Prerequisites

Before starting, check that your development environment is properly configured:

```bash
./scripts/check-environment.sh
```

This validates:
- Flutter SDK (v1.20.0+), Dart SDK
- Android: Java, Gradle, Android SDK, Build Tools, NDK
- iOS: Xcode, Command Line Tools, CocoaPods (macOS only)
- ANYLINE_MOBILE_SDK_LICENSE_KEY in .env file
- Flutter dependencies (flutter pub get)
- iOS CocoaPods dependencies (pod install)

## Getting Started

This project includes an Anyline Flutter Demo App with configurations for 22+ use cases. You can use the app code located in the [`main.dart`](https://github.com/Anyline/anyline-ocr-flutter-module/blob/main/example/lib/main.dart) file as orientation for your own implementation, but we strongly advise against using the same result processing approach as we did in our demo app. The reason why we only used `Map<String,dynamic>` and not custom model classes for storing results and therefore went without Dart typesafety is because for our purpose of only displaying results this was not really necessary. Creating classes for every single use would have been an overkill for this project, but we strongly encourage you to read our [Anyline Flutter Guide on documentation.anyline.com](https://documentation.anyline.com/flutter-plugin-component/latest/getting-started.html), where we go into detail about result processing and the form of all different possible results.

## License Key Setup

### Option 1: Using environment variable (recommended)

Set the license key in your shell profile (`~/.zshrc` or `~/.bashrc`):
```bash
export ANYLINE_MOBILE_SDK_LICENSE_KEY="your-anyline-license-key-here"
```

Then generate the `.env` file:
```bash
./scripts/generate_license_key.sh
```

This script reads from `ANYLINE_MOBILE_SDK_LICENSE_KEY` and creates the `.env` file.

### Option 2: Manual setup

Copy `.env.example` to `.env` and add your license key:
```
ANYLINE_MOBILE_SDK_LICENSE_KEY="your-anyline-license-key-here"
```

**Note:** The `.env` file takes precedence - if it exists, it will be used regardless of the system environment variable.