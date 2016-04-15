//
//  ChiebukuroList.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/25.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface ChiebukuroList : BaseModel
//id
@property (nonatomic, assign) NSInteger know_id;
//标题
@property (nonatomic, strong) NSString *title;
//评论总数
@property (nonatomic, assign) NSInteger comment_sum;
//发布时间
@property (nonatomic, retain) NSString *time;
//是否加急 1不加急  2加急
@property (nonatomic, assign) NSInteger urgent;
//是否评论过
@property (nonatomic, assign) NSInteger comments;
@end
