//
//  YIMLocationManager.m
//  YIMKit
//
//  Created by ybz on 2018/3/2.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "YIMLocationManager.h"
#import "YbzError.h"
#import <MapKit/MapKit.h>

@implementation YIMLocation
@end



@interface YIMLocationManager() <CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic)CLLocationCoordinate2D coordinate;
@property(nonatomic)CLLocationDistance altitude;
@property(nonatomic,strong)CLGeocoder *geocoder;

@end

@implementation YIMLocationManager

static YIMLocationManager *manager;
+(instancetype)singleManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YIMLocationManager alloc]init];
        manager.locationManager=[[CLLocationManager alloc]init];
        manager.locationManager.delegate= manager;
        manager.geocoder = [[CLGeocoder alloc]init];
        NSString *fullPath = [self lastLocationCacheFullPath];
        manager.last_location = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
    });
    return manager;
}

-(void)updateLocation{
    //如果没有授权则请求用户授权
    if (![CLLocationManager locationServicesEnabled]) {
        manager.status = YIMLocationStatusDisable;
    }else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        //请求打开定位
        [manager.locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        manager.status = YIMLocationStatusWhenInUse;
        [manager.locationManager startUpdatingLocation];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        YbzError *e = [[YbzError alloc]init];
        e.showUserMessage = @"Location service not open";
        e.insideMessage = @"无法使用定位，定位服务状态为：kCLAuthorizationStatusRestricted";
        [[NSNotificationCenter defaultCenter]postNotificationName:kYIMLocationGetLocationErrorNotifationName object:self userInfo:@{@"error":e}];
        manager.status = YIMLocationStatusRestricted;
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        YbzError *e = [[YbzError alloc]init];
        e.showUserMessage = @"Location service not open";
        e.insideMessage = @"无法使用定位，定位服务状态为：kCLAuthorizationStatusDenied";
        [[NSNotificationCenter defaultCenter]postNotificationName:kYIMLocationGetLocationErrorNotifationName object:self userInfo:@{@"error":e}];
        manager.status = YIMLocationStatusDenied;
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
        manager.status = YIMLocationStatusAlways;
        [manager.locationManager startUpdatingLocation];
    }
}
//获取到位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    [_locationManager stopUpdatingLocation];
}
//获取位置失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    YbzError *e = [[YbzError alloc]init];
    e.sysError = error;
    e.showUserMessage = @"Failed to get location";
    e.insideMessage = [NSString stringWithFormat:@"获取位置失败,%@",error.localizedDescription];
    [[NSNotificationCenter defaultCenter]postNotificationName:kYIMLocationGetLocationErrorNotifationName object:self userInfo:@{@"error":e}];
}

//定位授权状态改变
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    [self updateLocation];
}
//反地理编码
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    __weak typeof(self) weakSelf = self;
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        if (!error) {
            weakSelf.last_location = [[YIMLocation alloc]init];
            weakSelf.last_location.longitude = longitude;
            weakSelf.last_location.latitude = latitude;
            weakSelf.last_location.detail = placemark.name;
            weakSelf.last_location.country = placemark.country;
            weakSelf.last_location.province = placemark.administrativeArea;
            weakSelf.last_location.city = placemark.locality;
            [[weakSelf class]change_location:weakSelf.last_location];
            [[NSNotificationCenter defaultCenter]postNotificationName:kYIMLocationGetLocationNotifationName object:weakSelf];
        }else{
            YbzError *e = [[YbzError alloc]init];
            e.sysError = error;
            e.showUserMessage = @"Failed to get location";
            e.insideMessage = [NSString stringWithFormat:@"反地理编码失败,%@",error.localizedDescription];
            [[NSNotificationCenter defaultCenter]postNotificationName:kYIMLocationGetLocationErrorNotifationName object:weakSelf userInfo:@{@"error":e}];
        }
    }];
}

/**更改当前存储在本地的定位*/
+(void)change_location:(YIMLocation *)location{
    NSString *fullPath = [self lastLocationCacheFullPath];
    [NSKeyedArchiver archiveRootObject:location toFile:fullPath];
}
/**获取存储上次定位的路径*/
+(NSString*)lastLocationCacheFullPath{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *newPath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"location"]];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = false;
    [fm fileExistsAtPath:newPath isDirectory:&isDir];
    if (!isDir) {
        BOOL bCreateDir = [fm createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            return nil;
        }
    }
    newPath = [newPath stringByAppendingPathComponent:@"location.YIM"];
    return newPath;
}



@end

