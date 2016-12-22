Pod::Spec.new do |s|
  s.name             = "AMTestHelpers"
  s.version          = "1.1.0"
  s.summary          = "A collection of extensions and methods that make unit testing difficult behaviors easy."
  s.description      = <<-DESC
    `AMTestHelpers` helps make unit testing behaviors that are difficult to test, such as presenting view controllers, simple and easy through method swizzling.
                       DESC

  s.homepage         = "https://github.com/AnthonyMDev/AMTestHelpers"
  s.license          = 'MIT'
  s.author           = { "Anthony Miller" => "AnthonyMDev@gmail.com.com" }
  s.source           = { :git => "https://github.com/AnthonyMDev/AMTestHelpers.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/AnthonyMDev'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'UIKit'

  s.dependency "JRSwizzle", "~> 1.0"
end
