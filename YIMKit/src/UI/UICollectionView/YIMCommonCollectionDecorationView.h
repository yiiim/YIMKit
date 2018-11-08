//
//  YIYIMCommonCollectionDecorationView.h
//  YIMKit
//
//  Created by ybz on 2018/10/17.
//  Copyright © 2018 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const YIMCommonCollectionElementKindBorder;
UIKIT_EXTERN NSString *const YIMCommonCollectionElementKindLine;
UIKIT_EXTERN NSString *const YIMCommonCollectionElementKindCornerackgroud;

@interface YIMCommonCollectionDecorationView : UICollectionReusableView
@end

/**边框装饰*/
@interface YIMBorderCollectionDecorationView : YIMCommonCollectionDecorationView
@property(nonatomic,strong)UIColor *borderColor;
@property(nonatomic,assign)CGFloat cornerRadius;
@end

@interface YIMBorderCollectionZeroCornerDecorationView : YIMBorderCollectionDecorationView
@end

/**线装饰*/
@interface YIMLineCollectionDecorationView : YIMCommonCollectionDecorationView
@property(nonatomic,strong)UIColor *lineColor;
@end

/**888888号颜色的装饰线*/
@interface YIMLineCollectionBlackColorDecorationView : YIMLineCollectionDecorationView
@end

/**圆角背景装饰*/
@interface YIMCornerackgroudCollectionDecorationView : YIMCommonCollectionDecorationView
@property(nonatomic,assign)CGFloat cornerRadius;
@property(nonatomic,strong)UIColor *color;
@end
