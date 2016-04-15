//
//  MyAlertView.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/5.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MyAlertView.h"
#import "SystomoList.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
@interface MyAlertView ()
///  白色背景
@property (nonatomic, strong)UIView *backView;
///  说明框
@property (nonatomic, strong)UILabel *instructionsLable;
///  图片框
@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation MyAlertView
- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backView = [[UIView alloc] init];
        [self addSubview:self.backView];
        self.instructionsLable = [[UILabel alloc] init];
        
        self.imageView = [[UIImageView alloc] init];
//        [self.backView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor colorWithString:@"010101" alpha:0.6];
    [self cearteSubViews];
}
- (void)cearteSubViews
{
    [self.backView setFrame:CGRectMake(5, 60, WIDTH - 10, (WIDTH - 10)/320 * 400)];
    self.backView.backgroundColor = [UIColor colorWithString:@"ffffff" alpha:1];
    self.backView.layer.cornerRadius = 5;
    self.backView.clipsToBounds = YES;
    /// 图片加载框
    [self.imageView setFrame:CGRectMake(15, 15, WIDTH - 40, (WIDTH-40)/260 * 160)];
    NSURL *imageUrl = [NSURL URLWithString:self.groupModel.group_img];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (!self.imageView.image) {/// 判断是否用群组UI
        [self.imageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"group_waku_mini"]];
        [self createButton];
    }
    [self.backView addSubview:self.imageView];
    /// 返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(WIDTH - 10 - 15 - 25, (WIDTH-40)/260 * 160 + 25, 25, 25);
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_popupclose"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:backButton];
    /// 完成度说明文字
    [self.instructionsLable setFrame:CGRectMake(15, (WIDTH-40)/520 * 320 + 60, WIDTH - 40, ((WIDTH - 10)/320 * 400) - ((WIDTH-40)/520 * 320 + 80))];
    self.instructionsLable.numberOfLines = 3;
    self.instructionsLable.font = FONT_SIZE_6(16.f);
    self.instructionsLable.textColor = [UIColor colorWithString:@"393a40" alpha:1];
    
}
/// 推出键方法
- (void)backButtonAction:(UIButton *)button
{
    [UIView animateWithDuration:0.8f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/// 点击完成度说明是才会调用
- (void)setString:(NSString *)string
{
    if (_string != string) {
        _string = string;
    }
    self.instructionsLable.text = _string;
    [self.backView addSubview:self.instructionsLable];
    self.imageView.image = [UIImage imageNamed:@"illust_perfection_big"];

}
/// 会话或者退会视图
- (void)createButton
{
    
    
    NSArray *imageArr = [NSArray arrayWithObjects:@"btn_popup_troom_off", @"btn_popup_memmber_off", nil];
    NSArray *lableArr = [NSArray arrayWithObjects:@"トークルーム", @"メンバー", nil];
    CGFloat w = 80 * ((WIDTH - 10)/320);
    CGFloat BackViewHeith = self.backView.frame.size.height;
    
    for (int i = 0; i < 2; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((50 + w) * i + ((WIDTH - 10 - 2*(w + 10) - 50)/2), BackViewHeith - 20 - 20, (w + 10), 20)];
        label.text = lableArr[i];
        label.font = FONT_SIZE_6(14.f);
        label.textColor = [UIColor colorWithString:@"393a40" alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:label];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = 12130+i;
        button.frame = CGRectMake((50 + w) * i + ((WIDTH - 10 - 2*w - 50)/2), BackViewHeith - 45 - w, w, w);
        [button setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sessionOrQuitGroup:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:button];
    }
    UILabel *groupName = [[UILabel alloc] initWithFrame:CGRectMake(10, BackViewHeith - 45 - w - 40, WIDTH - 30, 20)];
    groupName.textAlignment = NSTextAlignmentCenter;
    groupName.font = FONT_SIZE_6(17.f);
    groupName.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
    groupName.text = self.groupModel.group_name;
    [self.backView addSubview:groupName];

}
/// 会话或者退会方法
- (void)sessionOrQuitGroup:(UIButton *)button
{
    switch (button.tag) {
        case 12130:
        {
            NSLog(@"会话");
            self.GroupSessionBlock();
        }
            break;
        case 12131:
        {
            NSLog(@"跳退会界面");
            self.QuitGroupBlock();
        }
            break;
            
        default:
            break;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
