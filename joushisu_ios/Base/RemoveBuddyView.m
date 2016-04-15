//
//  RemoveBuddyView.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/29.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "RemoveBuddyView.h"

@interface RemoveBuddyView ()
@property (nonatomic, retain)UIView *backGroundView;
@end

@implementation RemoveBuddyView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    
    // Do any additional setup after loading the view.
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH - 60, 160)];
    self.backGroundView.center = CGPointMake(self.center.x, self.center.y);
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundView.clipsToBounds = YES;
    self.backGroundView.layer.cornerRadius = 10;
    [self addSubview:self.backGroundView];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    back.frame = CGRectMake(CON_WIDTH - 60 - 25, 10, 15, 15);
    [back setBackgroundImage:[UIImage imageNamed:@"btn_popupclose"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:back];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, CON_WIDTH - 60 - 20, 20)];
    label.font = FONT_SIZE_6(16.f);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
    label.text = @"フォローを解除しますか？";
    [self.backGroundView addSubview:label];
    
    /// 确定
    UIButton *determine = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    determine.frame = CGRectMake((CON_WIDTH - 60 - 80 - 80 - 20) / 2, 50 + 20 + 28, 160 / 2, 41 / 2);
//    determine.center = CGPointMake(self.backGroundView.center.x - 50, self.backGroundView.center.y + 30);
    [determine setBackgroundImage:[UIImage imageNamed:@"btn_hai_on"] forState:UIControlStateNormal];
    [determine setBackgroundImage:[UIImage imageNamed:@"btn_hai"] forState:UIControlStateHighlighted];
    
    [determine addTarget:self action:@selector(delFriend:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:determine];
    
    /// 取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake((CON_WIDTH - 60 - 80 - 80 - 20) / 2 + 100, 50 + 20 + 28, 160 / 2, 41 / 2);
//    cancelButton.center = CGPointMake(self.backGroundView.center.x + 50, self.backGroundView.center.y + 30);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_iie_on"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_iie"] forState:UIControlStateHighlighted];
    
    [cancelButton addTarget:self action:@selector(cancelFriend:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:cancelButton];
    
}
/// 返回上级页面
- (void)backAction:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/// 确定删除好友
- (void)delFriend:(UIButton *)sender
{
    [self netWorkWithDelFriendId];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/// 取消删除好友
- (void)cancelFriend:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark 删除好友
- (void)netWorkWithDelFriendId
{
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SystomoDelFriend];
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];
    NSDictionary *parameters = @{@"rec_id":self.friendId,@"user_id":user.user_id};
    
//    __weak FriendsDataViewController *friendViewC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"1"]) {
            NSLog(@"删除成功");
            self.block();
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"删除完了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alert show];
        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
    
}
#pragma mark -

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
