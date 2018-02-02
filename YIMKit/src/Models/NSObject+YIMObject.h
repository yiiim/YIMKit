//
//  NSObject+YIMObject.h
//  YIMKit
//
//  Created by ybz on 2018/2/1.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YIMObject)


/**
 获取所有属性名称包括父类

 @return 属性名称
 */
+(NSArray<NSString*>*)yimAllPropertes;

/**
 获取所有属性名称包括父类

 @param endWithClass 到哪个父类为止
 @return 属性名称
 */
+(NSArray<NSString*>*)yimAllPropertes:(Class)endWithClass;

@end
