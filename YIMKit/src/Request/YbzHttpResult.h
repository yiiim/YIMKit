//
//  YbzHttpResult.h
//  Ybz.Library
//
//  Created by ybz on 2017/1/5.
//  Copyright © 2017年 ybz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YbzHttpRequest;
@class YbzHttpResponse;

@interface YbzHttpResult : NSObject

@property(nonatomic,weak)YbzHttpRequest* request;
@property(nonatomic,strong,readonly)NSString* requestIdentity;
@property(nonatomic,copy)void(^requestProgress)(float progressPre);

-(instancetype)initWithRequestIdentity:(NSString*)identity;

-(YbzHttpResponse*)getResponse;
-(void)asyncGetResponse:(void(^)(YbzHttpResponse*))asyncBlock;
-(void)asyncGetResponse:(void (^)(YbzHttpResponse *))asyncBlock useQueue:(dispatch_queue_t)queue;
@end

