//
//  NSBundle+YIMBundle.m
//  YIMKit
//
//  Created by ybz on 2018/5/25.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "NSBundle+YIMBundle.h"

@implementation NSBundle (YIMBundle)

+(instancetype)yimLibraryBundle{
    static NSBundle *bundle = nil;
    if (!bundle) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"yimLibrary" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    }
    return bundle;
}
+(UIImage*)yimLibraryBundleImageWithName:(NSString *)name{
    return [self yimLibraryBundleImageWithName:name imageType:@"png"];
}
+(UIImage*)yimLibraryBundleImageWithName:(NSString *)name imageType:(NSString *)type{
    NSString *path = [[self yimLibraryBundle]pathForResource:name ofType:type inDirectory:@"resource"];
    return [UIImage imageWithContentsOfFile:path];
}
+(NSString*)yimLibraryBundleLocalizedStringForKey:(NSString *)key{
    return [self yimLibraryBundleLocalizedStringForKey:key value:nil];
}
+(NSString*)yimLibraryBundleLocalizedStringForKey:(NSString *)key value:(NSString *)value{
    NSString *string = NSLocalizedStringWithDefaultValue(key, nil, [NSBundle yimLibraryBundle], value, @"");
    return string;
}

@end
