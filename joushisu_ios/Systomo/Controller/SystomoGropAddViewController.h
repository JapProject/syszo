//
//  SystomoGropAddViewController.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"

@interface SystomoGropAddViewController : BaseViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, copy)void(^refreshBlock)(void);
@end
