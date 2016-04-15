//
//  MPSEditTableController.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"
@class MyDataEditAddressModel;
@interface MPSEditTableController : BaseViewController

// 传值-网络请求接口
@property (nonatomic, strong)NSString *url;

// 修改后传值
@property (nonatomic, copy)void(^saveBlock)(id a);
@property (strong, nonatomic) NSDictionary *dicId;
@property (assign, nonatomic) NSInteger index;

@end
