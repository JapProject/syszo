//
//  MessagesModel.h
//  joushisu_ios
//
//  Created by zim on 15/6/8.
//  Copyright (c) 2015年 Unite and Grow Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagesModel : NSObject
@property (strong, nonatomic) NSString *group_id;
@property (strong, nonatomic) NSString *group_name;
@property (strong, nonatomic) NSString *ginfo_sum;
@property (strong, nonatomic) NSString *ginfo_content;
@property (strong, nonatomic) NSString *ginfo_img;
@property (strong, nonatomic) NSString *insert_time;
@property (strong, nonatomic) NSString *type;
@end
