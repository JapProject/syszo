//
//  ChatLeftStringCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/21.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//
/*聊天左侧字符串*/

#import "ChatLeftStringCell.h"

@interface ChatLeftStringCell ()

@end

@implementation ChatLeftStringCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.name = [[UILabel alloc] init];
        self.name.frame = CGRectMake(35, 5, CELL_WIDTH - 50, 20);
        self.name.textColor = [UIColor colorWithString:@"9c9c9e" alpha:1.f];
        self.name.font = FONT_SIZE_6(10.f);
        [self.contentView addSubview:self.name];
        
        self.backView = [[UIView alloc] init];
        self.backView.backgroundColor = [UIColor colorWithRed:240/255.f green:233/255.f blue:153/255.f alpha:1.f];
        self.backView.layer.cornerRadius = 15;
        self.backView.clipsToBounds = YES;
        [self.contentView addSubview:self.backView];
        
        self.content = [[UITextView alloc] init];
        self.content.editable = NO;
        self.content.scrollEnabled = NO;
        [self.backView addSubview:self.content];
        
        self.time = [[UILabel alloc] init];
        [self.contentView addSubview:self.time];
        UIImageView *userName = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_username"]];
        userName.frame = CGRectMake(15, 5, 20, 20);
        [self.contentView addSubview:userName];
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 25, 46, 33)];
        backImage.image = [UIImage imageNamed:@"message_box_left"];
        [self.contentView addSubview:backImage];
        [self.contentView sendSubviewToBack:backImage];
    }
    return self;
}

- (void)setModel:(ChatModel *)model
{
    _model = model;
    
    self.name.text = model.uname;
    
    
    self.content.font = FONT_SIZE_6(14.f);
    self.content.backgroundColor = [UIColor clearColor];
    self.content.text = model.info_content;
    self.content.editable = NO;
    CGSize size = [self sizeWithString:self.content.text font:FONT_SIZE_6(15.f)];
    self.content.frame = CGRectMake(10, 10, size.width, size.height + 10);
    
    self.backView.frame = CGRectMake(32, 25, size.width + 20, size.height + 20);
    
    self.time.frame = CGRectMake(32, 45+size.height, CELL_WIDTH / 2, 20);
    self.time.textColor = [UIColor colorWithString:@"9c9c9e" alpha:1.f];
    self.time.font = FONT_SIZE_6(8.f);
    self.time.text = model.info_time;
    
    self.cellH = self.time.bottom + 5;
    
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//
//}
// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CELL_WIDTH / 3 * 2, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName:  [UIFont systemFontOfSize:16]}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
