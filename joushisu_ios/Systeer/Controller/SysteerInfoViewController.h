//
//  SysteerInfoViewController.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"
#import "SystterList.h"
@interface SysteerInfoViewController : BaseViewController
@property (nonatomic, strong) SystterList *systeerList;
@property (nonatomic, copy) void(^refreshBlock)(void);
@end
