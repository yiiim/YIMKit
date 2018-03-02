//
//  YIMLocationManager.h
//  YIMKit
//
//  Created by ybz on 2018/3/2.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YIMCodingCopying.h"

typedef enum YIMLocationStatus{
    //用户没有打开定位服务
    YIMLocationStatusDisable,
    //没有获得用户授权使用定位服务,可能用户没有自己禁止访问授权
    YIMLocationStatusRestricted,
    //用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态
    YIMLocationStatusDenied,
    //应用获得授权可以一直使用定位服务，即使应用不在使用状态
    YIMLocationStatusAlways,
    //使用此应用过程中允许访问定位服务
    YIMLocationStatusWhenInUse
}YIMLocationStatus;

//定位成功时发送通知
#define kYIMLocationGetLocationNotifationName @"YIMLocationGetLocationNotifationName"
//定位失败时发送通知
#define kYIMLocationGetLocationErrorNotifationName @"YIMLocationGetLocationErrorNotifationName"

@interface YIMLocation : YIMCodingCopying

//经度
@property(nonatomic,assign)double longitude;
//纬度
@property(nonatomic,assign)double latitude;
//详细地址
@property(nonatomic,copy)NSString *detail;
//国家
@property(nonatomic,copy)NSString *country;
//省份
@property(nonatomic,copy)NSString *province;
//城市
@property(nonatomic,copy)NSString *city;
@end

@interface YIMLocationManager : NSObject

/**上一次定位的地点*/
@property(nonatomic,strong)YIMLocation *last_location;
@property(nonatomic,assign)YIMLocationStatus status;

+(instancetype)singleManager;

//更新位置
-(void)updateLocation;

@end
