//
//  AccountCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/5.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "AccountCell.h"
#import "AccountModel.h"
@interface AccountCell ()

/// 类别
@property (nonatomic, strong)UILabel *categoryTitle;
/// 内容
@property (nonatomic, strong)UILabel *contentTitle;
/// 箭头
@property (nonatomic, strong)UIImageView *arrow;


@end

@implementation AccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.categoryTitle = [[UILabel alloc] init];
        [self.contentView addSubview:self.categoryTitle];
        
        self.contentTitle = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentTitle];
        
        self.arrow = [[UIImageView alloc] init];
//        [self.contentView addSubview:self.arrow];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.categoryTitle.frame = CGRectMake(10, 10, (CELL_WIDTH - 20) / 5 * 2, CELL_HEIGHT-20);
    self.categoryTitle.font = FONT_SIZE_6(15.f);
    self.categoryTitle.textColor = [UIColor colorWithString:@"393a40" alpha:1];
    self.categoryTitle.text = self.model.categoryText;
//    self.categoryTitle.backgroundColor = [UIColor cyanColor];
    
    self.contentTitle.frame = CGRectMake(10 + (CELL_WIDTH - 20) / 5 * 2 + 5, 10, ((CELL_WIDTH - 20) / 5 * 3) - 20, CELL_HEIGHT-20);
    self.contentTitle.textAlignment = NSTextAlignmentCenter;
    self.contentTitle.textColor = [UIColor colorWithString:@"393a40" alpha:1];
    self.contentTitle.font = FONT_SIZE_6(15.f);
    self.contentTitle.text = self.model.contentText;
//    self.contentTitle.backgroundColor = [UIColor yellowColor];
    
    self.arrow.frame = CGRectMake(CELL_WIDTH - CELL_HEIGHT + 45, 25, 22 * ((CELL_HEIGHT - 50)/ 34), CELL_HEIGHT - 50);
    self.arrow.image = [UIImage imageNamed:@"arrowRight"];
    
    [self.contentView addSubview:self.arrow];
    
    // 线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CELL_HEIGHT - 2, CELL_WIDTH, 2)];
    line.backgroundColor = [UIColor colorWithString:@"eeeeee" alpha:1];
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
