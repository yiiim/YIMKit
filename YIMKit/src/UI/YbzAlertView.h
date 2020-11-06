//
//  YbzAlertView.h
//  Ybz.Library
//
//  Created by ybz on 2017/1/9.
//  Copyright © 2017年 ybz.com. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN const CGFloat YbzAlertViewHeightAutomaticDimension;
UIKIT_EXTERN const CGFloat YbzAlertViewWidthAutomaticDimension;


@interface YbzAlertView : UIView

/**内容视图 把自定义的视图添加到这个上面*/
@property(nonatomic,weak,readonly)UIView *contentve;
/**标题*/
@property(nonatomic,strong)NSString *title;
/**标题颜色*/
@property(nonatomic,strong)UIColor *titleColor;
/**标题标签字符*/
@property(nonatomic,strong)NSAttributedString *titleAttributedString;
/**标题背景颜色*/
@property(nonatomic,strong)UIColor *titleBackColor;
/**按钮背景颜色*/
@property(nonatomic,strong)UIColor *btnBackColor;
/**按钮文字颜色*/
@property(nonatomic,strong)UIColor *btnTextColor;
/**关闭按钮是否隐藏*/
@property(nonatomic,assign)BOOL closeButtonIsHidden;
/**标题栏是否隐藏*/
@property(nonatomic,assign)BOOL titleIsHidden;
/**标题栏高度 默认40*/
@property(nonatomic,assign)CGFloat titleHeight;
/**按钮高度 默认40*/
@property(nonatomic,assign)CGFloat buttonsHeight;
/**点击按钮执行的block*/
@property(nonatomic,copy)void(^clickButtonBlock)(NSInteger buttonIndex);

/*
 *初始化
 *@param height弹窗内容高度（不包括title和buttons）
 *@param width弹窗内容的宽度
 */
-(instancetype)initWithHeight:(CGFloat)height width:(CGFloat)width;
/*
 *初始化
 *@param height弹窗内容高度（不包括title和buttons）
 *@param width宽度
 *@param btnsTitle按钮title
 */
-(instancetype)initWithHeight:(CGFloat)height width:(CGFloat)width btnsTitle:(NSArray<NSString*>*)btnsTitle;

-(void)alert:(BOOL)animated;
-(void)hide:(BOOL)animated;

@end
