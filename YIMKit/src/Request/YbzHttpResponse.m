//
//  YbzHttpResponse.m
//  Ybz.Library
//
//  Created by ybz on 2016/12/27.
//  Copyright © 2016年 ybz.com. All rights reserved.
//

#import "YbzHttpResponse.h"
#import "NSObject+YYModel.h"

#define ResponseStatusOK 200
#define ResponseStatusBadRequest 400
#define ResponseStatusUnauthorized 401
#define ResponseStatusForbidden 403
#define ResponseStatusNotFound 404
#define ResponseStatusMethodNotAllowed 405
#define ResponseStatusNotAcceptable 406
#define ResponseStatusRequestTimeout 408
#define ResponseStatusInternalServerError 500
#define ResponseStatusNotImplemented 501
#define ResponseStatusBadGateway 502
#define ResponseStatusServiceUnavailable 503
#define ResponseStatusHTTPVersionNotSupported 505



@implementation YbzHttpResponse
@synthesize response;
@synthesize responseData;
@synthesize downloadFileUrl;
@synthesize error;



#ifdef HasYbzError
@synthesize ybzError;
-(instancetype)initWithResponse:(NSHTTPURLResponse *)resp responseData:(NSData *)data error:(NSError *)e{
    if (self = [super init]) {
        responseData = data;
        response = resp;
        self.ybzError = [[self class]createYbzErrorFromError:e response:response];
        error = e;
    }
    return self;
}
-(instancetype)initWithResponse:(NSHTTPURLResponse *)resp downloadFileUrl:(NSURL *)url error:(NSError *)e{
    if (self = [super init]) {
        response = resp;
        downloadFileUrl = url;
        self.ybzError = [[self class]createYbzErrorFromError:e response:response];
        error = e;
    }
    return self;
}
+(YbzError*)createYbzErrorFromError:(NSError*)error response:(NSHTTPURLResponse*)resp{
    if (resp.statusCode == ResponseStatusOK && !error) {
        return nil;
    }
    YbzError *ybzError = [[YbzError alloc]init];
    ybzError.sysError = error;
    if (!resp) {
        if (error) {
            ybzError.showUserMessage = @"request error";
            ybzError.insideMessage = error.description;
        }else{
            ybzError.showUserMessage = @"request error";
            ybzError.insideMessage = @"not get response，error before request，this is a bug";
        }
    }else if (resp.statusCode == ResponseStatusOK) {
        ybzError.showUserMessage = @"request error";
        ybzError.insideMessage = error.description;
    }else if(resp.statusCode == ResponseStatusRequestTimeout){
        ybzError.showUserMessage = @"request time out";
        ybzError.insideMessage = @"request time out";
    }else if (resp.statusCode < 500) {
        ybzError.showUserMessage = @"request error";
        ybzError.insideMessage = [NSString stringWithFormat:@"request error，the response status code is %ld",resp.statusCode];
    }else if (resp.statusCode >= 500){
        ybzError.showUserMessage = @"server busy";
        ybzError.insideMessage = [NSString stringWithFormat:@"server error，the response status code is %ld",resp.statusCode];
    }else{
        //more error info， wait to do
    }
    return ybzError;
}
#else
-(instancetype)initWithResponse:(NSHTTPURLResponse *)resp responseData:(NSData *)data error:(NSError *)e{
    if (self = [super init]) {
        responseData = data;
        response = resp;
        error = e;
    }
    return self;
}
-(instancetype)initWithResponse:(NSHTTPURLResponse *)resp downloadFileUrl:(NSURL *)url error:(NSError *)e{
    if (self = [super init]) {
        response = resp;
        downloadFileUrl = url;
        error = e;
    }
    return self;
}
#endif

-(BOOL)isSuccess{
    return self.response && self.response.statusCode == ResponseStatusOK && !self.error;
}
-(NSString*)string{
    return [self stringUseEncoding:NSUTF8StringEncoding];
}
-(NSString*)stringUseEncoding:(NSStringEncoding)encoding{
    return [[NSString alloc]initWithData:self.responseData encoding:encoding];
}
-(id)jsonObject:(NSJSONReadingOptions)options error:(NSError *__autoreleasing *)e{
    return [NSJSONSerialization JSONObjectWithData:self.responseData options:options error:e];
}
-(id)objectUseJsonWithYYModelClass:(Class)cls jsonOptions:(NSJSONReadingOptions)options error:(NSError *__autoreleasing *)e{
    id jsonObject = [self jsonObject:options error:e];
    if (e != NULL && jsonObject) {
        
        NSAssert(jsonObject, @"not get json object");
        
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            id modelObject = [cls modelWithJSON:jsonObject];
            return modelObject;
        }else if ([jsonObject isKindOfClass:[NSArray class]]){
            id arrayModelObject = [NSArray modelArrayWithClass:cls json:jsonObject];
            return arrayModelObject;
        }else{
            *e = [[NSError alloc]initWithDomain:@"json object not understand" code:0 userInfo:@{}];
        }
    }
    return nil;
}

@end
