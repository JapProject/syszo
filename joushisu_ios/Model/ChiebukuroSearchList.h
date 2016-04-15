//
//  ChiebukuroSearchList.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/25.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface ChiebukuroSearchList : BaseModel
//标题
@property (nonatomic, strong) NSString *title;
//信息ID
@property (nonatomic, assign) NSInteger know_id;
//时间
@property (nonatomic, strong) NSString *time;
@end
