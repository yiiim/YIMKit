//
//  ModelBase.m
//  YIMKit
//
//  Created by ybz on 2018/1/26.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "ModelBase.h"
#import "YYKit/YYKit.h"
#import <objc/runtime.h>

@interface ModelBase()

@end

@implementation ModelBase

-(instancetype)initWithJson:(id)json requestIdentity:(NSString *)identity{
    self = [[self class]modelWithJSON:json];
    _otherValues = [NSMutableDictionary dictionary];
    if(self && [json isKindOfClass:[NSDictionary class]]){
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        NSMutableArray *mArray = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            const char *cName = property_getName(property);
            NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
            [mArray addObject:name];
        }
        NSDictionary *jsonDic = json;
        NSArray *otherKeyArray = [jsonDic.allKeys filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT SELF IN %@",mArray]];
        for (NSString *key in otherKeyArray) {
            NSDictionary<NSString*,NSArray<NSString*>*>* mapKeys = [self mergeMaps];
            if ([mapKeys.allKeys containsObject:key]) {
                for (NSString* propertie in mapKeys[key]) {
                    if([mArray containsObject:propertie])
                        [self setValue:jsonDic[key] forKey:propertie];
                }
            }
            [self.otherValues setObject:jsonDic[key] forKey:key];
        }
    }
    return self;
}
-(instancetype)initWithJson:(id)json{
    return [self initWithJson:json requestIdentity:nil];
}
+(NSArray*)arrayWithJson:(id)json requestIdentity:(NSString *)identity{
    if ([json isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray array];
        for (id data in json) {
            [array addObject:[[self alloc]initWithJson:data requestIdentity:identity]];
        }
        return array;
    }else{
        return nil;
    }
}
+(NSArray*)arrayWithJson:(id)json{
    return [self arrayWithJson:json requestIdentity:nil];
}
-(NSDictionary<NSString*,NSArray<NSString*>*>*)mapJsonKeyValues{
    return @{};
}
-(NSDictionary<NSString*,NSString*>*)mapJsonKeyValue{
    return @{};
}
-(NSDictionary<NSString*,NSArray<NSString*>*>*)mergeMaps{
    NSMutableDictionary<NSString*,NSArray<NSString*>*>* mapKeys = [[self mapJsonKeyValues]mutableCopy];
    NSDictionary<NSString*,NSString*>* mapKey = [self mapJsonKeyValue];
    for (NSString* key in mapKey) {
        NSString *vaule = mapKey[key];
        if ([mapKeys.allKeys containsObject:key]) {
            NSMutableArray<NSString*>* array = [NSMutableArray arrayWithArray:mapKeys[key]];
            if (![array containsObject:vaule]) {
                [array addObject:vaule];
                [mapKeys setObject:array forKey:key];
            }
        }else{
            [mapKeys setObject:@[vaule] forKey:key];
        }
    }
    return mapKeys;
}
@end
