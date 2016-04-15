//
//  EnterController.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterController : UIViewController
/// 点击返回时,若没进行过登陆注册操作则返回上一页
@property (nonatomic, copy)void(^comeBackBlock)(void);

@end
