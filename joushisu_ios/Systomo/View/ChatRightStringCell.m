//
//  ChatRightStringCell.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/21.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//
/*聊天右面字符串*/
#import "ChatRightStringCell.h"

@interface ChatRightStringCell ()
/// 聊天框
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UITextView *content;

@end

@implementation ChatRightStringCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backView = [[UIView alloc] init];
        [self.contentView addSubview:self.backView];
        self.backView.backgroundColor = [UIColor colorWithRed:199/255.f green:238/255.f blue:151/255.f alpha:1.f];
        self.backView.layer.cornerRadius = 15;
        self.backView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.backView.clipsToBounds = YES;
        
        self.content = [[UITextView alloc] init];
        self.content.editable = NO ;
        self.content.scrollEnabled = NO;
        [self.backView addSubview:self.content];
        
        self.time = [[UILabel alloc] init];
        self.time.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:self.time];
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(CELL_WIDTH - 25 - 46, 15, 46, 33)];
        backImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        backImage.image = [UIImage imageNamed:@"message_box_right"];
        [self.contentView addSubview:backImage];
        [self.contentView sendSubviewToBack:backImage];
    }
    return self;
}


- (void)setModel:(ChatModel *)model
{
    self.content.font = FONT_SIZE_6(14.f);
    self.content.backgroundColor = [UIColor clearColor];
    self.content.text = model.info_content;
    CGSize size = [self sizeWithString:self.content.text font:self.content.font];
    self.content.frame = CGRectMake(10, 10, size.width + 5, size.height + 10);
    
    
    self.backView.frame = CGRectMake(CELL_WIDTH - size.width - 20 - 32, 15, size.width + 20, size.height + 20);
    
    self.time.frame = CGRectMake(CELL_WIDTH-32 - CELL_WIDTH/2, 15+size.height+20, CELL_WIDTH / 2, 20);
    self.time.textColor = [UIColor colorWithString:@"9c9c9e" alpha:1.f];
    self.time.textAlignment = NSTextAlignmentRight;
    self.time.font = FONT_SIZE_6(8.f);
    self.time.text = model.info_time;
    self.cellH = self.time.bottom;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //    self.content.numberOfLines = 0;
    
}
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
