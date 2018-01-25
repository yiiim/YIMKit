Pod::Spec.new do |s|
  s.name         = 'YIMKit'
  s.version      = '0.0.5'
  s.summary      = 'library for ybz'
  s.homepage     = 'https://github.com/yiiim/YIMKit'
  s.license      = 'MIT'
  s.authors      = {'ybz' => 'ybz975218925@live.com'}
  s.platform     = :ios, '8.0'
  s.source       = {:git => 'https://github.com/yiiim/YIMKit.git', :tag => s.version}
  s.source_files = 'YIMKit/src/**/*.{h,m,c}'
  s.resource     = 'YIMKit/resource/*.bundle'
  s.requires_arc = true
  s.dependency "Masonry"
  s.dependency "DZNEmptyDataSet"
  s.dependency "YYKit"  

end
