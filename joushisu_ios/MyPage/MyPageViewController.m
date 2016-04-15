//
//  MyPageViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MyPageViewController.h"
#import "MyPageHeaderView.h"
#import "MyResumeCell.h"
#import "MPSettingViewController.h" /// 设置
#import "MyAlertView.h" /// 模态出来的视图
#import "MyDataModel.h" /// 个人资料model
#import "MyDataIntroduceCell.h"/// 自我介绍的cell
#import "MultiSelectionTableViewCell.h"

#import "MPHistroyViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface MyPageViewController ()<UITableViewDataSource, UITableViewDelegate,NADViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)NSMutableArray *myDataArray;

//@property (nonatomic, strong)MyDataModel *model;

@property (nonatomic, strong)MyPageHeaderView *hview;

@property (nonatomic, strong) NADView *ADView;

@property (nonatomic, strong)UserModel *user;
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }

@end

@implementation MyPageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        self.user = [UserModel unpackUserInfo];
//        if (!self.user) {
//            NSLog(@"self.user = %@", self.user);
//            EnterController *enter = [[EnterController alloc] init];
//            [self.navigationController presentViewController:enter animated:YES completion:^{
//                
//            }];
//            enter.comeBackBlock = ^(){
//                /// 不做登陆操作, 直接返回上一页
//                [self comeBack];
//            };
//
//        }
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.user = [UserModel unpackUserInfo];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [UserModel unpackUserInfo];
    if (!self.user) {
        EnterController *enter = [[EnterController alloc] init];
        AppDelegate *appdele = [UIApplication sharedApplication].delegate;
        [appdele.navi presentViewController:enter animated:YES completion:^{
            
        }];
        enter.comeBackBlock = ^(){
            /// 不做登陆操作, 直接返回上一页
            [self comeBack];
        };
    }
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"マイページ"];
//    view.backgroundColor = [UIColor yellowColor];
//    CGPoint temp = view.center;
//    temp.x += 30;
//    view.center = temp;
//    
    CGRect tempSize = view.frame;
    tempSize.size.width -= 15;
    view.frame = tempSize;
    
//    self.dataArray = [NSMutableArray arrayWithObjects:@"性別", @"現在地", @"業種", @"会社規模", @"役職・役割", @"年間予算", @"情シス歴", @"ソフトウェア", @"ハードウェア", @"保有資格", @"シストモ", @"いいね！数", nil];
    self.dataArray = [NSMutableArray arrayWithObjects:@"性別", @"現在地", @"業種", @"会社規模", @"役職・役割", @"年間予算", @"情シス歴", @"シストモ", @"いいね！数", nil];
//    self.myDataArray = [[NSMutableArray alloc]init];
    
    
    // 设置右上角导航栏
    UIBarButtonItem *setting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_mypage_off"] style:UIBarButtonItemStyleDone target:self action:@selector(rightSettingAction:)];
    UIImage *searcg_g = [[UIImage imageNamed:@"btn_mypost_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *history = [[UIBarButtonItem alloc] initWithImage:searcg_g style:UIBarButtonItemStyleDone target:self action:@selector(rightHistoryAction:)];
    self.navigationItem.rightBarButtonItems = @[setting, history];
    UserModel *user = [UserModel unpackUserInfo];

    [self netWorkingWithUserID:user.user_id];
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

    //加菊花
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
//    [self.progress show:YES];
    [self.view addSubview:self.progress];
    
}

#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height);
}
#pragma mark - 网络请求
- (void)netWorkingWithUserID:(NSString *)user_id
{
    //加菊花
//    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
//    self.progress.labelText = LODEING;
    [self.progress show:YES];
//    [self.view addSubview:self.progress];
    
    [self.myDataArray removeAllObjects];
    self.myDataArray = [[NSMutableArray alloc] init];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,MyPageData];
    //传入的参数
    NSDictionary *parameters = @{@"user_id":user_id};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"我的====%@", responseObject);
        NSDictionary *dic = [responseObject objectForKey:@"data"];
        if ([dic isEqual:@""]) {
            [self.progress hide:YES];
            return;
        }
        MyDataModel *model = [[MyDataModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        
        NSString *userSex = @"";
        switch ([model.user_sex integerValue]) {
            case 1:
            {
                userSex = @"男";
            }
                break;
            case 2:
            {
                userSex = @"女";
            }
                break;
            case 3:
            {
                userSex = @"その他";
            }
                break;
                
            default:
                break;
        }
        [self.myDataArray addObject:userSex];
        [self.myDataArray addObject:model.address];
        [self.myDataArray addObject:model.industry];
        [self.myDataArray addObject:model.size_company];
        [self.myDataArray addObject:model.job];
        [self.myDataArray addObject:model.reg_money];
        [self.myDataArray addObject:model.calendar];
//        [self.myDataArray addObject:model.software];
//        [self.myDataArray addObject:model.hardware];
//        [self.myDataArray addObject:model.qualified];
//        [self.myDataArray addObject:model.allyear];
        [self.myDataArray addObject:model.number];
        [self.myDataArray addObject:model.price];
        [self.myDataArray addObject:model.introduction];
        // 获取到数据后存入本地临时文件夹
        NSString *path2 = NSTemporaryDirectory();
        NSString *arrPath = [path2 stringByAppendingPathComponent:@"MyData.xml"];

        // 写入
        BOOL result2 = [self.myDataArray writeToFile:arrPath atomically:YES];
//        NSLog(@"数组写入结果: %d, 地址:%@, 数组:%@", result2, path2, self.myDataArray);
        
        self.hview.update.text = [NSString stringWithFormat:@"最終更新 %@", model.time];
        self.hview.numder.text = model.scale;
        [self.progress hide:YES];
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
//        [self.progress hide:YES];
        return ;
    }];
}

#pragma mark - nacigation
/// 返回
- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"SYSZO"];
//    CGPoint temp = view.center;
//    temp.x -= 30;
//    view.center = temp;
//    
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
        [view setTitleImage:nil titleName:@"SYSZO"];
        //    CGPoint temp = view.center;
        //    temp.x -= 30;
        //    view.center = temp;
        //
        CGRect tempSize = view.frame;
        tempSize.size.width += 15;
        view.frame = tempSize;

        NSLog(@"返回");
    }
}


//右上角方法
- (void)rightSettingAction:(UIButton *)bar
{
    MPSettingViewController *viewC = [[MPSettingViewController alloc] init];
//    viewC.tempArray = self.myDataArray;
    UserModel *user = [UserModel unpackUserInfo];
    __block MyPageViewController *myPage = self;
    viewC.reloadDataBlock = ^(){
        [myPage netWorkingWithUserID:user.user_id];
    };
    
    [self.navigationController pushViewController:viewC animated:YES];
}
- (void)rightHistoryAction:(UIButton *)bar
{/// 投稿履历
    MPHistroyViewController *MPHistroyVC = [[MPHistroyViewController alloc] init];
    
    [self.navigationController pushViewController:MPHistroyVC animated:YES];
}
#pragma mark---
#pragma mark 创建表视图

- (void)createTableView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 140 * (CON_WIDTH / 320))];
    headerView.backgroundColor = [UIColor colorWithString:@"dbdbdb" alpha:1];
    self.hview = [[MyPageHeaderView alloc] initWithFrame:CGRectMake(5, 5, CON_WIDTH - 10, 140 * (CON_WIDTH / 320) - 40)];
    [headerView addSubview:self.hview];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(CON_WIDTH - 100 - 30, self.hview.frame.size.height + 10, 120, 140 - 100 - 15);
//    [button setBackgroundColor:[UIColor whiteColor]];
    button.titleLabel.font = FONT_SIZE_6(13.f);
    [button setTitle:@"完成度とは?" forState:UIControlStateNormal];
    UIImage *sU0 = [[UIImage imageNamed:@"icon_q"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:sU0 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithString:@"89a9ca" alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(illustrateView) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 25;
    //除去线
    self.tableView.separatorStyle = NO;
    self.tableView.tableHeaderView = headerView;
    [self.view addSubview:self.tableView];
}
/// 完成度说明出现的方法
- (void)illustrateView
{
    NSLog(@"说明");
    MyAlertView *alert = [[MyAlertView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT)];
    alert.string = @"完成度を高めると、\nシストモで検索されやすくなったり\n新しいつながりがたくさん増えるよ！";
    alert.alpha = 0;
    [self.view.window addSubview:alert];
    [UIView animateWithDuration:0.8f animations:^{
        alert.alpha = 1;
    }];
    
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
            return self.myDataArray.count - 1;
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
            static NSString *string = @"mypageFrist";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.textLabel.text = self.user.user_name;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.image = [UIImage imageNamed:@"icon_myname"];
            cell.textLabel.font = FONT_SIZE_6(15.f);
            return cell;
        }
            break;
        case 1:
        {
            NSString *content = self.myDataArray[indexPath.row];
            if ((indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9) && content && ![content isEqualToString:@""] && [content containsString:@","]) {
                NSArray  *nib= [[NSBundle mainBundle] loadNibNamed:@"MultiSelectionTableViewCell" owner:self options:nil];
                MultiSelectionTableViewCell *MSCell = [nib objectAtIndex:0];
                MSCell.titleLabel.text = self.dataArray[indexPath.row];
                MSCell.addbutton.hidden = YES;
                NSArray *contents = [content componentsSeparatedByString:@","];
                float cellHight;
                if (!content || [content isEqualToString:@""]) {
                    cellHight = 45;
                }
                else if (![content containsString:@","]) {
                    cellHight = 45;
                }
                else {
                    cellHight = contents.count * 35 + 10;
                }
                MSCell.titleLabel.frame = CGRectMake(5, (cellHight - MSCell.titleLabel.frame.size.height) / 2, (SCREEN_WIDTH - 10) / 5 * 2 - 15, MSCell.titleLabel.frame.size.height);
                
                for (int i = 0; i < contents.count; i ++) {
                    UILabel *contentButton = [[UILabel alloc] initWithFrame:CGRectMake(10 + (SCREEN_WIDTH - 10) / 5 * 2, 5 + i * 35, SCREEN_WIDTH - (10 + (SCREEN_WIDTH - 10) / 5 * 2) - 10, 35)];
                    contentButton.textColor = [UIColor blackColor];
                    contentButton.text = contents[i];
                    [MSCell addSubview:contentButton];
                }
                MSCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return MSCell;
            }
            static NSString *string = @"mypageSec";
            MyResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[MyResumeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.categoryTitle.text = self.dataArray[indexPath.row];
            if (indexPath.row == 11) {
                cell.contentTitle.text = [NSString stringWithFormat:@"%@ 人", self.myDataArray[indexPath.row]];
            } else if(indexPath.row == 12){
                cell.contentTitle.text = [NSString stringWithFormat:@"%@ いいね", self.myDataArray[indexPath.row]];
            } else {
                cell.contentTitle.text = self.myDataArray[indexPath.row];
            }
            
            return cell;
        }
            break;
        case 2:
        {
            static NSString *string = @"mypageThi";
            MyDataIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[MyDataIntroduceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selfIntroduce.text = [self.myDataArray lastObject];
            cell.selfIntroduce.editable = NO;
            return cell;
        }
            break;
            
        default:
        {
            static NSString *string = @"mypagenull";
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
            if (indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9) {
                NSString *content = self.myDataArray[indexPath.row];
                if (!content || [content isEqualToString:@""]) {
                    return 45;
                }
                if (![content containsString:@","]) {
                    return 45;
                }
                NSArray *contents = [content componentsSeparatedByString:@","];
                return contents.count * 35 + 10;
            }
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
