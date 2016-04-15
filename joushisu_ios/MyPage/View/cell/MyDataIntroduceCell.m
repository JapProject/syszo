//
//  MyDataIntroduceCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/25.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MyDataIntroduceCell.h"

@interface MyDataIntroduceCell ()
@end

@implementation MyDataIntroduceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selfIntroduce = [[UITextView alloc] init];
        [self.contentView addSubview:self.selfIntroduce];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.selfIntroduce.frame = CGRectMake(0, 0, CELL_WIDTH, CELL_HEIGHT);
    self.selfIntroduce.font = FONT_SIZE_6(17.f);
    self.selfIntroduce.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
