//
//  YbzHttpResponse.h
//  Ybz.Library
//
//  Created by ybz on 2016/12/27.
//  Copyright © 2016年 ybz.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include("YbzError.h")
#import "YbzError.h"
#define HasYbzError
#endif

@interface YbzHttpResponse : NSObject

@property(nonatomic,readonly,strong)NSHTTPURLResponse *response;
@property(nonatomic,readonly,strong)NSData *responseData;
@property(nonatomic,readonly,strong)NSURL *downloadFileUrl;
@property(nonatomic,readonly,strong)NSError *error;
@property(nonatomic,readonly,assign)BOOL isSuccess;

#ifdef HasYbzError
@property(nonatomic,strong)YbzError* ybzError;
#endif



-(instancetype)initWithResponse:(NSHTTPURLResponse*)response responseData:(NSData*)data error:(NSError*)e;
-(instancetype)initWithResponse:(NSHTTPURLResponse *)response downloadFileUrl:(NSURL*)url error:(NSError*)e;

-(NSString*)string;
-(NSString*)stringUseEncoding:(NSStringEncoding)encoding;
-(id)jsonObject:(NSJSONReadingOptions)options error:(NSError**)error;
-(id)objectUseJsonWithYYModelClass:(Class)cls jsonOptions:(NSJSONReadingOptions)options error:(NSError**)error;

@end
