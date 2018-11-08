//
//  YIMLoginUser.m
//  YIMKit
//
//  Created by ybz on 2018/1/27.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "YIMLoginUser.h"

NSString* kYIMDidGetLoginUserButNotLoginNoticationName = @"DidGetLoginUserButNotLoginNoticationName";
NSString* kYIMDidLoginNoticationName = @"kYIMDidLoginNoticationName";
NSString* kYIMDidLoginOutNoticationName = @"kYIMDidLoginOutNoticationName";

#define __YIMLoginUserSaveLoginUserKey__ @"YIMLoginUserSaveLoginUserKey"

@interface YIMLoginUser()
@end

@implementation YIMLoginUser

+(BOOL)isLogin{
    return [[self getLoginUser:false option:@{@"date":[NSDate date]}]loginKey];
}
+(instancetype)getLoginUser{
    return [self getLoginUser:true option:@{@"date":[NSDate date]}];
}
+(instancetype)getLoginUser:(BOOL)isSendNotication option:(NSDictionary *)option{
    YIMLoginUser *user = [[[self class]alloc]initWithLocalData:option];
    if(!user){
        [[NSNotificationCenter defaultCenter]postNotificationName:kYIMDidGetLoginUserButNotLoginNoticationName object:nil];
    }
    return user;
}
+(void)loginWithUser:(YIMLoginUser *)user{
    NSAssert(user.loginKey, @"loginKey is nil");
    [self setSingleLoginUser:user];
    [user saveToLocal];
    [[NSNotificationCenter defaultCenter]postNotificationName:kYIMDidLoginNoticationName object:nil];
}
+(void)loginWithLoginKey:(NSString *)loginKey{
    NSAssert(loginKey, @"loginKey is nil");
    YIMLoginUser *loginUser = [[[self class]alloc]init];
    loginUser.loginKey = loginKey;
    [self setSingleLoginUser:loginUser];
    [loginUser saveToLocal];
    [[NSNotificationCenter defaultCenter]postNotificationName:kYIMDidLoginNoticationName object:nil];
}
+(void)loginWithJson:(id)json{
    YIMLoginUser *loginUser = [[[self class]alloc]initWithJson:json];
    NSAssert(loginUser.loginKey, @"loginKey is nil");
    [self setSingleLoginUser:loginUser];
    [loginUser saveToLocal];
    [[NSNotificationCenter defaultCenter]postNotificationName:kYIMDidLoginNoticationName object:nil];
}
/**登出*/
+(void)loginOut{
    [self deleteLocal];
    [[NSNotificationCenter defaultCenter]postNotificationName:kYIMDidLoginOutNoticationName object:nil];
}

static __kindof YIMLoginUser *_singleLoginUser;
static NSLock *_singleLoginUserLock;
static bool _isUserSetSingle;
+(void)setSingleLoginUser:(__kindof YIMLoginUser *)loginUser{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _isUserSetSingle = true;
        _singleLoginUserLock = [[NSLock alloc]init];
    });
    [_singleLoginUserLock lock];
    _singleLoginUser = loginUser;
    [_singleLoginUserLock unlock];
}
+(instancetype)singleLoginUser{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!_isUserSetSingle){
            [self setSingleLoginUser:[self getLoginUser]];
        }
    });
    return _singleLoginUser;
}
-(instancetype)initWithLocalData:(NSDictionary *)option{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:__YIMLoginUserSaveLoginUserKey__];
    self = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return self;
}
-(void)saveToLocal{
    NSData *objData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults]setObject:objData forKey:__YIMLoginUserSaveLoginUserKey__];
}
+(void)deleteLocal{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:__YIMLoginUserSaveLoginUserKey__];
}
@end
