//
//  SystterList.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/25.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface SystterList : BaseModel
@property (nonatomic, assign) NSInteger bird_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic) BOOL vip_flg;
@end
