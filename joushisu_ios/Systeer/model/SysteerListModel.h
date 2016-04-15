//
//  SysteerListModel.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/31.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface SysteerListModel : BaseModel
/// 评论人的id
@property (nonatomic, copy) NSString *user_id;
/// 评论人名
@property (nonatomic, copy) NSString *user_name;
/// 评论id
@property (nonatomic, copy) NSString *comments_id;
/// 论时间
@property (nonatomic, copy) NSString *comments_time;
/// 内容
@property (nonatomic, copy) NSString *comments;
/// 是否赞过
@property (nonatomic, copy) NSString *if_good;

@end
