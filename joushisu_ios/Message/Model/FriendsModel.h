//
//  FriendsModel.h
//  joushisu_ios
//
//  Created by zim on 15/6/8.
//  Copyright (c) 2015年 Unite and Grow Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsModel : NSObject
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *insert_time_m;
@property (strong, nonatomic) NSString *minfo_content;
@property (strong, nonatomic) NSString *minfo_img;
@property (strong, nonatomic) NSString *type;
@end
