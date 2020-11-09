#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint xi_ma_la_ya_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'xi_ma_la_ya_plugin'
  s.version          = '0.0.2'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = [
    'XiMaLaYaSDK/include/**/*.{h}', 
    'Classes/**/*'
  ]
  s.public_header_files = [
    'XiMaLaYaSDK/include/**/*.{h}',
    'Classes/**/*.h'
  ]
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.frameworks = [
    'SystemConfiguration', 
    'CoreTelephony'
  ]
  s.libraries = "z"
  s.vendored_libraries = [
    'XiMaLaYaSDK/*.{a}'
  ]
  s.resource = 'XiMaLaYaSDK/include/Resource/XMResource.bundle'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64', 'OTHER_LDFLAGS' => '-ObjC' }
  s.swift_version = '5.3'
end
