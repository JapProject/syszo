//
//  SelectHeaderTwoView.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SelectHeaderTwoView.h"

@interface SelectHeaderTwoView ()
@property (nonatomic, strong)UIView *bottom;
@end

@implementation SelectHeaderTwoView
- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titles = [[NSMutableArray alloc] init];
//        self.imageNames_off = [[NSMutableArray alloc] init];
//        self.imageNames_on = [[NSMutableArray alloc] init];
//        self.btnNumber = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.imageNames_off = [NSMutableArray arrayWithObjects:@"subnavi_left_off", @"subnavi_right_off", nil];
//    self.imageNames_on = [NSMutableArray arrayWithObjects:@"subnavi_left_on",  @"subnavi_right_on", nil];
    self.titles = [NSMutableArray arrayWithObjects: @"フォロー", @"フォロワー", nil];

    self.bottom = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
    self.bottom.layer.cornerRadius = 5;
    self.bottom.clipsToBounds = YES;
    [self addSubview:self.bottom];
    
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((i *(CON_WIDTH - 20) / 2), 0, (CON_WIDTH - 20) / 2 - 1, self.frame.size.height - 20);
        button.tag = 30303 + i;
        button.backgroundColor = SystomoTabColorOff;
//        [button setBackgroundImage:[UIImage imageNamed:self.imageNames_off[i]] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%ld %@", (long)0, self.titles[i]] forState:UIControlStateNormal];
        if (CON_HEIGHT > 735.f) {
            button.titleLabel.font = FONT_SIZE_6(17.f);
        } else {
            button.titleLabel.font = FONT_SIZE_6(13.f);
        }
        
        if (i != 0) {
            // 线
            UIView *Vertical = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, 1, self.frame.size.height - 20)];
            Vertical.backgroundColor = [UIColor whiteColor];
            [button addSubview:Vertical];
        }
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom addSubview:button];
    }
    // 线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, CON_WIDTH, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
}

- (void)setBtnNumber:(NSMutableArray *)btnNumber
{
    if (_btnNumber != btnNumber) {
        _btnNumber = btnNumber;
    }
    for (int i = 0; i < 2; i ++) {
        UIButton *button = (UIButton *)[self viewWithTag:30303 + i];
        [button setTitle:[NSString stringWithFormat:@"%@ %@", self.btnNumber[i], self.titles[i]] forState:UIControlStateNormal];
    }
}

- (void)buttonAction:(UIButton *)sender
{
    // 改变背景图片
    for (UIButton *button in [self.bottom subviews]) {
        [button setBackgroundColor:SystomoTabColorOff];
    }
//    for (int i = 0; i < 2; i ++) {
//        UIButton *button = (UIButton *)[self viewWithTag:30303 + i];
//        [button setBackgroundColor:SystomoTabColorOff];
////        [button setBackgroundImage:[UIImage imageNamed:self.imageNames_off[i]] forState:UIControlStateNormal];
//    }
    [sender setBackgroundColor:SystomoTabColorOn];
//    [sender setBackgroundImage:[UIImage imageNamed:self.imageNames_on[sender.tag - 30303]] forState:UIControlStateNormal];
    // 传值并操作
    self.SelectTableView(sender.tag);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
