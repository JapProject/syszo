//
//  SystomoGropEditHeaderView.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/13.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoGropEditHeaderView.h"

@implementation SystomoGropEditHeaderView
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gropImageView.frame = CGRectMake(10, 10, 80, 80);
    self.gropNameLabel.frame = CGRectMake(105, 30, 160, 40);
    self.explainLabel.frame = CGRectMake(0, 100, CON_WIDTH, 20);
    self.addBtn.frame = CGRectMake(0, 120, CON_WIDTH, 40);
    self.leaveBtn.frame = CGRectMake(CON_WIDTH - 70, 60, 60, 30);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.gropImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.gropImageView addTarget:self action:@selector(newGroupImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.gropImageView];
        
        
        self.gropNameLabel = [[UILabel alloc] init];
        self.gropNameLabel.textColor = DarkGreen;
        self.gropNameLabel.font = FONT_SIZE_6(17.f);
        [self addSubview:self.gropNameLabel];
        
        self.leaveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.leaveBtn setBackgroundImage:[UIImage imageNamed:@"btn_withdraw_off"] forState:UIControlStateNormal];
        [self.leaveBtn addTarget:self action:@selector(leaveBtnAction1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leaveBtn];
        
        
        self.explainLabel = [[UILabel alloc] init];
        self.explainLabel.text = @"  メンバー";
        self.explainLabel.font = FONT_SIZE_6(15.f);
        self.explainLabel.backgroundColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222/ 255.0 alpha:1];
        self.explainLabel.textColor = Ashen;
        [self addSubview:self.explainLabel];
        
        self.addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        UIImage *addmemmber = [[UIImage imageNamed:@"icon_addmemmber"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.addBtn setImage:addmemmber forState:UIControlStateNormal];
        [self.addBtn setTitle:@" 編集" forState:UIControlStateNormal];
        [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.addBtn.titleLabel.font = FONT_SIZE_6(15.f);
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"btn_green_off"] forState:UIControlStateNormal];

        [self.addBtn addTarget:self action:@selector(addPeopleAction1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addBtn];
        
        
    }
    return self;
}
- (void)newGroupImage {
    self.gropChangeImageAction();
}

- (void)addPeopleAction1:(UIButton *)button
{
    self.addPeopleAction();
}
- (void)leaveBtnAction1:(UIButton *)button
{
    self.leaveAction();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
