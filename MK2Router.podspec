Pod::Spec.new do |s|
  s.name         = "MK2Router"
  s.version      = "2.4.0"
  s.summary      = "Routing utility for UIViewController"
  s.description  = <<-DESC
    MK2Router is a routing utility for UIViewController using Swift.
  DESC
  s.homepage     = "https://github.com/imk2o/MK2Router"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author             = { "Yuichi Kobayashi" => "imk2o@icloud.com" }
  s.swift_version = "5.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/imk2o/MK2Router.git", :tag => "#{s.version}" }
  s.source_files  = "MK2Router-iOS/*.swift"
  s.frameworks  = "Foundation", "UIKit"
end
