//
//  AnswerCellTwo.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/29.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChiebukuroCommentsList;
@interface AnswerCellTwo : UITableViewCell
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic,strong) UIImageView * isVipIcon;
@property (nonatomic, strong) UIImageView *asImage;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UIButton *goodBtn;
@property (nonatomic, strong) UILabel *likeNumber;           //收藏数目
@property (nonatomic, strong) ChiebukuroCommentsList *model;
@property (nonatomic, copy) void(^goodAction)();
@property (copy, nonatomic) void(^didUserName)();
@property (assign, nonatomic) NSInteger cellH;
- (void)setUps;
- (void)getLikeCount;
- (void)likeFail;
@end
