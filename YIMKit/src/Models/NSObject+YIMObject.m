//
//  NSObject+YIMObject.m
//  YIMKit
//
//  Created by ybz on 2018/2/1.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "NSObject+YIMObject.h"
#import <objc/runtime.h>
#import "YYKit.h"

@implementation NSObject (YIMObject)



+(NSArray<NSString*>*)yimAllPropertes{
    return [self yimAllPropertes:[NSObject class]];
}
+(NSArray<NSString*>*)yimAllPropertes:(Class)endWithClass{
    NSMutableArray<NSString*>* property_list = [NSMutableArray array];
    YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:[self class]];
    while (![classInfo.name isEqualToString:NSStringFromClass(endWithClass)] && classInfo) {
        for (NSString* obj in classInfo.propertyInfos) {
            [property_list addObject:obj];
        }
        classInfo = [YYClassInfo classInfoWithClass:classInfo.superCls];
    }
    return property_list;
}

@end
