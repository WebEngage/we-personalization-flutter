#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint we_personalization_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'we_personalization_flutter'
  s.version          = '2.1.0'
  s.summary          = 'WebEngage Flutter Personalization iOS SDK.'
  s.description      = <<-DESC
WebEngage Flutter Personalization iOS SDK.
                       DESC
  s.homepage         = 'https://webengage.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'WebEngage' => 'mobile@webengage.com' }
  s.source           = { :path => '.' }
  s.source_files = 'we_personalization_flutter/Sources/we_personalization_flutter/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'WEPersonalization'
  s.platform = :ios, '13.0'
  s.swift_version = '5.0'
end

