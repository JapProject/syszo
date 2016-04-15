//
//  MyDataModel.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MyDataEditUpload.h"

@interface MyDataModel : MyDataEditUpload
/// 用户名
@property (nonatomic, copy)NSString *user_nick;
/// 更新日期
@property (nonatomic, copy)NSString *time;
/// 资料百分比
@property (nonatomic, copy)NSString *scale;

@end
