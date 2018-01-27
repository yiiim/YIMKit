//
//  YIMLoginUser.h
//  YIMKit
//
//  Created by ybz on 2018/1/27.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "YIMModelBase.h"

/**当获取登录用户时未登录发出的通知*/
FOUNDATION_EXPORT NSString *kDidGetLoginUserButNotLoginNoticationName;

@interface YIMLoginUser : YIMModelBase

/**登录密钥*/
@property(atomic,strong)NSString* loginKey;

/**是否登录*/
+(BOOL)isLogin;
/**
 获取登录用户
 */
+(instancetype)getLoginUser;

/**
 获取本地保存的登录用户

 @param isSendNotication 未登录时是否发送通知
 @param option 一些配置
 @return 本地保存的登录用户
 */
+(instancetype)getLoginUser:(BOOL)isSendNotication option:(NSDictionary*)option;

/**使用用户模型登录，必须包含loginKey*/
+(void)loginWithUser:(YIMLoginUser*)user;
/**使用json格式的用户模型登录，必须包含loginKey*/
+(void)loginWithJson:(id)json;
/**使用loginKey登录，不保存任何登录用户信息*/
+(void)loginWithLoginKey:(NSString*)loginKey;
/**设置登录时触发，子类重写时必须调用父类*/
+(void)didLogin:(__kindof YIMLoginUser*)loginUser;

/**设置单例的登录用户，该方法是线程安全的*/
+(void)setSingleLoginUser:(__kindof YIMLoginUser*)loginUser;
/**获取单例的登录用户，子类需保证属性的线程访问安全,如果没有设置单例登录用户，这个方法将设置一个当前登录用户为单例用户。通常需要获取用户信息不需要更改用户属性时使用此方法以节约性能*/
+(__kindof YIMLoginUser*)singleLoginUser;

/**默认是使用UserDefaults保存的数据*/
-(instancetype)initWithLocalData:(NSDictionary*)option;
/**默认保存到UserDefaults*/
-(void)saveToLocal;

@end
