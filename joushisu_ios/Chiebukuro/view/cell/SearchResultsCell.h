//
//  SearchResultsCell.h
//  joushisu_ios
//
//  Created by 常宽 on 15/4/28.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsCell : UITableViewCell

@property (nonatomic, strong)UIImageView *rankingImage; // 排名的图片
@property (nonatomic, strong)UILabel *rankingNumder;    // 排名的号
@property (nonatomic, strong)UILabel *details;          // 详情
@property (nonatomic, assign)NSInteger count;

@end
