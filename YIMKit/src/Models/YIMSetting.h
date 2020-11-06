//
//  YIMSetting.h
//  YIMKit
//
//  Created by ybz on 2018/1/25.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YIMCodingCopying.h"
#import <UIKit/UIKit.h>

@interface YIMSetting : YIMCodingCopying

@property(strong,nonatomic)UIColor *tintColor;

/**默认配置*/
+(instancetype)defualt;
/**
 将配置持久化，注意，着不是实时的。将会在子线程持久化
 */
+(void)useSetting:(YIMSetting*)setting;
/**
 获取当前持久化的设置，如果从本地获取不到持久化的配置，将获取默认配置，并将默认配置持久化
 设置这个方法返回的示例的属性都将被持久化
 */
+(instancetype)current;
/**使用json获取设置，json可以是数组，字典，json的NSData，json字符串*/
+(id)settingObjWithJson:(id)json;
/**使用json 字典获取设置*/
+(instancetype)settingWithJson:(NSDictionary*)json;
/**使用json 数组获取设置集合*/
+(NSArray*)arrayWithJson:(NSArray*)json;

/**使用字典初始化*/
-(instancetype)initWithJson:(NSDictionary*)json;
/**
 合并配置，以参数中的配置为主，覆盖self，参数中的配置实例如果属性从未被赋值，则不会合并至self
 */
-(YIMSetting*)mergeSetting:(YIMSetting*)setting;


/**不需要持久化的属性列表*/
-(NSArray<NSString*>*)notPersistenceProperty;


@end
