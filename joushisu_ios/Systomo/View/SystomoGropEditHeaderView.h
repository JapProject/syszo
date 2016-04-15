//
//  SystomoGropEditHeaderView.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/13.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystomoGropEditHeaderView : UIView
@property (nonatomic, strong) UILabel *gropNameLabel;
@property (nonatomic, strong) UIButton *gropImageView;
@property (nonatomic, strong) UILabel *explainLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *leaveBtn;
@property (nonatomic, copy) void(^leaveAction)();
@property (nonatomic, copy) void(^addPeopleAction)();
@property (nonatomic, copy) void(^gropChangeImageAction)();
@end
