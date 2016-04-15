//
//  SystomoGropCell.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoGropCell.h"

@implementation SystomoGropCell
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.userImage.frame = CGRectMake(10, 8, 30, 30);
    self.enterImage.frame = CGRectMake(CELL_WIDTH - 30, 12, 13, 20);
    self.titleLabel.frame = CGRectMake(50, 7, 150, 30);
    self.line.frame = CGRectMake(0, CELL_HEIGHT - 1, CELL_WIDTH, 1);
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userImage];
        

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = FONT_SIZE_6(15.f);
        [self.contentView addSubview:self.titleLabel];
        
        self.enterImage = [[UIImageView alloc] init];
        self.enterImage.image = [UIImage imageNamed:@"arrowRight"];
        [self.contentView addSubview:self.enterImage];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222/ 255.0 alpha:1];
        [self.contentView addSubview:self.line];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
