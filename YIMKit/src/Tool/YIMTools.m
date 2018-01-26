//
//  YIMTools.m
//  YIMKit
//
//  Created by ybz on 2018/1/26.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "YIMTools.h"

CGSize DesignSizeScreenSize(AppDesignSizeDevice designSize){
    switch (designSize) {
        case DesignSizeIPhone4:
            return CGSizeMake(320, 480);
        case DesignSizeIPhone5:
            return CGSizeMake(320, 567);
        case DesignSizeIPhone6:
            return CGSizeMake(375, 667);
        case DesignSizeIPhone6Plus:
            return CGSizeMake(540, 960);
        case DesignSizeIPhoneX:
            return CGSizeMake(375, 812);
        default:
            break;
    }
}

CGFloat autoSizeVertical_d(CGFloat designValue,AppDesignSizeDevice designSize){
    return [UIScreen mainScreen].bounds.size.height/DesignSizeScreenSize(designSize).height * designValue;
}
CGFloat autoSizeVertical(CGFloat designValue){
    return autoSizeVertical_d(designValue,DesignSizeIPhone6);
}
CGFloat autoSizeHorizontal_d(CGFloat designValue,AppDesignSizeDevice designSize){
    return [UIScreen mainScreen].bounds.size.width/DesignSizeScreenSize(designSize).width * designValue;
}
CGFloat autoSizeHorizontal(CGFloat designValue){
    return autoSizeHorizontal_d(designValue,DesignSizeIPhone6);
}

CGFloat autoHeightUseRatio(CGFloat width,CGSize designSize){
    return width/(designSize.width/designSize.height);
}
CGFloat autoWidthUseRatio(CGFloat height,CGSize designSize){
    return height/(designSize.height/designSize.width);
}






@implementation YIMTools

@end
