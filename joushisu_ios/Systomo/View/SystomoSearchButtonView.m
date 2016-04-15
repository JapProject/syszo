//
//  SystomoSearchButtonView.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/8.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoSearchButtonView.h"

@implementation SystomoSearchButtonView
- (void)layoutSubviews
{
    self.line.frame = CGRectMake(0, 1, CON_WIDTH, 1);
    self.label.frame = CGRectMake(5, 10, 150, 30);
    self.buttonLiftOne.frame = CGRectMake(5, 40, CON_WIDTH / 2 - 5, 50);
    self.buttonRightOne.frame = CGRectMake(CON_WIDTH / 2 + 5, 40, CON_WIDTH / 2 - 10, 50);
    self.buttonLiftTwo.frame = CGRectMake(5, 95, CON_WIDTH / 2 - 5, 50);
    self.buttonRightTwo.frame = CGRectMake(CON_WIDTH / 2 + 5, 95, CON_WIDTH / 2 - 10, 50);
    
    self.buttonLiftThi.frame = CGRectMake(5, 150, CON_WIDTH / 2 - 5, 50);
    self.buttonRightThi.frame = CGRectMake(CON_WIDTH / 2 + 5, 150, CON_WIDTH / 2 - 10, 50);


    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label = [[UILabel alloc] init];
        self.label.textColor = DarkGreen;
        self.label.font = FONT_SIZE_6(17.f);
        self.label.text = @"カテゴリ検索";
        [self addSubview:self.label];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222/ 255.0 alpha:1];
        [self addSubview:self.line];
        
        
        self.buttonLiftOne = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.buttonLiftOne setBackgroundImage:[UIImage imageNamed:@"btn_green_off"] forState:UIControlStateNormal];
        self.buttonLiftOne.titleLabel.font = FONT_SIZE_6(14.f);
        [self.buttonLiftOne setTitle:@"会社規模" forState:UIControlStateNormal];
        self.buttonLiftOne.tag = 101;
        [self.buttonLiftOne addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonLiftOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.buttonLiftOne];
        
        self.buttonRightOne = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.buttonRightOne setBackgroundImage:[UIImage imageNamed:@"btn_green_off"] forState:UIControlStateNormal];
        self.buttonRightOne.titleLabel.font = FONT_SIZE_6(14.f);
        [self.buttonRightOne setTitle:@"役職・役割" forState:UIControlStateNormal];
        self.buttonRightOne.tag = 102;
        [self.buttonRightOne addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonRightOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.buttonRightOne];
        
        self.buttonLiftTwo = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.buttonLiftTwo setBackgroundImage:[UIImage imageNamed:@"btn_green_off"] forState:UIControlStateNormal];
        self.buttonLiftTwo.titleLabel.font = FONT_SIZE_6(14.f);
        [self.buttonLiftTwo setTitle:@"情シス歴" forState:UIControlStateNormal];
        self.buttonLiftTwo.tag = 106;
        [self.buttonLiftTwo addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonLiftTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.buttonLiftTwo];
        
//        self.buttonLiftTwo = [UIButton buttonWithType:UIButtonTypeSystem];
//        [self.buttonLiftTwo setBackgroundImage:[UIImage imageNamed:@"btn_green_off"] forState:UIControlStateNormal];
//        self.buttonLiftTwo.titleLabel.font = FONT_SIZE_6(14.f);
//        [self.buttonLiftTwo setTitle:@"ハードウェア" forState:UIControlStateNormal];
//        self.buttonLiftTwo.tag = 103;
//        [self.buttonLiftTwo addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.buttonLiftTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self addSubview:self.buttonLiftTwo];
//        
//        
//        self.buttonRightTwo = [UIButton buttonWithType:UIButtonTypeSystem];
//        [self.buttonRightTwo setBackgroundImage:[UIImage imageNamed:@"btn_green_off"] forState:UIControlStateNormal];
//        self.buttonRightTwo.titleLabel.font = FONT_SIZE_6(14.f);
//        [self.buttonRightTwo setTitle:@"ソフトウェア" forState:UIControlStateNormal];
//        self.buttonRightTwo.tag = 104;
//        [self.buttonRightTwo addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.buttonRightTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self addSubview:self.buttonRightTwo];
//        
//        
//        self.buttonLiftThi = [UIButton buttonWithType:UIButtonTypeSystem];
//        [self.buttonLiftThi setBackgroundImage:[UIImage imageNamed:@"btn_green_off"] forState:UIControlStateNormal];
//        self.buttonLiftThi.titleLabel.font = FONT_SIZE_6(14.f);
//        [self.buttonLiftThi setTitle:@"保有資格" forState:UIControlStateNormal];
//        self.buttonLiftThi.tag = 105;
//        [self.buttonLiftThi addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.buttonLiftThi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self addSubview:self.buttonLiftThi];
        
//        self.buttonRightThi = [UIButton buttonWithType:UIButtonTypeSystem];
//        [self.buttonRightThi setBackgroundImage:[UIImage imageNamed:@"btn_green_off"] forState:UIControlStateNormal];
//        self.buttonRightThi.titleLabel.font = FONT_SIZE_6(14.f);
//        [self.buttonRightThi setTitle:@"情シス歴" forState:UIControlStateNormal];
//        self.buttonRightThi.tag = 106;
//        [self.buttonRightThi addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.buttonRightThi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self addSubview:self.buttonRightThi];
    }

    return self;
}
- (void)buttonClick:(UIButton *)button{
    NSInteger buttonTag = button.tag;
    NSString *tempStr = button.titleLabel.text;
    self.ButtonAction (buttonTag, tempStr);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
