//
//  FriendNickCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/11.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendNickCell : UITableViewCell

@property (nonatomic, copy)NSDictionary *dic;
/// 删除好友
@property (nonatomic, copy)void(^delDuddyBlock)();
/// 添加好友
@property (nonatomic, copy)void(^addDuddyBlock)();
/// 发起会话
@property (nonatomic, copy)void(^sessionBlock)();

///  加为好友
@property (nonatomic, strong)UIButton *addDuddy;
///  count
@property (nonatomic, strong)NSString *isFirend;

@end
