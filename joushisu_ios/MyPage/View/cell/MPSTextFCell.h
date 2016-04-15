//
//  MPSTextFCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/22.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPSTextFCell : UITableViewCell
@property (nonatomic, strong)UILabel *passWordTitle;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, assign)BOOL formail;

@end
