

Pod::Spec.new do |s|

  s.name         = "JWTrace"
  s.version      = "0.1.3"
  s.summary      = "日志打印控制器."


  s.homepage     = "https://github.com/junwangInChina/JWTrace"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "wangjun" => "github_work@163.com" }
  s.platform     = :ios, "7.0"


  s.source       = { :git => "https://github.com/junwangInChina/JWTrace.git", :tag => s.version }

  s.source_files = "JWTraceDemo/JWTrace/**/*.{h,m}"
  s.requires_arc = true

  s.framework  = "UIKit"


end
