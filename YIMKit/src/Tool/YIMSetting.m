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
#import "NSObject+YIMObject.h"
#import "YIMTools.h"

#define __YIMSettingCachePath__ [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,  NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"YIMSetting.obj"]
#define __YIMSettingCacheKey__ @"__YIMSettingCacheKey__"

/**用于持久化的队列*/
static dispatch_queue_t persistenceDataQueue;

@interface YIMSetting(){
    @private
    /**这个字段标记self是否来自于本地持久化的Setting*/
    bool _fromLocalData;
}
/**所有被设置过的属性值都会被储存在这个字典中，以标记这个属性不再是默认值*/
@property(nonatomic,strong)NSMutableDictionary *mergeConfigDic;
@end

@implementation YIMSetting

+(void)load{
    persistenceDataQueue = dispatch_queue_create("ybzhome.com.persistenceDataQueue", DISPATCH_QUEUE_SERIAL);
}

+(instancetype)defualt{
    return [[YIMSetting alloc]init];
}
+(instancetype)current{
    YYDiskCache *cache = [[YYDiskCache alloc]initWithPath:__YIMSettingCachePath__];
    YIMSetting *obj = (YIMSetting*)[cache objectForKey:__YIMSettingCacheKey__];
    if(!obj){
        obj = [self defualt];
        [self useSetting:obj];
    }
    obj->_fromLocalData = true;
    return obj;
}
+(void)useSetting:(YIMSetting *)setting{
    dispatch_async(persistenceDataQueue, ^{
        YYDiskCache *cache = [[YYDiskCache alloc]initWithPath:__YIMSettingCachePath__];
        [cache setObject:setting forKey:__YIMSettingCacheKey__];
    });
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
        return [self settingWithJson:jsonObj];
    }else if ([jsonObj isKindOfClass:[NSArray class]]){
        return [self arrayWithJson:jsonObj];
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
-(instancetype)init{
    if (self = [super init]) {
        [self configSelfPropertyObserver];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configSelfPropertyObserver];
    }
    return self;
}
-(instancetype)initWithJson:(NSDictionary *)json{
    self = [[self class]modelWithJSON:json];
    if ([json.allKeys containsObject:@"tintColor"] && [json[@"tintColor"] isKindOfClass:[NSString class]]) {
        self.tintColor = [UIColor colorWithHexString:json[@"tintColor"]];
    }
    return self;
}
-(NSMutableDictionary*)mergeConfigDic{
    if (!_mergeConfigDic) {
        _mergeConfigDic = [NSMutableDictionary dictionary];
    }
    return _mergeConfigDic;
}
-(YIMSetting*)mergeSetting:(YIMSetting*)setting{
    NSArray<NSString*>* propertes = [[self class] yimAllPropertes];
    for (int i = 0; i < propertes.count; i++) {
        NSString *name = propertes[i];
        if([setting.mergeConfigDic.allKeys containsObject:name]){
            id value = [setting valueForKey:name];
            [self setValue:value forKey:name];
        }
    }
    return self;
}
-(NSArray<NSString*>*)notPersistenceProperty{
    return @[@"mergeConfigDic"];
}

/**监听自身所有属性变更*/
-(void)configSelfPropertyObserver{
    NSArray<NSString*>* propertes = [[self class] yimAllPropertes];
    NSArray<NSString*>* notPersistenceProperty = [self notPersistenceProperty];
    for (NSString *property in propertes) {
        if(![notPersistenceProperty containsObject:property]){
            [self addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:NULL];
        }
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self) {
        //将变更的属性保存
        if (![self.mergeConfigDic.allKeys containsObject:keyPath]) {
            [self.mergeConfigDic setObject:@{} forKey:keyPath];
        }
        //如果self是来自current，属性变更重新持久化
        if (self->_fromLocalData) {
            [[self class]useSetting:self];
        }
    }
}
-(void)dealloc{
    NSArray<NSString*>* propertes = [[self class] yimAllPropertes];
    for (NSString *property in propertes) {
        [self removeObserver:self forKeyPath:property];
    }
}

@end
