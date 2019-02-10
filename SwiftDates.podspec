#
# Be sure to run `pod lib lint MyLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftDates'
  s.version          = '1.0.0'
  s.summary          = 'Practical real-world dates: timey-wimey date-y things, Swift successor to old NSDate repo'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Practical real-world dates: timey-wimey date-y things, Swift successor to old NSDate repo
                       DESC

  s.homepage         = 'https://github.com/erica/SwiftDates'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Erica Sadun' => 'erica@ericasadun.com' }
  s.source           = { :git => 'https://github.com/erica/SwiftDates.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '5.0'

  s.source_files = 'Sources/**/*'

end
