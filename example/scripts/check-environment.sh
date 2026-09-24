#!/bin/bash

################################################################################
# Anyline Flutter Plugin - Environment Check Script
################################################################################
# This script validates your development environment for building and running
# the Anyline Flutter example application on Android and iOS.
#
# Usage:
#   ./scripts/check-environment.sh           # Interactive mode with colors
#   ./scripts/check-environment.sh --ci      # CI mode (plain text, strict)
#   ./scripts/check-environment.sh --help    # Show help
#
# This script checks for:
#   - Flutter SDK (minimum version 3.38.0)
#   - Dart SDK (bundled with Flutter)
#   - Java (for Android builds)
#   - Gradle (for Android builds)
#   - Android SDK and environment variables
#   - Android Build Tools (for Flutter Android builds)
#   - Android NDK 25.x (specified in pubspec.yaml)
#   - Xcode and iOS development tools (macOS only)
#   - CocoaPods (macOS only, REQUIRED for iOS builds)
#   - xcrun devicectl (recommended for iOS device deployment)
#   - ANYLINE_MOBILE_SDK_LICENSE_KEY (environment variable or .env file)
#
# Exit codes:
#   0 - All required prerequisites are met (warnings allowed)
#   1 - One or more required prerequisites are missing
################################################################################

set -e  # Exit on error in strict mode (can be overridden)
set +e  # Allow continuing through checks

# Detect CI environment
CI_MODE=false
if [[ "$1" == "--ci" ]] || [[ -n "${CI:-}" ]]; then
    CI_MODE=true
fi

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    cat << EOF
Anyline Flutter Plugin - Environment Check Script

Usage:
  ./scripts/check-environment.sh           # Interactive mode with colors
  ./scripts/check-environment.sh --ci      # CI mode (plain text, strict)
  ./scripts/check-environment.sh --help    # Show this help

This script checks for:
  - Flutter SDK (minimum version 3.38.0)
  - Dart SDK (bundled with Flutter)
  - Java (for Android builds)
  - Gradle (for Android builds)
  - Android SDK and environment variables
  - Android Build Tools (for Flutter Android builds)
  - Android NDK 25.x (specified in pubspec.yaml)
  - Xcode and iOS development tools (macOS only)
  - CocoaPods (macOS only, REQUIRED for iOS builds)
  - xcrun devicectl (recommended for iOS device deployment)
  - ANYLINE_MOBILE_SDK_LICENSE_KEY (environment variable or .env file)

Exit codes:
  0 - All required prerequisites met (warnings allowed)
  1 - One or more required prerequisites missing
EOF
    exit 0
fi

# Find repository root and change to it
if git rev-parse --git-dir > /dev/null 2>&1; then
    REPO_ROOT=$(git rev-parse --show-toplevel)
    cd "$REPO_ROOT" || {
        echo "Error: Could not change to repository root: $REPO_ROOT" >&2
        exit 1
    }
else
    echo "Warning: Not in a git repository. Assuming current directory is repository root."
fi

# Color codes (disabled in CI mode)
if [[ "$CI_MODE" == "true" ]]; then
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    DIM=""
    NC=""
    CHECK="[OK]"
    CROSS="[FAIL]"
    WARN="[WARN]"
    INFO="[INFO]"
else
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    BOLD='\033[1m'
    DIM='\033[2m'
    NC='\033[0m'
    CHECK="✅"
    CROSS="❌"
    WARN="⚠️ "
    INFO="ℹ️ "
fi

# Track overall status
HAS_ERRORS=false
HAS_WARNINGS=false

# AWK pattern for extracting second field
AWK_PRINT_FIELD2='{print $2}'

# Platform constants
readonly PLATFORM_MACOS="darwin"

# Helper functions
print_header() {
    local message="$1"
    echo ""
    echo "=========================================="
    echo "$message"
    echo "=========================================="
    return 0
}

print_section() {
    local message="$1"
    echo ""
    echo -e "${BOLD}$message${NC}"
    return 0
}

print_success() {
    local message="$1"
    echo -e "${GREEN}${CHECK}${NC} $message"
    return 0
}

print_error() {
    local message="$1"
    echo -e "${RED}${CROSS}${NC} $message"
    HAS_ERRORS=true
    return 0
}

print_warning() {
    local message="$1"
    echo -e "${YELLOW}${WARN}${NC} $message"
    HAS_WARNINGS=true
    return 0
}

print_info() {
    local message="$1"
    echo -e "${BLUE}${INFO}${NC} $message"
    return 0
}

print_fix() {
    local message="$1"
    echo -e "   ${BLUE}→${NC} Fix: $message"
    return 0
}

# Start checks
print_header "Anyline Flutter Plugin - Environment Check"

if [[ "$CI_MODE" == "true" ]]; then
    echo "Running in CI mode"
else
    echo "Running in local mode"
fi

################################################################################
# Check 1: Flutter SDK and Dart
################################################################################
print_section "Check 1: Flutter SDK and Dart"

if command -v flutter &> /dev/null; then
    # Get Flutter version
    FLUTTER_VERSION=$(flutter --version | head -n 1 | awk "$AWK_PRINT_FIELD2" || true)
    print_success "Flutter SDK found: $FLUTTER_VERSION"

    # Check Flutter channel
    FLUTTER_CHANNEL=$(flutter --version | grep -o "channel [a-z]*" | awk "$AWK_PRINT_FIELD2" || true)
    if [[ -n "$FLUTTER_CHANNEL" ]]; then
        print_info "Flutter channel: $FLUTTER_CHANNEL"
    fi

    # Check Dart SDK (bundled with Flutter)
    if command -v dart &> /dev/null; then
        DART_VERSION=$(dart --version 2>&1 | awk '{print $4}' || true)
        print_success "Dart SDK found: $DART_VERSION"
    else
        print_warning "Dart SDK not found in PATH (should be bundled with Flutter)"
    fi

    # Validate minimum Flutter version (3.38.0, for the iOS host's scene template)
    FLUTTER_MAJOR=$(echo "$FLUTTER_VERSION" | cut -d. -f1)
    FLUTTER_MINOR=$(echo "$FLUTTER_VERSION" | cut -d. -f2)

    if [[ "$FLUTTER_MAJOR" -lt 3 ]] || [[ "$FLUTTER_MAJOR" -eq 3 && "$FLUTTER_MINOR" -lt 38 ]]; then
        print_error "Flutter version must be 3.38.0 or higher (found: $FLUTTER_VERSION)"
        print_fix "Update Flutter: flutter upgrade"
        HAS_ERRORS=true
    else
        print_success "Flutter version meets minimum requirement (>=3.38.0)"
    fi

    # Check if flutter doctor has any critical issues (optional)
    if [[ "$CI_MODE" != "true" ]]; then
        print_info "Run 'flutter doctor' for detailed environment diagnostics"
    fi

else
    print_error "Flutter SDK not found in PATH"
    print_fix "Install Flutter SDK from https://flutter.dev/docs/get-started/install"
    print_fix "Add Flutter to PATH: export PATH=\"\$PATH:\$HOME/flutter/bin\""
    HAS_ERRORS=true
fi

################################################################################
# Check 2: Java (for Android builds)
################################################################################
print_section "Check 2: Java"

if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    print_success "Java is installed: $JAVA_VERSION"

    if [[ -n "${JAVA_HOME:-}" ]]; then
        print_success "JAVA_HOME is set: $JAVA_HOME"
    else
        print_warning "JAVA_HOME environment variable is not set"
        print_fix "Set JAVA_HOME in your shell profile (~/.zshrc or ~/.bashrc)"
        print_info "JAVA_HOME may be required by some Android build tools"
    fi
else
    print_error "Java is not installed"
    print_fix "Install Java 8 or higher for Android builds"
    print_fix "Using Homebrew: brew install openjdk@21"
    print_fix "Or download from: https://adoptium.net/"
fi

################################################################################
# Check 3: Gradle (for Android builds)
################################################################################
print_section "Check 3: Gradle"

if command -v gradle &> /dev/null; then
    GRADLE_VERSION=$(gradle --version 2>&1 | grep "Gradle" | head -n 1)
    print_success "Gradle is installed: $GRADLE_VERSION"
else
    print_warning "Gradle is not installed (Flutter bundles Gradle wrapper)"
    print_info "Flutter typically uses bundled Gradle wrapper for Android builds"
    print_info "Manual Gradle installation: brew install gradle or sdk install gradle"
fi

################################################################################
# Check 4: Android SDK
################################################################################
print_section "Check 4: Android SDK"

ANDROID_SDK_FOUND=false
ANDROID_SDK_PATH=""

# Check environment variables
if [[ -n "${ANDROID_HOME:-}" ]] && [[ -d "$ANDROID_HOME" ]]; then
    print_success "ANDROID_HOME is set: $ANDROID_HOME"
    ANDROID_SDK_FOUND=true
    ANDROID_SDK_PATH="$ANDROID_HOME"
elif [[ -n "${ANDROID_SDK_ROOT:-}" ]] && [[ -d "$ANDROID_SDK_ROOT" ]]; then
    print_success "ANDROID_SDK_ROOT is set: $ANDROID_SDK_ROOT"
    ANDROID_SDK_FOUND=true
    ANDROID_SDK_PATH="$ANDROID_SDK_ROOT"
elif [[ -d "$HOME/Library/Android/sdk" ]]; then
    print_warning "Android SDK found at $HOME/Library/Android/sdk, but ANDROID_HOME not set"
    print_fix "Add to your shell profile: export ANDROID_HOME=\$HOME/Library/Android/sdk"
    print_fix "Add to PATH: export PATH=\$ANDROID_HOME/platform-tools:\$PATH"
    ANDROID_SDK_FOUND=true
    ANDROID_SDK_PATH="$HOME/Library/Android/sdk"
elif [[ -d "$HOME/Android/Sdk" ]]; then
    print_warning "Android SDK found at $HOME/Android/Sdk, but ANDROID_HOME not set"
    print_fix "Add to your shell profile: export ANDROID_HOME=\$HOME/Android/Sdk"
    print_fix "Add to PATH: export PATH=\$ANDROID_HOME/platform-tools:\$PATH"
    ANDROID_SDK_FOUND=true
    ANDROID_SDK_PATH="$HOME/Android/Sdk"
else
    print_error "Android SDK not found"
    print_fix "Install Android SDK via Android Studio"
    print_fix "Or install command line tools: https://developer.android.com/studio"
fi

# Check for platform-tools (adb)
if [[ "$ANDROID_SDK_FOUND" == "true" ]]; then
    if command -v adb &> /dev/null; then
        ADB_VERSION=$(adb --version 2>&1 | head -n 1)
        print_success "Android Platform Tools: $ADB_VERSION"
    else
        print_warning "adb not in PATH"
        print_fix "Add to PATH: export PATH=\$ANDROID_HOME/platform-tools:\$PATH"
    fi

    # Check for build-tools (Flutter needs recent version)
    if [[ -d "$ANDROID_SDK_PATH/build-tools" ]]; then
        LATEST_BUILD_TOOLS=$(ls -1 "$ANDROID_SDK_PATH/build-tools" 2>/dev/null | sort -V | tail -n 1 || true)
        if [[ -n "$LATEST_BUILD_TOOLS" ]]; then
            print_success "Android Build Tools installed: $LATEST_BUILD_TOOLS"

            # List all available versions for info
            if [[ "$CI_MODE" != "true" ]]; then
                ALL_BUILD_TOOLS=$(ls -1 "$ANDROID_SDK_PATH/build-tools" 2>/dev/null | tr '\n' ', ' | sed 's/,$//' || true)
                if [[ -n "$ALL_BUILD_TOOLS" ]]; then
                    print_info "Available Build Tools: $ALL_BUILD_TOOLS"
                fi
            fi
        else
            print_warning "No Android Build Tools found"
            print_fix "Install via Android Studio SDK Manager"
            print_fix "Or via command line: \$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager 'build-tools;34.0.0'"
        fi
    else
        print_error "Android Build Tools directory not found"
        print_fix "Install Build Tools via Android Studio SDK Manager"
    fi

    # Check for NDK (specified in pubspec.yaml: 25.1.8937393)
    if [[ -d "$ANDROID_SDK_PATH/ndk" ]]; then
        NDK_VERSIONS=$(ls -1 "$ANDROID_SDK_PATH/ndk" 2>/dev/null || true)
        if echo "$NDK_VERSIONS" | grep -q "25\."; then
            NDK_25_VERSION=$(echo "$NDK_VERSIONS" | grep "^25\." | sort -V | tail -n 1)
            print_success "Android NDK 25.x found: $NDK_25_VERSION"
        else
            print_warning "Android NDK 25.x not found (required version: 25.1.8937393)"
            print_fix "Install via Android Studio SDK Manager"
            print_fix "Or via command line: \$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager 'ndk;25.1.8937393'"
            if [[ -n "$NDK_VERSIONS" ]]; then
                print_info "Available NDK versions: $(echo $NDK_VERSIONS | tr '\n' ', ' | sed 's/,$//')"
            fi
        fi
    else
        print_warning "Android NDK directory not found"
        print_info "NDK may be optional for basic Flutter Android builds"
        print_fix "Install if needed: \$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager 'ndk;25.1.8937393'"
    fi
fi

################################################################################
# Check 5: Xcode and iOS Development Tools (macOS only)
################################################################################
if [[ "$OSTYPE" == "$PLATFORM_MACOS"* ]]; then
    print_section "Check 5: Xcode and iOS Tools"

    # Check Xcode
    if command -v xcodebuild &> /dev/null; then
        XCODE_VERSION=$(xcodebuild -version | head -n 1)
        print_success "$XCODE_VERSION is installed"

        # Check command line tools
        if xcode-select -p &> /dev/null; then
            XCODE_PATH=$(xcode-select -p)
            print_success "Xcode Command Line Tools: $XCODE_PATH"

            # Check if pointing to standalone tools instead of Xcode
            if [[ "$XCODE_PATH" == "/Library/Developer/CommandLineTools" ]]; then
                print_warning "Command line tools pointing to standalone installation"
                print_fix "Point to Xcode: sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
            fi
        else
            print_error "Xcode Command Line Tools not configured"
            print_fix "Run: sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
            print_fix "Or install standalone tools: xcode-select --install"
        fi
    else
        print_error "Xcode is not installed"
        print_fix "Install Xcode from the Mac App Store"
        print_fix "Or download from https://developer.apple.com/xcode/"
    fi

    # Check CocoaPods (REQUIRED for Flutter iOS builds)
    if command -v pod &> /dev/null; then
        POD_VERSION=$(pod --version 2>&1)
        print_success "CocoaPods is installed: $POD_VERSION"
    else
        print_error "CocoaPods not found (REQUIRED for Flutter iOS builds)"
        print_fix "Install CocoaPods: sudo gem install cocoapods"
        print_fix "Or via Homebrew: brew install cocoapods"
        HAS_ERRORS=true
    fi

    # Check xcrun devicectl (recommended for iOS device deployment)
    if command -v xcrun &> /dev/null; then
        if xcrun devicectl --version &> /dev/null 2>&1 || xcrun devicectl --help &> /dev/null 2>&1; then
            print_success "xcrun devicectl is available (recommended for device deployment)"
        else
            print_warning "xcrun devicectl not available"
            print_info "Update Xcode to latest version for improved device deployment"
        fi
    fi

else
    print_info "Skipping iOS checks (not on macOS)"
fi

################################################################################
# Check 6: ANYLINE_MOBILE_SDK_LICENSE_KEY and .env File Configuration
################################################################################
print_section "Check 6: ANYLINE_MOBILE_SDK_LICENSE_KEY and .env File"

ENV_FILE_PATH="Source/example/.env"

# Check .env file (Flutter example uses flutter_dotenv)
if [[ -f "$ENV_FILE_PATH" ]]; then
    # Check for correct key name (ANYLINE_MOBILE_SDK_LICENSE_KEY)
    if grep -q "^ANYLINE_MOBILE_SDK_LICENSE_KEY=" "$ENV_FILE_PATH"; then
        print_success ".env file exists with correct 'ANYLINE_MOBILE_SDK_LICENSE_KEY' format"

        # Verify the value is not empty
        LICENSE_VALUE=$(grep "^ANYLINE_MOBILE_SDK_LICENSE_KEY=" "$ENV_FILE_PATH" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
        if [[ -n "$LICENSE_VALUE" ]]; then
            OBFUSCATED_KEY="${LICENSE_VALUE:0:10}...${LICENSE_VALUE: -10}"
            print_success "License key is set: $OBFUSCATED_KEY"
        else
            print_error "License key is empty in .env file"
            print_fix "Add your license key to $ENV_FILE_PATH: ANYLINE_MOBILE_SDK_LICENSE_KEY=your-license-key-here"
            HAS_ERRORS=true
        fi
    elif grep -q "^licenseKey=" "$ENV_FILE_PATH"; then
        print_error ".env file uses old key name 'licenseKey' (should be 'ANYLINE_MOBILE_SDK_LICENSE_KEY')"
        print_fix "Change 'licenseKey=' to 'ANYLINE_MOBILE_SDK_LICENSE_KEY=' in $ENV_FILE_PATH"
        HAS_ERRORS=true
    else
        print_error ".env file exists but 'ANYLINE_MOBILE_SDK_LICENSE_KEY' not found"
        print_fix "Add to $ENV_FILE_PATH: ANYLINE_MOBILE_SDK_LICENSE_KEY=your-license-key-here"
        HAS_ERRORS=true
    fi
else
    print_warning ".env file not found at $ENV_FILE_PATH"
    print_fix "Copy .env.example to .env and add your license key"
    print_info "Note: Required for running example app, not for building plugin"
    HAS_WARNINGS=true
fi

# Also check environment variable
if [[ -n "${ANYLINE_MOBILE_SDK_LICENSE_KEY:-}" ]]; then
    OBFUSCATED_KEY="${ANYLINE_MOBILE_SDK_LICENSE_KEY:0:10}...${ANYLINE_MOBILE_SDK_LICENSE_KEY: -10}"
    print_info "ANYLINE_MOBILE_SDK_LICENSE_KEY environment variable is also set: $OBFUSCATED_KEY"
fi

################################################################################
# Check 6a: Flutter Dependencies
################################################################################
print_section "Check 6a: Flutter Dependencies"

PUBSPEC_PATH="Source/example/pubspec.yaml"
PUBSPEC_LOCK="Source/example/pubspec.lock"
PUB_CACHE="Source/example/.dart_tool/package_config.json"

if [[ -f "$PUB_CACHE" ]]; then
    print_success "Flutter dependencies are installed"
else
    print_warning "Flutter dependencies not installed"
    print_fix "Run: cd Source/example && flutter pub get"
    HAS_WARNINGS=true
fi

################################################################################
# Check 6b: iOS CocoaPods Dependencies (macOS only)
################################################################################
if [[ "$OSTYPE" == "$PLATFORM_MACOS"* ]]; then
    print_section "Check 6b: iOS CocoaPods Dependencies"

    PODFILE="Source/example/ios/Podfile"
    PODFILE_LOCK="Source/example/ios/Podfile.lock"
    PODS_DIR="Source/example/ios/Pods"

    if [[ -f "$PODFILE" ]]; then
        if [[ -d "$PODS_DIR" ]] && [[ -f "$PODFILE_LOCK" ]]; then
            print_success "iOS CocoaPods dependencies are installed"

            # Check Anyline SDK version
            if grep -q "Anyline" "$PODFILE_LOCK"; then
                ANYLINE_VERSION=$(grep -A 1 "- Anyline" "$PODFILE_LOCK" | grep ":" | head -1 | awk "$AWK_PRINT_FIELD2" | tr -d '()')
                if [[ -n "$ANYLINE_VERSION" ]]; then
                    print_info "Anyline iOS SDK version: $ANYLINE_VERSION"
                fi
            fi
        else
            print_warning "iOS CocoaPods dependencies not installed"
            print_fix "Run: cd Source/example/ios && pod install"
            HAS_WARNINGS=true
        fi
    else
        print_info "No Podfile found (expected for Flutter plugin)"
    fi
fi

################################################################################
# Check 7: iOS Simulators (local mode only, macOS only)
################################################################################
if [[ "$CI_MODE" == "false" ]] && [[ "$OSTYPE" == "darwin"* ]]; then
    print_section "Check 7: iOS Simulators (Optional)"

    if command -v xcrun &> /dev/null; then
        SIMULATOR_COUNT=$(xcrun simctl list devices available 2>/dev/null | grep -c "iPhone" || true)

        if [[ "$SIMULATOR_COUNT" -gt 0 ]]; then
            print_success "Found $SIMULATOR_COUNT iOS simulator(s)"
        else
            print_warning "No iOS simulators found"
            print_fix "Open Xcode and install iOS simulators via Settings > Platforms"
        fi
    fi
fi

################################################################################
# Check 8: Android Devices/Emulators (local mode only)
################################################################################
if [[ "$CI_MODE" == "false" ]] && [[ "$ANDROID_SDK_FOUND" == "true" ]]; then
    print_section "Check 8: Android Devices/Emulators (Optional)"

    # Check for connected devices
    if command -v adb &> /dev/null; then
        DEVICE_COUNT=$(adb devices 2>/dev/null | grep -v "List of devices" | grep -c "device" || true)

        if [[ "$DEVICE_COUNT" -gt 0 ]]; then
            print_success "Found $DEVICE_COUNT connected Android device(s)/emulator(s)"
        else
            print_warning "No Android devices or emulators connected"
            print_fix "Connect a device or start an emulator via Android Studio AVD Manager"
            print_fix "Or use Flutter: flutter emulators --launch <emulator_id>"
        fi
    fi
fi

################################################################################
# Summary
################################################################################
print_header "Summary"

if [[ "$HAS_ERRORS" == "true" ]]; then
    echo -e "${RED}${CROSS} Some required prerequisites are missing${NC}"
    echo ""
    echo "Please fix the errors above and run this script again."
    echo ""

    if [[ "$CI_MODE" == "false" ]]; then
        echo "Quick setup guide:"
        echo "  1. Install Flutter SDK: https://flutter.dev/docs/get-started/install"
        echo "  2. Install Java 8+: brew install openjdk@21"
        echo "  3. Install Android SDK via Android Studio"
        if [[ "$OSTYPE" == "$PLATFORM_MACOS"* ]]; then
            echo "  4. Install Xcode from Mac App Store"
            echo "  5. Install CocoaPods: sudo gem install cocoapods"
        fi
        echo "  6. Run this script again: ./scripts/check-environment.sh"
    fi

    exit 1
elif [[ "$HAS_WARNINGS" == "true" ]]; then
    echo -e "${YELLOW}${WARN} Environment check passed with warnings${NC}"
    echo ""
    echo "You can proceed with development, but some optional features may not work."
    echo "Review the warnings above to enable all functionality."

    if [[ "$CI_MODE" == "false" ]]; then
        echo ""
        echo "Recommended next steps:"
        echo "  1. Navigate to the example app:"
        echo -e "     ${DIM}cd Source/example${NC}"
        echo ""
        echo "  2. Install Flutter dependencies:"
        echo -e "     ${DIM}flutter pub get${NC}"
        echo ""
        echo "  3. Run on connected device:"
        echo -e "     ${DIM}flutter run${NC}"
        echo ""
        if [[ "$OSTYPE" == "$PLATFORM_MACOS"* ]]; then
            echo "For iOS development:"
            echo -e "  - Run on iOS simulator: ${DIM}flutter run -d \"iPhone 15\"${NC}"
            echo -e "  - Run on iOS device: ${DIM}flutter run -d <device-id>${NC}"
            echo -e "  - Build iOS: ${DIM}flutter build ios${NC}"
            echo ""
        fi
        echo "For Android development:"
        echo -e "  - Run on Android emulator: ${DIM}flutter run${NC}"
        echo -e "  - Build Android APK: ${DIM}flutter build apk${NC}"
        echo ""
    fi

    exit 0
else
    echo -e "${GREEN}${CHECK} All prerequisites are met!${NC}"
    echo ""

    if [[ "$CI_MODE" == "false" ]]; then
        echo -e "${BOLD}Next steps:${NC}"
        echo ""
        echo "  1. Navigate to the example app:"
        echo -e "     ${DIM}cd Source/example${NC}"
        echo ""
        echo "  2. Install Flutter dependencies:"
        echo -e "     ${DIM}flutter pub get${NC}"
        echo ""
        echo "  3. Run on connected device:"
        echo -e "     ${DIM}flutter run${NC}"
        echo ""
        echo "  4. Or build for specific platform:"
        echo -e "     ${DIM}flutter build apk        # Android${NC}"
        echo -e "     ${DIM}flutter build ios        # iOS${NC}"
        echo ""
        if [[ "$OSTYPE" == "$PLATFORM_MACOS"* ]]; then
            echo -e "  Tip: List available devices with: ${DIM}flutter devices${NC}"
            echo ""
        fi
        echo "For more information, see README.md"
    else
        echo "Environment ready for CI build"
    fi

    exit 0
fi
