//
//  SystomoCell.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystomoCell : UITableViewCell
@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *enterImage;
@property (nonatomic, strong) UIButton *proFileBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, copy) void(^proFileAction)();

@end
