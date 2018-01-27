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

@implementation YIMCodingCopying

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            const char *cName = property_getName(property);
            NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
            id value = [aDecoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:name];
        if(value){
            [aCoder encodeObject:value forKey:name];
        }
    }
}
-(instancetype)copy{
    id copy = [[[self class]alloc]init];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
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
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
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
