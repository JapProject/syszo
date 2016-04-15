//
//  ChiebukuroInfoList.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/25.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface ChiebukuroInfoList : BaseModel
//发布者ID
@property (nonatomic, assign) NSInteger user_id;
//姓名
@property (nonatomic, strong) NSString *user_name;
//时间
@property (nonatomic, strong) NSString *time;
//内容
@property (nonatomic, strong) NSString *content;
//是否赞过
@property (nonatomic, assign) NSInteger good;
@end
