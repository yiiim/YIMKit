//
//  YIMNavigationViewController.m
//  YIMKit
//
//  Created by ybz on 2018/1/25.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "YIMNavigationViewController.h"
#import "UIImage+YIMImage.h"
#import "YIMSetting.h"
#import <objc/runtime.h>
#import "Masonry.h"

typedef enum YIMNavigationControllerTransitionType{
    YIMNavigationControllerTransitionTypePush,
    YIMNavigationControllerTransitionTypePop
}YIMNavigationControllerTransitionType;

@interface YIMNavigationControllerTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property(nonatomic,weak)YIMNavigationViewController *navigationController;
@end
@implementation YIMNavigationControllerTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return .5f;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    
    toVc.navigationItemViewYIM.frame = self.navigationController.customNavigationBar.bounds;
    //    [toVc.navigationItemViewYIM layoutSubviews];
   
    CGRect toOriginalFrame = toView.frame;
    CGRect fromOriginalFrame = fromView.frame;
    CGRect toOriginalTitleFrame = fromVc.navigationItemViewYIM.titleView.frame;
    CGRect fromOriginalTitleFrame = fromVc.navigationItemViewYIM.titleView.frame;
    
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    [self.navigationController.customNavigationBar addSubview:toVc.navigationItemViewYIM];
    [self.navigationController.customNavigationBar addSubview:fromVc.navigationItemViewYIM];
    
    //push
    if ([self.navigationController.viewControllers containsObject:fromVc] && [self.navigationController.viewControllers containsObject:toVc]) {
        if ([self.navigationController.viewControllers indexOfObject:fromVc] < [self.navigationController.viewControllers indexOfObject:toVc]) {
            

            toView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
            toVc.navigationItemViewYIM.titleView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, toOriginalTitleFrame.origin.y, toOriginalTitleFrame.size.width, toOriginalTitleFrame.size.height);
            toVc.navigationItemViewYIM.alpha = 0;
            
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                toView.frame = toOriginalFrame;
                toVc.navigationItemViewYIM.alpha = 1;
                toVc.navigationItemViewYIM.titleView.frame = toOriginalTitleFrame;
                
                fromView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
                fromVc.navigationItemViewYIM.titleView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, fromVc.navigationItemViewYIM.titleView.frame.origin.y, fromVc.navigationItemViewYIM.titleView.frame.size.width, fromVc.navigationItemViewYIM.titleView.frame.size.height);
                fromVc.navigationItemViewYIM.alpha = 0;
            } completion:^(BOOL finished) {
                fromView.frame = fromOriginalFrame;
                fromVc.navigationItemViewYIM.alpha = 1;
                fromVc.navigationItemViewYIM.titleView.frame = fromOriginalTitleFrame;
                [transitionContext completeTransition:finished];
            }];
        }
    }else if (![self.navigationController.viewControllers containsObject:fromVc]){
        toView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
        toVc.navigationItemViewYIM.titleView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, toVc.navigationItemViewYIM.titleView.frame.origin.y, toVc.navigationItemViewYIM.titleView.frame.size.width, toVc.navigationItemViewYIM.titleView.frame.size.height);
        toVc.navigationItemViewYIM.alpha = 0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            toView.frame = toOriginalFrame;
            toVc.navigationItemViewYIM.alpha = 1;
            toVc.navigationItemViewYIM.titleView.frame = toOriginalTitleFrame;
            
            fromView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(fromView.frame), CGRectGetWidth(fromView.frame), CGRectGetHeight(fromView.frame));
            fromVc.navigationItemViewYIM.alpha = 0;
            fromVc.navigationItemViewYIM.titleView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, fromVc.navigationItemViewYIM.titleView.frame.origin.y, fromVc.navigationItemViewYIM.titleView.frame.size.width, fromVc.navigationItemViewYIM.titleView.frame.size.height);
            
        } completion:^(BOOL finished) {
            fromVc.navigationItemViewYIM.alpha = 1;
            fromVc.navigationItemViewYIM.titleView.frame = fromOriginalTitleFrame;
            fromView.frame = fromOriginalFrame;
            [transitionContext completeTransition:finished];
        }];
    }
}
@end


@interface YIMNavigationItemView()
@property(nonatomic,weak)UIViewController *hostViewController;
@property(nonatomic,strong,readwrite)UIView *bottomLineView;
@end

@implementation UIViewController (YIMNavigationViewController)
-(YIMNavigationViewController*)navigationViewControllerYIM{
    if([self.navigationController isKindOfClass:[YIMNavigationViewController class]]){
        return (YIMNavigationViewController*)self.navigationController;
    }
    return nil;
}
static void *navigationItemViewYIMKey = &navigationItemViewYIMKey;
-(YIMNavigationItemView*)navigationItemViewYIM{
    YIMNavigationItemView *view = objc_getAssociatedObject(self, &navigationItemViewYIMKey);
    if(!view){
        view = [[YIMNavigationItemView alloc]init];
        view.tintColor = [YIMSetting current].tintColor;
        [self setNavigationItemViewYIM:view];
    }
    return view;
}
-(void)setNavigationItemViewYIM:(YIMNavigationItemView *)navigationItemViewYIM{
    navigationItemViewYIM.hostViewController = self;
    objc_setAssociatedObject(self, &navigationItemViewYIMKey, navigationItemViewYIM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@implementation YIMNavigationItemView
-(instancetype)init{
    if(self = [super init]){
        __weak typeof(self) weakSelf = self;
        
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:.5f];
        [self addSubview:contentView];
        
        UIView *statusFrameView = [[UIView alloc]init];
        statusFrameView.userInteractionEnabled = false;
        [self addSubview:statusFrameView];
        
        UIView *titleView = [[UIView alloc]init];
        titleView.userInteractionEnabled = false;
        [self addSubview:titleView];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [backButton setImage:[[UIImage imageNamed:@"nav_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(weakSelf);
            make.width.equalTo(@34);
        }];
        
        UIView *navBottomLineView = [[UIView alloc]init];
        navBottomLineView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:.5f];
        [contentView addSubview:navBottomLineView];
        [navBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(contentView);
            make.height.equalTo(@1);
        }];
        
        self.contentView = contentView;
        self.backButton = backButton;
        self.statusFrameView = statusFrameView;
        self.titleView = titleView;
        self.bottomLineView = navBottomLineView;
    }
    return self;
}
-(void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    [self.backButton setImage:[[self.backButton.imageView.image imageWithTintColor:tintColor]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.bottomLineView.backgroundColor = tintColor;
}
-(void)clickBack:(id)sender{
    [self.hostViewController.navigationController popViewControllerAnimated:true];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, -[UIApplication sharedApplication].statusBarFrame.size.height, self.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height + self.frame.size.height);
    self.statusFrameView.frame = CGRectMake(0, -[UIApplication sharedApplication].statusBarFrame.size.height, self.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height);
    self.titleView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
-(UILabel*)titleLabel{
    if(!_titleLabel){
        UILabel *titleLabel = [[UILabel alloc]init];
        [self.titleView addSubview:titleLabel];
        __weak typeof(self) weakSelf = self;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.titleView);
        }];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
-(void)setHostViewController:(UIViewController *)hostViewController{
    _hostViewController = hostViewController;
    if(!self.titleLabel.text){
        self.titleLabel.text = hostViewController.title;
    }
}
@end

@interface YIMNavigationBar()<UINavigationBarDelegate>
@end
@implementation YIMNavigationBar
@end


@interface HiddenNavigationBar : UINavigationBar
@end
@implementation HiddenNavigationBar

-(void)didAddSubview:(UIView *)subview{
    [super didAddSubview:subview];
    [subview removeFromSuperview];
}
@end


@interface YIMNavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation YIMNavigationViewController
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [self initWithNavigationBarClass:[HiddenNavigationBar class] toolbarClass:UIToolbar.class];
    self.viewControllers = @[rootViewController];
    return self;
}
-(instancetype)init{
    return [self initWithNavigationBarClass:[HiddenNavigationBar class] toolbarClass:UIToolbar.class];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = true;
    
    self.delegate = self;
    YIMNavigationBar *navBar = [[YIMNavigationBar alloc]init];
    navBar.frame = self.navigationBar.frame;
    [self.view addSubview:navBar];
    self.customNavigationBar = navBar;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if(self.navigationBar && self.customNavigationBar && self.navigationBar.superview == self.customNavigationBar.superview){
        self.customNavigationBar.frame = self.navigationBar.frame;
        [self.view bringSubviewToFront:self.customNavigationBar];
    }
}
-(void)setNavigationBarHidden:(BOOL)navigationBarHidden{
    [super setNavigationBarHidden:navigationBarHidden];
    self.customNavigationBar.hidden = navigationBarHidden;
    if (!navigationBarHidden) {
        if(self.navigationBar && self.customNavigationBar && self.navigationBar.superview == self.customNavigationBar.superview){
            self.customNavigationBar.frame = self.navigationBar.frame;
            [self.view layoutSubviews];
            [self.view bringSubviewToFront:self.customNavigationBar];
        }
    }
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = true;
    [super pushViewController:viewController animated:animated];
}
-(UIViewController*)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}
-(void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{
    [super setViewControllers:viewControllers animated:animated];
    YIMNavigationItemView *itemView = viewControllers.firstObject.navigationItemViewYIM;
    [self.customNavigationBar addSubview:itemView];
    itemView.backButton.hidden = true;
    itemView.frame = self.customNavigationBar.bounds;
    itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
    return true;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    YIMNavigationControllerTransition *transition = [[YIMNavigationControllerTransition alloc]init];
    transition.navigationController = self;
    return transition;
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.customNavigationBar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.customNavigationBar addSubview:viewController.navigationItemViewYIM];
    viewController.navigationItemViewYIM.frame = self.customNavigationBar.bounds;
    viewController.navigationItemViewYIM.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
