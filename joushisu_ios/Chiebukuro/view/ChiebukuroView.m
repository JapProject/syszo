//
//  ChiebukuroView.m
//  joushisu_ios
//
//  Created by 常宽 on 15/4/29.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "ChiebukuroView.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@interface ChiebukuroView ()<UITextViewDelegate>

@end

@implementation ChiebukuroView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.title = [[UILabel alloc] init];
        [self addSubview:self.title];
        
        self.backImageView = [[UIImageView alloc ]init];
        [self addSubview:self.backImageView];
        
        self.textView = [[UITextView alloc] init];
        [self.backImageView addSubview:self.textView];
        
        self.placeholder = [[UILabel alloc] init];
        [self.backImageView addSubview:self.placeholder];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self createSubView];
    
    // 线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, WIDTH, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
}
- (void)createSubView
{
    self.title.frame = CGRectMake(10, 20, WIDTH - 20, 17);
//    self.title.font = FONT_SIZE_6(17.f);
    self.title.font = FONT_SIZE_10(17.f);
    
    self.backImageView.frame = CGRectMake(10, (20 + 9 + 17), WIDTH - 20, HEIGHT - (20 + 9 + 17) - 15);
    self.backImageView.userInteractionEnabled = YES;
    self.backImageView.image = [UIImage imageNamed:@"searchbox"];
    
    self.textView.frame = CGRectMake(5, 5, WIDTH - 30, HEIGHT - (20 + 9 + 17) - 15 - 10);
    self.textView.font = FONT_SIZE_7(14.f);
    self.textView.delegate = self;
    
    self.placeholder.frame = CGRectMake(WIDTH - 100, 10, 80, HEIGHT - (20 + 9 + 17) - 15 - 20);
    self.placeholder.font = FONT_SIZE_7(14.f);
    self.placeholder.textColor = Ashen;
//    self.placeholder.backgroundColor = [UIColor yellowColor];
}

#pragma mark--输入框协议-代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
}


- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
