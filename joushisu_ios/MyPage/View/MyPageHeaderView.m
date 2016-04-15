//
//  MyPageHeaderView.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/4.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MyPageHeaderView.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@interface MyPageHeaderView ()
///  饼图
@property (nonatomic, strong)UIImageView *imageView;
/////  最終更新
//@property (nonatomic, strong)UILabel *update;
/// 完成度
@property (nonatomic, strong)UILabel *completeness; //日语
@property (nonatomic, strong)UILabel *completeness2;
/// 百分比
//@property (nonatomic, strong)UILabel *numder;   // 数字
@property (nonatomic, strong)UILabel *symbol;   // 百分比符号
@end
@implementation MyPageHeaderView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        self.update = [[UILabel alloc] init];
        [self addSubview:self.update];
        
        self.completeness = [[UILabel alloc] init];
        [self addSubview:self.completeness];
        
        self.completeness2 = [[UILabel alloc] init];
        [self addSubview:self.completeness2];
                
        self.numder = [[UILabel alloc] init];
        [self addSubview:self.numder];
        
        self.symbol = [[UILabel alloc] init];
        [self addSubview:self.symbol];
    }
    return self;
}

- (void)layoutSubviews
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor whiteColor];
    [super layoutSubviews];
    
    
    self.imageView.frame = CGRectMake(10, 10, (HEIGHT - 20) / 124 * 148, HEIGHT - 20);
    self.imageView.image = [UIImage imageNamed:@"illust_perfection"];
    
    self.update.frame = CGRectMake(WIDTH/5*2, 10, WIDTH/5*3 -10, 14);
    self.update.textAlignment = NSTextAlignmentRight;
    self.update.font = FONT_SIZE_6(14.f);
    self.update.textColor = [UIColor colorWithString:@"a7aca9" alpha:1];
    
    self.numder.frame = CGRectMake(WIDTH - 110 - 35, HEIGHT - 10 - 50, 110, 50);
    self.numder.text = @"0";
    self.numder.textAlignment = NSTextAlignmentRight;
    self.numder.font =[UIFont fontWithName:@"HiraSansOldStd-W6" size:50];
    self.numder.textColor = [UIColor colorWithString:@"5fa6ca" alpha:1];
    
    self.symbol.frame = CGRectMake(WIDTH  - 35, HEIGHT - 10 - 35, 35, 35);
    self.symbol.textAlignment = NSTextAlignmentRight;
    self.symbol.text= @"%";
    self.symbol.font = FONT_SIZE_6(35.f);
    self.symbol.textColor = [UIColor colorWithString:@"8b8a85" alpha:1];
    
    self.completeness.frame = CGRectMake((HEIGHT - 10) / 124 * 148 - 10, HEIGHT - 10 - 35, WIDTH - self.imageView.frame.origin.x - self.imageView.frame.size.width - self.numder.frame.size.width, 11);
    self.completeness.text = @"プロフィール";
//    self.completeness.backgroundColor = [UIColor redColor];
    self.completeness.textAlignment = NSTextAlignmentCenter;
    self.completeness.font = [UIFont systemFontOfSize:11];
    self.completeness.textColor = [UIColor colorWithString:@"8b8a85" alpha:1];
    
    self.completeness2.frame = CGRectMake((HEIGHT - 10) / 124 * 148 - 10,  HEIGHT - 10 - 24, WIDTH - self.imageView.frame.origin.x - self.imageView.frame.size.width - self.numder.frame.size.width, 19);
    self.completeness2.text = @"完成度";
//    self.completeness2.backgroundColor = [UIColor greenColor];
    self.completeness2.textAlignment = NSTextAlignmentCenter;
    self.completeness2.font = FONT_SIZE_6(19.f);
    self.completeness2.textColor = [UIColor colorWithString:@"8b8a85" alpha:1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
