//
//  SearchResultPeopelViewController.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/13.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchResultPeopelViewController : BaseViewController
@property (nonatomic, strong) NSString *cat_id;

/// 把网址传进去
//@property (nonatomic, copy) NSString *urlString;

/// 把大类型出过去.上面那条作废
@property (nonatomic, copy) NSString *urlType;

/// 返回刷新
@property (nonatomic, copy) void(^block)(void);

@end
