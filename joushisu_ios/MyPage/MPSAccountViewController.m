//
//  MPSAccountViewController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/5.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MPSAccountViewController.h"
#import "AccountCell.h"
#import "AccountModel.h"
#import "MPSAccountEditViewController.h"
#import "MPSEmailViewController.h"

@interface MPSAccountViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,NADViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NADView *ADView;
@end

@implementation MPSAccountViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UserModel *user = [UserModel unpackUserInfo];
    
    AccountModel *model1 = [[AccountModel alloc] init];
    model1.categoryText = @"バスワード";
    model1.contentText = @"＊＊＊＊＊＊＊＊＊";
    AccountModel *model2 = [[AccountModel alloc] init];
    model2.categoryText = @"メールアドレス";
    model2.contentText = user.user_email;
    self.dataArray = [NSMutableArray arrayWithObjects:model1, model2, nil];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserModel *user = [UserModel unpackUserInfo];
    
    AccountModel *model1 = [[AccountModel alloc] init];
    model1.categoryText = @"バスワード";
    model1.contentText = @"＊＊＊＊＊＊＊＊＊";
    AccountModel *model2 = [[AccountModel alloc] init];
    model2.categoryText = @"メールアドレス";
    model2.contentText = user.user_email;
    self.dataArray = [NSMutableArray arrayWithObjects:model1, model2, nil];
    
    // Do any additional setup after loading the view.
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"アカウント"];
    CGPoint temp = view.center;
    temp.x -= 15;
    view.center = temp;
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
    _ADView.delegate = self;
    [_ADView load];
    [self.view addSubview:_ADView];

}

#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height);
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
- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"設定"];
    
    CGPoint temp = view.center;
    temp.x += 15;
    view.center = temp;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
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
    static NSString *string = @"Account";
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[AccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
///  返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MPSAccountEditViewController *edit = [[MPSAccountEditViewController alloc] init];
        [self.navigationController pushViewController:edit animated:YES];
    }
    if (indexPath.row == 1) {
        MPSEmailViewController *edit = [[MPSEmailViewController alloc] init];
        [self.navigationController pushViewController:edit animated:YES];
    }

}
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

#pragma mark -

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
