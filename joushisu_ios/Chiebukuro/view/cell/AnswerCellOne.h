//
//  AnswerCellOne.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/4.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChiebukuroCommentsList.h"

@interface AnswerCellOne : UITableViewCell
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UITextView *infoLabel;
@property (nonatomic, strong) UIImageView *userImage;

@property (nonatomic,strong) UIImageView * isVipIcon;
@property (nonatomic, strong) UIImageView *asImage;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) ChiebukuroCommentsList *model;
@property (nonatomic, copy) void (^editAction)();
@property (nonatomic, copy) void (^delAction)();
@property (copy, nonatomic) void(^didUserName)();
@property (assign, nonatomic) NSInteger cellH;
- (void)setUPs;
@end

