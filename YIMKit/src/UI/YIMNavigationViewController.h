//
//  YIMNavigationViewController.h
//  YIMKit
//
//  Created by ybz on 2018/1/25.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YIMNavigationBar;
@class YIMNavigationViewController;
@class YIMNavigationItemView;

@interface UIViewController (YIMNavigationViewController)
/**获取YIM导航控制器（如果当前导航控制是YIM的话）*/
@property(nonatomic,readonly,weak)YIMNavigationViewController* navigationViewControllerYIM;
/**获取YIM导航项目（如果当前导航控制是YIM的话）*/
@property(nonatomic,readonly,strong)YIMNavigationItemView* navigationItemViewYIM;
@end

@interface YIMNavigationItemView : UIView
@property(nonatomic,strong)UIColor *tintColor;
/**返回按钮*/
@property(nonatomic,strong)UIButton* backButton;
/**全部内容view*/
@property(nonatomic,strong)UIView *contentView;
/**状态栏位置的view*/
@property(nonatomic,strong)UIView *statusFrameView;
/**标题view，在状态栏下面，这个view在push或pop动画时是滑入的*/
@property(nonatomic,strong)UIView *titleView;
/**标题label*/
@property(nonatomic,strong)UILabel *titleLabel;
/**底部横线view*/
@property(nonatomic,strong,readonly)UIView *bottomLineView;
@end

@interface YIMNavigationBar : UIView
@property(nonatomic,strong)UIButton *backButton;
@end


@interface YIMNavigationViewController : UINavigationController
@property(nonatomic,strong)YIMNavigationBar *customNavigationBar;
@end
