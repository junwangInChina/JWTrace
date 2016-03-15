
Pod::Spec.new do |s|
  // 名称
  s.name         = "JWTrace"
  // 版本
  s.version      = "0.0.3"
  // 描述
  s.summary      = "日志打印控制器"
  // 主页
  s.homepage     = "https://github.com/junwangInChina/JWTrace"
  // 证书申明
  #s.license      = "MIT"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  // 作者
  s.author       = { "wangjun" => "github_work@163.com" }
  // 支持版本
  s.platform     = :ios, "7.0"
  // 版本地址
  s.source       = { :git => "https://github.com/junwangInChina/JWTrace.git", :tag => "0.0.3" }
  // 库文件路径（相对于.podspec文件的路径）
  s.source_files  = "JWTraceDemo/JWTrace/**/*.{h,m}"
  // 是否支持arc
  s.requires_arc = true
end
