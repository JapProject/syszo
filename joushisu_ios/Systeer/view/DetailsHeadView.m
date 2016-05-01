//
//  DetailsHeadView.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/31.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "DetailsHeadView.h"
#import "SystterInfoList.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@interface DetailsHeadView ()
/// 用户头像
@property (nonatomic, strong) UIImageView *userImage;

@property (nonatomic,strong) UIImageView * isVipIcon;
/// 用户名
@property (nonatomic, strong) UILabel *userLabel;
/// 日期
@property (nonatomic, strong) UILabel *dayLabel;
/// 图片内容
@property (nonatomic, strong) UIImageView *contentPic;
/// 内容
//@property (nonatomic, strong) UITextView *infoLabel;
/// 点赞
@property (nonatomic, strong) UIButton *goodBirdBtn;
/// 删除
@property (nonatomic, strong)UIButton *deleteButton;        
/// 线
@property (nonatomic ,strong) UIView *line;


@end

@implementation DetailsHeadView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userImage = [[UIImageView alloc] init];
        [self addSubview:self.userImage];
        
        self.userLabel = [[UILabel alloc] init];
        [self addSubview:self.userLabel];
        
        self.isVipIcon = [[UIImageView alloc]init];
        [self addSubview:self.isVipIcon];
        
        self.userLabel.userInteractionEnabled = YES ;
        UITapGestureRecognizer *userNameDidTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidAction)];
        [self.userLabel addGestureRecognizer:userNameDidTap];
        
        self.dayLabel = [[UILabel alloc] init];
        [self addSubview:self.dayLabel];
        
        
        self.contentPic = [[UIImageView alloc] init];
        [self addSubview:self.contentPic];
        
        
        self.infoLabel = [[UITextView alloc] init];
        /// 文字内容
        self.infoLabel.font = FONT_SIZE_6(15.f);
        self.infoLabel.textColor = DarkGreen;
        self.infoLabel.editable = NO;
        self.infoLabel.scrollEnabled = NO;
//            self.infoLabel.backgroundColor = [UIColor redColor];
        self.infoLabel.dataDetectorTypes = UIDataDetectorTypeLink;
        [self addSubview:self.infoLabel];
        
        
        self.goodBirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.goodBirdBtn];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.line = [[UIView alloc] init];
        [self addSubview:self.line];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /// 用户图片
    [self.userImage setFrame:CGRectMake(7, 45, 15, 20)];
    self.userImage.image = [UIImage imageNamed:@"icon_user_off"];
     self.isVipIcon.image = [UIImage imageNamed:@"icon_vip_on"];

    
    /// 用户名
    [self.userLabel setFrame:CGRectMake(28, 46, WIDTH - 56, 21)];
    self.userLabel.text = self.InfoModel.user_name;
    self.userLabel.textColor = DarkGreen;
    self.userLabel.font = FONT_SIZE_6(13.f);
    
    if(self.InfoModel.vip_flg){
        self.isVipIcon.frame = CGRectMake(40, 40, 25, 30);
        [self.userLabel setFrame:CGRectMake(68, 46, WIDTH - 56, 21)];
        self.isVipIcon.hidden = NO;
    }else{
        
        [self.userLabel setFrame:CGRectMake(28, 46, WIDTH - 56, 21)];
        self.isVipIcon.hidden = YES;
    }

    //判断主贴发帖人是否是当前用户,显示不同颜色图片和name
    UserModel *user = [UserModel unpackUserInfo];
    NSString *user__id =[NSString stringWithFormat:@"%ld",(long)self.InfoModel.user_id]  ;
    if ([user__id isEqualToString: user.user_id]) {
        self.userImage.image = [UIImage imageNamed:@"icon_user_on"];
        self.userLabel.textColor = Yellow;
        
    }
    
    /// 日期
    [self.dayLabel setFrame:CGRectMake(WIDTH - 150, 10, 155, 21)];
    self.dayLabel.font = FONT_SIZE_6(14.f);
    self.dayLabel.textColor = Ashen;
    
   

//    self.infoLabel.numberOfLines = 0;
    
    /// 点赞按钮
    self.goodBirdBtn.frame = CGRectMake(WIDTH - 90, HEIGHT - 28 - 10, 80, 28);
    
    self.deleteButton.frame = CGRectMake(WIDTH - 28 - 10, HEIGHT - 28 - 10, 28, 28);
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_del"] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteSelf:) forControlEvents:UIControlEventTouchUpInside];

    /// 线
    [self.line setFrame:CGRectMake(0, HEIGHT - 1, WIDTH, 1)];
    self.line.backgroundColor = [UIColor lightGrayColor];

}
#pragma mark 点赞
- (void)buttonBirdGood:(UIButton *)sender
{
    NSLog(@"点赞");
    self.goodActionBlock();
    UserModel *user = [UserModel unpackUserInfo];
    if (!user) {
        return;
    }
    [self.goodBirdBtn setBackgroundImage:[UIImage imageNamed:@"btn_iine_on"] forState:UIControlStateNormal];
}
#pragma mark - 
#pragma mark set方法 获取数据
- (void) setInfoModel:(SystterInfoList *)InfoModel
{
    if (_InfoModel != InfoModel) {
        _InfoModel = InfoModel;
    }
    self.userLabel.text = _InfoModel.user_name;
    self.dayLabel.text = _InfoModel.time;
    self.infoLabel.text = _InfoModel.content;
    [self.infoLabel sizeToFit];
    CGFloat hidel = self.infoLabel.height ;
    
//    //    UILabel设置行间距等属性：
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:LineSpacing];
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_InfoModel.content attributes:attributes  ];
    
    
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]initWithString:_InfoModel.content];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
    
    [paragraphStyle1 setLineSpacing:LineSpacing];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, _InfoModel.content.length)];
    
    self.infoLabel.attributedText = attributedString1;
//    self.infoLabel.text = _InfoModel.content;
//    [self.infoLabel sizeToFit];
    CGSize size = [self sizeWithString:self.infoLabel.text font:[UIFont fontWithName:@"HiraSansOldStd-W6" size:20.f]];
    self.infoLabel.frame = CGRectMake(self.infoLabel.left, self.infoLabel.top, self.infoLabel.width, size.height + 20);
    
    
    if (![_InfoModel.pic  isEqualToString: @""]) {
        [self dataImageViewCreateWithImageUrl:_InfoModel.pic];
    } else {
        [self.infoLabel sizeToFit];
        [self.infoLabel setFrame:CGRectMake(8, 68, CON_WIDTH - 16, size.height + 20)];
    }
    
    //是否点过赞1没有 2点过
    if (self.InfoModel.if_good == 1) {
        [self.goodBirdBtn setBackgroundImage:[UIImage imageNamed:@"btn_iine_off"] forState:UIControlStateNormal];
        [self.goodBirdBtn addTarget:self action:@selector(buttonBirdGood:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.InfoModel.if_good == 2) {
        [self.goodBirdBtn setBackgroundImage:[UIImage imageNamed:@"btn_iine_on"] forState:UIControlStateNormal];
    }
    
    UserModel *user = [UserModel unpackUserInfo];
    if (_InfoModel.user_id == [user.user_id integerValue]) {
        [self.goodBirdBtn removeFromSuperview];
        [self addSubview:self.deleteButton];
    }
    
//    self.infoLabel.font = FONT_SIZE_6(15.f);

}
- (void) deleteSelf:(UIButton *)sender
{
    self.deleteActionBlock();
}
- (void)dataImageViewCreateWithImageUrl:(NSString *)image
{
    [self.contentPic setFrame:CGRectMake(8, 68, WIDTH - 16, 200)];
    __block DetailsHeadView *hearView = self;

    CGSize size = [self sizeWithString:self.infoLabel.text font:FONT_SIZE_6(18.f)];
    
    [self.contentPic setImageWithURL:[NSURL URLWithString:image]placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [hearView.contentPic setFrame:CGRectMake(8, 68, WIDTH - 16, image.size.height * ((WIDTH - 16) / image.size.width))];
        [hearView.infoLabel setFrame:CGRectMake(8, 68 + self.contentPic.frame.size.height, WIDTH - 16, self.infoLabel.height + 20)];
    }];
}

// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(WIDTH - 20, 1000000)//限制最大的宽度和高度
                                       options:
                   NSStringDrawingTruncatesLastVisibleLine //| NSStringDrawingUsesFontLeading
                   |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HiraSansOldStd-W6" size:font.pointSize] }//传人的字体字典
                                       context:nil];
    
    return rect.size;
}
#pragma mark 点击姓名
- (void)tapDidAction{
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
