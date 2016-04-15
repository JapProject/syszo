//
//  QandAViewController.h
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"
#import "ChiebukuroList.h"
@interface QandAViewController : BaseViewController
@property (nonatomic, strong) ChiebukuroList *chieburoList;
// 用于返回后刷新
@property (nonatomic, copy)void(^refreshBlock)(void);

@end
