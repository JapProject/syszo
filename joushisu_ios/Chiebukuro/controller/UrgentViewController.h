//
//  UrgentViewController.h
//  joushisu_ios
//
//  Created by zim on 15/6/10.
//  Copyright (c) 2015年 Unite and Grow Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SelectHeaderView.h"    // 选择表头视图
#import "QandAViewController.h" // 进入Q&A页
#import "ChiebukuroListCell.h"
#import "SysteerSearchViewController.h"
#import "ChiebukuroEditInfoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ChiebukuroList.h"

@interface UrgentViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tabelArr;
@property (nonatomic, strong) NSString *selectCount;
@property (nonatomic, strong) NSString *pageNumder1;
@property (nonatomic, strong) NSString *pageNumder2;
@property (nonatomic, strong) NSString *pageNumder3;

@end
