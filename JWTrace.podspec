
Pod::Spec.new do |s|

  s.name         = "JWTrace"
  s.version      = "0.0.2"
  s.summary      = "A short description of JWTrace."
  s.homepage     = "https://github.com/junwangInChina/JWTrace"
  s.license      = "MIT"
  s.author       = { "wangjun" => "github_work@163.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/junwangInChina/JWTrace.git", :tag => "0.0.2" }

  s.source_files  = "JWTraceDemo/JWTrace/**/*.{h,m}"

  s.requires_arc = true

end
