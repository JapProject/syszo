//
//  QHeaderModel.h
//  joushisu_ios
//
//  Created by 常宽 on 15/4/28.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface QHeaderModel : BaseModel
/// 内容
@property (nonatomic, strong)NSString *content;
/// 日期时间
@property (nonatomic, strong)NSString *time;
/// 标题
@property (nonatomic, strong)NSString *title;
/// 用户id
@property (nonatomic, strong)NSString *user_id;
/// 用户名
@property (nonatomic, strong)NSString *user_name;
/// 评论数
@property (nonatomic, strong)NSString *comment_sum;
/// 图片地址
@property (nonatomic, strong)NSString *info_img;
//是否点赞
@property (nonatomic, assign)NSInteger if_good;
@property (nonatomic, assign)NSInteger topicID;
@end
