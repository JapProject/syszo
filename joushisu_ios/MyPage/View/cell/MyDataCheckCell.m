//
//  MyDataCheckCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/22.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MyDataCheckCell.h"

@interface MyDataCheckCell ()
//@property (nonatomic, strong)UILabel *userName;
@property (nonatomic, strong)UIImageView *userImage;
@property (nonatomic, strong)UIButton *checkMyself;
@end

@implementation MyDataCheckCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.userName = [[UITextField alloc] init];
        self.userName.borderStyle = UITextBorderStyleRoundedRect;
        [self.contentView addSubview:self.userName];
        
        self.userImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userImage];
        
        self.checkMyself = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:self.checkMyself];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.userImage.image = [UIImage imageNamed:@"icon_myname"];
    self.userImage.frame = CGRectMake(10, (CELL_HEIGHT - 20) / 2, 20, 20);
    
    self.userName.frame = CGRectMake(10 + 20 + 10, (CELL_HEIGHT - 25) / 2, CELL_WIDTH - 30 - 10 - 70, 25);
    self.userName.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
    self.userName.font = FONT_SIZE_6(15.f);
    
    self.checkMyself.frame = CGRectMake(CELL_WIDTH - 50, (CELL_HEIGHT - 40)/2, 40, 40);
    [self.checkMyself setBackgroundImage:[UIImage imageNamed:@"btn_preview_big_off"] forState:UIControlStateNormal];
    [self.checkMyself setBackgroundImage:[UIImage imageNamed:@"btn_preview_big_on"] forState:UIControlStateHighlighted];
    
    [self.checkMyself addTarget:self action:@selector(checkMyselfAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)checkMyselfAction:(UIButton *)sender
{
    NSLog(@"查看列表");
    self.block();
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
