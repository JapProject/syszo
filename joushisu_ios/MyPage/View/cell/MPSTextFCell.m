//
//  MPSTextFCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/22.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MPSTextFCell.h"

@interface MPSTextFCell ()

@end

@implementation MPSTextFCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.passWordTitle = [[UILabel alloc] init];
        [self.contentView addSubview:self.passWordTitle];
        
        self.textField = [[UITextField alloc] init];
        [self.contentView addSubview:self.textField];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.formail) {
        self.passWordTitle.frame = CGRectMake(20, 10, CELL_WIDTH -20 - 20, 30);
        self.passWordTitle.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
        self.passWordTitle.font = FONT_SIZE_6(16.f);
        
        self.textField.frame = CGRectMake(20 , 40, CELL_WIDTH - 20 - 20, 30);
        self.textField.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
        self.textField.font = FONT_SIZE_6(14.f);
        // 全变成小星星
        self.textField.secureTextEntry = NO;
        // 再次编辑时内容清空
        self.textField.clearsOnBeginEditing = YES;
        // 清除按钮
        self.textField.clearButtonMode = UITextFieldViewModeAlways;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20 , 10 + 80 - 20, CELL_WIDTH - 20 - 20, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
    }
    else {
        self.passWordTitle.frame = CGRectMake(20, 10, 90, CELL_HEIGHT - 20);
        self.passWordTitle.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
        self.passWordTitle.font = FONT_SIZE_6(10.f);
        
        self.textField.frame = CGRectMake(20 + 90 + 5, 10, CELL_WIDTH - 20 - 90 - 5 - 20, CELL_HEIGHT - 20);
        self.textField.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
        self.textField.font = FONT_SIZE_6(17.f);
        // 全变成小星星
        self.textField.secureTextEntry = YES;
        // 再次编辑时内容清空
        self.textField.clearsOnBeginEditing = YES;
        // 清除按钮
        self.textField.clearButtonMode = UITextFieldViewModeAlways;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20 + 165 + 5, 10+CELL_HEIGHT - 20, CELL_WIDTH - 20 - 165 - 5 - 20, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
    }
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
