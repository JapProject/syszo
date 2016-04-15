//
//  GlistModel.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/27.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface GlistModel : BaseModel
@property (nonatomic, strong) NSString *ginfo_content;
@property (nonatomic, copy) NSString *ginfo_img;
@property (nonatomic, strong) NSString *ginfo_sum;
@property (nonatomic, strong) NSString *group_id;
@property (nonatomic, strong) NSString *group_name;
@property (nonatomic, strong) NSString *insert_time;
@end
