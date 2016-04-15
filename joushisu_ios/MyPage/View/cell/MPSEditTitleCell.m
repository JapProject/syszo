//
//  MPSEditTitleCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/22.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MPSEditTitleCell.h"

@implementation MPSEditTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        self.maileLabel = [[UILabel alloc] init];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.formail) {
        self.titleLabel.frame = CGRectMake(20, 10, CELL_WIDTH - 40, 30);
        self.titleLabel.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
        self.titleLabel.font =  FONT_SIZE_6(16.f);
        
        self.maileLabel.frame = CGRectMake(20, 40, CELL_WIDTH - 40, 30);
        self.maileLabel.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
        self.maileLabel.font =  FONT_SIZE_6(14.f);
        [self.contentView addSubview:self.maileLabel];
    }
    else {
        self.titleLabel.frame = CGRectMake(20, 10, CELL_WIDTH - 40, CELL_HEIGHT - 20);
        self.titleLabel.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
        self.titleLabel.font =  FONT_SIZE_6(14.f);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
