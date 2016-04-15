//
//  SystomoGropEditViewController.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/13.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"
#import "SystomoList.h"
@interface SystomoGropEditViewController : BaseViewController
@property (nonatomic, strong) SystomoList *model;
@property (nonatomic, strong) NSMutableArray *tableArr;

/// 返回后刷新
@property (nonatomic, copy)void(^refreshBlock)(void);

@end
