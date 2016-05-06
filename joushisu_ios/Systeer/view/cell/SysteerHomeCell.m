//
//  SysteerHomeCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/26.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SysteerHomeCell.h"

@implementation SysteerHomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.infoLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.infoLabel];
        
        self.isVipIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:self.isVipIcon];
        
        
        self.UserName = [[UILabel alloc] init];
        [self.contentView addSubview:self.UserName];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.infoLabel.frame = CGRectMake(10, 5, CELL_WIDTH - 20, CELL_HEIGHT - 10 - 20);
    self.infoLabel.numberOfLines = 2;
    self.infoLabel.font = FONT_SIZE_6(17.f);
    self.infoLabel.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
    
     self.isVipIcon.image = [UIImage imageNamed:@"icon_vip_on"];
    
    self.UserName.frame = CGRectMake(10, CELL_HEIGHT - 10 - 20, (CELL_WIDTH-20) / 2, 20);
    self.UserName.font = FONT_SIZE_6(13.f);
    self.UserName.textColor = [UIColor colorWithString:@"aca7a9" alpha:1.f];
    self.UserName.textAlignment = NSTextAlignmentLeft;
    
    if(self.list.vip_flg){
        self.isVipIcon.frame = CGRectMake(10, CELL_HEIGHT - 10 - 25, 25, 30);
        self.UserName.frame=CGRectMake(45, CELL_HEIGHT - 10 - 20, (CELL_WIDTH-20) / 2, 20);
        self.isVipIcon.hidden = NO;
    }else{
        self.UserName.frame = CGRectMake(10, CELL_HEIGHT - 10 - 20, (CELL_WIDTH-20) / 2, 20);
        self.isVipIcon.hidden = YES;
    }

    
    
    
    self.timeLabel.frame = CGRectMake(CELL_WIDTH / 2, CELL_HEIGHT - 10 - 20, (CELL_WIDTH-20) / 2, 20);
    self.timeLabel.font = FONT_SIZE_6(13.f);
    self.timeLabel.textColor = [UIColor colorWithString:@"aca7a9" alpha:1.f];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
