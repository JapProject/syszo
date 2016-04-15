//
//  MPWebViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/5.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MPWebViewController.h"

@interface MPWebViewController () {
    UIWebView *webView;
}
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation MPWebViewController
/// 返回
- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"設定"];
    CGRect tempSize = view.frame;
    tempSize.size.width += 15;
    view.frame = tempSize;
    //        @property (assign, nonatomic) BOOL comYes;
            self.comYes = YES;
    //
    //        if (self.comYes ) {
    //            return;
    //        }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNaviBar {
    UIView *naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 64)];
    naviBar.backgroundColor = [UIColor colorWithString:@"76be9d" alpha:1.0];
    [self.view addSubview:naviBar];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    title.center = CGPointMake(self.view.center.x, 42);
    title.text = @"利用規約";
    title.textColor = [UIColor whiteColor];
    title.font = FONT_SIZE_6(17.f);
    title.textAlignment = NSTextAlignmentCenter;
    [naviBar addSubview:title];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    back.frame = CGRectMake(20, 27, 30, 30);
    [back setBackgroundImage:[UIImage imageNamed:@"btn_back_off"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:back];
    
    webView.frame = CGRectMake(0, 64, CON_WIDTH, CON_HEIGHT - 64);
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject: self])
    {
        //        @property (assign, nonatomic) BOOL comYes;
        //        self.comYes = YES;
        //
                if (self.comYes ) {
                    return;
                }
        NavbarView *view = [NavbarView sharedInstance];
        [view setTitleImage:nil titleName:@"設定"];
        CGRect tempSize = view.frame;
        tempSize.size.width += 15;
        view.frame = tempSize;
        

        NSLog(@"返回");
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (void)creatView
{
     webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT)];
    NSURL *url = [NSURL URLWithString:self.ulrStr];
    [webView loadRequest:[NSURLRequest  requestWithURL:url]];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
}
- (void)setUlrStr:(NSString *)ulrStr
{
    if (_ulrStr != ulrStr) {
        _ulrStr = ulrStr;
    }
    [self creatView];
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
