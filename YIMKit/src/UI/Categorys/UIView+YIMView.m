//
//  UIView+YIMView.m
//  AFNetworking
//
//  Created by ybz on 2018/10/19.
//

#import "UIView+YIMView.h"
#import <objc/runtime.h>
#import "Masonry.h"

@interface _YIMCustomGradientLayer : UIView
@property(nonatomic,strong)CAGradientLayer *gLayer;
@end
@implementation _YIMCustomGradientLayer
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CAGradientLayer *gLayer = [CAGradientLayer layer];
        gLayer.locations = @[[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:1]];
        gLayer.startPoint = CGPointMake(0, 0.5);
        gLayer.endPoint = CGPointMake(1, 0.5);
        [self.layer addSublayer:gLayer];
        self.gLayer = gLayer;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.superview) {
        [self.superview insertSubview:self atIndex:0];
    }
    self.userInteractionEnabled = NO;
    self.gLayer.frame = self.bounds;
}
@end

@implementation UIView (YIMView)

static char *yimCustomGradientLayerView = "yimCustomGradientLayerView";
-(_YIMCustomGradientLayer*)customGradientLayerView{
    _YIMCustomGradientLayer *gLayerView = objc_getAssociatedObject(self, &yimCustomGradientLayerView);
    if (!gLayerView) {
        gLayerView = [[_YIMCustomGradientLayer alloc]init];
        objc_setAssociatedObject(self, &yimCustomGradientLayerView, gLayerView, OBJC_ASSOCIATION_RETAIN);
        gLayerView.hidden = true;
        [self insertSubview:gLayerView atIndex:0];
        __weak typeof(self) weakSelf = self;
        [gLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
    }
    return gLayerView;
}
-(void)gradientBackgroundColor:(UIColor*)color1 color2:(UIColor*)color2{
    _YIMCustomGradientLayer *gLayerView = [self customGradientLayerView];
    gLayerView.gLayer.colors = @[(id)color1.CGColor,(id)color2.CGColor];
    gLayerView.hidden = false;
    [self insertSubview:gLayerView atIndex:0];
}
@end
