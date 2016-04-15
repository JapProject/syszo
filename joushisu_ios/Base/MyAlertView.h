//
//  MyAlertView.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/5.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SystomoList;
@interface MyAlertView : UIView

///  完成度说明要用到的属性
@property (nonatomic, copy)NSString *string;
///  图片名
@property (nonatomic, strong)SystomoList *groupModel;
///  跳转群组会话
@property (nonatomic, copy)void(^GroupSessionBlock)(void);
///  跳转退会页面
@property (nonatomic, copy)void(^QuitGroupBlock)(void);

@end
