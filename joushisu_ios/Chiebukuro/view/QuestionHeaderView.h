//
//  QuestionHeaderView.h
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHeaderModel.h"
@interface QuestionHeaderView : UIView
@property (nonatomic, strong)QHeaderModel *model;
@property (nonatomic, strong)UILabel *date;                 // 日期时间
@property (nonatomic, strong)UIImageView *userImageView;    // 用户名_状态图片
@property (nonatomic, strong)UILabel *userName;             // 用户名_用户名
@property (nonatomic, strong)UILabel *questionTitle;        // 问题主题
@property (nonatomic, strong)UITextView *content;              // 问题内容
@property (nonatomic, strong)UIImageView *dataImageView;    // 问题内容图片
@property (nonatomic, strong)UILabel *answerNumder;         // 评论数
@property (nonatomic, strong)UIImageView *answerImage;      // 评论数图片
@property (nonatomic, strong)UIView *line;                  // 线
@property (nonatomic, strong)UIButton *deleteButton;        // 删除按钮
@property (nonatomic, strong)UIButton *likeButton;          //收藏按钮
@property (nonatomic, strong)UILabel *likeNumber;           //收藏数目
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSString *likeCounts;
/// 删除操作
@property (nonatomic, copy)void(^delBlock)();
@property (copy, nonatomic) void (^tapUserName)();
@property (copy, nonatomic) void (^tapLikeButton)();

- (void)getLikeCount;
- (void)likeFail;

@end
