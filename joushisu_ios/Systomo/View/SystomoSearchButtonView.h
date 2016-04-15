//
//  SystomoSearchButtonView.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/8.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystomoSearchButtonView : UIView
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *buttonLiftOne;
@property (nonatomic, strong) UIButton *buttonRightOne;
@property (nonatomic, strong) UIButton *buttonLiftTwo;
@property (nonatomic, strong) UIButton *buttonRightTwo;
@property (nonatomic, strong) UIButton *buttonLiftThi;
@property (nonatomic, strong) UIButton *buttonRightThi;
@property (nonatomic, copy) void(^ButtonAction)(NSInteger, NSString *);

@end
