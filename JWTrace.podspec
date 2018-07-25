
Pod::Spec.new do |s|

  s.name         = "JWTrace"
  s.version      = "0.0.6"
  s.summary      = "日志打印控制器"

  #主页
  s.homepage     = "https://github.com/junwangInChina/JWTrace"
  #证书申明
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  #作者
  s.author       = { "wangjun" => "github_work@163.com" }
  #支持版本
  s.platform     = :ios, "7.0"
  #项目地址，版本
  s.source       = { :git => "https://github.com/junwangInChina/JWTrace.git", :tag => "0.0.6" }

  #库文件路径
  s.source_files  = "JWTraceDemo/JWTrace/**/*.{h,m}"
  #是否ARC
  s.requires_arc = true

end
