//
//  UserModel.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel <NSCopying>
/// 用户名
@property (nonatomic, strong)NSString *user_name;
/// 用户邮箱
@property (nonatomic, strong)NSString *user_email;
/// 用户id
@property (nonatomic, strong)NSString *user_id;
/// 用户密码
@property (nonatomic, strong)NSString *user_password;

/// 解档方法
+ (UserModel *)unpackUserInfo;


@end
