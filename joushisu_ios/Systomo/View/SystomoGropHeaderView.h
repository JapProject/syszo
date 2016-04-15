//
//  SystomoGropHeaderView.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystomoGropHeaderView : UIView
@property (nonatomic, strong) UITextField *gropNameTextField;
@property (nonatomic, strong) UIButton *gropBtn;
@property (nonatomic, strong) UILabel *explainLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, copy) void(^gropChangeImageAction)();
@property (nonatomic, copy) void(^addPeopleAction)();
@end
