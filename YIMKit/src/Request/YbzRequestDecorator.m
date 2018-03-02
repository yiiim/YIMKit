//
//  RequestDecorator.m
//  TimeMessenger.Logic
//
//  Created by ybz on 2017/6/12.
//  Copyright © 2017年 ybz.com. All rights reserved.
//

#import "YbzRequestDecorator.h"
#include <CommonCrypto/CommonCrypto.h>
#import "AFNetworking.h"
#import "YYKit/YYKit.h"

@interface YbzRequestDecorator(){
    @private
    YbzHttpRequest *_request;
}
@end

@implementation YbzRequestDecorator

@synthesize request = _request;

-(instancetype)initWithHttpRequest:(YbzHttpRequest *)request{
    if (self = [super init]) {
        _request = request;
    }
    return self;
}
-(YbzHttpResult*)send{
    [self applyDecorator];
    [self applySend];
    return [_request send];
}
-(YbzHttpResult*)download{
    [self applyDecorator];
    [self applyDownload];
    return [_request send];
}
-(YbzHttpResult*)upload:(void (^)(id<AFMultipartFormData>))block{
    [self applyDecorator];
    [self applyUpload];
    return [_request upload:block];
}
-(void)applyDecorator{
    
}
-(void)applySend{
    
}
-(void)applyUpload{
    
}
-(void)applyDownload{
    
}
-(NSDictionary<NSString*,id>*)allParams{
    NSMutableDictionary<NSString*,id>* params = [NSMutableDictionary dictionary];
    [self.request.queryString enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [params setObject:obj forKey:key];
    }];
    [self.request.form enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [params setObject:obj forKey:key];
    }];
    return params;
}
-(void)setParam:(id)param forKey:(NSString *)key{
    if ([self.request.HTTPMethodsEncodingParametersInURI containsObject: self.request.methodString]) {
        [self.request.queryString setObject:param forKey:key];
    }else{
        [self.request.form setObject:param forKey:key];
    }
}

@end

@interface SignRequestDecorator()
@property(nonatomic,strong)NSString *signSecretKey;
@end

@implementation SignRequestDecorator

-(instancetype)init{
    if (self = [super init]) {
        self.signSecretKey = @"yy";
        self.signParamKey = @"sign";
    }
    return self;
}
-(instancetype)initWithHttpRequest:(YbzHttpRequest *)request{
    if (self = [super initWithHttpRequest:request]) {
        self.signSecretKey = @"yy";
        self.signParamKey = @"sign";
    }
    return self;
}
-(instancetype)initWithSignKey:(NSString *)signKey request:(YbzHttpRequest *)request{
    if (self = [super initWithHttpRequest:request]) {
        self.signSecretKey = signKey;
        self.signParamKey = @"sign";
    }
    return self;
}

-(void)applyDecorator{
    [super applyDecorator];
    [self sign];
}

//添加签名
-(void)sign{
    //添加时间戳参数
    if(self.timestampParamKey)
        [self setParam:[NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]] forKey:self.timestampParamKey];
    //添加随机数参数
    if(self.signaturenonceParamKey)
        [self setParam:[NSString stringWithFormat:@"%d",arc4random()] forKey:self.signaturenonceParamKey];
    
    NSString *method = self.request.methodString;
    NSDictionary<NSString*,id> *params = [self allParams];
    //参数按键排序
    NSArray<NSString*>* sortParamsKeys = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    //拼接参数
    NSMutableString *paramString = [NSMutableString string];
    for (NSInteger i = 0; i < sortParamsKeys.count; i++) {
        [paramString appendFormat:@"%@=%@",sortParamsKeys[i],params[sortParamsKeys[i]]];
        if(i != sortParamsKeys.count - 1){
            [paramString appendString:@"&"];
        }
    }
    NSString *url = self.request.path;
    
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@/?";
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    NSMutableCharacterSet *characterSet = [[NSCharacterSet URLQueryAllowedCharacterSet]mutableCopy];
    [characterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    //把拼接的参数url编码
    paramString = [NSMutableString stringWithString:[paramString stringByAddingPercentEncodingWithAllowedCharacters:characterSet]];
    //把地址url编码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    //签名字符串由method、url、参数用&拼接
    NSString *signString = [NSString stringWithFormat:@"%@&%@&%@",method,url,paramString];
    //hmacsha1加密
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    const char *cKey = [self.signSecretKey cStringUsingEncoding:NSUTF8StringEncoding];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), [signString dataUsingEncoding:NSUTF8StringEncoding].bytes, signString.length, result);
    NSString *sign = [[NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH]base64EncodedString];
    
    //把签名添加值参数
    [self setParam:sign forKey:self.signParamKey];
}

@end

























