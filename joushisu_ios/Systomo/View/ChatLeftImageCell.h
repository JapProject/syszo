//
//  ChatLeftImageCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/21.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//
/*聊天左侧图片*/
#import <UIKit/UIKit.h>

@interface ChatLeftImageCell : UITableViewCell
/// 用户名
@property (nonatomic, strong)UILabel *name;
/// 图片缩略图
@property (nonatomic, strong)UIImageView *myImageView;
/// 点击图片
@property (nonatomic, copy)void(^clickImageBlock)(void);

@end
