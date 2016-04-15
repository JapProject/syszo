//
//  BaseModel.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/25.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // 系统的纠错方法,当key值不在类的属性列表的时候,就会调用
}

// 取值的纠错方法
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
