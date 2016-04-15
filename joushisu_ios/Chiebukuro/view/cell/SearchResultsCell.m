//
//  SearchResultsCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/4/28.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SearchResultsCell.h"


#define WIDTH self.contentView.frame.size.width
#define HEIGHT self.contentView.frame.size.height


@interface SearchResultsCell ()

@end

@implementation SearchResultsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.rankingImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.rankingImage];
        
        self.rankingNumder = [[UILabel alloc] init];
        [self.rankingImage addSubview:self.rankingNumder];
        
        self.details = [[UILabel alloc] init];
        [self.contentView addSubview:self.details];
    }
    return self;
}

static NSInteger iCount = 0;
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (iCount == 0) {
        [self ceateKeyWordSubViews];
    } else {
        [self ceateSubViews];
    }
    
}


- (void)ceateKeyWordSubViews
{
//    NSLog(@"0");
    self.rankingImage.frame = CGRectMake(10, 11, 25, 25);
    self.rankingNumder.frame = CGRectMake(0, 5, 25, 15);
    self.rankingNumder.textAlignment = NSTextAlignmentCenter;
    self.rankingNumder.font = FONT_SIZE_6(15.f);
    self.rankingNumder.textColor = [UIColor whiteColor];
    self.details.frame = CGRectMake(55, 16, WIDTH - 110, 20);
    self.details.font = FONT_SIZE_6(15.f);
    self.details.textColor = DarkGreen;
}

- (void)ceateSubViews
{
   // NSLog(@"1");
    self.details.frame = CGRectMake(10, 5, WIDTH - 20, HEIGHT - 8);
    
    self.details.font = FONT_SIZE_6(17.f);
    self.details.textColor = DarkGreen;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
