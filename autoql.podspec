#
# Be sure to run `pod lib lint chata.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'autoql'
  s.version          = '1.0.3'
  s.summary          = 'You can create a chat connected with your data.'
  s.swift_version    = '4.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'With this Widget You can create a chat connected with your database.'
  <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/chatatechnologies/ios-autoql.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chata' => 'vicente@rinro.com.mx' }
  s.source           = { :git => 'https://github.com/chatatechnologies/ios-autoql.git', :tag => "1.0.3" }
  #s.source           = { :git => 'https://github.com/chatatechnologies/ios-autoql', :tag => s.version.to_s }
  
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  #s.source_files = 'chata/Classes/**/*'
  s.source_files = 'Classes/**/*'
  s.resources = 'Assets/*.{png,storyboard,gif,json}'

  s.resource_bundles = {
    'autoql' => ['Assets/*.{png,gif,json}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
