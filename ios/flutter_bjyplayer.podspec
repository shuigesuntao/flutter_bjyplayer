#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_bjyplayer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_bjyplayer'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.frameworks       = ['CoreGraphics', 'Foundation', 'CoreServices', 'Photos', 'UIKit', 'CoreTelephony', 'CoreMedia', 'AVFoundation', 'AVKit', 'MediaPlayer']
  s.platform = :ios, '9.0'

  s.default_subspecs = ['static.source']

  s.subspec 'static.source' do |ss|
    ss.source_files = 'BJVideoPlayerUI/Classes/**/*'
    ss.resource_bundles = {
     'BJVideoPlayerUI' => ['BJVideoPlayerUI/Assets/*.png']
    }
    end

  s.dependency 'BaijiaYun/BJVideoPlayerCore', '~> 2.11.8'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES",
  'DEFINES_MODULE' => 'YES',
  'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.static_framework = true
end
