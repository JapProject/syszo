//
//  MessageTableViewCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/29.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *infoLabel;
@property (strong, nonatomic)  UILabel *timeLabel;
@end
