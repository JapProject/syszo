//
//  ChiebukuroCommentsList.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/25.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface ChiebukuroCommentsList : BaseModel
//用户ID
@property (nonatomic, assign) NSInteger user_id;
//用户名
@property (nonatomic, strong) NSString *user_name;
//评论ID
@property (nonatomic, assign) NSInteger comments_id;
//评论时间
@property (nonatomic, strong) NSString *comments_time;
//评论内容
@property (nonatomic, strong) NSString *comments;
//是否赞过
@property (nonatomic, assign) NSInteger if_good;
//是否评论过
@property (nonatomic, assign) NSInteger if_comment;
//是否是自己的信息
@property (nonatomic, assign) NSInteger if_myself;
//点赞数目
@property (nonatomic, assign) NSInteger comment_goods;
@end
