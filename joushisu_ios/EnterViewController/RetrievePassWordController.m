//
//  RetrievePassWordController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/18.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "RetrievePassWordController.h"
@import GoogleMobileAds;

/*找回密码*/
@interface RetrievePassWordController () <UIAlertViewDelegate, UITextFieldDelegate, NADViewDelegate>
{
    
    GADBannerView *bannerView_;
}
@property (nonatomic, strong)UITextField *emailField;
@property (nonatomic, strong) NADView *ADView;
//@property (nonatomic, strong)MBProgressHUD *progress1;

@end

@implementation RetrievePassWordController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTopViews];
    [self createSubviews];
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
    [_ADView load];
    _ADView.delegate = self;
    [self.view addSubview:_ADView];

    //加菊花
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    //    [self.progress show:YES];
    [self.view addSubview:self.progress];
}

#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
}
- (void)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createTopViews
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 64)];
    [topView setBackgroundColor:[UIColor colorWithString:@"76be9d" alpha:1.0]];
    [self.view addSubview:topView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(0, 0, 28, 28);
    backButton.center = CGPointMake(32, 42);
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_back_off"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    title.center = CGPointMake(self.view.center.x, 42);
    title.text = @"パスワード再発行";
    title.textColor = [UIColor whiteColor];
    title.font = FONT_SIZE_6(17.f);
    title.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:title];
    
}

- (void)createSubviews
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH - 20, 80)];
    title.center = CGPointMake(self.view.center.x, 64 + 40 + 40);
    title.numberOfLines = 0;
    title.font = FONT_SIZE_6(14.f);
    title.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
    title.text = @"ご登録いただいているメールアドレスを入力の上送信ボタンを押してください。　\nごご登録メールアドレス宛に、再発行したバスワードを送信します。";
    
    //    UILabel设置行间距等属性：
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:title.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:LineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.text.length)];
    title.attributedText = attributedString;

    [self.view addSubview:title];
    
    UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH - 20, 20)];
    email.center = CGPointMake(self.view.center.x, 64 + 40 + 40 + 80);
    email.font = FONT_SIZE_6(17.f);
    email.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
    email.text = @"メールアドレス";
    [self.view addSubview:email];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH-20, 30)];
    backImageView.center = CGPointMake(self.view.center.x, 64 + 40 + 40 + 80 + 35);
    backImageView.image = [UIImage imageNamed:@"searchbox"];
    backImageView.userInteractionEnabled = YES;
    [self.view addSubview:backImageView];
    
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, CON_WIDTH-30, 30)];
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailField.delegate = self;
    [backImageView addSubview:self.emailField];
    
    UIButton *senderMessage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    senderMessage.frame = CGRectMake(0, 0, 143, 32);
    senderMessage.center = CGPointMake(self.view.center.x, 64 + 40 + 40 + 80 + 35 + 30 + 40);
    [senderMessage setBackgroundImage:[UIImage imageNamed:@"btn_sendpw_off"] forState:UIControlStateNormal];
    [senderMessage addTarget:self action:@selector(senderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:senderMessage];
    
}
// 点击发送
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self senderAction:nil];
    return YES;
}
/// 点击送信执行的方法
- (void)senderAction:(UIButton *)sender
{
    NSLog(@"送信");
    
    [self netWorkingWithEmail:self.emailField.text];
}
- (void)netWorkingWithEmail:(NSString *)userEmail
{
    [self.progress show:YES];

    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,UserGetPassword];
    //传入的参数
    NSDictionary *parameters = @{@"user_email":userEmail};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 判断返回信息result,1为成功并保存,0为失败并提示错误信息
        NSLog(@"%@", responseObject);
        [self.progress hide:YES];
        if (![[responseObject objectForKey:@"result"] isEqualToString:@"1"]) {
            NSString *errer = [responseObject objectForKey:@"msg"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"パラメーターは不正確です" message:errer delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:nil];
            [alertView show];
            return;
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"パスワードの再設定メールを送信しました" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            alertView.tag = 20489;
            [alertView show];
            return;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 20489) {
        NSLog(@"OK, 返回上一页");
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
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
