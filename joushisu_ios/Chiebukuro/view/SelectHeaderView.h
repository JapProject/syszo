//
//  SelectHeaderView.h
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectHeaderView : UIView

/// 传一个值判断是那个页面跳过来的
@property (nonatomic, copy)NSString *viewControllerTag;


//@property (nonatomic, strong)NSMutableArray *imageNames_off;    //图片名数组
//@property (nonatomic, strong)NSMutableArray *imageNames_on; 
//@property (nonatomic, strong)NSMutableArray *titles;        //标题名数组

@property (nonatomic, copy)void(^SelectTableView)(NSInteger);   // 传值并跳转

@end
