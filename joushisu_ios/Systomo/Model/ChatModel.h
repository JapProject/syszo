//
//  ChatModel.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/22.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface ChatModel : BaseModel
//消息类型 1群聊 2单聊
@property (nonatomic, strong) NSString *info_type;
//消息内容
@property (nonatomic, strong) NSString *info_content;
//消息图片
@property (nonatomic, strong) NSString *info_img;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *info_time;
/// 发送者的id
@property (nonatomic, copy) NSString *user_id;

/// 本地图片
@property (nonatomic, strong) UIImage *send_Image;

@end
