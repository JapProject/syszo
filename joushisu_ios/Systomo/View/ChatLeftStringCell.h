//
//  ChatLeftStringCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/21.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//
/*聊天左侧字符串*/

#import <UIKit/UIKit.h>
#import "ChatModel.h"
@interface ChatLeftStringCell : UITableViewCell
/// 用户名
@property (nonatomic, strong)UILabel *name;
/// 聊天框
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UITextView *content;
/// 时间
@property (nonatomic, strong)UILabel *time;
@property (nonatomic, strong) ChatModel *model;
@property (assign, nonatomic) CGFloat cellH;

@end
