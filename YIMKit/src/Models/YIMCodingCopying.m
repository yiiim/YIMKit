//
//  YIMCoding.m
//  YIMKit
//
//  Created by ybz on 2018/1/27.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "YIMCodingCopying.h"
#import <objc/runtime.h>
#import "YIMTools.h"
#import "NSObject+YIMObject.h"
#import "YYKit.h"

@implementation YIMCodingCopying

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        NSArray<NSString*>* property_list = [[self class] yimAllPropertes];
        for (int i = 0; i < property_list.count; i++) {
            NSString *name = property_list[i];
            id value = [aDecoder decodeObjectForKey:name];
            if(value)
                [self setValue:value forKey:name];
        }
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    NSArray<NSString*>* property_list = [[self class] yimAllPropertes];
    for (int i = 0; i < property_list.count; i++) {
        NSString *name = property_list[i];
        id value = [self valueForKey:name];
        if(value){
            [aCoder encodeObject:value forKey:name];
        }
    }
}
-(instancetype)copy{
    id copy = [[[self class]alloc]init];
    NSArray<NSString*>* property_list = [[self class] yimAllPropertes];
    for (int i = 0; i < property_list.count; i++) {
        NSString *name = property_list[i];
        id value = [self valueForKey:name];
        if ([value respondsToSelector:@selector(copy)]) {
            [copy setValue:[value copy] forKey:name];
        }else{
            [copy setValue:value forKey:name];
        }
    }
    return copy;
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[[self class]alloc]init];
    NSArray<NSString*>* property_list = [[self class] yimAllPropertes];
    for (int i = 0; i < property_list.count; i++) {
        NSString *name = property_list[i];
        id value = [self valueForKey:name];
        if ([value respondsToSelector:@selector(copyWithZone:)]) {
            [copy setValue:[value copyWithZone:zone] forKey:name];
        }else{
            [copy setValue:value forKey:name];
        }
    }
    return copy;
}
@end
