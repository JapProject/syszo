//
//  MyDataCheckCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/22.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDataCheckCell : UITableViewCell
@property (nonatomic, strong)UITextField *userName;
@property (nonatomic, copy)void(^block)(void);
@end
