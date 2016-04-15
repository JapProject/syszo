//
//  NavbarView.h
//  joushisu_ios
//
//  Created by 常宽 on 15/4/28.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavbarView : UIView

@property (nonatomic, strong)UIImageView *titleImage;
@property (nonatomic, strong)UILabel *titleName;
/// 创建单例实例
+ (instancetype)sharedInstance;

/// 方法赋值
- (void)setTitleImage:(NSString *)ImageName titleName:(NSString *)titleName;

@end
