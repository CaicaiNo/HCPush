#
#  Be sure to run `pod spec lint HCPushSettingViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "HCPush"
  s.version      = "1.1.3-beta"
  s.summary      = "A simple push setting viewController,Use for present a new viewController content"
  s.description  = "A simple push setting viewController,Use for present a new viewController content,HCPushSettingViewController will contain viewController.Support two kinds of content type."
  s.homepage     = "https://github.com/CaicaiNo"
  s.license      = "MIT"
  s.author       = { "CaicaiNo" => "277715243@qq.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/CaicaiNo/HCPush.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.{h,m,mm}"
  s.public_header_files = "Classes/**/*.h"

  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

end
