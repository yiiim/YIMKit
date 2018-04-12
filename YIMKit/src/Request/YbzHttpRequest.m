//
//  YbzHttpRequest.m
//  Ybz.Library
//
//  Created by ybz on 2016/12/27.
//  Copyright © 2016年 ybz.com. All rights reserved.
//

#import "YbzHttpRequest.h"
#import "YbzHttpResponse.h"
#import "AFNetworking.h"
#import "YbzHttpResult.h"
#import "AFNetworking.h"

static dispatch_queue_t af_complete_queue;
static dispatch_group_t af_complete_group;

@interface YbzHttpRequestResult : YbzHttpResult{
@private
    dispatch_semaphore_t semaphore;
    dispatch_queue_t asnycQueue;
    YbzHttpResponse* _response;
}
@property(nonatomic,copy)void(^didGetResponseBlock)(YbzHttpResponse*);
@property(nonatomic,strong,readonly)YbzHttpResponse *response;
@property(nonatomic,strong)NSURLSessionTask *task;
@property(nonatomic,strong)NSString *downloadFileSavePath;
@end
@implementation YbzHttpRequestResult
@synthesize response = _response;

-(instancetype)initWithAfnManager:(AFHTTPSessionManager*)manager{
    return [self initWithAfnManager:manager identity:nil];
}
-(instancetype)initWithAfnManager:(AFHTTPSessionManager*)manager identity:(NSString*)requestIdentity{
    if (self = [super initWithRequestIdentity:requestIdentity]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            af_complete_queue = dispatch_queue_create("ybz_afn_complete_queue", DISPATCH_QUEUE_SERIAL);
            af_complete_group = dispatch_group_create();
        });
        manager.completionGroup = af_complete_group;
        manager.completionQueue = af_complete_queue;
        
        [manager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
            
        }];
        
        semaphore = dispatch_semaphore_create(0);
        asnycQueue = dispatch_queue_create("YbzHttpRequestResultAsyncQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}
-(instancetype)initWithError:(NSError *)error{
    if (self = [super init]) {
        semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

-(NSString*)requestIdentity{
    NSString* ity = [super requestIdentity];
    if (ity) {
        return ity;
    }
    return [NSString stringWithFormat:@"%ld",self.task.taskIdentifier];
}
-(void)afDataTaskUploadProgress:(NSProgress*)progress{
    if(self.requestProgress)
        self.requestProgress((progress.totalUnitCount/progress.completedUnitCount)/2);
}
-(void)afDataTaskDownloadProgress:(NSProgress*)progress{
    if(self.requestProgress)
        self.requestProgress((progress.totalUnitCount/progress.completedUnitCount)/2 + 0.5);
}
-(void)afDataTaskCompletion:(NSURLResponse *)response responseObject:(id)object error:(NSError*)error{
    [self requestCompeleteWithResponse:[[YbzHttpResponse alloc]initWithResponse:(NSHTTPURLResponse*)response responseData:object error:error]];
}
-(void)afDownloadTaskPorgress:(NSProgress*)progress{
    if(self.requestProgress)
        self.requestProgress(progress.totalUnitCount/progress.completedUnitCount);
}
-(NSURL*)afDownloadTaskDestination:(NSURL*)targetPath response:(NSURLResponse*)response{
    return [NSURL fileURLWithPath:self.downloadFileSavePath];
}
-(void)afDownloadTaskCompletion:(NSURLResponse*)response filePath:(NSURL*)path error:(NSError*)error{
    [self requestCompeleteWithResponse:[[YbzHttpResponse alloc]initWithResponse:(NSHTTPURLResponse*)response downloadFileUrl:path error:error]];
}

-(void)afUploadTaskProgress:(NSProgress*)progress{
    if(self.requestProgress)
        self.requestProgress(progress.totalUnitCount/progress.completedUnitCount);
}
-(void)afUploadTaskCompletion:(NSURLResponse *)response responseObject:(id)object error:(NSError*)error{
    [self requestCompeleteWithResponse:[[YbzHttpResponse alloc]initWithResponse:(NSHTTPURLResponse*)response responseData:object error:error]];
}
-(void)requestCompeleteWithResponse:(YbzHttpResponse*)resp{
    _response = resp;
    dispatch_semaphore_signal(semaphore);
}
-(YbzHttpResponse*)getResponse{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return self.response;
}
-(void)asyncGetResponse:(void (^)(YbzHttpResponse *))asyncBlock{
    [self asyncGetResponse:asyncBlock useQueue:dispatch_get_main_queue()];
}
-(void)asyncGetResponse:(void (^)(YbzHttpResponse *))asyncBlock useQueue:(dispatch_queue_t)queue{
    dispatch_async(asnycQueue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            asyncBlock(self.response);
        });
    });
}

@end




@interface YbzHttpRequest(){
    NSString *_path;
    NSString *_requestIdentity;
    NSURL *_rawUrl;
    NSMutableArray<NSString*>* _acceptTypes;
    dispatch_semaphore_t result_semaphore;
    NSMutableDictionary<NSString*,id>* _cookies;
    NSMutableDictionary<NSString*,NSString*>* _headers;
    NSMutableDictionary<NSString*,id>* _queryString;
    NSMutableDictionary<NSString*,id>* _form;
}


@property(nonatomic,weak)YbzHttpRequestResult *result;

@end

@implementation YbzHttpRequest

@synthesize path = _path;
@synthesize acceptTypes = _acceptTypes;
@synthesize headers = _headers;
@synthesize queryString = _queryString;
@synthesize form = _form;
@synthesize rawUrl = _rawUrl;
@synthesize requestIdentity = _requestIdentity;

-(instancetype)initWithUrl:(NSString *)url{
    return [self initWithUrl:url requestIdentity:nil];
}
-(instancetype)initWithUrl:(NSString *)url requestIdentity:(NSString *)identity{
    if (self = [super init]) {
        self.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
        _path = url;
        _requestIdentity = identity;
    }
    return self;
}
+(instancetype)CreateWithUrl:(NSString *)url{
    return [[[self class]alloc] initWithUrl:url];
}


-(NSMutableArray<NSString*>*)acceptTypes{
    if(!_acceptTypes){
        _acceptTypes = [NSMutableArray array];
        [_acceptTypes addObject:@"html/text"];
        [_acceptTypes addObject:@"application/json"];
    }
    return _acceptTypes;
}
-(NSMutableDictionary<NSString*,id>*)cookies{
    if(!_cookies)
        _cookies = [NSMutableDictionary dictionary];
    return _cookies;
}
-(NSMutableDictionary<NSString*,NSString*>*)headers{
    if(!_headers)
        _headers = [NSMutableDictionary dictionary];
    return _headers;
}
-(NSMutableDictionary<NSString*,id>*)queryString{
    if(!_queryString)
        _queryString = [NSMutableDictionary dictionary];
    return _queryString;
}
-(NSMutableDictionary<NSString*,id>*)form{
    if(!_form)
        _form = [NSMutableDictionary dictionary];
    return _form;
}

-(NSString*)methodString{
    switch (self.httpMethod) {
        case Post:
            return @"POST";
        case Get:
            return @"GET";
        case Put:
            return @"PUT";
        case Delete:
            return @"DELETE";
        default:
            return @"GET";
    }
}


-(YbzHttpResult*)send{
    NSError *error;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = self.stringEncoding;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableSet<NSString*>* set = [NSMutableSet<NSString*> setWithSet:manager.responseSerializer.acceptableContentTypes];
    [self.acceptTypes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [set addObject:obj];
    }];
    manager.responseSerializer.acceptableContentTypes = set;
    
    NSURLRequest *request = [self afRequestWithAfRequestSerializer:manager.requestSerializer error:&error];
    if (error) {
        return [[YbzHttpRequestResult alloc]initWithError:error];
    }
    
    request = [self requestByYbzHttpRequest:request];
    _rawUrl = request.URL;
    YbzHttpRequestResult *result = [[YbzHttpRequestResult alloc]initWithAfnManager:manager identity:_requestIdentity];
    
    NSURLSessionDataTask* task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [result afDataTaskCompletion:response responseObject:responseObject error:error];
    }];
    
    result.request = self;
    result.task = task;
    
    [task resume];
    return result;
}
-(YbzHttpResult*)download{
    NSError *error;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = self.stringEncoding;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableSet<NSString*>* set = [NSMutableSet<NSString*> setWithSet:manager.responseSerializer.acceptableContentTypes];
    [self.acceptTypes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [set addObject:obj];
    }];
    manager.responseSerializer.acceptableContentTypes = set;
    
    YbzHttpRequestResult *result = [[YbzHttpRequestResult alloc]initWithAfnManager:manager identity:_requestIdentity];
    result.downloadFileSavePath = self.fileDownlodaSavePath;
    
    
    NSURLRequest *request = [self afRequestWithAfRequestSerializer:manager.requestSerializer error:&error];
    if (error) {
        return [[YbzHttpRequestResult alloc]initWithError:error];
    }
    request = [self requestByYbzHttpRequest:request];
    _rawUrl = request.URL;
    
    NSURLSessionDownloadTask* task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [result afDownloadTaskDestination:targetPath response:response];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [result afDownloadTaskCompletion:response filePath:filePath error:error];
    }];
    
    result.task = task;
    result.request = self;
    
    [task resume];
    return result;
}
-(YbzHttpResult*)upload:(void (^)(id<AFMultipartFormData>))block{
    NSError *error;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.stringEncoding = self.stringEncoding;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableSet<NSString*>* set = [NSMutableSet<NSString*> setWithSet:manager.responseSerializer.acceptableContentTypes];
    [self.acceptTypes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [set addObject:obj];
    }];
    manager.responseSerializer.acceptableContentTypes = set;
    
    YbzHttpRequestResult *result = [[YbzHttpRequestResult alloc]initWithAfnManager:manager identity:_requestIdentity];
    
    NSURLRequest *request = [self afRequestWithAfRequestSerializer:manager.requestSerializer dataBlock:block error:&error];
    if (error) {
        return [[YbzHttpRequestResult alloc]initWithError:error];
    }
    request = [self requestByYbzHttpRequest:request];
    _rawUrl = request.URL;
    
    NSURLSessionUploadTask* task = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [result afUploadTaskCompletion:response responseObject:responseObject error:error];
    }];
    
    [task resume];
    
    result.task = task;
    return result;
}

-(NSURLRequest*)afRequestWithAfRequestSerializer:(AFHTTPRequestSerializer*)requestSerializer error:(NSError**)error{
    NSURL *url = [self afRequestUrlWithAfRequestSerializer:requestSerializer];
    id params = [self afRequestParamsWithAfRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:self.methodString URLString:url.absoluteString parameters:params error:error];
    return request;
}
-(NSURLRequest*)afRequestWithAfRequestSerializer:(AFHTTPRequestSerializer*)requestSerializer dataBlock:(void(^)(id<AFMultipartFormData>))dataBlock error:(NSError**)error{
    NSURL *url = [self afRequestUrlWithAfRequestSerializer:requestSerializer];
    id params = [self afRequestParamsWithAfRequestSerializer:requestSerializer];
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:self.methodString URLString:url.absoluteString parameters:params constructingBodyWithBlock:dataBlock error:error];
    request = [[self requestByYbzHttpRequest:request]mutableCopy];
    _rawUrl = url;
    return request;
}
-(id)afRequestParamsWithAfRequestSerializer:(AFHTTPRequestSerializer*)requestSerializer{
    NSDictionary *parametrs = nil;
    if (![requestSerializer.HTTPMethodsEncodingParametersInURI containsObject:self.methodString]) {
        parametrs = self.form;
    }else{
        parametrs = self.queryString;
    }
    return parametrs;
}
-(NSURL*)afRequestUrlWithAfRequestSerializer:(AFHTTPRequestSerializer*)requestSerializer{
    NSMutableString *urlString = [NSMutableString stringWithString:self.hostUrl];
    urlString = [NSMutableString stringWithString:[urlString stringByAppendingPathComponent:_path]];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}
-(NSURLRequest*)requestByYbzHttpRequest:(NSURLRequest*)urlRequest{
    NSMutableURLRequest *request = [urlRequest mutableCopy];
    [self.headers enumerateKeysAndObjectsUsingBlock:^(NSString* field, NSString* value, BOOL * __unused stop) {
        [request setValue:value forHTTPHeaderField:field];
    }];
    if (self.contentType) {
        [request setValue:self.contentType forHTTPHeaderField:@"Content-Type"];
    }
    request.cachePolicy = self.cachePolicy;
    request.timeoutInterval = self.timeout;
    return request;
}
@end

