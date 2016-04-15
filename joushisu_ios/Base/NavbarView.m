//
//  NavbarView.m
//  joushisu_ios
//
//  Created by 常宽 on 15/4/28.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "NavbarView.h"

@implementation NavbarView

static NavbarView *nacView = nil;

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self) {
    if (!nacView) {
        nacView = [super allocWithZone:zone];
    }
}
    return nacView;
}
+ (id)copyWithZone:(struct _NSZone *)zone
{
    return nacView;
}
/// 创建单例实例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        nacView = [[NavbarView alloc] init];
    });
    return nacView;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleImage = [[UIImageView alloc] init];
        [self addSubview:self.titleImage];
        
        self.titleName = [[UILabel alloc] init];
        [self addSubview:self.titleName];
//        self.backgroundColor = [UIColor redColor];
//        self.titleImage.backgroundColor = [UIColor greenColor];
//        self.titleName.backgroundColor = [UIColor blueColor];
    }
    return self;
}

//- (instancetype) initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        self.titleImage = [[UIImageView alloc] init];
//        [self addSubview:self.titleImage];
//        
//        self.titleName = [[UILabel alloc] init];
//        [self addSubview:self.titleName];
//    }
//    return self;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.backgroundColor = [UIColor colorWithRed:1.000 green:0.311 blue:0.562 alpha:1.000];
    self.titleImage.frame = CGRectMake(0, 0, 18, 18);
    
    self.titleName.frame = CGRectMake(self.titleImage.frame.size.width * 1.5, 0, self.frame.size.width - self.titleImage.frame.size.width * 1.5, 18);
//    self.titleName.font = FONT_SIZE_6(17.f);
    self.titleName.font = FONT_SIZE_10(17.f);
    [self.titleName sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.titleImage.frame.size.width * 1.5 + self.titleName.frame.size.width, self.frame.size.height);
    self.titleName.textColor = [UIColor whiteColor];
    
    
}

- (void)setTitleImage:(NSString *)ImageName titleName:(NSString *)titleName
{
    if (ImageName != nil) {
        self.titleImage.image = [UIImage imageNamed:ImageName];
    } else {
        self.titleImage.frame = CGRectMake(0, 0, 0, 0);
        self.titleImage.image = nil;
    }
    self.titleName.text = titleName;
    [self.titleName sizeToFit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
