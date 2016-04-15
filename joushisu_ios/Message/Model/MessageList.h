//
//  MessageList.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/12.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface MessageList : BaseModel

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *insert_time_m;
@property (nonatomic, strong) NSString *minfo_content;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, copy) NSString *minfo_img;
@end
