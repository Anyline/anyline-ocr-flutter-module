#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint anyline_plugin.podspec' to validate before publishing.
#

# Single source of truth for the bundled Anyline iOS SDK. The checksum is the
# SHA-256 of the xcframework archive, and matches the one published in the SDK's
# Package.swift. prepare_release.sh bumps both lines together — keep adjacent.
anyline_sdk_version  = '56.3.0'
anyline_sdk_checksum = 'fd2ad2847801619799c99267f02f4657beab64dc217e56258a0e5038f1ddbd84'

Pod::Spec.new do |s|
  s.name             = 'anyline_plugin'
  s.version          = '56.3.0'
  s.summary          = 'Anyline SDK'
  s.description      = <<-DESC
Anyline OCR Module
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Anyline GmbH' => 'capture-team@anyline.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  # The Anyline iOS SDK is vendored as a prebuilt xcframework fetched at
  # `pod install` instead of resolved via CocoaPods Trunk, which goes
  # read-only 2026-12-02. See fetch_anyline_sdk.sh for the download, checksum
  # check and caching. Invoked via `sh` so a dropped exec bit during pub
  # packaging is harmless.
  s.vendored_frameworks = 'Anyline.xcframework'
  s.preserve_paths      = 'fetch_anyline_sdk.sh'
  s.prepare_command     = "sh fetch_anyline_sdk.sh #{anyline_sdk_version} #{anyline_sdk_checksum}"

  s.static_framework = true
  s.platform = :ios, '12.0'
  s.ios.deployment_target = '12.0'

  # The vendored Anyline.xcframework ships no arm64 simulator slice
  # (ios-arm64 device + ios-x86_64-simulator only), so exclude arm64 for the
  # simulator SDK. On Apple Silicon, run on device or use Rosetta.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
