//
//  MPSettingViewController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/5.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MPSettingViewController.h"
#import "SettingCell.h"
#import "MPSEditViewController.h"   ///个人资料编辑
#import "MPSAccountViewController.h"    /// 个人账户
#import "MPWebViewController.h" //网页
#import "PushViewController.h" // 推送
#import <MessageUI/MessageUI.h>

@interface MPSettingViewController ()<UITableViewDataSource, UITableViewDelegate, NADViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NADView *ADView;
@end

@implementation MPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"設定"];
    CGPoint temp = view.center;
    temp.x += 20;
    view.center = temp;
    //  Profile编辑、Push通知、账户、情シスパラダイス是什么、问询、使用规约
    self.dataArray = [NSMutableArray arrayWithObjects:@"プロフィール編集",@"プッシュ通知",@"アカウント",@"お問い合わせ", @"利用規約",@"ログアウト", nil];
    [self createTableView];
    //添加广告
//    bannerView_ = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(CON_WIDTH, 50))
//                                                 origin:CGPointMake(
//                                                                    0,
//                                                                    self.view.bounds.size.height-kGADAdSizeBanner.size.height - 64
//                                                                    )];
//    bannerView_.adUnitID = adunitID;
//    bannerView_.rootViewController = self;
//    [self.view addSubview:bannerView_];
//    [bannerView_ loadRequest:[GADRequest request]];
    
    self.ADView = [[NADView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 114, self.view.frame.size.width, 50) isAdjustAdSize:YES];
    [_ADView setNendID:NAND_ID spotID:NAND_SPOT_ID];
    [_ADView load];
    _ADView.delegate = self;
    [self.view addSubview:_ADView];

}

#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT- _ADView.frame.size.height);
}
- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"マイページ"];
    self.reloadDataBlock();
    CGPoint temp = view.center;
    temp.x -= 20;
    view.center = temp;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 创建表视图
- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT- _ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithString:@"fafafa" alpha:1];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;

    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark tabelView协议
///  section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
///  每个section里的row的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
///  返回tableView里的cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string = @"settingCell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.backgroundColor = [UIColor colorWithString:@"ffffff" alpha:1];
    cell.settingTitle.text = self.dataArray[indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {//  Profile编辑
            MPSEditViewController *edit = [[MPSEditViewController alloc] init];
//            edit.MyDataArray = self.tempArray;
            [self.navigationController pushViewController:edit animated:YES];
            NavbarView *view = [NavbarView sharedInstance];
            [view setTitleImage:nil titleName:@"プロフィール編集"];
            
            CGPoint temp = view.center;
            temp.x -= 45;
            view.center = temp;
            CGRect tempSize = view.frame;
            tempSize.size.width += 45;
            view.frame = tempSize;
        }
            break;
        case 1:
        {//  Push通知
            PushViewController *pushVC = [[PushViewController alloc] init];
            [self.navigationController pushViewController:pushVC animated:YES];
        }
            break;
        case 2:
        {//  账户
            MPSAccountViewController *accountViewC = [[MPSAccountViewController alloc] init];
            [self.navigationController pushViewController:accountViewC animated:YES];
        }
            break;
//        case 3:
//        {//  情シスパラダイス是什么
//            MPWebViewController *webVC = [[MPWebViewController alloc] init];
//            webVC.ulrStr = JoushisuIsWhatUrl;
//            [self.navigationController pushViewController:webVC animated:YES];
//        }
//            break;
        case 3:
        {//  问询
            ///点击报告发送邮件
            [self sendEMail];
        }
            break;
        case 4:
        {//  使用规约
            MPWebViewController *webVC = [[MPWebViewController alloc] init];
            webVC.ulrStr = JoushisuAttentionUrl;
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 5:
        {//  退出
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ログアウト" message:nil delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"ログアウト", nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark 发送邮件
//点击按钮后，触发这个方法
-(void)sendEMail
{
    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
        [self sendEmailAction]; // 调用发送邮件的代码
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Send mail failed" message:@"The user is not set email account" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)sendEmailAction
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:@"お問い合わせ"];
    // 设置收件人
//    [mailCompose setToRecipients:@[@"app@ug-inc.net"]];
    [mailCompose setToRecipients:@[@"support@syszo.com"]];
//    // 设置抄送人
//    [mailCompose setCcRecipients:@[@"1229436624@qq.com"]];
//    // 设置密抄送
//    [mailCompose setBccRecipients:@[@"shana_happy@126.com"]];
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"シス蔵-お問い合わせ-";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //	[mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    /**
     *  添加附件
     */
//    UIImage *image = [UIImage imageNamed:@"image"];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"custom.png"];
//    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
//    NSData *pdf = [NSData dataWithContentsOfFile:file];
//    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"7天精通IOS233333"];
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteFile];
        UserModel *user = [UserModel unpackUserInfo];
        if (!user) {
            EnterController *enter = [[EnterController alloc] init];
            enter.comeBackBlock = ^(){
                NSLog(@"未刷新");
            };
            [self presentViewController:enter animated:YES completion:^{
                
            }];
        }
    }
}


/// 删除文件(归档)
-(void)deleteFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths lastObject];
    //文件名
    NSString *uniquePath = [documentPath stringByAppendingPathComponent:@"userInfo.xml"];
    // 临时文件名
    NSString *path2 = NSTemporaryDirectory();
    NSString *uniquePath2 = [path2 stringByAppendingPathComponent:@"userInfo.xml"];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"document没找到文件");
        BOOL blHave2 = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath2];
        if (!blHave2) {
            NSLog(@"tmp没找到文件");
            return ;
        } else {
            NSLog(@" tmp找到文件");
            BOOL blDele= [fileManager removeItemAtPath:uniquePath2 error:nil];
            if (blDele) {
                NSLog(@"删除成功");
            }else {
                NSLog(@"删除失败");
            }
        }
    }else {
        NSLog(@" document3找到文件");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
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
