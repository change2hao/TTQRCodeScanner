#
# Be sure to run `pod lib lint TTQRCodeScanner.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TTQRCodeScanner"
  s.version          = "1.0.1"
  s.summary          = "TTQRCodeScanner is a light component that makes scan QRCode or BarCode conveniently."
  # s.description      = <<-DESC
                       # An optional longer description of TTQRCodeScanner

                       # * Markdown format.
                       # * Don't worry about the indent, we strip it!
                       # DESC
  s.homepage         = "https://github.com/change2hao/TTQRCodeScanner"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Administrator" => "lwtiandev@gmail.com" }
  s.source           = { :git => "https://github.com/change2hao/TTQRCodeScanner.git", :tag => "1.0.1" }
  s.social_media_url = 'https://twitter.com/change2hao'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'TTQRCodeScanner' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
