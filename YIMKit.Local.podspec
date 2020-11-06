

Pod::Spec.new do |s|
s.name         = 'YIMKit.Local'
s.version      = '0.1.9'
s.summary      = 'library for ybz'
s.homepage     = 'https://github.com/yiiim/YIMKit'
s.license      = 'MIT'
s.authors      = {'ybz' => 'ybz975218925@live.com'}
s.platform     = :ios, '8.0'
s.source       = {:path => '/Users/ybz/ybz/GitProjects/YIMKit'}
s.source_files = 'YIMKit/src/**/*.{h,m,c}'
s.resource     = 'YIMKit/resource/*.bundle'
s.requires_arc = true


s.subspec 'Common' do |scom|
    scom.source_files = 'YIMKit/src/Common/**/*.{h,m,c}'
end
s.subspec 'Models' do |smodel|
    smodel.source_files = 'YIMKit/src/Models/**/*.{h,m,c}'
    smodel.dependency 'YIMKit.Local/Common'
    smodel.dependency "YYKit"
end
s.subspec 'Tool' do |stool|
    stool.source_files = 'YIMKit/src/Tool/**/*.{h,m,c}'
    stool.dependency 'YIMKit.Local/Common'
    stool.dependency 'YIMKit.Local/Models'
end

s.subspec 'UI' do |sui|
    sui.source_files = 'YIMKit/src/UI/**/*.{h,m,c}'
    sui.dependency 'YIMKit.Local/Common'
    sui.dependency 'YIMKit.Local/Tool'
    sui.dependency "Masonry"
    sui.dependency "DZNEmptyDataSet"
    sui.dependency "YYKit"
end

s.subspec 'Request' do |srq|
    srq.source_files = 'YIMKit/src/Request/**/*.{h,m,c}'
    srq.dependency 'YIMKit.Local/Common'
    srq.dependency 'YIMKit.Local/Models'
    srq.dependency 'YIMKit.Local/Tool'
    srq.dependency "AFNetworking"
end


s.dependency "Masonry"
s.dependency "DZNEmptyDataSet"
s.dependency "YYKit"
s.dependency "AFNetworking"


end
