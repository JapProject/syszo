//
//  MessageTableViewCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/29.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()

@end

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.titleLabel];
        
        self.infoLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.infoLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.timeLabel];
        
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(5, 10, CELL_WIDTH - 10, 20);
    self.titleLabel.font = FONT_SIZE_6(16.f);
    
    self.infoLabel.frame = CGRectMake(5, 10 + 20 + 10, CELL_WIDTH - 10, 35);
    self.infoLabel.numberOfLines = 2;
    self.infoLabel.font = FONT_SIZE_6(14.f);
    
    self.timeLabel.frame = CGRectMake(5, CELL_HEIGHT - 5 - 20, CELL_WIDTH - 10, 20);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor colorWithString:@"a7aca9" alpha:1.f];
    self.timeLabel.font = FONT_SIZE_6(13.f);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
