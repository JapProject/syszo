//
//  UserModel.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
// 协议方法
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // 编码的方法 将对象的所有数据写到一起 方便存储
    // 将某一条数据编码
    [aCoder encodeObject:self.user_name forKey:@"name"];
    [aCoder encodeObject:self.user_password forKey:@"password"];
    [aCoder encodeObject:self.user_id forKey:@"numder"];
    [aCoder encodeObject:self.user_email forKey:@"email"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        // 解码的方法~
        self.user_name = [aDecoder decodeObjectForKey:@"name"];
        self.user_password = [aDecoder decodeObjectForKey:@"password"];
        self.user_id = [aDecoder decodeObjectForKey:@"numder"];
        self.user_email = [aDecoder decodeObjectForKey:@"email"];
    }
    return self;
}

/// 解档方法
+ (UserModel *)unpackUserInfo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths lastObject];
    NSString *userInfoPath = [documentPath stringByAppendingPathComponent:@"userInfo.xml"];
    
    NSString *path2 = NSTemporaryDirectory();
    NSString *userInfoPath2 = [path2 stringByAppendingPathComponent:@"userInfo.xml"];
    
    // 反归档类
    UserModel *userBack = [NSKeyedUnarchiver unarchiveObjectWithFile:userInfoPath];
    if (!userBack) {
        userBack = [NSKeyedUnarchiver unarchiveObjectWithFile:userInfoPath2];
    }
//    NSLog(@"%@", userBack.user_name);
    return userBack;
}

@end
