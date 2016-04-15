//
//  MPSettingViewController.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/5.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"

@interface MPSettingViewController : BaseViewController

//@property (nonatomic, copy)NSMutableArray *tempArray;

/// 需要返回时执行网络请求刷新数据
@property (nonatomic, copy)void(^reloadDataBlock)();

@end
