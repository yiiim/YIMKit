//
//  NSBundle+YIMBundle.h
//  YIMKit
//
//  Created by ybz on 2018/5/25.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSBundle (YIMBundle)

+(instancetype)yimLibraryBundle;
+(UIImage*)yimLibraryBundleImageWithName:(NSString*)name;
+(UIImage*)yimLibraryBundleImageWithName:(NSString *)name imageType:(NSString*)type;
+(NSString*)yimLibraryBundleLocalizedStringForKey:(NSString*)key;
+(NSString*)yimLibraryBundleLocalizedStringForKey:(NSString*)key value:(NSString *)value;

@end
