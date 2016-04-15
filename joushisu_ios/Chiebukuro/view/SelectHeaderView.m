//
//  SelectHeaderView.m
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SelectHeaderView.h"

#define WIDTH self.frame.size.width

@interface SelectHeaderView ()

//@property (nonatomic, strong)NSMutableArray *imageNames_off;    //图片名数组
//@property (nonatomic, strong)NSMutableArray *imageNames_on;
@property (nonatomic, strong)NSMutableArray *titles;        //标题名数组

@property (nonatomic, strong)UIView *bottom; ///底层view

@end

@implementation SelectHeaderView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bottom = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
    self.bottom.layer.cornerRadius = 5;
    self.bottom.clipsToBounds = YES;
    [self addSubview:self.bottom];
    
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake((i *(WIDTH - 20) / 3), 0, (WIDTH - 20) / 3 - 1, self.frame.size.height - 20);
        button.tag = 19191 + i;
        if (i == 0) {
            if ([self.viewControllerTag isEqualToString:@"bird"]) {
                [button setBackgroundColor:SysteerTabColorOn];
            } else {
                [button setBackgroundColor:ChiebukuroTabColorOn];
            }
//            [button setBackgroundImage:[UIImage imageNamed:self.imageNames_on[i]] forState:UIControlStateNormal];
        } else {
            if ([self.viewControllerTag isEqualToString:@"bird"]) {
                [button setBackgroundColor:SysteerTabColorOff];
            } else {
                [button setBackgroundColor:ChiebukuroTabColorOff];
            }
//            [button setBackgroundImage:[UIImage imageNamed:self.imageNames_off[i]] forState:UIControlStateNormal];
            UIView *Vertical = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, 1, self.frame.size.height - 20)];
            Vertical.backgroundColor = [UIColor whiteColor];
            [button addSubview:Vertical];
        }
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
//        NSLog(@"width======%f", CON_HEIGHT);
        if (CON_HEIGHT > 735.f) {
            button.titleLabel.font = FONT_SIZE_6(17.f);
        } else {
            button.titleLabel.font = FONT_SIZE_6(13.f);
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom addSubview:button];
    }
    // 线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, WIDTH, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
}

- (void)setViewControllerTag:(NSString *)viewControllerTag
{
    if (_viewControllerTag != viewControllerTag) {
        _viewControllerTag = viewControllerTag;
    }
    /// 进行数据加载
    [self reloadSubViewsWithTag:_viewControllerTag];
}
- (void)reloadSubViewsWithTag:(NSString *)viewControllerTag
{
    if ([viewControllerTag isEqualToString:@"bird"]) {
        
        self.titles = [[NSMutableArray alloc] initWithObjects:@"すべて", @"シストモ", @"じぶん", nil];
//        self.imageNames_off = [[NSMutableArray alloc] initWithObjects:@"tab2_left_off", @"tab2_center_off", @"tab2_right_off", nil];
//        self.imageNames_on = [[NSMutableArray alloc] initWithObjects:@"tab2_left_on", @"tab2_center_on", @"tab2_right_on", nil];
        
    } else if([viewControllerTag isEqualToString:@"elephant"]){
        
        self.titles = [[NSMutableArray alloc] initWithObjects:@"新着順", @"コメント順", @"じぶんの投稿", nil];
//        self.imageNames_off = [[NSMutableArray alloc] initWithObjects:@"subnavi_left_off", @"subnavi_center_off", @"subnavi_right_off", nil];
//        self.imageNames_on = [[NSMutableArray alloc] initWithObjects:@"subnavi_left_on", @"subnavi_center_on", @"subnavi_right_on", nil];
    }
}

- (void)buttonAction:(UIButton *)sender
{
    // 传值并操作
    self.SelectTableView(sender.tag);
    // 改变背景图片
    for (UIButton *button in [self.bottom subviews]) {
        if ([self.viewControllerTag isEqualToString:@"bird"]) {
            [button setBackgroundColor:SysteerTabColorOff];
        } else {
            [button setBackgroundColor:ChiebukuroTabColorOff];
        }
    }
    
//    for (int i = 0; i < 3; i ++) {
//        UIButton *button = (UIButton *)[self viewWithTag:19191 + i];
//        if ([self.viewControllerTag isEqualToString:@"bird"]) {
//            [button setBackgroundColor:SysteerTabColorOff];
//        } else {
//            [button setBackgroundColor:ChiebukuroTabColorOff];
//        }
////        [button setBackgroundImage:[UIImage imageNamed:self.imageNames_off[i]] forState:UIControlStateNormal];
//    }
//    [sender setBackgroundImage:[UIImage imageNamed:self.imageNames_on[sender.tag - 19191]] forState:UIControlStateNormal];
    if ([self.viewControllerTag isEqualToString:@"bird"]) {
        [sender setBackgroundColor:SysteerTabColorOn];
    } else {
        [sender setBackgroundColor:ChiebukuroTabColorOn];
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
