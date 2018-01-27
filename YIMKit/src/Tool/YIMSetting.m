//
//  YIMSetting.m
//  YIMKit
//
//  Created by ybz on 2018/1/25.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "YIMSetting.h"
#import "YYCache.h"
#import "NSObject+YYModel.h"
#import "YYKit.h"

#define __YIMSettingCachePath__ [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,  NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"YIMSetting.obj"]
#define __YIMSettingCacheKey__ @"__YIMSettingCacheKey__"

@implementation YIMSetting

static YIMSetting* _setting;
+(instancetype)defualt{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _setting = [[YIMSetting alloc]init];
    });
    return _setting;
}
+(instancetype)current{
    YYDiskCache *cache = [[YYDiskCache alloc]initWithPath:__YIMSettingCachePath__];
    id obj = [cache objectForKey:__YIMSettingCacheKey__];
    if(obj){
        return obj;
    }else{
        return [self defualt];
    }
}
+(void)useSetting:(YIMSetting *)setting{
    YYDiskCache *cache = [[YYDiskCache alloc]initWithPath:__YIMSettingCachePath__];
    [cache setObject:setting forKey:__YIMSettingCacheKey__];
}
+(id)settingObjWithJson:(id)json{
    id jsonObj = json;
    if([json isKindOfClass:[NSData class]]){
        jsonObj = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
    }else if ([json isKindOfClass:[NSString class]]){
        NSString *jsonString = json;
        jsonObj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }
    if ([jsonObj isKindOfClass:[NSDictionary class]]) {
        return [self settingWithJson:json];
    }else if ([jsonObj isKindOfClass:[NSArray class]]){
        return [self arrayWithJson:json];
    }else{
        return nil;
    }
}
+(NSArray*)arrayWithJson:(NSArray *)json{
    NSMutableArray* array = [NSMutableArray array];
    for (id obj in json) {
        if([obj isKindOfClass:[self class]]){
            [array addObject:obj];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            [array addObject:[[self alloc]initWithJson:obj]];
        }
    }
    return array;
}
+(instancetype)settingWithJson:(NSDictionary *)json{
    return [[self alloc]initWithJson:json];
}

-(instancetype)initWithJson:(NSDictionary *)json{
    self = [[self class]modelWithJSON:json];
    if ([json.allKeys containsObject:@"tintColor"] && [json[@"tintColor"] isKindOfClass:[NSString class]]) {
        self.tintColor = [UIColor colorWithHexString:json[@"tintColor"]];
    }
    return self;
}

-(YIMSetting*)mergeSetting:(YIMSetting*)setting{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        id value = [setting valueForKey:name];
        if(value){
            [self setValue:value forKey:name];
        }
    }
    return self;
}
@end
