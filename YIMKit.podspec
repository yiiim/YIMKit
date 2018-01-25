Pod::Spec.new do |s|
s.name         = 'YIMKit'
s.version      = '0.0.1'
s.summary      = 'library for ybz'
s.homepage     = 'https://github.com/yiiim/YIMKit'
s.license      = 'MIT'
s.authors      = {'ybz' => 'ybz975218925@live.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/yiiim/YIMKit.git', :tag => s.version}
s.source_files = 'YIMKit/src/**/*.{h,m,c}','yimediter/*.{h,m}'
s.resource     = 'YIMKit/resource/*.bundle'
s.dependency   = 'Masonry', '~> 1.1.0'
s.requires_arc = true
end
