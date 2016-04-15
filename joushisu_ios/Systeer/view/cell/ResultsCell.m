//
//  ResultsCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/4/27.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "ResultsCell.h"

@interface ResultsCell ()
@property (nonatomic, strong)UIImageView *cellImageView;

@end

@implementation ResultsCell

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
