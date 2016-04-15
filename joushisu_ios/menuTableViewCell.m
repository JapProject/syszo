//
//  menuTableViewCell.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "menuTableViewCell.h"

@implementation menuTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

       // self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, 80);
        
        self.titleImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.titleImage];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleImage.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - 1);

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
