//
//  MyResumeCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/4.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MyResumeCell.h"


@interface MyResumeCell ()
///// 类别
//@property (nonatomic, strong)UILabel *categoryTitle;
///// 内容
//@property (nonatomic, strong)UILabel *contentTitle;
@end

@implementation MyResumeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.categoryTitle = [[UILabel alloc] init];
        [self.contentView addSubview:self.categoryTitle];
        
        self.contentTitle = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentTitle];
        
        self.myImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.myImage];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.categoryTitle.frame = CGRectMake(5, 5, (CELL_WIDTH - 10) / 5 * 2 - 15, CELL_HEIGHT - 10);
    [self.categoryTitle setBackgroundColor:[UIColor colorWithString:@"8b8a85" alpha:1]];
    self.categoryTitle.font = FONT_SIZE_6(15.f);
    self.categoryTitle.textColor = [UIColor colorWithString:@"ffffff" alpha:1];
    self.categoryTitle.textAlignment = NSTextAlignmentCenter;
    
    self.contentTitle.frame = CGRectMake(10 + (CELL_WIDTH - 10) / 5 * 2, 5, CELL_WIDTH - (10 + (CELL_WIDTH - 10) / 5 * 2) - 5, CELL_HEIGHT - 10);
    self.contentTitle.font = FONT_SIZE_6(15.f);
//    self.contentTitle.text = @"※入力したユーザーは見つかりませんでした。";
    
    self.myImage.frame = CGRectMake(CELL_WIDTH - 10 - 30, (CELL_HEIGHT - 17) / 2, 11, 17);
    
    // 线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CELL_HEIGHT - 1, CELL_WIDTH, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
