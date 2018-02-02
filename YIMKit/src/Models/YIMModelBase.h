//
//  ModelBase.h
//  YIMKit
//
//  Created by ybz on 2018/1/26.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YIMCodingCopying.h"

@interface YIMModelBase : YIMCodingCopying

@property(nonatomic,strong)NSMutableDictionary *otherValues;


-(instancetype)initWithJson:(id)json;
-(instancetype)initWithJson:(id)json requestIdentity:(const NSString*)identity;
+(NSArray*)arrayWithJson:(id)json;
+(NSArray*)arrayWithJson:(id)json requestIdentity:(const NSString*)identity;




/**
 服务端的数据map到类的数据
 格式：
 {
 @"server key":@[@"class property1",@"class property2"]
 }
 */
-(NSDictionary<NSString*,NSArray<NSString*>*>*)mapJsonKeyValues;
/**
 服务端的数据map到类的数据
 格式：
 {
 @"server key":@"class property1"
 }
 */
-(NSDictionary<NSString*,NSString*>*)mapJsonKeyValue;


@end
