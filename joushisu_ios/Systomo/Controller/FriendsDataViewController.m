//
//  FriendsDataViewController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/11.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "FriendsDataViewController.h"
#import "FriendNickCell.h"
#import "MyResumeCell.h"
#import "FriendDataModel.h"
#import <MessageUI/MessageUI.h>
#import "ChatViewController.h"
#import "RemoveBuddyView.h"
#import "SystomoViewController.h"
@interface FriendsDataViewController ()<UITableViewDelegate, UITableViewDataSource, NADViewDelegate>

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)NSMutableArray *friendDataArray;

@property (nonatomic, strong)UITableView *tableView;
/// 网络请求结果
@property (nonatomic, strong)FriendDataModel *model;
@property (nonatomic, strong)NADView *ADView;

@end

@implementation FriendsDataViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        self.member_id = [[NSString alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
//    self.dataArray = [NSMutableArray arrayWithObjects:@"性別", @"現在地", @"業種", @"会社規模", @"役職・役割", @"年間予算", @"情シス歴", @"ソフトウェア", @"ハードウェア", @"保有資格",@"シストモ", @"いいね！数", nil];
    self.dataArray = [NSMutableArray arrayWithObjects:@"性別", @"現在地", @"業種", @"会社規模", @"役職・役割", @"年間予算", @"情シス歴",@"シストモ", @"いいね！数", nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_report_off"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    
    //加菊花
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    [self.progress show:YES];
    [self.view addSubview:self.progress];
    
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
    
    self.ADView = [[NADView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 114.0, self.view.frame.size.width, 50) isAdjustAdSize:YES];
    [_ADView setNendID:NAND_ID spotID:NAND_SPOT_ID];
    [_ADView load];
    _ADView.delegate = self;
    [self.view addSubview:_ADView];

}

#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64-_ADView.frame.size.height);
}

- (void)setMember_id:(NSString *)member_id
{
    if (_member_id != member_id) {
        _member_id = member_id;
    }
    UserModel *user = [UserModel unpackUserInfo];
    [self netWorkingWithUserID:user.user_id friendId:_member_id];
}
/// 报告按钮
- (void)rightBarButtonAction:(UIBarButtonItem *)sender
{
    ///点击报告发送邮件
    [self sendEMail];
}

- (void)comeBack
{
    NSArray *arrTap = self.navigationController.viewControllers;
    if ([[arrTap objectAtIndex:arrTap.count - 2] isKindOfClass:[SystomoViewController class]]) {
        self.refreshBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 网络请求
- (void)netWorkingWithUserID:(NSString *)userId friendId:(NSString *)memberId
{
    self.friendDataArray = [NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SystomoFriend];
    //传入的参数
    NSDictionary *parameters = @{@"member_id":memberId,@"user_id":userId};
    
    __weak FriendsDataViewController *friendViewC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        [self.progress hide:YES];
        if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSString class]]) {
            return;
        }
        NSDictionary *dic = [responseObject objectForKey:@"data"];
        friendViewC.model = [[FriendDataModel alloc] init];
        [friendViewC.model setValuesForKeysWithDictionary:dic];
        
        NSString *sex = @"";
        if ([friendViewC.model.user_sex isEqualToString:@"1"]) {
            sex = @"男";
        } else if ([friendViewC.model.user_sex isEqualToString:@"2"]){
            sex = @"女";
        } else {
            sex = @"その他";
        }
        
        [friendViewC.friendDataArray addObject:sex];
        [friendViewC.friendDataArray addObject:friendViewC.model.address];
        [friendViewC.friendDataArray addObject:friendViewC.model.industry];
        [friendViewC.friendDataArray addObject:friendViewC.model.size_company];
        [friendViewC.friendDataArray addObject:friendViewC.model.job];
        [friendViewC.friendDataArray addObject:friendViewC.model.reg_money];
        [friendViewC.friendDataArray addObject:friendViewC.model.calendar];
//        [friendViewC.friendDataArray addObject:friendViewC.model.software];
//        [friendViewC.friendDataArray addObject:friendViewC.model.hardware];
//        [friendViewC.friendDataArray addObject:friendViewC.model.qualified];
//        [friendViewC.friendDataArray addObject:friendViewC.model.allyear];
        [friendViewC.friendDataArray addObject:friendViewC.model.number];
        [friendViewC.friendDataArray addObject:friendViewC.model.price];
        [friendViewC.friendDataArray addObject:friendViewC.model.user_nick];
        [friendViewC.friendDataArray addObject:friendViewC.model.introduction];
//        self.friendEmail = [NSString stringWithString:friendViewC.model.user_email];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
}

#pragma mark -
- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64-_ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 25;
    //除去线
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark tabelView协议
///  section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
///  每个section里的row的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.friendDataArray.count - 2;
            break;
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}
///  返回tableView里的cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *string = @"FriendDataFrist";
            FriendNickCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[FriendNickCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            if (self.friendDataArray.count != 0) {
                NSString *nick = [self.friendDataArray objectAtIndex:self.friendDataArray.count - 2];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:nick, @"name", self.model.if_member , @"isMember", _member_id, @"rec_id", nil];
                cell.dic = dic;
            }
            
            __weak FriendsDataViewController *friends = self;
            cell.sessionBlock = ^(){
                NSLog(@"发起会话2");
                ChatViewController *chatVC = [[ChatViewController alloc] init];
                chatVC.member_id = friends.member_id;
                [self.navigationController pushViewController:chatVC animated:YES];
                
            };
            __block FriendNickCell *cell2 = cell;
            cell.addDuddyBlock = ^(){
                NSLog(@"添加好友2");
                [cell2.addDuddy setBackgroundImage:[UIImage imageNamed:@"icon_follow"] forState:UIControlStateNormal];
                cell2.isFirend = @"1";
                [self netWorkWithAddFriendId:self.member_id];
            };
            cell.delDuddyBlock = ^(){
                
                NSLog(@"删除好友2");
                RemoveBuddyView *remove = [[RemoveBuddyView alloc] initWithFrame:self.view.bounds];
                remove.friendId = self.member_id;
                remove.alpha = 0;
                
                remove.block =^(){
                    [cell2.addDuddy setBackgroundImage:[UIImage imageNamed:@"btn_nofollow_big"] forState:UIControlStateNormal];
                    cell2.isFirend = @"2";
                };
                
                [self.view.window addSubview:remove];
                [UIView animateWithDuration:0.3 animations:^{
                    remove.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
                
            };
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            static NSString *string = @"FriendDatasec";
            MyResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[MyResumeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.categoryTitle.text = self.dataArray[indexPath.row];
            cell.contentTitle.text = self.friendDataArray[indexPath.row];
            //            NSLog(@"%d", indexPath.row);
            return cell;
            
        }
            break;
        case 2:
        {
            static NSString *string = @"FriendDatathe";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.textLabel.text = [self.friendDataArray lastObject];
            return cell;
        }
            break;
            
        default:
        {
            static NSString *string = @"FriendDataull";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            return cell;
        }
            break;
    }
}
/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 65;
            break;
        case 1:
            return 45;
            break;
        case 2:
            return 60;
            break;
            
        default:
            return 0;
            break;
    }
}
///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
///  自定义section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 25)];
    view.backgroundColor = [UIColor colorWithString:@"d0d0d0" alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 11, 12)];
    imageView.image = [UIImage imageNamed:@"icon_donguri@2x"];
    [view addSubview:imageView];
    
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 + 11, 6, CON_WIDTH - 21, 12)];
    sectionTitle.font = FONT_SIZE_6(12.f);
    sectionTitle.textColor = [UIColor colorWithString:@"8f8f8f" alpha:1];
    [view addSubview:sectionTitle];
    switch (section) {
        case 0:
            sectionTitle.text = @"マイネーム";
            break;
        case 1:
            sectionTitle.text = @"Profile";
            break;
        case 2:
            sectionTitle.text = @"自己紹介";
            break;
            
        default:
            break;
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 2:
            return 20;
            break;
            
        default:
            return 0;
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
    [mailCompose setSubject:@"ユーザーに関する報告"];
    // 设置收件人
//    NSString *friendEmail = [NSString stringWithString:self.model.user_email];
//    NSString *friendEmail = @"app@ug-inc.net";
    NSString *friendEmail = @"support@syszo.com";
    NSLog(@"friendEmail = %@", friendEmail);
    [mailCompose setToRecipients:@[friendEmail]];
//    // 设置抄送人
//    [mailCompose setCcRecipients:@[@"1229436624@qq.com"]];
//    // 设置密抄送
//    [mailCompose setBccRecipients:@[@"shana_happy@126.com"]];
    /**
     *  设置邮件的正文内容
     */
//    NSString *emailContent = @"友達にしましょう!";
    UserModel *user = [UserModel unpackUserInfo];
    NSString *emailContent = [NSString stringWithFormat:@"報告するユーザー：%@\n報告されるユーザー：%@\n\nこのユーザーに関して報告したい内容を以下にご入力後送信ください。\n（例）投稿に不適切なコンテンツが多い", user.user_name, self.model.user_nick];
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
#pragma mark 添加好友
- (void)netWorkWithAddFriendId:(NSString *)friendId
{
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SystomoAddFriend];
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];
    NSDictionary *parameters = @{@"rec_id":friendId,@"user_id":user.user_id};
    
//    __weak FriendsDataViewController *friendViewC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"1"]) {
            NSLog(@"添加成功");
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"亲友登录完了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
//#pragma mark 删除好友
//- (void)netWorkWithDelFriendId:(NSString *)friendId
//{
//    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SystomoDelFriend];
//    //传入的参数
//    UserModel *user = [UserModel unpackUserInfo];
//    NSDictionary *parameters = @{@"rec_id":friendId,@"user_id":user.user_id};
//    
//    __weak FriendsDataViewController *friendViewC = self;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        if ([[responseObject objectForKey:@"result"] isEqualToString:@"1"]) {
//            NSLog(@"删除成功");
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"删除完了" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alert show];
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alert show];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        // NSLog(@"%@", error);
//    }];
//    
//}
//#pragma mark -


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
