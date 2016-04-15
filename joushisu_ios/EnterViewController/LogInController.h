//
//  LogInController.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInController : UIViewController

@property (nonatomic, copy)void(^disMiss)(void);
+ (BOOL)saveUserInfo:(UserModel *)userInfo;

@end
