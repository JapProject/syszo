//
//  FriendsDataViewController.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/11.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"

@interface FriendsDataViewController : BaseViewController

/// 好友的id
@property (nonatomic, copy)NSString *member_id;

/// 返回刷新
@property (nonatomic, copy)void(^refreshBlock)(void);
@end
