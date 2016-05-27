#
#  Be sure to run `pod spec lint voice.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "YAHMultiPhoto"
  s.version      = "0.0.3"
  s.summary      = "查看大图"

  s.description  = <<-DESC
                   查看大图功能，支持本地图片、相册图片、网络图片等
                   DESC

  s.homepage     = "https://github.com/yahua/YAHMutiPhoto"
  

  s.license      = "MIT"
  

  s.author             = { "yahua" => "yahua523@163.com" }

  s.platform     = :ios, "7.0"

  s.requires_arc = true

  s.source       = { :git => "https://github.com/yahua/YAHMultiPhoto.git", :tag => "#{s.version}" }

  s.source_files  = "YAHMultiPhoto/*.{h,m}"

  s.dependency 'SDWebImage'


end
