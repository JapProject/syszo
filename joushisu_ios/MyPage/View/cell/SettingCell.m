//
//  SettingCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/5.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell ()
@end

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.settingTitle = [[UILabel alloc] init];
        [self.contentView addSubview:self.settingTitle];
        
        self.arrow = [[UIImageView alloc] init];
        [self.contentView addSubview:self.arrow];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.settingTitle.frame = CGRectMake(10, (CELL_HEIGHT - 15) / 2, CELL_WIDTH - 20 - CELL_HEIGHT, 15);
    self.settingTitle.font = FONT_SIZE_6(15.f);
    self.settingTitle.textColor = [UIColor colorWithString:@"393a40" alpha:1];
    
    self.arrow.frame = CGRectMake(CELL_WIDTH - CELL_HEIGHT + 40, 20, 22 * ((CELL_HEIGHT - 40)/ 34), CELL_HEIGHT - 40);
    self.arrow.image = [UIImage imageNamed:@"arrowRight"];
    
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
