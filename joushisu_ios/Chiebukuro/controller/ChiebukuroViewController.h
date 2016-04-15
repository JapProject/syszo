//
//  ChiebukuroViewController.h
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectHeaderView.h"    // 选择表头视图
#import "QandAViewController.h" // 进入Q&A页
#import "ChiebukuroListCell.h"
#import "SysteerSearchViewController.h"
#import "ChiebukuroEditInfoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ChiebukuroList.h"
#import "UrgentViewController.h"

@interface ChiebukuroViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tabelArr;
@property (nonatomic, strong) NSString *selectCount;
@property (nonatomic, strong) NSString *pageNumder1;
@property (nonatomic, strong) NSString *pageNumder2;
@property (nonatomic, strong) NSString *pageNumder3;
@end
