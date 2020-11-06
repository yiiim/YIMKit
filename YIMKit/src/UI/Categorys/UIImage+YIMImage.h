//
//  UIImage+YIMImage.h
//  YIMKit
//
//  Created by ybz on 2018/1/25.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YIMImage)

/**返回一个指定主题颜色的图片*/
-(UIImage*)imageWithTintColor:(UIColor*)color;
/**返回一个当前配置主题色的图片*/
-(UIImage*)tintImage;

@end
