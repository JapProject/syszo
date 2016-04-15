//
//  AnswerCellTwo.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/29.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "AnswerCellTwo.h"
#import "ChiebukuroCommentsList.h"
#import "TYAttributedLabel.h"
#import "TYLinkTextStorage.h"
@interface AnswerCellTwo ()<TYAttributedLabelDelegate>
@property (nonatomic, strong) UITextView *infoLabel;
@property (nonatomic, strong)UIView *line;
@property (strong, nonatomic) UIButton *userButton;

//@property (nonatomic, strong) UITextView *infoLabel;

@end

@implementation AnswerCellTwo

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.asImage = [[UIImageView alloc] init];
        self.asImage.image = [UIImage imageNamed:@"icon_answer"];
        [self.contentView addSubview:self.asImage];
        
        self.userImage = [[UIImageView alloc] init];
        self.userImage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:self.userImage];
        
        self.userLabel = [[UILabel alloc] init];
        self.userLabel.font = FONT_SIZE_6(13.f);
        self.userLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:self.userLabel];
        self.userLabel.userInteractionEnabled = YES ;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidAction)];
        //添加手势
        [self.userLabel addGestureRecognizer:tap];

        
        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.font = FONT_SIZE_6(15.f);
        self.dayLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        self.dayLabel.textColor = Ashen;
        [self.contentView addSubview:self.dayLabel];
        
        self.infoLabel = [[UITextView alloc] initWithFrame:CGRectZero];
        self.infoLabel.font = FONT_SIZE_6(15.f);
        self.infoLabel.textColor = DarkGreen;
//        self.infoLabel.dataDetectorTypes = UIDataDetectorTypeLink;
        self.infoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.infoLabel.editable = NO;
         self.infoLabel.dataDetectorTypes = UIDataDetectorTypeLink;

        self.infoLabel.scrollEnabled = NO;
//        self.infoLabel.editable = NO;
//        self.infoLabel.numberOfLines = 0;
//        self.infoLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.infoLabel];
        
        self.goodBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.goodBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:self.goodBtn];
        
        self.likeNumber = [[UILabel alloc] init];
        self.likeNumber.textColor = [UIColor colorWithRed:98 / 255.0 green:137 / 255.0 blue:204 / 255.0 alpha:1];
        [self addSubview:self.likeNumber];
        
        self.line = [[UIView alloc] init];
        self.line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:self.line];
        [self.asImage setFrame:CGRectMake(7, 9, 50, 13)];
        [self.userImage setFrame:CGRectMake(7, 25, 15, 20)];
        [self.userLabel setFrame:CGRectMake(28, 26, 142, 21)];
        [self.dayLabel setFrame:CGRectMake(CELL_WIDTH - 155, 8, 155, 21)];
        
        
    }
    return self;
}

- (void)setUps{
//    [self.asImage setFrame:CGRectMake(7, 9, 50, 13)];
//    [self.userImage setFrame:CGRectMake(7, 25, 15, 20)];
//    [self.userLabel setFrame:CGRectMake(28, 26, 142, 21)];
//    [self.dayLabel setFrame:CGRectMake(CELL_WIDTH - 155, 8, 155, 21)];
    
    self.dayLabel.text = self.model.comments_time;
    self.infoLabel.text = self.model.comments;
//self.infoLabel.textColor = [UIColor redColor];
    //    UILabel设置行间距等属性：
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.infoLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:LineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.infoLabel.text.length)];
     [attributedString addAttribute: NSForegroundColorAttributeName value: DarkGreen range: NSMakeRange(0, self.infoLabel.text.length)];
    self.infoLabel.attributedText = attributedString;
//    self.infoLabel.backgroundColor = [UIColor redColor];
    self.userLabel.text = self.model.user_name;
//    CGSize stringSize = [self sizeWithString:self.infoLabel.text font:FONT_SIZE_6(23.f)];
    CGSize stringSize = [self sizeWithString: self.model.comments font:FONT_SIZE_6(23.f)];
    [self.infoLabel setFrame:CGRectMake(8, 48, CELL_WIDTH - 16, stringSize.height + 25)];
    
    self.goodBtn.frame = CGRectMake(CELL_WIDTH - 90, self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + 8, 80, 28);
    self.userLabel.textColor = DarkGreen;
    self.userImage.image = [UIImage imageNamed:@"icon_user_off"];
    //是否点过赞1没有 2点过
    if (self.model.if_good == 1) {
        [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"btn_iine_off"] forState:UIControlStateNormal];
        [self.goodBtn addTarget:self action:@selector(buttonGood:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.model.if_good == 2) {
        [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"btn_iine_on"] forState:UIControlStateNormal];
        [self.goodBtn addTarget:self action:@selector(buttonGood:) forControlEvents:UIControlEventTouchUpInside];

    }
    self.likeNumber.text = [NSString stringWithFormat:@"%d",(int)self.model.comment_goods];
    self.likeNumber.textAlignment = NSTextAlignmentCenter;
    self.likeNumber.font = FONT_SIZE_7(13.f);
    CGSize size = [self sizeWithString:self.likeNumber.text font:self.likeNumber.font];
    self.goodBtn.frame = CGRectMake(CELL_WIDTH - size.width - 15 - 85, self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + 8, 80, 28);
    self.likeNumber.frame = CGRectMake(CELL_WIDTH - size.width - 15, self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + 8, size.width, 28);
    
//    [self.line setFrame:CGRectMake(0, self.goodBtn.bottom + 5 - 1, CELL_WIDTH, 1)];
    [self.line setFrame:CGRectMake(0, self.goodBtn.bottom + 5 - 1, CELL_WIDTH, 1)];
    self.line.backgroundColor = [UIColor lightGrayColor];
    
    self.infoLabel.font = FONT_SIZE_6(15.f);
//    self.infoLabel.textColor = DarkGreen;
    self.cellH = self.goodBtn.bottom + 5 ;
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//
//}
- (void)buttonGood:(UIButton *)button
{
    self.goodAction();
    UserModel *user = [UserModel unpackUserInfo];
    if (!user) {
        return;
    }
    if (_model.if_good == 1) {
        _model.if_good = 2;
        _model.comment_goods ++;
    }
    else {
        _model.if_good = 1;
        _model.comment_goods --;
    }
}

- (void)likeFail {
    _model.if_good = _model.if_good == 1 ? 2 : 1;
}

- (void)getLikeCount {
    
    if (_model.if_good) {
        //是否点过赞1没有 2点过
        if (self.model.if_good == 1) {
            [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"btn_iine_off"] forState:UIControlStateNormal];
            [self.goodBtn addTarget:self action:@selector(buttonGood:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (self.model.if_good == 2) {
            [self.goodBtn setBackgroundImage:[UIImage imageNamed:@"btn_iine_on"] forState:UIControlStateNormal];
            [self.goodBtn addTarget:self action:@selector(buttonGood:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.likeNumber.text = [NSString stringWithFormat:@"%d",(int)self.model.comment_goods];
        self.likeNumber.textAlignment = NSTextAlignmentCenter;
        self.likeNumber.font = FONT_SIZE_7(13.f);
        CGSize size = [self sizeWithString:self.likeNumber.text font:self.likeNumber.font];
        self.goodBtn.frame = CGRectMake(CELL_WIDTH - size.width - 15 - 85, self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + 8, 80, 28);
        self.likeNumber.frame = CGRectMake(CELL_WIDTH - size.width - 15, self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + 8, size.width, 28);

    }
}

// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
   
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CON_WIDTH - 20, 10000)//限制最大的宽度和高度
                                       options:
                   NSStringDrawingTruncatesLastVisibleLine
                   //                   NSStringDrawingUsesFontLeading
                   | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HiraSansOldStd-W6" size:16.f] }//传人的字体字典
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
