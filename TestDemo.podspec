#
#  Be sure to run `pod spec lint TestDemo.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "TestDemo"
s.version      = "0.0.1"
s.summary      = "循环滚动播放图片"

s.description  = <<-DESC
循环滚动播放图片,自动播放,手动播放
DESC

s.homepage     = "https://github.com/DoubleYao/TestDemo"
s.license      = "MIT"
s.author       = { "DoubleYao" => "apple_doubleyao@126.com" }
s.platform     = :ios,'6.0'

s.source       = { :git => "https://github.com/DoubleYao/TestDemo", :tag => "#{s.version}" }
s.source_files = "TestDemo/Class/*.{h,m}"
s.framework    = "UIKit"
s.requires_arc = true
end
