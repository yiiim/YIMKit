//
//  RequestDecorator.h
//  TimeMessenger.Logic
//
//  Created by ybz on 2017/6/12.
//  Copyright © 2017年 ybz.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YbzHttpNetworking.h"

/**request装饰基类*/
@interface YbzRequestDecorator : YbzHttpRequest

/**装饰的是这个request，修改self无效果*/
@property(nonatomic,strong)YbzHttpRequest *request;

-(instancetype)initWithHttpRequest:(YbzHttpRequest*)request;

/**应用装饰到所有请求 send upload download*/
-(void)applyDecorator;
/**应用装饰到send*/
-(void)applySend;
/**应用装饰到upload*/
-(void)applyUpload;
/**应用装饰到download*/
-(void)applyDownload;

/**
 提供一个获取所有参数的方法
 @return 参数
 */
-(NSDictionary<NSString*,id>*)allParams;
/**
 提供一个设置参数的方法

 @param param 参数值
 @param key 键
 */
-(void)setParam:(id)param forKey:(NSString*)key;

@end


/**签名装饰*/
@interface SignRequestDecorator : YbzRequestDecorator
/**添加时间戳参数的请求key 如果不填则不添加时间戳参数*/
@property(nonatomic,strong)NSString *timestampParamKey;
/**添加随机数参数的请求key 如果不填则不添加随机参数*/
@property(nonatomic,strong)NSString *signaturenonceParamKey;
/**添加前面的请求key，默认“sign”*/
@property(nonatomic,strong)NSString *signParamKey;
/**签名密钥*/
@property(nonatomic,strong)NSString *signKey;

-(instancetype)initWithSignKey:(NSString*)signKey request:(YbzHttpRequest*)request;
@end
