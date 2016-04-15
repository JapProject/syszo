//
//  GroupSelectFriendCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/12.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SystomoList;
@interface GroupSelectFriendCell : UITableViewCell

/// 传值
@property (nonatomic, strong)SystomoList *model;
@property (nonatomic, copy)NSString *countStr;

/// 点击进入好友详情
@property (nonatomic, copy)void(^profileBlock)(void);
/// 点击将好友添加到群
@property (nonatomic, copy)void(^selectFriendBlock)(SystomoList *);
/// 将好友删除群
@property (nonatomic, copy)void(^disSelectFriendBlock)(SystomoList *);


@end
