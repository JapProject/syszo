//
//  AnswerCellOne.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/4.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "AnswerCellOne.h"
#import "UIView UIViewSAAdditions.h"
@interface AnswerCellOne ()
@property (nonatomic, strong)UIView *line;
@end

@implementation AnswerCellOne
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.asImage = [[UIImageView alloc] init];
        self.asImage.image = [UIImage imageNamed:@"icon_answer"];
        [self.contentView addSubview:self.asImage];
        
        self.userImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.userImage];
        
        
        self.userLabel = [[UILabel alloc] init];
        self.userLabel.font = FONT_SIZE_6(13.f);
        [self.contentView addSubview:self.userLabel];
//        self.userLabel.backgroundColor = [UIColor redColor];
       
        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.font = FONT_SIZE_6(15.f);
        self.dayLabel.textColor = Ashen;
        [self.contentView addSubview:self.dayLabel];
        
        self.infoLabel = [[UITextView alloc] init];
//        self.infoLabel.font = FONT_SIZE_6(22.f);
//        self.infoLabel.font = [UIFont fontWithName:@"HiraSansOldStd-W6" size:22.f];
//        self.infoLabel.textColor = DarkGreen;
//        self.infoLabel.textColor = [UIColor yellowColor];
        self.infoLabel.editable = NO;
        self.infoLabel.scrollEnabled = NO;
        self.infoLabel.dataDetectorTypes = UIDataDetectorTypeLink;

//        self.infoLabel.numberOfLines = 0;
//        self.infoLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.infoLabel];
        


        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"btn_edit"] forState:UIControlStateNormal];
        [self.editBtn addTarget:self action:@selector(buttonEdit:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.editBtn];
        
        
        self.delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.delBtn setBackgroundImage:[UIImage imageNamed:@"btn_del"] forState:UIControlStateNormal];
        [self.delBtn addTarget:self action:@selector(buttonDel:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.delBtn];

        
        self.line = [[UIView alloc] init];
        self.line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.line];
        
    }
    
    return self;
}




- (void)setUPs{
    [self.asImage setFrame:CGRectMake(7, 9, 50, 13)];
    [self.userImage setFrame:CGRectMake(7, 25, 15, 20)];
    [self.userLabel setFrame:CGRectMake(28, 26, 142, 21)];
    [self.dayLabel setFrame:CGRectMake(CON_WIDTH - 155, 8, 155, 21)];
    
    self.dayLabel.text = self.model.comments_time;
    self.infoLabel.text = self.model.comments;
    
    
    //        UILabel设置行间距等属性：
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.infoLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:LineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.infoLabel.text.length)];
    [attributedString addAttribute: NSForegroundColorAttributeName value: DarkGreen range: NSMakeRange(0, self.infoLabel.text.length)];
//    self.infoLabel.backgroundColor = [UIColor redColor];
    self.infoLabel.attributedText = attributedString;
    
    self.userLabel.text = self.model.user_name;
    
    //    CGSize stringSize = [self sizeWithString:self.infoLabel.text font:FONT_SIZE_6(23.f)];
       [self.infoLabel sizeToFit];
    [self.infoLabel setFrame:CGRectMake(8, 48, CELL_WIDTH - 16,self.infoLabel.height + 5)];
 
    self.userLabel.textColor = Yellow;
    self.userImage.image = [UIImage imageNamed:@"icon_user_on"];
    
    self.editBtn.frame = CGRectMake(CON_WIDTH - 90, self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + 8, 28, 28);
    self.delBtn.frame = CGRectMake(CON_WIDTH - 50, self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + 8, 28, 28);
    
    [self.line setFrame:CGRectMake(0, self.delBtn.bottom + 5, CELL_WIDTH, 1)];
    self.line.backgroundColor = [UIColor lightGrayColor];
    
    self.infoLabel.font = FONT_SIZE_6(15.f);
    
    self.cellH = self.delBtn.bottom + 5 ;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
    
}
- (void)buttonEdit:(UIButton *)button
{
    self.editAction();
}
- (void)buttonDel:(UIButton *)button
{
    self.delAction();
}

// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CON_WIDTH - 20, 10000)//限制最大的宽度和高度
                                       options:
                   NSStringDrawingTruncatesLastVisibleLine
                   //                   NSStringDrawingUsesFontLeading
                   | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font.pointSize]}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

#pragma  mark 姓名点击事件
- (void)tapDidAction{
    self.didUserName();
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
