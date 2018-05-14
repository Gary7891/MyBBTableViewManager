Pod::Spec.new do |s|
  s.name         = "MyBBTableViewManager"
  s.version      = "0.1.2"
  s.summary      = "ASPkit列表管理器"
  s.homepage     = "https://git.tticar.com/pods/MyBBTableViewManager"
  s.license      = "Copyright (C) 2016 Gary, Inc.  All rights reserved."
  s.author             = { "Gary" => "zguanyu@163.com" }
  s.social_media_url   = "http://www.cupinn.com"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://git.tticar.com/pods/MyBBTableViewManager.git", :tag => '0.1.2'}
  s.source_files  = "MyBBTableViewManager/MyBBTableViewManager/**/*.{h,m,c}"
  s.requires_arc = true
  s.dependency 'pop'
  s.dependency 'Texture'
  s.dependency 'BBNetwork'
end
