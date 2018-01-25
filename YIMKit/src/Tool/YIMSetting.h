//
//  YIMSetting.h
//  YIMKit
//
//  Created by ybz on 2018/1/25.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YIMSetting : NSObject <NSCoding>

@property(strong,nonatomic)UIColor *tintColor;

/**默认配置*/
+(instancetype)defualt;
/**设置当前配置*/
+(void)useSetting:(YIMSetting*)setting;
/**当前设置，如果没有则使用默认配置*/
+(instancetype)current;
/**使用json获取设置，json可以是数组，字典，json的NSData，json字符串*/
+(id)settingObjWithJson:(id)json;
/**使用json 字典获取设置*/
+(instancetype)settingWithJson:(NSDictionary*)json;
/**使用json 数组获取设置集合*/
+(NSArray*)arrayWithJson:(NSArray*)json;

/**使用字典初始化*/
-(instancetype)initWithJson:(NSDictionary*)json;
/**合并配置，以参数重的配置为主，覆盖self*/
-(YIMSetting*)mergeSetting:(YIMSetting*)setting;


@end
