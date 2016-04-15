//
//  DetailsHeadView.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/31.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SystterInfoList;

@interface DetailsHeadView : UIView

/// 传进来参数
@property (nonatomic, strong)SystterInfoList *InfoModel;
/// 点赞的实现
@property (nonatomic, copy)void(^goodActionBlock)();
/// 删除的实现
@property (nonatomic, copy)void(^deleteActionBlock)();

@property (copy, nonatomic) void (^tapUserName)();
/// 内容
@property (nonatomic, strong) UITextView *infoLabel;
@end
