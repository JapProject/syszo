//
//  ChatGroupViewController.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/23.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"

@interface ChatGroupViewController : BaseViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//用于发送id 告诉和谁聊天
@property (nonatomic, strong) NSString *group_id;
/// 判断上级页面
@property (nonatomic, strong) NSString *previousPage;

@end
