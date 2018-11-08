//
//  YIYIMCommonCollectionDecorationView.m
//  YIMKit
//
//  Created by ybz on 2018/10/17.
//  Copyright © 2018 ybz. All rights reserved.
//

#import "YIMCommonCollectionDecorationView.h"
#import "YYKit.h"

NSString *const YIMCommonCollectionElementKindBorder = @"YIMCommonCollectionElementKindBorder";
NSString *const YIMCommonCollectionElementKindLine = @"YIMCommonCollectionElementKindLine";
NSString *const YIMCommonCollectionElementKindCornerackgroud = @"YIMCommonCollectionElementKindCornerackgroud";

@implementation YIMCommonCollectionDecorationView

@end

@implementation YIMBorderCollectionDecorationView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1;
        self.borderColor = UIColorHex(818181);
        self.cornerRadius = 5;
        self.userInteractionEnabled = false;
    }
    return self;
}
-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}
@end

@implementation YIMBorderCollectionZeroCornerDecorationView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.cornerRadius = 0;
    }
    return self;
}
@end

@implementation YIMLineCollectionDecorationView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.lineColor = UIColorHex(ebebeb);
    }
    return self;
}
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
}
@end
@implementation YIMLineCollectionBlackColorDecorationView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.lineColor = UIColorHex(888888);
    }
    return self;
}
@end


@implementation YIMCornerackgroudCollectionDecorationView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = true;
        self.color = [UIColor whiteColor];
        self.cornerRadius = 8;
    }
    return self;
}
-(void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}
-(void)setColor:(UIColor *)color{
    _color = color;
    self.backgroundColor = color;
}
@end
