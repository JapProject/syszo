//
//  BaseViewController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor =  [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_back_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] landscapeImagePhone:[UIImage imageNamed:@"btn_back_on"] style:UIBarButtonItemStylePlain target:self action:@selector(comeBack)];
    self.navigationItem.leftBarButtonItem = bar;
    // 隐藏返回键
//    self.navigationItem.hidesBackButton = YES;
    
    
    
}
/// 返回
- (void)comeBack
{
//    [self.navigationController popViewControllerAnimated:YES];
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
