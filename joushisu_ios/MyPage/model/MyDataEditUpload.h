//
//  MyDataEditUpload.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface MyDataEditUpload : BaseModel

/// 用户id
@property (nonatomic ,copy)NSString *user_id;
/// 性别
@property (nonatomic ,copy)NSString *user_sex;
/// 地址
@property (nonatomic ,copy)NSString *address;
/// 行业
@property (nonatomic ,copy)NSString *industry;
/// 公司规模
@property (nonatomic ,copy)NSString *size_company;
/// 职务
@property (nonatomic ,copy)NSString *job;
/// 注册基金
@property (nonatomic ,copy)NSString *reg_money;
/// 情历基点
@property (nonatomic ,copy)NSString *calendar;
/// 软件
@property (nonatomic ,copy)NSString *software;
/// 硬件
@property (nonatomic ,copy)NSString *hardware;
/// 拥有资格
@property (nonatomic ,copy)NSString *qualified;
/// 全年预算
@property (nonatomic ,copy)NSString *allyear;
/// 人数
@property (nonatomic ,copy)NSString *number;
/// 要价
@property (nonatomic ,copy)NSString *price;
/// 自我介绍
@property (nonatomic ,copy)NSString *introduction;




@end
