//
//  ChiebukuroListCell.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/4.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "ChiebukuroListCell.h"

@implementation ChiebukuroListCell
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.infoLabel.frame = CGRectMake(10, 13, CELL_WIDTH - 20, 51);
    self.chatImageView.frame = CGRectMake(90, CELL_HEIGHT - 25, 17, 17);
    self.chatLabel.frame = CGRectMake(110, CELL_HEIGHT - 25, 50, 17);
    self.timeLabel.frame = CGRectMake(CELL_WIDTH - 150, CELL_HEIGHT - 25, 150, 17);
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.infoLabel = [[UILabel alloc] init];
        self.infoLabel.numberOfLines = 2;
        self.infoLabel.font = FONT_SIZE_6(15.f);
        [self.contentView addSubview:self.infoLabel];
        
        self.chatImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.chatImageView];
        
        self.chatLabel = [[UILabel alloc] init];
        self.chatLabel.font = FONT_SIZE_6(14.f);
        [self.contentView addSubview:self.chatLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = FONT_SIZE_6(14.f);
        [self.contentView addSubview:self.timeLabel];
        

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
