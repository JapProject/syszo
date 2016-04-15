//
//  SystomoAddPeopleViewController.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/8.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"

@interface SystomoAddPeopleViewController : BaseViewController

/// 把已经选择的好友传进去
@property (nonatomic, strong) NSMutableArray *friendArray;

/// 把选择后的好友传出来
@property (nonatomic, copy)void(^MyFriendsBlock)(NSMutableArray *);

@end
