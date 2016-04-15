//
//  FriendDataModel.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/11.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MyDataModel.h"

@interface FriendDataModel : MyDataModel
// 是否是好友 (1是,2不是)
@property (nonatomic, copy)NSString *if_member;
// 好友的邮箱
@property (nonatomic, copy)NSString *user_email;

@end
