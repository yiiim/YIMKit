//
//  UIImage+YIMImage.m
//  YIMKit
//
//  Created by ybz on 2018/1/25.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "UIImage+YIMImage.h"
#import "YIMSetting.h"

@implementation UIImage (YIMImage)

-(UIImage*)imageWithTintColor:(UIColor*)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage*)tintImage{
    return [self imageWithTintColor:[YIMSetting current].tintColor];
}

@end
