//
//  SystomoSearchTableListViewController.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/12.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"

@interface SystomoSearchTableListViewController : BaseViewController <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchNameText;
@property (nonatomic, strong) NSString *resultName;
@end
