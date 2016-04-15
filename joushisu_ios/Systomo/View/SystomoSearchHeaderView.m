//
//  SystomoSearchHeaderView.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoSearchHeaderView.h"

@implementation SystomoSearchHeaderView
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.userImage.frame = CGRectMake(10, 14, 28, 18);
    self.enterImage.frame = CGRectMake(CON_WIDTH - 30, 14, 13, 20);
    self.titleLabel.frame = CGRectMake(50, 7, 140, 30);
    self.line.frame = CGRectMake(0, self.frame.size.height - 1, CON_WIDTH, 1);
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userImage = [[UIImageView alloc] init];
        self.userImage.image = [UIImage imageNamed:@"icon_group_plus"];
        [self addSubview:self.userImage];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = FONT_SIZE_6(17.f);
        self.titleLabel.text = @"グループ作成";
        [self addSubview:self.titleLabel];
        
        self.enterImage = [[UIImageView alloc] init];
        self.enterImage.image = [UIImage imageNamed:@"arrowRight"];
        [self addSubview:self.enterImage];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222/ 255.0 alpha:1];
        [self addSubview:self.line];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
