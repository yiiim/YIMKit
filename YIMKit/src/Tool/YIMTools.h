//
//  YIMTools.h
//  YIMKit
//
//  Created by ybz on 2018/1/26.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DesignSizeIPhone6,
    DesignSizeIPhone6Plus,
    DesignSizeIPhone5,
    DesignSizeIPhone4,
    DesignSizeIPhoneX
} AppDesignSizeDevice;

/**根据指定设计尺寸，获取当前屏幕垂直尺寸，第一个参数为设计图垂直尺寸，第二个参数为设计图的设备尺寸*/
CGFloat autoSizeVertical_d(CGFloat designValue,AppDesignSizeDevice designSize);
/**根据指定iPhone6设计尺寸，获取当前屏幕垂直尺寸*/
CGFloat autoSizeVertical(CGFloat designValue);
/**根据指定设计尺寸，获取当前屏幕水平尺寸，第一个参数为设计图水平尺寸，第二个参数为设计图的设备尺寸*/
CGFloat autoSizeHorizontal_d(CGFloat designValue,AppDesignSizeDevice designSize);
/**根据指定iPhone6设计尺寸，获取当前屏幕水平尺寸*/
CGFloat autoSizeHorizontal(CGFloat designValue);

/**根据指定比例获取高度，第一个参数为宽度，第二个参数是比例的宽高*/
CGFloat autoHeightUseRatio(CGFloat width,CGSize ratioSize);
/**根据指定比例获取宽度，第一个参数为高度，第二个参数是比例的宽高*/
CGFloat autoWidthUseRatio(CGFloat height,CGSize ratioSize);

bool property_is_valuetype(NSString *name,Class cls);


@interface YIMTools : NSObject

@end
