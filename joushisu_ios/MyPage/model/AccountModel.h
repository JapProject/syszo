//
//  AccountModel.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/5.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseModel.h"

@interface AccountModel : BaseModel
/// 类别
@property (nonatomic, strong)NSString *categoryText;
/// 内容
@property (nonatomic, strong)NSString *contentText;
@end
