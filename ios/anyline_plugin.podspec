#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint anyline_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'anyline_plugin'
  s.version          = '54.8.0'
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
  s.dependency 'Anyline', '54.8.0'
  s.static_framework = true
  s.platform = :ios, '12.0'
  s.ios.deployment_target = '12.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
