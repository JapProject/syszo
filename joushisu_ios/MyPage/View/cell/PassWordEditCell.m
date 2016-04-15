//
//  PassWordEditCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/8.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "PassWordEditCell.h"

@interface PassWordEditCell ()
@property (nonatomic, retain)UILabel *explainTitle; /// 说明

@property (nonatomic, retain)UITextField *textField;    /// 输入

@end

@implementation PassWordEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
