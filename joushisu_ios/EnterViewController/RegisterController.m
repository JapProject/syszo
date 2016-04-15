//
//  RegisterController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "RegisterController.h"
#import "APService.h"
#import "MPWebViewController.h"

@import GoogleMobileAds;

@interface RegisterController () <NADViewDelegate>
{
    
    GADBannerView *bannerView_;
}
@property (nonatomic, strong)UITextField *user_name;
@property (nonatomic, strong)UITextField *user_Email;
@property (nonatomic, strong)UITextField *user_passWord;
@property (nonatomic, strong)MBProgressHUD *progress;
@property (nonatomic, strong)NADView *ADView;
@property (nonatomic, strong)UIButton *checkButton;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
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
    title.text = @"新規登録";
    title.textColor = [UIColor whiteColor];
    title.font = FONT_SIZE_6(17.f);
    title.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:title];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake(0, 0, 56, 28);
    saveButton.center = CGPointMake(CON_WIDTH - 28 - 10, 42);
    [saveButton setBackgroundImage:[UIImage imageNamed:@"btn_save_off"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
}

#pragma mark 创建各种视图
- (void)createSubViews
{
    /// 昵称
    self.user_name = [[UITextField alloc] init];
    self.user_name.tag = 17780;
    [self.view addSubview:self.user_name];
    /// 邮箱
    self.user_Email = [[UITextField alloc] init];
    self.user_Email.tag = 17781;
    self.user_Email.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:self.user_Email];
    /// 密码
    self.user_passWord = [[UITextField alloc] init];
    self.user_passWord.tag = 17782;
        // 全变成小星星
    self.user_passWord.secureTextEntry = YES;
        // 再次编辑时内容清空
    self.user_passWord.clearsOnBeginEditing = YES;
        // 清除按钮
    self.user_passWord.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.user_passWord];
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkButton.frame = CGRectMake(20, 320, 35, 35);
    [_checkButton setImage:[UIImage imageNamed:@"icon_nocheck"] forState:UIControlStateNormal];
    [_checkButton setImage:[UIImage imageNamed:@"icon_checked"] forState:UIControlStateSelected];
    [_checkButton addTarget:self action:@selector(checkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkButton];
    
    UIButton *checkNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkNameButton.frame = CGRectMake(60, 320, 90, 35);
    [checkNameButton setTitle:@"利用規約" forState:UIControlStateNormal];
    [self.view addSubview:checkNameButton];
    [checkNameButton setTitleColor:[UIColor colorWithString:@"76be9d" alpha:1.0] forState:UIControlStateNormal];
    [checkNameButton addTarget:self action:@selector(checkNameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(140, 320, 100, 35)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor blackColor];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.text = @"に同意する";
    [self.view addSubview:lable];
    
    /// 用户名/邮箱/密码
    NSArray *array = [NSArray arrayWithObjects:@"ニックネーム", @"メールアドレス", @"バスワード(6~16文字)", nil];
    
    for (int i = 17780; i < 17783; i ++) {
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, CON_WIDTH - 20, 30)];
        backImageView.center = CGPointMake(self.view.center.x, 64+60 + ((30 + 17 + 9 + 20) * (i - 17780)));
        backImageView.image = [UIImage imageNamed:@"searchbox"];
        backImageView.userInteractionEnabled = YES;
        [self.view addSubview:backImageView];
        
        UITextField *tempTextField = (UITextField *)[self.view viewWithTag:i];
        tempTextField.placeholder = array[i - 17780];
        tempTextField.frame = CGRectMake(0 , 0, CON_WIDTH - 30, 30);
        tempTextField.font = [UIFont boldSystemFontOfSize:17.f];
        tempTextField.center = CGPointMake(self.view.center.x, 64+60 + ((30 + 17 + 9 + 20) * (i - 17780)));
        [self.view bringSubviewToFront:tempTextField];
        
        
        /// 输入框上面的说明
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CON_WIDTH - 60, 20)];
        label.center = CGPointMake((CON_WIDTH - 40)/2, 64+30 + ((30 + 17 + 9 + 20) * (i - 17780)));
        label.font = FONT_SIZE_6(17.f);
        label.textColor = [UIColor colorWithString:@"393a40" alpha:1.f];
        label.text = array[i - 17780];
        [self.view addSubview:label];
        
    }
}

- (void)checkButtonClicked {
    self.checkButton.selected = !self.checkButton.selected;
}

- (void)checkNameButtonClicked {
    MPWebViewController *webVC = [[MPWebViewController alloc] init];
    webVC.ulrStr = JoushisuAttentionUrl;
    [webVC setNaviBar];
    [self presentViewController:webVC animated:YES completion:nil];
}

/// 点击注册执行的方法
- (void)registerAction:(UIButton *)sender
{
    NSLog(@"注册");
    
    if(self.user_name.text.length == 0 || self.user_passWord.text.length < 6|| self.user_passWord.text.length > 16 || self.user_Email.text.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"パラメーターは不正確です" message:@"内容を入力してください" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (!self.checkButton.selected) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"利用規約に同意した上で登録してください。" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    /// 删除本地的用户信息
    [self deleteDocumentFile];
    [self deleteTmpFile];
    /// 注册
    [self creatDataWithNick:self.user_name.text pwd:self.user_passWord.text email:self.user_Email.text];
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
        [self dismissViewControllerAnimated:YES completion:^{
            self.disMiss();
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}
/// 注册时的网络请求
- (void)creatDataWithNick:(NSString *)nick pwd:(NSString *)pwd email:(NSString *)email
{
    //加菊花
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    [self.progress show:YES];
    [self.view addSubview:self.progress];
    
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,UserRegister];
    //传入的参数
    NSDictionary *parameters = @{@"user_nick":nick,@"user_pwd":pwd ,@"user_email":email};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 判断返回信息result,1为成功并保存,0为失败并提示错误信息
        if (![[responseObject objectForKey:@"result"] isEqualToString:@"1"]) {
            NSString *errer = [responseObject objectForKey:@"msg"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"パラメーターは不正確です" message:errer delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:nil];
            [alertView show];
            [self.progress hide:YES];
            return;
        } else {
            UserModel *user = [[UserModel alloc] init];
            user.user_name = nick;      //self.user_name.text;
            user.user_password = pwd;   //self.user_name.text;
            user.user_email = email;    //self.user_Email.text;
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            user.user_id = [dic objectForKey:@"user_id"];
            /**本地存储**/
            [self saveUserInfo:user];
            /// 聊天时需要的id
            [self netWorking];
            [self.progress hide:YES];
           
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
    }];
   
}
/// 归档方法
- (BOOL)saveUserInfo:(UserModel *)userInfo
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths lastObject];
    NSString *userInfoPath = [documentPath stringByAppendingPathComponent:@"userInfo.xml"];
    // 归档类 将一个实现了NSCoding协议的对象 写入本地
    BOOL result = [NSKeyedArchiver archiveRootObject:userInfo toFile:userInfoPath];
    NSLog(@"用户信息存入:%d 地址---%@", result, userInfoPath);
    return result;
}
/// 删除Document文件(归档)
-(void)deleteDocumentFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths lastObject];
    //文件名
    NSString *uniquePath = [documentPath stringByAppendingPathComponent:@"userInfo.xml"];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"document没找到文件");
        return ;
    }else {
        NSLog(@" document找到文件");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}
/// 删除临时文件(归档)
-(void)deleteTmpFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    // 临时文件名
    NSString *path2 = NSTemporaryDirectory();
    NSString *uniquePath2 = [path2 stringByAppendingPathComponent:@"userInfo.xml"];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath2];
    if (!blHave) {
        NSLog(@"tmp没找到文件");
        return ;
    }else {
        NSLog(@" tmp找到文件");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath2 error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
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
