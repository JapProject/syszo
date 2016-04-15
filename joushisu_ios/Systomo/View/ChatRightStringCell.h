//
//  ChatRightStringCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/21.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//
/*聊天右面字符串*/
#import <UIKit/UIKit.h>
#import "ChatModel.h"
@interface ChatRightStringCell : UITableViewCell
@property (nonatomic, strong) ChatModel *model;
/// 时间
@property (nonatomic, strong)UILabel *time;
@property (assign, nonatomic) NSInteger cellH;

@end
