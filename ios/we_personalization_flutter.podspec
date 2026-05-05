#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_personalization_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'we_personalization_flutter'
  s.version          = '1.1.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'we_personalization_flutter/Sources/we_personalization_flutter/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'WEPersonalization'
  s.platform = :ios, '13.0'
  s.swift_version = '5.0'
end
