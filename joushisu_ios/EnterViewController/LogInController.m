//
//  LogInController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "LogInController.h"
#import "RetrievePassWordController.h"
#import "APService.h"

@import GoogleMobileAds;

@interface LogInController () <NADViewDelegate>
{
    GADBannerView *bannerView_;
}
/// 用户名
@property (nonatomic, strong)UITextField *user_Email;
/// 密码
@property (nonatomic, strong)UITextField *user_password;
/// 是否要记住密码
@property (nonatomic, assign)BOOL count;
@property (nonatomic, strong)MBProgressHUD *progress;
@property (nonatomic, strong) NADView *ADView;
@end

@implementation LogInController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTopViews];
    [self createSubViews];
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
    title.text = @"ログイン";
    title.textColor = [UIColor whiteColor];
    title.font = FONT_SIZE_6(17.f);
    title.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:title];
}

- (void)createSubViews
{
    self.user_Email = [[UITextField alloc] init];
    self.user_Email.tag = 17880;
    self.user_Email.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:self.user_Email];
    
    self.user_password = [[UITextField alloc] init];
    self.user_password.tag = 17881;
        // 全变成小星星
    self.user_password.secureTextEntry = YES;
        // 再次编辑时内容清空
    self.user_password.clearsOnBeginEditing = YES;
        // 清除按钮
    self.user_password.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.user_password];
    
    
    NSArray *array = [NSArray arrayWithObjects:@"メールアドレス", @"バスワード(6~16文字)", nil];
    for (int i = 17880; i < 17882; i ++) {
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, CON_WIDTH - 20, 30)];
        backImageView.center = CGPointMake(self.view.center.x, 64+60 + ((30 + 17 + 9 + 20) * (i - 17880)));
        backImageView.image = [UIImage imageNamed:@"searchbox"];
        backImageView.userInteractionEnabled = YES;
        [self.view addSubview:backImageView];
        
        UITextField *tempTextField = (UITextField *)[self.view viewWithTag:i];
        tempTextField.placeholder = array[i - 17880];
        tempTextField.frame = CGRectMake(0 , 0, CON_WIDTH - 30, 30);
        tempTextField.font = [UIFont boldSystemFontOfSize:17.f];
        tempTextField.center = CGPointMake(self.view.center.x, 64+60 + ((30 + 17 + 9 + 20) * (i - 17880)));
        [self.view bringSubviewToFront:tempTextField];

        /// 输入框上面的说明
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CON_WIDTH - 60, 20)];
        label.center = CGPointMake((CON_WIDTH - 40)/2, 64+30 + ((30 + 17 + 9 + 20) * (i - 17880)));
        label.font = FONT_SIZE_6(17.f);
        label.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
        label.text = array[i - 17880];
        [self.view addSubview:label];   
        
    }

    UIButton *rememberPassword = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rememberPassword.frame = CGRectMake(0, 0, 40 + 180, 40);
    rememberPassword.center = CGPointMake(self.view.center.x, 64 + 40 + 152);
    [rememberPassword setImage:[[UIImage imageNamed:@"icon_nocheck"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rememberPassword setTitle:@" 次回から自動ログイン" forState:UIControlStateNormal];
    [rememberPassword setTitleColor:[UIColor colorWithString:@"393a40" alpha:1.f] forState:UIControlStateNormal];
    rememberPassword.titleLabel.font = FONT_SIZE_6(17.f);
    self.count = NO;
    rememberPassword.tag = self.count;
    [rememberPassword addTarget:self action:@selector(isRememberThePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberPassword];
    
    UIButton *senderMessage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    senderMessage.frame = CGRectMake(0, 0, 143, 32);
    senderMessage.center = CGPointMake(self.view.center.x, 64 + 80 + 152 + 40);
    [senderMessage setBackgroundImage:[UIImage imageNamed:@"btn_sendpw_off"] forState:UIControlStateNormal];
    
    [senderMessage addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:senderMessage];
    
    UILabel *retrieveLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH - 20, 20)];
    retrieveLabel1.center = CGPointMake(self.view.center.x, 64 + 80 + 152 + 40 + 40);
    retrieveLabel1.font = FONT_SIZE_6_H(14.f);
    retrieveLabel1.text = @"パスワードを忘れた方は";
    retrieveLabel1.textAlignment = NSTextAlignmentCenter;
    retrieveLabel1.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
    [self.view addSubview:retrieveLabel1];
    
    UIView *backRet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 128 + 125, 20)];
    backRet.center = CGPointMake(self.view.center.x, 64 + 80 + 152 + 40 + 40 + 20);
    [self.view addSubview:backRet];
    
    UIButton *retrieve = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    retrieve.frame = CGRectMake(0, 0, 128, 20);
    retrieve.titleLabel.font = FONT_SIZE_6_H(14.f);
    [retrieve setTitle:@"バスワードの再設定" forState:UIControlStateNormal];
    [retrieve setTitleColor:[UIColor colorWithString:@"83a7d4" alpha:1] forState:UIControlStateNormal];
    [retrieve addTarget:self action:@selector(retrievePassword:) forControlEvents:UIControlEventTouchUpInside];
    [backRet addSubview:retrieve];
    
    UILabel *retrieveLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(128, 0, 125, 20)];
    retrieveLabel2.font = FONT_SIZE_6_H(14.f);
    retrieveLabel2.text = @"を行ってください。";
    retrieveLabel2.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
    [backRet addSubview:retrieveLabel2];
    
}
/// 密码找回
- (void)retrievePassword:(UIButton *)sender
{
    RetrievePassWordController *retrViewC = [[RetrievePassWordController alloc] init];
    [self presentViewController:retrViewC animated:YES completion:^{
        
    }];
}

/// 点击注册执行的方法
- (void)loginAction:(UIButton *)sender
{
    NSLog(@"登陆");
    if(self.user_Email.text.length == 0 || self.user_password.text.length < 6 || self.user_password.text.length > 16)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"パラメーターは不足です" message:@"元パスワードと新パスワードは入力してください" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    /// 登陆时的网络请求
    [self creatDataWithNick:self.user_Email.text pwd:self.user_password.text];
//    /// 聊天时需要的id
//    [self netWorking];
}

- (void)isRememberThePassword:(UIButton *)sender
{
    if (sender.tag == YES) {
        [sender setImage:[[UIImage imageNamed:@"icon_nocheck"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        sender.tag = NO;
        self.count = NO;
    } else {
        [sender setImage:[[UIImage imageNamed:@"icon_checked"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        sender.tag = YES;
        self.count = YES;
    }
}
/// 聊天时需要的id
- (void)netWorking
{
    NSLog(@"要上传的id ==== %@", [APService registrationID]);
    UserModel *user = [UserModel unpackUserInfo];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,UserDeviceId];
    //传入的参数
    NSDictionary *parameters = @{@"user_id":user.user_id ,@"device":@"2", @"device_id":[APService registrationID]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"数据结果===%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];

}

/// 登陆时的网络请求
- (void)creatDataWithNick:(NSString *)nick pwd:(NSString *)pwd
{
    //加菊花
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    [self.progress show:YES];
    [self.view addSubview:self.progress];
    
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,UserLogIn];
    //传入的参数
    NSDictionary *parameters = @{@"user_email":nick,@"user_pwd":pwd};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"数据结果===%@", responseObject);
        // 判断返回信息result,1为成功并保存,0为失败并提示错误信息
        if (![[responseObject objectForKey:@"result"] isEqualToString:@"1"]) {
            NSString *errer = [responseObject objectForKey:@"msg"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"パラメーターは不正確です" message:errer delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:nil];
            [alertView show];
            [self.progress hide:YES];
            return;
        } else {
            UserModel *user = [[UserModel alloc] init];
            user.user_email = nick;
            user.user_password = pwd;
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            user.user_name = [dic objectForKey:@"user_nick"];
            user.user_id = [dic objectForKey:@"user_id"];
            /**本地存储**/
            [self saveUserInfo:user];
            /// 聊天时需要的id
            [self netWorking];
            [self.progress hide:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                self.disMiss();
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}
/// 归档方法
- (BOOL)saveUserInfo:(UserModel *)userInfo
{
    NSString *path = [NSString string];
    if (self.count == YES) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [paths lastObject];
        path = documentPath;
    } else {
        NSString *tmpDir = NSTemporaryDirectory();
        path = tmpDir;
    }
    
    
    NSString *userInfoPath = [path stringByAppendingPathComponent:@"userInfo.xml"];
    // 归档类 将一个实现了NSCoding协议的对象 写入本地
    BOOL result = [NSKeyedArchiver archiveRootObject:userInfo toFile:userInfoPath];
    NSLog(@"用户信息存入:%d 地址---%@", result, userInfoPath);
    return result;
}


/// 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
