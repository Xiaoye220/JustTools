#
# Be sure to run `pod lib lint JustTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JustTools'
  s.version          = '1.0.0'
  s.summary          = 'A short description of JustTools.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yezengfeng/JustTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yezengfeng' => '576934532@qq.com' }
  s.source           = { :git => 'https://github.com/yezengfeng/JustTools.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  
  s.subspec 'UIKit' do |sp|
    sp.source_files = 'JustTools/Classes/UIKit/**/*'
  end

  s.subspec 'Foundation' do |sp|
    sp.source_files = 'JustTools/Classes/Foundation/*'
  end

  s.subspec 'Utils' do |sp|
    sp.source_files = 'JustTools/Classes/Utils/*'
  end
end
