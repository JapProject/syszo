//
//  ChiebukuroEditInfoViewController.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/27.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"
@class QHeaderModel;
@interface ChiebukuroEditInfoViewController : BaseViewController <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITextField *quText;
@property (nonatomic, strong) UITextView *awText;
@property (nonatomic, strong) NSString *quStr;
@property (nonatomic, strong) NSString *awStr;
@property (nonatomic, assign) BOOL urgent;
/// 编辑时需要的model类
@property (nonatomic, strong) QHeaderModel *model;
/// 编辑时还需要know_id
@property (nonatomic, strong) NSString *know_id;

// 用于返回后刷新
@property (nonatomic, copy)void(^refreshEditBlock)(void);
@end
