//
//  SysteerHomeCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/26.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystterList.h"
@interface SysteerHomeCell : UITableViewCell
@property (strong, nonatomic)UILabel *infoLabel;
@property (strong, nonatomic)UILabel *UserName;
@property (strong, nonatomic)UILabel *timeLabel;
@property (nonatomic,strong) UIImageView * isVipIcon;
@property (nonatomic,strong) SystterList * list;

@end
