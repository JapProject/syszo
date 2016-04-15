//
//  SysteerEditInfoViewController.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/25.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"
@class SystterInfoList;
@interface SysteerEditInfoViewController : BaseViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (nonatomic, strong) UITextView *textField;
@property (nonatomic, strong) NSString *postImage;
@property (nonatomic, strong) NSData *imageData;
//图片绝对路径
@property (nonatomic, strong) NSString *data;
//错误信息
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSString *postStr;

// 编辑时要传的值
@property (nonatomic, strong) SystterInfoList *model;
@property (nonatomic, strong) NSString *bird_id;


// 用于返回后刷新
@property (nonatomic, copy)void(^refreshEditBlock)(void);
@end
