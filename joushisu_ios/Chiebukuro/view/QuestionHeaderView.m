//
//  QuestionHeaderView.m
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "QuestionHeaderView.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height


@interface QuestionHeaderView ()

@end

@implementation QuestionHeaderView


- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.date = [[UILabel alloc] init];
        [self addSubview:self.date];
//        self.backgroundColor = [UIColor redColor];
        self.line = [[UIView alloc]init];
        [self addSubview:self.line];
        
        self.userImageView = [[UIImageView alloc] init];
        [self addSubview:self.userImageView];
        
        self.isVipIcon = [[UIImageView alloc]init];
        [self addSubview:self.isVipIcon];
        
        self.userName = [[UILabel alloc] init];
        [self addSubview:self.userName];
        self.userName.userInteractionEnabled = YES ;
        UITapGestureRecognizer *userNameDidTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        
        [self.userName  addGestureRecognizer:userNameDidTap];
        
//        self.userName.backgroundColor = [UIColor redColor];

        self.questionTitle = [[UILabel alloc] init];
        [self addSubview:self.questionTitle];

        self.content = [[UITextView alloc] init];
        self.content.editable = NO;
        self.content.scrollEnabled = NO;
        self.content.dataDetectorTypes = UIDataDetectorTypeLink;
        [self addSubview:self.content];

        self.dataImageView = [[UIImageView alloc] init];
        [self addSubview:self.dataImageView];
        
        self.answerImage = [[UIImageView alloc] init];
        [self addSubview:self.answerImage];
        
        self.answerNumder = [[UILabel alloc] init];
        [self addSubview:self.answerNumder];
        
        self.likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.likeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.likeButton];
        
        self.likeNumber = [[UILabel alloc] init];
        self.likeNumber.textColor = [UIColor colorWithRed:98 / 255.0 green:137 / 255.0 blue:204 / 255.0 alpha:1];
        [self addSubview:self.likeNumber];
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self addSubview:self.deleteButton];
        [self.userImageView setFrame:CGRectMake(7, 50, 22*0.8, 32*0.8)];
        [self.date setFrame:CGRectMake(WIDTH - 220, 20, 210, 20)];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
  
//    // 问题内容图片
//    [self dataImageViewCreate];
    // 回答数
    [self answerCreate];
    // 线
    [self.line setFrame:CGRectMake(0, self.frame.size.height - 1, WIDTH, 1)];
    self.line.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark 日期时间
- (void)timeTitle
{
    self.date.textColor = DarkGreen;
    self.date.font = FONT_SIZE_7(15.f);
//    self.date.text = @"2015-04-24   18:07";
    self.date.textAlignment = NSTextAlignmentRight;
}
#pragma mark 用户名
- (void)userNameTitle
{
   //#warning  用户图片可能要判断 icon_user_off、on
    
    self.userImageView.image = [UIImage imageNamed:@"icon_user_off"];
     self.isVipIcon.image = [UIImage imageNamed:@"icon_vip_on"];
  
    if(self.model.vip_flg){
        self.isVipIcon.frame = CGRectMake(40, 48, 25, 30);
        [self.userName setFrame:CGRectMake(2*_userImageView.frame.origin.x+_userImageView.frame.size.width+35, _userImageView.frame.origin.y, WIDTH - (2*_userImageView.frame.origin.x+_userImageView.frame.size.width-35), _userImageView.frame.size.height)];
        self.isVipIcon.hidden = NO;
    }else{
        
        [self.userName setFrame:CGRectMake(2*_userImageView.frame.origin.x+_userImageView.frame.size.width, _userImageView.frame.origin.y, WIDTH - (2*_userImageView.frame.origin.x+_userImageView.frame.size.width), _userImageView.frame.size.height)];
        self.isVipIcon.hidden = YES;
    }

    self.userName.textColor = DarkGreen;
    self.userName.font = FONT_SIZE_6(13.f);
    self.userName.textAlignment = NSTextAlignmentLeft;
    
    //判断主贴发帖人是否是当前用户,显示不同颜色图片和name
    UserModel *user = [UserModel unpackUserInfo];
    if ([self.model.user_id isEqualToString: user.user_id]) {
        self.userImageView.image = [UIImage imageNamed:@"icon_user_on"];
        self.userName.textColor = Yellow;

    }
    
   
    
}
#pragma mark 问题主题
- (void)questionTitleCreate
{
    UIFont *fontTest = FONT_SIZE_6(17.f);
    self.questionTitle.font = fontTest;
    self.questionTitle.textColor = DarkGreen;
    self.questionTitle.numberOfLines = 0;
    [self.questionTitle sizeToFit];
}
#pragma mark 问题内容
- (void)questionContentCreate
{
    UIFont *fontTest = FONT_SIZE_6(15.f);
    self.content.font = FONT_SIZE_6(15.f);
//    self.content.numberOfLines = 0;
//    self.content.backgroundColor = [UIColor cyanColor];
    self.content.textColor = DarkGreen;
    [self.content sizeToFit];
}
// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
//    font.pointSize
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(WIDTH - 20, 10000)//限制最大的宽度和高度
                                       options:
                   NSStringDrawingTruncatesLastVisibleLine //| NSStringDrawingUsesFontLeading
                   |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font.pointSize]}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}
#pragma mark 问题内容图片
- (void)dataImageViewCreateWithImageUrl:(NSString *)image
{
    [self.dataImageView setFrame:CGRectMake(10, _questionTitle.frame.origin.y + _questionTitle.frame.size.height + 10, WIDTH - 20, 200)];
    __block QuestionHeaderView *hearView = self;

    
//    CGSize size = [self sizeWithString:self.content.text font:[UIFont systemFontOfSize:23.f]];
//    [self.dataImageView setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        if (image.size.width != 0 ) {
//            
//            [hearView.dataImageView setFrame:CGRectMake(10, _questionTitle.frame.origin.y + _questionTitle.frame.size.height + 10, WIDTH - 20, image.size.height * ((WIDTH - 20) / image.size.width))];
//            [hearView.content setFrame:CGRectMake(10, _questionTitle.frame.origin.y + _questionTitle.frame.size.height + 10 + self.dataImageView.frame.size.height, WIDTH - 20, hearView.content.height + 20)];
//            [hearView.content sizeToFit];
//            hearView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(hearView.content.frame) + 30);
//            [hearView.tableView reloadData];
//        }
//    }];
}

#pragma mark 回答数
- (void)answerCreate
{
    [self.answerImage setFrame:CGRectMake(10, HEIGHT - 25, 16, 13)];
#warning 品论图片可能要判断 icon_comment_off、on
    self.answerImage.image = [UIImage imageNamed:@"icon_comment_off"];
    
    [self.answerNumder setFrame:CGRectMake(10 + 16, HEIGHT - 25, 80, 13)];
    self.answerNumder.textAlignment = NSTextAlignmentLeft;
    self.answerNumder.font = FONT_SIZE_7(13.f);

    self.likeNumber.textAlignment = NSTextAlignmentCenter;
    self.likeNumber.font = FONT_SIZE_7(13.f);
    CGSize size = [self sizeWithString:self.likeNumber.text font:self.likeNumber.font];
    self.likeButton.frame = CGRectMake(WIDTH - size.width - 15 - 85, HEIGHT - 33, 80, 28);
    self.likeNumber.frame = CGRectMake(WIDTH - size.width - 15, HEIGHT - 33, size.width, 28);
    
    self.deleteButton.frame = CGRectMake(WIDTH - size.width - 15 - 85 - 34, HEIGHT - 33, 28, 28);
}
#pragma mark ---
- (void)setModel:(QHeaderModel *)model
{
    if (_model != model) {
        _model = model;
    }
    
    self.questionTitle.text = model.title;
    [self.questionTitle sizeToFit];
    self.content.text = model.content;
    
    //    UILabel设置行间距等属性：
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.questionTitle.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:LineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.questionTitle.text.length)];
    self.questionTitle.attributedText = attributedString;
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]initWithString:self.content.text];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle1 setLineSpacing:LineSpacing];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, self.content.text.length)];
    self.content.attributedText = attributedString1;
    [self.content sizeToFit];
//    已经写在上面了
//    [self.content sizeToFit];
//    [self.questionTitle sizeToFit];
    UIFont *fontTest = FONT_SIZE_6(18.f);
    CGSize titleSize = [self sizeWithString:self.questionTitle.text font:[UIFont systemFontOfSize:18]];
    
//    [self.questionTitle setFrame:CGRectMake(10, _userImageView.frame.origin.y + 20 + 20, CON_WIDTH - 20 , self.questionTitle.height + 10)];
    [self.questionTitle setFrame:CGRectMake(10, _userImageView.frame.origin.y + 20 + 20, CON_WIDTH - 20 , titleSize.height + 10)];
    self.questionTitle.backgroundColor = [UIColor yellowColor];
    
    

    CGSize size = [self sizeWithString:self.content.text font:FONT_SIZE_6(23.f)];
    if (![_model.info_img  isEqualToString: @""]) {
        [self.content setFrame:CGRectMake(10, _questionTitle.frame.origin.y + _questionTitle.frame.size.height + 10, WIDTH - 20, self.content.height )];
        [self dataImageViewCreateWithImageUrl:_model.info_img];
    } else {
        [self.content setFrame:CGRectMake(10, _questionTitle.frame.origin.y + _questionTitle.frame.size.height + 10, WIDTH - 20, self.content.height )];
    }
    
    
    [self getLikeCount];
    
    self.userName.text = model.user_name;
    self.date.text = model.time;
    self.answerNumder.text = [NSString stringWithFormat:@" %@", model.comment_sum];
    
    /// 创建一个删除按钮
    UserModel *user = [UserModel unpackUserInfo];
    if ([model.user_id isEqualToString: user.user_id]) {
        self.deleteButton.frame = CGRectMake(WIDTH - 28 - 10, _questionTitle.frame.origin.y + _questionTitle.frame.size.height + 10 + self.dataImageView.frame.size.height + self.content.height + 20, 28, 28);
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_del"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteSelf:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.content.font = FONT_SIZE_6(15.f);
    
    
    
    // 日期时间
    [self timeTitle];
    // 用户名
    [self userNameTitle];
    // 问题主题
    [self questionTitleCreate];
    // 问题内容
    [self questionContentCreate];

}

- (void)buttonGood:(UIButton *)button
{
    self.tapLikeButton();
    UserModel *user = [UserModel unpackUserInfo];
    if (!user) {
        return;
    }
    _model.if_good = _model.if_good == 1 ? 2 : 1;
}

- (void)likeFail {
    _model.if_good = _model.if_good == 1 ? 2 : 1;
}

- (void)getLikeCount {
    UserModel *user = [UserModel unpackUserInfo];
    if (![_model.user_id isEqualToString: user.user_id]) {
        if (_model.if_good) {
            //是否点过赞1没有 2点过
            if (self.model.if_good == 1) {
                [self.likeButton setBackgroundImage:[UIImage imageNamed:@"btn_iine_off"] forState:UIControlStateNormal];
                [self.likeButton addTarget:self action:@selector(buttonGood:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (self.model.if_good == 2) {
                [self.likeButton setBackgroundImage:[UIImage imageNamed:@"btn_iine_on"] forState:UIControlStateNormal];
                [self.likeButton addTarget:self action:@selector(buttonGood:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    else {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"btn_iine_on"] forState:UIControlStateNormal];
        [self.likeButton removeTarget:self action:@selector(buttonGood:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSDictionary *parameters = @{@"know_id":[NSString stringWithFormat:@"%ld", (long)_model.topicID]};
    
    //加菊花
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,@"index.php/know/get_good_count"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.likeNumber.text = responseObject[@"data"][@"good_count"];
        CGSize size = [self sizeWithString:self.likeNumber.text font:self.likeNumber.font];
        self.likeButton.frame = CGRectMake(WIDTH - size.width - 15 - 85, HEIGHT - 33, 80, 28);
        self.likeNumber.frame = CGRectMake(WIDTH - size.width - 15, HEIGHT - 33, size.width, 28);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.likeNumber.text = @"0";
        CGSize size = [self sizeWithString:self.likeNumber.text font:self.likeNumber.font];
        self.likeButton.frame = CGRectMake(WIDTH - size.width - 15 - 85, HEIGHT - 33, 80, 28);
        self.likeNumber.frame = CGRectMake(WIDTH - size.width - 15, HEIGHT - 33, size.width, 28);
    }];
}
- (void) deleteSelf:(UIButton *)sender
{
    self.delBlock();
}

- (void)tapAction{
    self.tapUserName();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
