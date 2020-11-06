//
//  YbzAlertView.m
//  Ybz.Library
//
//  Created by ybz on 2017/1/9.
//  Copyright © 2017年 ybz.com. All rights reserved.
//

#import "YbzAlertView.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "UIImage+YIMImage.h"


const CGFloat YbzAlertViewHeightAutomaticDimension = -1;
const CGFloat YbzAlertViewWidthAutomaticDimension = -1;

static UIWindow *ybzAlertViewWindow;

@interface YbzAlertView()

@property(nonatomic,weak)UIView *alterve;
@property(nonatomic,weak)UILabel *titlelbl;
@property(nonatomic,weak)UIView *titleve;
@property(nonatomic,weak)UIView *btnsve;
@property(nonatomic,weak)UIButton *closebtn;
@property(nonatomic,weak,readwrite)UIView *contentve;

@property(nonatomic,strong)MASConstraint *titleHeightConstraint;
@property(nonatomic,strong)MASConstraint *buttonsHeightConstraint;

@property(nonatomic,assign)CGFloat width;

@end

@implementation YbzAlertView

+(void)initialize{
    ybzAlertViewWindow = [[UIWindow alloc]init];
    ybzAlertViewWindow.windowLevel = UIWindowLevelAlert;
    ybzAlertViewWindow.backgroundColor = [UIColor clearColor];
}

-(instancetype)initWithHeight:(CGFloat)height width:(CGFloat)width{
    return [self initWithHeight:height width:width btnsTitle:nil];
}
-(instancetype)initWithHeight:(CGFloat)height width:(CGFloat)width btnsTitle:(NSArray<NSString *> *)btnsTitle{
    if (self = [super init]) {
        
        _titleHeight = 36;
        _buttonsHeight = 40;
        self.width = width;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.2f];
        UIView *maskve = [[UIView alloc]init];
        maskve.userInteractionEnabled = YES;
        [self addSubview:maskve];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click_blank:)];
        [maskve addGestureRecognizer:tap];
        
        UIView* alterve = [[UIView alloc]init];
        alterve.layer.cornerRadius = 5;
        alterve.clipsToBounds = YES;
        [self addSubview:alterve];
        
        UIView *titleve = [[UIView alloc]init];
        titleve.backgroundColor = [UIColor whiteColor];
        [alterve  addSubview:titleve];
        
        UILabel *titlelbl = [[UILabel alloc]init];
        titlelbl.textAlignment = NSTextAlignmentCenter;
        [titleve addSubview:titlelbl];
        
        UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Ybz.LibraryBundle.bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        UIImage *(^getBundleImage)(NSString *) = ^(NSString *n) {
            return [UIImage imageWithContentsOfFile:[bundle pathForResource:n ofType:@"tiff"]];
        };
        UIImage *coloseImage = getBundleImage(@"close");
        [closebtn setImage:coloseImage forState:UIControlStateNormal];
        [closebtn addTarget:self action:@selector(click_close:) forControlEvents:UIControlEventTouchUpInside];
        [titleve addSubview:closebtn];
        
        UIView *btnsve = [[UIView alloc]init];
        btnsve.backgroundColor = [UIColor whiteColor];
        [alterve addSubview:btnsve];
        
        UIView* contentve = [[UIView alloc]init];
        contentve.backgroundColor = [UIColor whiteColor];
        [alterve addSubview:contentve];
        
        
        __weak typeof(self) weakSelf = self;
        [maskve mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        [alterve mas_makeConstraints:^(MASConstraintMaker *make) {
            if (width != YbzAlertViewWidthAutomaticDimension)
                make.width.equalTo(@(width));
            make.center.equalTo(weakSelf);
        }];
        
        [titleve mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(alterve);
            make.right.equalTo(alterve);
            make.top.equalTo(alterve);
            weakSelf.titleHeightConstraint = make.height.equalTo([NSNumber numberWithFloat:self.titleHeight]);
        }];
        [titlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(titleve);
            make.left.greaterThanOrEqualTo(titleve);
            make.right.greaterThanOrEqualTo(closebtn.mas_left);
        }];
        [closebtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [closebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(titleve).offset(-4);
            make.top.equalTo(titleve).offset(4);
            make.bottom.equalTo(titleve).offset(-4);
            make.width.equalTo(closebtn.mas_height);
        }];
        
        [contentve mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(alterve);
            make.right.equalTo(alterve);
            make.top.equalTo(titleve.mas_bottom);
            if (height != YbzAlertViewHeightAutomaticDimension)
                make.height.equalTo(@(height));
        }];
        
        [btnsve mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(alterve);
            make.right.equalTo(alterve);
            make.top.equalTo(contentve.mas_bottom);
            if (btnsTitle.count)
                weakSelf.buttonsHeightConstraint = make.height.equalTo([NSNumber numberWithFloat:self.buttonsHeight]);
            else
                make.height.equalTo(@0);
            make.bottom.equalTo(alterve);
        }];
        self.alterve = alterve;
        self.titleve = titleve;
        self.titlelbl = titlelbl;
        self.btnsve = btnsve;
        self.closebtn = closebtn;
        self.contentve = contentve;
        
        if (btnsTitle.count) {
            UIButton *lastbtn;
            for (int i = 0; i < btnsTitle.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
                btn.tag = i;
                [btn setTitle:btnsTitle[i] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(click_btn:) forControlEvents:UIControlEventTouchUpInside];
                [btnsve addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(btnsve);
                    make.bottom.equalTo(btnsve);
                    if (lastbtn){
                        make.left.equalTo(lastbtn.mas_right);
                        make.width.equalTo(lastbtn);
                    }
                    else
                        make.left.equalTo(btnsve);
                    if (i == btnsTitle.count - 1)
                        make.right.equalTo(btnsve);
                }];
                lastbtn = btn;
            }
        }
        
    }
    return self;
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titlelbl.text = title;
}
-(void)setTitleBackColor:(UIColor *)titleBackColor{
    _titleBackColor = titleBackColor;
    self.titleve.backgroundColor = titleBackColor;
    
}
-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.titlelbl.textColor = titleColor;
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"resource.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *(^getBundleImage)(NSString *) = ^(NSString *n) {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:n ofType:@"png"]];
    };
    UIImage *coloseImage = getBundleImage(@"close");
    [self.closebtn setImage:[coloseImage imageWithTintColor:titleColor] forState:UIControlStateNormal];
}
-(void)setBtnBackColor:(UIColor *)btnBackColor{
    _btnBackColor = btnBackColor;
    self.btnsve.backgroundColor = btnBackColor;
}
-(void)setBtnTextColor:(UIColor *)btnTextColor{
    _btnTextColor = btnTextColor;
    for (UIView* ve in self.btnsve.subviews) {
        if ([ve isKindOfClass:[UIButton class]]) {
            [((UIButton*)ve) setTitleColor:btnTextColor forState:UIControlStateNormal];
        }
    }
}
-(void)setTitleHeight:(CGFloat)titleHeight{
    _titleHeight = titleHeight;
    self.titleHeightConstraint.equalTo([NSNumber numberWithFloat:titleHeight]);
    [self layoutSubviews];
}
-(void)setButtonsHeight:(CGFloat)buttonsHeight{
    _buttonsHeight = buttonsHeight;
    self.buttonsHeightConstraint.equalTo([NSNumber numberWithFloat:buttonsHeight]);
    [self layoutSubviews];
}
-(void)setTitleIsHidden:(BOOL)titleIsHidden{
    _titleIsHidden = titleIsHidden;
    self.titleve.hidden = titleIsHidden;
}
-(void)setCloseButtonIsHidden:(BOOL)closeButtonIsHidden{
    _closeButtonIsHidden = closeButtonIsHidden;
    self.closebtn.hidden = closeButtonIsHidden;
}
-(void)setTitleAttributedString:(NSAttributedString *)titleAttributedString{
    _titleAttributedString = titleAttributedString;
    self.titlelbl.attributedText = titleAttributedString;
}



-(void)click_blank:(UITapGestureRecognizer*)sender{
    if (!CGRectContainsPoint(self.alterve.bounds, [sender locationInView:self.alterve]))
        [self hide:YES];
}
-(void)click_btn:(UIButton*)sender{
    if (self.clickButtonBlock) {
        self.clickButtonBlock(sender.tag);
    }
}
-(void)click_close:(id)sender{
    [self hide:YES];
}


-(void)alert:(BOOL)animated{
    [ybzAlertViewWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ybzAlertViewWindow);
    }];
    [ybzAlertViewWindow makeKeyAndVisible];
    if (animated) {
        self.alterve.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:.2f animations:^{
            self.alterve.transform = CGAffineTransformIdentity;
        }];
    }
}
-(void)hide:(BOOL)animated{
    void(^hideBlock)(void) = ^{
        [self removeFromSuperview];
        ybzAlertViewWindow.hidden = YES;
    };
    
    if (animated) {
        [UIView animateWithDuration:.2f animations:^{
            self.alterve.transform = CGAffineTransformMakeScale(.01f, .01f);
        }completion:^(BOOL finished) {
            self.alterve.transform = CGAffineTransformIdentity;
            hideBlock();
        }];
    }else{
        hideBlock();
    }
}

-(void)KeyboardWillShowNotification:(NSNotification*)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect boardRect = [ybzAlertViewWindow convertRect:[value CGRectValue] fromView:nil];
    
    CGFloat height = CGRectGetHeight(self.alterve.frame);
    CGFloat nomalbottom = ([UIScreen mainScreen].bounds.size.height - height)/2;
    __weak typeof(self) weakSelf = self;
    if(nomalbottom<([UIScreen mainScreen].bounds.size.height - boardRect.size.height)){
        [self.alterve mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (weakSelf.width != YbzAlertViewWidthAutomaticDimension)
                make.width.equalTo(@(weakSelf.width));
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf).offset(-(nomalbottom+(boardRect.size.height-nomalbottom)));
        }];
    }else{
        [self.alterve mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (weakSelf.width != YbzAlertViewWidthAutomaticDimension)
                make.width.equalTo(@(weakSelf.width));
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf).offset(-nomalbottom);
        }];
    }
    [self layoutIfNeeded];
    
}
-(void)KeyboardWillHideNotification:(id)sender{
    __weak typeof(self) weakSelf = self;
    [self.alterve mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.width != YbzAlertViewWidthAutomaticDimension)
            make.width.equalTo(@(weakSelf.width));
        make.center.equalTo(weakSelf);
    }];
    [self layoutIfNeeded];
}


@end
