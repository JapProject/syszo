//
//  ChatRightImageCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/21.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "ChatRightImageCell.h"

@implementation ChatRightImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.myImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.myImageView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.myImageView.frame = CGRectMake(CELL_WIDTH - (CELL_WIDTH / 3 * 2) - 25, 25 + 10, CELL_WIDTH / 3 * 2, 150);
    self.myImageView.clipsToBounds = YES;
    self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.myImageView.layer.cornerRadius = 5;
    self.myImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageAction:)];
    [self.myImageView addGestureRecognizer:tap];
    
}
- (void)clickImageAction:(UIButton *)sender
{
    NSLog(@"点击图片");
    self.clickImageBlock();
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
