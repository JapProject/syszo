//
//  ChiebukuroView.h
//  joushisu_ios
//
//  Created by 常宽 on 15/4/29.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChiebukuroView : UIView

///  标题
@property (nonatomic, strong) UILabel *title;

///  提示文字
@property (nonatomic, strong) UILabel *placeholder;

/// 背景边框
@property (nonatomic, strong) UIImageView *backImageView;

/// 输入框
@property (nonatomic, strong) UITextView *textView;
@end
