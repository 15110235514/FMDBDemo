Pod::Spec.new do |s|
  s.name         = "HIWFMDB"
  s.version      = “1.1.1”
  s.ios.deployment_target = ‘8.0’
  s.osx.deployment_target = '10.9’
  s.summary      = "A convenient data storage location”
  s.homepage     = "https://github.com/IcefieldWolf/HIWFMDB"
  s.license      = "MIT"
  s.author             = { “IcefieldWolf” => “1025964887@qq.com” }
  s.social_media_url   = "http://weibo.com/exceptions"
  s.source       = { :git => "https://github.com/IcefieldWolf/HIWFMDB", :tag => s.version }
  s.source_files  = "HIWFMDB"
  s.requires_arc = true
end
 