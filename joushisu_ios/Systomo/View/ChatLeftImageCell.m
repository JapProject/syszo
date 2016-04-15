//
//  ChatLeftImageCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/21.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//
/*聊天左侧图片*/
#import "ChatLeftImageCell.h"

@implementation ChatLeftImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.name = [[UILabel alloc] init];
        [self.contentView addSubview:self.name];
        
        self.myImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.myImageView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImageView *userName = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_username"]];
    userName.frame = CGRectMake(15, 5, 20, 20);
    [self.contentView addSubview:userName];
    
    self.name.frame = CGRectMake(35, 5, CELL_WIDTH - 50, 20);
    self.name.textColor = [UIColor colorWithString:@"9c9c9e" alpha:1.f];
    self.name.font = FONT_SIZE_6(10.f);
    
    self.myImageView.frame = CGRectMake(15, 25 + 10, CELL_WIDTH / 3 * 2, 150);
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
