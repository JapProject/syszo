//
//  SystterInfoList.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/25.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface SystterInfoList : BaseModel
//姓名
@property (nonatomic, strong) NSString *user_name;

@property (nonatomic)   NSInteger vip_flg;
//ID
@property (nonatomic, assign) NSInteger user_id;
//时间
@property (nonatomic, strong) NSString *time;
//详情
@property (nonatomic, strong) NSString *content;
//是否点赞 1无 2有
@property (nonatomic, assign) NSInteger if_good;
//图片
@property (nonatomic, copy) NSString *pic;
@end
