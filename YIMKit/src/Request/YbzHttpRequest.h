//
//  YbzHttpRequest.h
//  Ybz.Library
//
//  Created by ybz on 2016/12/27.
//  Copyright © 2016年 ybz.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class YbzHttpResponse;
@class YbzHttpResult;

typedef enum YbzHttpRequestMethod{
    Post,
    Get,
    Put,
    Delete
}YbzHttpRequestMethod;

typedef enum YbzHttpRequestStatus{
    Ready,
    Requesting, 
    Complete,
    Suspend,
    Cancel
}YbzHttpRequestStatus;

typedef enum YbzHttpRequestSessionType{
    Data,
    Upload,
    Download
}YbzHttpRequestSessionType;

typedef NSData*(^YbzHttpRequestHttpBodyCreateBlock)(void);




@interface YbzHttpRequest : NSObject

/**客户端接受的Accept类型*/
@property(nonatomic,strong,readonly)NSMutableArray<NSString*>* acceptTypes;
/**请求的header*/
@property(nonatomic,strong,readonly)NSMutableDictionary<NSString*,NSString*>* headers;
/**内容类型*/
@property(nonatomic,strong)NSString *contentType;
/**请求地址栏参数*/
@property(nonatomic,strong,readonly)NSMutableDictionary<NSString*,id>* queryString;
/**请求form表单数据*/
@property(nonatomic,strong,readonly)NSMutableDictionary<NSString*,id>* form;
/**请求的原始url*/
@property(nonatomic,strong,readonly)NSURL *rawUrl;
/**获取请求的虚拟路径*/
@property(nonatomic,strong,readonly)NSString *path;
/**请求的超时时间*/
@property(nonatomic,assign)NSTimeInterval timeout;
/**请求的类型*/
@property(nonatomic,assign)YbzHttpRequestMethod httpMethod;
/**请求类型String （@“Get”，@“Post”。。。）*/
@property(nonatomic,strong,readonly)NSString *methodString;
/**请求的主机地址*/
@property(nonatomic,copy)NSString *hostUrl;
/**缓存策略*/
@property NSURLRequestCachePolicy cachePolicy;
/**字符编码 默认utf8*/
@property (nonatomic, assign) NSStringEncoding stringEncoding;
/**下载文件的保存地址*/
@property (nonatomic, strong) NSString *fileDownlodaSavePath;

@property (nonatomic, strong) NSSet <NSString *> *HTTPMethodsEncodingParametersInURI;

@property (nonatomic, strong, readonly) const NSString* requestIdentity;


+(instancetype)CreateWithUrl:(NSString*)url;
-(instancetype)initWithUrl:(NSString*)url;
-(instancetype)initWithUrl:(NSString *)url requestIdentity:(NSString*)identity;

-(YbzHttpResult*)send;
-(YbzHttpResult*)upload:(void(^)(id <AFMultipartFormData> formData))block;
-(YbzHttpResult*)download;



@end













