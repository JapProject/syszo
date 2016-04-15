//
//  ChatRightImageCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/21.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//
/*聊天右侧的图片*/

#import <UIKit/UIKit.h>

@interface ChatRightImageCell : UITableViewCell

/// 图片缩略图
@property (nonatomic, strong)UIImageView *myImageView;
/// 点击图片
@property (nonatomic, copy)void(^clickImageBlock)(void);

@end
