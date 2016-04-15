//
//  MultiSelectionTableViewCell.h
//  joushisu_ios
//
//  Created by mac on 15/10/1.
//  Copyright © 2015年 Unite and Grow Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiSelectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addbutton;
@property (strong, nonatomic) UIButton *contentButton;
@property (strong, nonatomic) UIButton *deleteBUtton;
@property (strong, nonatomic) UILabel *contentLable;
@property (assign, nonatomic) BOOL isEditing;

@end
