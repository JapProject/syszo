//
//  SystomoGropHeaderView.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoGropHeaderView.h"

@implementation SystomoGropHeaderView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gropBtn.frame = CGRectMake(10, 10, 80, 80);
    self.gropNameTextField.frame = CGRectMake(105, 30, 100, 40);
    self.explainLabel.frame = CGRectMake(0, 100, CON_WIDTH, 20);
    self.addBtn.frame = CGRectMake(0, 120, CON_WIDTH, 45);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.gropBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.gropBtn addTarget:self action:@selector(gropAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.gropBtn];
        
        
        self.gropNameTextField = [[UITextField alloc] init];
        self.gropNameTextField.textColor = DarkGreen;
        self.gropNameTextField.font = FONT_SIZE_6(17.f);
        [self addSubview:self.gropNameTextField];
        
        
        self.explainLabel = [[UILabel alloc] init];
        self.explainLabel.text = @"  メンバー追加";
        self.explainLabel.font = FONT_SIZE_6(15.f);
        self.explainLabel.backgroundColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222/ 255.0 alpha:1];
        self.explainLabel.textColor = Ashen;
        [self addSubview:self.explainLabel];
        
        self.addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage *addmemmber = [[UIImage imageNamed:@"icon_addmemmber"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.addBtn setImage:addmemmber forState:UIControlStateNormal];
        [self.addBtn setTitle:@" 追加" forState:UIControlStateNormal];
        [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.addBtn.titleLabel.font = FONT_SIZE_6(15.f);
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_off"] forState:UIControlStateNormal];
        [self.addBtn addTarget:self action:@selector(addPeopleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addBtn];
        
        
    }
    return self;
}
- (void)gropAction:(UIButton *)button
{
    self.gropChangeImageAction();
}
- (void)addPeopleAction:(UIButton *)button
{
    self.addPeopleAction();
}

//回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
