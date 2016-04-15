//
//  RemoveBuddyView.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/29.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoveBuddyView : UIView
@property (nonatomic, copy)NSString *friendId;
/// 返回后换图表
@property (nonatomic, copy)void(^block)();
@end
