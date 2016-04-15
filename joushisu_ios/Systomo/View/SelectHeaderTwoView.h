//
//  SelectHeaderTwoView.h
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectHeaderTwoView : UIView
//@property (nonatomic, strong)NSMutableArray *imageNames_off;    //图片名数组
//@property (nonatomic, strong)NSMutableArray *imageNames_on;
@property (nonatomic, strong)NSMutableArray *titles;        //标题名数组

@property (nonatomic, copy)void(^SelectTableView)(NSInteger);   // 传值并跳转
@property (nonatomic, strong) NSMutableArray *btnNumber;
@end
