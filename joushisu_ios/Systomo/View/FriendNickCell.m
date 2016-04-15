//
//  FriendNickCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/11.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "FriendNickCell.h"

@interface FriendNickCell ()
///  昵称
@property (nonatomic, strong)UILabel *friName;
///  头像
@property (nonatomic, strong)UIImageView *friImageView;
///  发起会话
@property (nonatomic, strong)UIButton *session;
/////  加为好友
//@property (nonatomic, strong)UIButton *addDuddy;
/////  count
//@property (nonatomic, strong)NSString *isFirend;

@end

@implementation FriendNickCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.dic = [[NSDictionary alloc] init];
        
        self.friName = [[UILabel alloc] init];
        [self.contentView addSubview:self.friName];
        
        self.friImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_username"]];
        [self.contentView addSubview:self.friImageView];
        
        self.addDuddy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:self.addDuddy];
        
        self.session = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.contentView addSubview:self.session];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.friImageView.frame = CGRectMake(10, (CELL_HEIGHT - 20) / 2, 20, 20);
    
    self.friName.frame = CGRectMake(20 + self.friImageView.frame.size.width, (CELL_HEIGHT - 20) / 2, CELL_WIDTH - 60, 20);
    self.friName.font = FONT_SIZE_6(15.f);
    self.friName.text = [self.dic valueForKey:@"name"];
    
    
    self.session.frame = CGRectMake(CELL_WIDTH - 30 - 80, (CELL_HEIGHT-40)/2, 40, 40);
    [self.session setBackgroundImage:[UIImage imageNamed:@"btn_message_off"] forState:UIControlStateNormal];
    [self.session addTarget:self action:@selector(sessionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.addDuddy.frame = CGRectMake(CELL_WIDTH - 20 - 40, (CELL_HEIGHT-40)/2, 40, 40);
    /// 是否是好友, 1是, 2不是
//    NSLog(@"isMember??===%@" ,[self.dic valueForKey:@"isMember"]);
    
    if ([[self.dic valueForKey:@"isMember"] isEqualToString:@"1"]) {
        [self.addDuddy setBackgroundImage:[UIImage imageNamed:@"icon_follow"] forState:UIControlStateNormal];
    } else {
        [self.addDuddy setBackgroundImage:[UIImage imageNamed:@"btn_nofollow_big"] forState:UIControlStateNormal];
    }
    
    [self.addDuddy addTarget:self action:@selector(addDuddyAction:) forControlEvents:UIControlEventTouchUpInside];
    UserModel *user = [UserModel unpackUserInfo];
    
    if ([[self.dic valueForKey:@"rec_id"] isEqualToString:user.user_id]) {
        [self.addDuddy removeFromSuperview];
        [self.session removeFromSuperview];
    }
}
- (void)addDuddyAction:(UIButton *)sender
{
    if (!self.isFirend) {
        self.isFirend = [NSString stringWithString:[self.dic valueForKey:@"isMember"]];
    }
    NSLog(@"isFriend===%@" ,self.isFirend);
    if ([self.isFirend isEqualToString:@"1"]) {
        /// 如果是好友,点击删除好友
        NSLog(@"删除好友");
        self.delDuddyBlock();
    } else {
        /// 如果不是好友,点击添加好友
        self.addDuddyBlock();
        NSLog(@"加好友");
    }
}


- (void)sessionAction:(UIButton *)sender
{
    NSLog(@"发起会话");
    self.sessionBlock();
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
