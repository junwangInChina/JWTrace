
Pod::Spec.new do |s|

  s.name         = "JWTrace"
  s.version      = "0.0.2"
  s.summary      = "A short description of JWTrace."

  s.homepage     = "https://github.com/junwangInChina/JWTrace"

  s.license      = "MIT"

  s.author             = { "junwangInChina" => "https://github.com/junwangInChina" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/junwangInChina/JWTrace.git", :tag => "0.0.2" }

  s.source_files  = "JWTraceDemo/JWTrace/**/*.{h,m}"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
