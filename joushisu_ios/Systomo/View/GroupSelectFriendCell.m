//
//  GroupSelectFriendCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/12.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "GroupSelectFriendCell.h"
#import "SystomoList.h"

@interface GroupSelectFriendCell ()
/// 好友资料
@property (nonatomic, strong)UIButton *friendData;
/// 好友姓名
@property (nonatomic, strong)UILabel *friendName;
/// 好友是否已被选择过
@property (nonatomic, strong)UIButton *isSelect;
@end

@implementation GroupSelectFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.friendData = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.friendData];
        
        self.friendName = [[UILabel alloc] init];
        [self.contentView addSubview:self.friendName];
        
        self.isSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.isSelect];
        
//        self.countStr = [[NSString alloc] init];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.friendData.frame = CGRectMake(CELL_WIDTH - 100, 7, 69, 30);
    [self.friendData addTarget:self action:@selector(profileAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.friendData setBackgroundImage:[UIImage imageNamed:@"btn_profile_off"] forState:UIControlStateNormal];
    
    self.friendName.frame = CGRectMake(50, 7, 140, 30);
    self.friendName.font = FONT_SIZE_6(15.f);
    self.friendName.textColor = [UIColor colorWithString:@"393a40" alpha:1];
    self.friendName.text = self.model.member_name;
    
    self.isSelect.frame = CGRectMake(10, 8, 30, 30);
    [self.isSelect addTarget:self action:@selector(isSelectAction:) forControlEvents:UIControlEventTouchUpInside];

    if ([self.model.selectCount isEqualToString:@"1"]) {
        [self.isSelect setBackgroundImage:[UIImage imageNamed:@"checkbox_on"] forState:UIControlStateNormal];
    } else {
        [self.isSelect setBackgroundImage:[UIImage imageNamed:@"checkbox_off"] forState:UIControlStateNormal];
    }

    // 线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CELL_HEIGHT - 1, CELL_WIDTH, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
}

- (void)profileAction:(UIButton *)sender
{
    self.profileBlock();
}
- (void)isSelectAction:(UIButton *)sender
{
    if ([self.model.selectCount isEqualToString:@"1"]) {
        /// 已经被选中时,点击被取消
        [self.isSelect setBackgroundImage:[UIImage imageNamed:@"checkbox_off"] forState:UIControlStateNormal];
        self.model.selectCount = [NSString stringWithFormat:@"0"];
        self.disSelectFriendBlock(self.model);
    } else {
        /// 未被选中时,点击被选中
        [self.isSelect setBackgroundImage:[UIImage imageNamed:@"checkbox_on"] forState:UIControlStateNormal];
        self.model.selectCount = [NSString stringWithFormat:@"1"];
        self.selectFriendBlock(self.model);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
