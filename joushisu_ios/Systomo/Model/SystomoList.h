//
//  SystomoList.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/11.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface SystomoList : BaseModel

@property (nonatomic, strong) NSString *group_name;
@property (nonatomic, strong) NSString *group_number;
@property (nonatomic, strong) NSString *group_id;
@property (nonatomic, strong) NSString *group_img;
@property (nonatomic, strong) NSString *member_name;
@property (nonatomic, strong) NSString *member_id;

/// 自定义属性用来判断是否被选过了
@property (nonatomic, copy) NSString *selectCount;

@end
