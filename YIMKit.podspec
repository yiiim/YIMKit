Pod::Spec.new do |s|
  s.name         = 'YIMKit'
  s.version      = '0.2.1'
  s.summary      = 'library for ybz'
  s.homepage     = 'https://github.com/yiiim/YIMKit'
  s.license      = 'MIT'
  s.authors      = {'ybz' => 'ybz975218925@live.com'}
  s.platform     = :ios, '10.0'
  s.source       = { :git => "https://github.com/yiiim/YIMKit.git", :tag => "#{s.version}"}
  s.source_files = 'YIMKit/src/**/*.{h,m,c}'
  s.resource     = 'YIMKit/resource/*.bundle'
  s.requires_arc = true
  
  
  s.subspec 'Common' do |scom|
      scom.source_files = 'YIMKit/src/Common/**/*.{h,m,c}'
  end
  s.subspec 'Model' do |smodel|
      smodel.source_files = 'YIMKit/src/Models/**/*.{h,m,c}'
      smodel.dependency 'YIMKit/Common'
      smodel.dependency "YYKit"
  end
  s.subspec 'Tool' do |stool|
      stool.source_files = 'YIMKit/src/Tool/**/*.{h,m,c}'
      stool.dependency 'YIMKit/Common'
      stool.dependency 'YIMKit/Model'
  end
  
  s.subspec 'UI' do |sui|
      sui.source_files = 'YIMKit/src/UI/**/*.{h,m,c}'
      sui.dependency 'YIMKit/Common'
      sui.dependency 'YIMKit/Tool'
      sui.dependency "Masonry"
      sui.dependency "DZNEmptyDataSet"
      sui.dependency "YYKit"
  end
  
  s.subspec 'Network' do |srq|
      srq.source_files = 'YIMKit/src/Request/**/*.{h,m,c}'
      srq.dependency 'YIMKit/Common'
      srq.dependency 'YIMKit/Model'
      srq.dependency 'YIMKit/Tool'
      srq.dependency "AFNetworking"
  end
  
  
  s.dependency "Masonry"
  s.dependency "DZNEmptyDataSet"
  s.dependency "YYKit"
  s.dependency "AFNetworking", '~> 4.0'
  

end


