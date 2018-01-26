//
//  YbzHttpResult.m
//  Ybz.Library
//
//  Created by ybz on 2017/1/5.
//  Copyright © 2017年 ybz.com. All rights reserved.
//

#import "YbzHttpResult.h"

@interface YbzHttpResult()
@property(nonatomic,strong,readwrite)NSString* requestIdentity;
@end

@implementation YbzHttpResult

-(instancetype)initWithRequestIdentity:(NSString *)identity{
    if (self = [super init]) {
        self.requestIdentity = identity;
    }
    return self;
}
-(YbzHttpResponse*)getResponse{
    return nil;
}
-(void)asyncGetResponse:(void(^)(YbzHttpResponse*))asyncBlock{
    
}
-(void)asyncGetResponse:(void (^)(YbzHttpResponse *))asyncBlock useQueue:(dispatch_queue_t)queue{
    
}

@end
