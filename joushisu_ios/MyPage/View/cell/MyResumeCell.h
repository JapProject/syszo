//
//  MyResumeCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/5/4.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyResumeCell : UITableViewCell
/// 类别
@property (nonatomic, strong)UILabel *categoryTitle;
/// 内容
@property (nonatomic, strong)UILabel *contentTitle;
/// 箭头标志
@property (nonatomic, strong)UIImageView *myImage;
@end
