//
//  EnterController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "EnterController.h"
#import "LogInController.h"
#import "RegisterController.h"

@import GoogleMobileAds;

@interface EnterController () <NADViewDelegate>

{
    GADBannerView *bannerView_;
}
@property (nonatomic, strong) NADView *ADView;
@end

@implementation EnterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createButton];
    //添加广告 kGADAdSizeBanner 替换为 GADAdSizeFromCGSize(CGSizeMake(CON_WIDTH, 50)
//    bannerView_ = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(CON_WIDTH, 50))
//                                                 origin:CGPointMake(
//                                                                    0,
//                                                                    self.view.bounds.size.height-kGADAdSizeBanner.size.height
//                                                                    )];
//    bannerView_.adUnitID = adunitID;
//    bannerView_.rootViewController = self;
//    [self.view addSubview:bannerView_];
//    [bannerView_ loadRequest:[GADRequest request]];
    
    self.ADView = [[NADView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50) isAdjustAdSize:YES];
    [_ADView setNendID:NAND_ID spotID:NAND_SPOT_ID];
    _ADView.delegate = self;
    [_ADView load];
    [self.view addSubview:_ADView];
    
}

#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
}
- (void)createButton
{
    NSArray *array = [NSArray arrayWithObjects:@"btn_login_off", @"btn_entry_off", nil];
    for (int i = 0; i < array.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, 214.5, 48);
        button.center = CGPointMake(self.view.center.x, 64 + 120 + ((48 + 120) * i));
        button.tag = 18180 + i;
        [button setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    /// 强制登陆
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    back.frame = CGRectMake(20, 35, 30, 30);
    [back setBackgroundImage:[UIImage imageNamed:@"btn_popupclose"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    /// 登陆
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 20.f)];
    label1.center = CGPointMake(self.view.center.x, 10 + 64 + 48 + 10);
    label1.font = FONT_SIZE_6(17.f);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
    label1.text = @"メンバーの方";
    [self.view addSubview:label1];
    /// 注册
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 20.f)];
    label2.center = CGPointMake(self.view.center.x, 10 + 64 + 48 + 163);
    label2.font = FONT_SIZE_6(17.f);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
    label2.text = @"はじめての方";
    [self.view addSubview:label2];
    /// 注册副标题
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 20.f)];
    label3.center = CGPointMake(self.view.center.x, 10 + 64 + 48 + 183);
    label3.font = FONT_SIZE_6(14.f);
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
    label3.text = @"簡単操作でご利用できます";
    [self.view addSubview:label3];
    
    
}

- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 18180:
        {
            LogInController *login = [[LogInController alloc] init];
            __block EnterController *enter = self;
            login.disMiss = ^(){
                [enter dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:login animated:YES completion:nil];
        }
            break;
        case 18181:
        {
            RegisterController * registerVC = [[RegisterController alloc] init];
            __block EnterController *enter = self;
            registerVC.disMiss = ^(){
                [enter dismissViewControllerAnimated:YES completion:nil];
            };
            [self presentViewController:registerVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
- (void)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        UserModel *user = [UserModel unpackUserInfo];
        if (!user) {
            self.comeBackBlock();
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
