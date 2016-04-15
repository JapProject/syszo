//
//  SystomoSelectGoodFirendCell.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/8.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystomoSelectGoodFirendCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *proFileBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, copy) void(^proFileAction)();

@end
