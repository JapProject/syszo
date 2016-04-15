//
//  SystomoViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoViewController.h"
#import "SelectHeaderView.h"
#import "SelectHeaderTwoView.h"
#import "SystomoCell.h"
#import "SystomoGropAddViewController.h"
#import "SystomoGropCell.h"
#import "SystomoSearchViewController.h"
#import "FriendsDataViewController.h"   //好友详情页
#import "PowderModel.h"                 //粉与被粉 model
#import "SystomoList.h"
#import "MyAlertView.h"
#import "SystomoGropEditViewController.h"
#import "ChatViewController.h"          // 会话页
#import "ChatGroupViewController.h"
@interface SystomoViewController () <UITableViewDataSource, UITableViewDelegate, NADViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *groupArr;
@property (nonatomic, strong) NSMutableArray *singleArr;
@property (nonatomic, strong) SelectHeaderTwoView *selectView;
@property (nonatomic, strong) NSString *uid_a_sum;
@property (nonatomic, strong) NSString *uid_b_sum;
@property (nonatomic, strong) NSString *group_sum;
@property (nonatomic, strong) NSString *member_sum;
@property (assign, nonatomic) BOOL isyse;
@property (assign, nonatomic) BOOL comYes;
@property (nonatomic, strong) NADView *ADView;

//        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }


@end

@implementation SystomoViewController
- (BOOL)isyse
{
    if (!_isyse) {
        _isyse = YES;
        
    }
    return _isyse;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置右上角导航栏
    UIBarButtonItem *addGrop = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_plus_off"] style:UIBarButtonItemStyleDone target:self action:@selector(rightGropAction:)];
    UIImage *searcg_g = [[UIImage imageNamed:@"btn_group_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *addIndividual = [[UIBarButtonItem alloc] initWithImage:searcg_g style:UIBarButtonItemStyleDone target:self action:@selector(rightIndividualAction:)];
    self.navigationItem.rightBarButtonItems = @[addGrop, addIndividual];
    
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_systomo" titleName:@"シストモ"];
    CGPoint temp = view.center;
    temp.x += 10;
    view.center = temp;
    
    CGRect tempSize = view.frame;
    tempSize.size.width -= 20;
    view.frame = tempSize;
    self.groupArr = [NSMutableArray array];
    self.singleArr = [NSMutableArray array];
    [self creatView];
    UserModel *user = [UserModel unpackUserInfo];
    [self creatDataWithUser_id:user.user_id Num:@"1"];
    
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

    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    [self.progress show:YES];
    [self.view addSubview:self.progress];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotissss:) name:@"通知" object:nil];

}

#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
    self.tableView.frame = CGRectMake(0, CON_WIDTH / 480 * 70, CON_WIDTH, CON_HEIGHT - 64 - _ADView.frame.size.height - CON_WIDTH / 480 * 70);
}
/// 返回
- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"SYSZO"];
    CGPoint temp = view.center;
    temp.x -= 10;
    view.center = temp;
    
    CGRect tempSize = view.frame;
    tempSize.size.width += 20;
    view.frame = tempSize;
    self.comYes = YES;
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
        CGPoint temp = view.center;
        temp.x -= 10;
        view.center = temp;
        
        CGRect tempSize = view.frame;
        tempSize.size.width += 20;
        view.frame = tempSize;

    }
}



- (void)creatDataWithUser_id:(NSString *)user_id Num:(NSString *)num {
    
    //加菊花
    [self.progress show:YES];


    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SystomoListUrl];
    //传入的参数
    NSDictionary *parameters = @{@"user_id": user_id, @"p_num": num,@"p_size":@"20"};
    
    __weak SystomoViewController *systomoVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *tempDic = [responseObject objectForKey:@"data"];
      //  NSLog(@"========%@", responseObject);
        self.group_sum = [tempDic objectForKey:@"group_sum"];
        self.member_sum = [tempDic objectForKey:@"member_sum"];
        self.uid_a_sum = [tempDic objectForKey:@"uid_a_sum"];
        self.uid_b_sum = [tempDic objectForKey:@"uid_b_sum"];
       //组成员列表
        NSMutableArray *tempArr = [tempDic objectForKey:@"list_g"];
        for (NSDictionary *dic in tempArr) {
            SystomoList *systomoList = [[SystomoList alloc] init];

            [systomoList setValuesForKeysWithDictionary:dic];
            [systomoVC.groupArr addObject:systomoList];
        }
       //个人好友列表
      NSMutableArray *tempArr1 = [tempDic objectForKey:@"list_m"];
        for (NSDictionary *dic1 in tempArr1) {
            SystomoList *systomoList = [[SystomoList alloc] init];
       [systomoList setValuesForKeysWithDictionary:dic1];
       [systomoVC.singleArr addObject:systomoList];

        }
        //按钮上的数字
        self.selectView.btnNumber = [NSMutableArray arrayWithObjects:self.uid_a_sum,self.uid_b_sum, nil];
        [self.progress hide:YES];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
    }];
}
#pragma mark 粉与被粉的网络请求
- (void)netWorkingWithTypeURL:(NSString *)urlString userId:(NSString *)user_id page:(NSString *)page
{
    //加菊花
    
    [self.progress show:YES];

    NSString *str = urlString;
    //传入的参数
    NSDictionary *parameters = @{@"user_id":user_id,@"p_num":page,@"p_size":@"20"};
    __weak SystomoViewController *systomoVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"========%@", responseObject);
        systomoVC.tableView.sectionHeaderHeight = 0;
        [systomoVC.groupArr removeAllObjects];
        [systomoVC.singleArr removeAllObjects];
        NSMutableArray *tempArray = [responseObject objectForKey:@"data"];
        for (NSDictionary *dic in tempArray) {
            PowderModel *model = [[PowderModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [systomoVC.singleArr addObject:model];
        }
        [systomoVC.tableView reloadData];
        [self.progress hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
}

- (void)creatView
{
    self.selectView = [[SelectHeaderTwoView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_WIDTH / 480 * 70)];
//    self.selectView.imageNames_off = [NSMutableArray arrayWithObjects:@"subnavi_left_off", @"subnavi_right_off", nil];
//    self.selectView.imageNames_on = [NSMutableArray arrayWithObjects:@"subnavi_left_on",  @"subnavi_right_on", nil];
//    self.selectView.titles = [NSMutableArray arrayWithObjects: @"フォロー", @"フォロワー", nil];
    // 传出tag值，并可以执行方法
    __block SystomoViewController *viewC = self;
    self.selectView.SelectTableView = ^(NSInteger tag){
        NSLog(@"%ld", (long)tag);
        // 网络请求，刷新列表
        UserModel *user = [UserModel unpackUserInfo];
        switch (tag) {
            case 30303:/// 我的好友(互粉的)
            {
                NSString *urlSting = [NSString stringWithFormat:@"%@%@", TiTleUrl, SystomoListPowder];
                [viewC netWorkingWithTypeURL:urlSting userId:user.user_id page:@"1"];
            }
                break;
            case 30304:/// 我粉过的
            {
                NSString *urlSting = [NSString stringWithFormat:@"%@%@", TiTleUrl, SystomoListThePowder];
                [viewC netWorkingWithTypeURL:urlSting userId:user.user_id page:@"1"];
            }
                break;
            default:
                break;
        }
                
    };
    [self.view addSubview:self.selectView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CON_WIDTH / 480 * 70, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height - CON_WIDTH / 480 * 70) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //除去线
    self.tableView.separatorStyle = NO;
    self.tableView.sectionHeaderHeight = 25;

//    [self setupRefresh];
    [self.view addSubview:self.tableView];
    
    

}
- (void)receiveNotissss:(NSNotification *)noti
{
    UserModel *user = [UserModel unpackUserInfo];
    [self.progress show:YES];
    [self.tableView removeFromSuperview];
    [self.selectView removeFromSuperview];
    [self.singleArr removeAllObjects];
    [self.groupArr removeAllObjects];
    [self creatView];
    [self creatDataWithUser_id:user.user_id Num:@"1"];
}
//  section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
///  每个section里的row的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.groupArr.count;
            break;
        case 1:
            return self.singleArr.count;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.section) {
        case 0:
        {
            static NSString *str = @"SystomoViewCellone";
            SystomoGropCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
            if (!cell) {
                cell = [[SystomoGropCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.userImage.image = [UIImage imageNamed:@"icon_group"];
            if(indexPath.row <  self.groupArr.count ){
                
                SystomoList *systomoList = [self.groupArr objectAtIndex:indexPath.row];
                
                cell.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", systomoList.group_name, systomoList.group_number];
            }
            return cell;

        }
            break;
        case 1:
        {
            static NSString *str = @"SystomoViewCelltwo";
            SystomoCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
            if (!cell) {
                cell = [[SystomoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.proFileBtn setBackgroundImage:[UIImage imageNamed:@"btn_profile_off"] forState:UIControlStateNormal];
            
            if ( indexPath.row < self.singleArr.count) {
           
            id model = [self.singleArr objectAtIndex:indexPath.row];
            if ([model isKindOfClass:[SystomoList class]]) {
                SystomoList *systomoList = [self.singleArr objectAtIndex:indexPath.row];
                cell.userImage.image = [UIImage imageNamed:@"icon_follow"];
                cell.titleLabel.text = systomoList.member_name;
                
                cell.proFileAction = ^(){
                    NSLog(@"点击进入好友预览界面");
                    FriendsDataViewController *friendData = [[FriendsDataViewController alloc] init];
                    friendData.refreshBlock = ^(){
                        UserModel *user = [UserModel unpackUserInfo];
                        [self.tableView removeFromSuperview];
                        [self.selectView removeFromSuperview];
                        [self.singleArr removeAllObjects];
                        [self.groupArr removeAllObjects];
                        [self creatView];
                        [self creatDataWithUser_id:user.user_id Num:@"1"];
                    };
                    friendData.member_id = systomoList.member_id;
                    [self.navigationController pushViewController:friendData animated:YES];
                };
            }
            
            if ([model isKindOfClass:[PowderModel class]]) {
                PowderModel *model = [self.singleArr objectAtIndex:indexPath.row];
                if ([model.if_member isEqualToString:@"2"]) {
                    cell.userImage.image = [UIImage imageNamed:@"icon_nofollow"];
                } else {
                    cell.userImage.image = [UIImage imageNamed:@"icon_follow"];
                }
                cell.titleLabel.text = model.member_name;
                cell.proFileAction = ^(){
                    NSLog(@"点击进入好友预览界面");
                    FriendsDataViewController *friendData = [[FriendsDataViewController alloc] init];
                    friendData.refreshBlock = ^(){
                        UserModel *user = [UserModel unpackUserInfo];
                        [self.tableView removeFromSuperview];
                        [self.selectView removeFromSuperview];
                        [self.singleArr removeAllObjects];
                        [self.groupArr removeAllObjects];
                        [self creatView];
                        [self creatDataWithUser_id:user.user_id Num:@"1"];
                    };
                    friendData.member_id = model.member_id;
                    [self.navigationController pushViewController:friendData animated:YES];
                };

            }
             }
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

    return nil;
    
}
///  自定义section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 25)];
    view.backgroundColor = [UIColor colorWithString:@"dfdfdf" alpha:1];

    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 , 5, CON_WIDTH - 21, 12)];
    sectionTitle.font = FONT_SIZE_6(12.f);
    sectionTitle.textColor = [UIColor colorWithString:@"8f8f8f" alpha:1];
    [view addSubview:sectionTitle];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 24, CON_WIDTH, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [view addSubview:line];
    
    switch (section) {
        case 0:
            sectionTitle.text = [NSString stringWithFormat:@"グループ (%@)", self.group_sum];
            break;
        case 1:
            sectionTitle.text = [NSString stringWithFormat:@"シストモ (%@)", self.member_sum];
            break;
            
        default:
            break;
    }
    
    return view;
}
/// 点击cell的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            MyAlertView *alert = [[MyAlertView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT)];
            SystomoList *model = self.groupArr[indexPath.row];
            alert.groupModel = model;
            alert.alpha = 0;
            [self.view.window addSubview:alert];
            [UIView animateWithDuration:0.8f animations:^{
                alert.alpha = 1;
                
            }];
            __block SystomoViewController *systomo = self;
            __block MyAlertView *alertTemp = alert;
            /// 跳转1
            alert.GroupSessionBlock= ^(){
                NSLog(@"跳转会话2 群名:%@ 群id:%@", model.group_name, model.group_id);
                
                ChatGroupViewController *chatGroup = [[ChatGroupViewController alloc] init];
                chatGroup.group_id = model.group_id;
                [systomo.navigationController pushViewController:chatGroup animated:YES];
                [UIView animateWithDuration:0.8f animations:^{
                    alertTemp.alpha = 0;
                } completion:^(BOOL finished) {
                    [alertTemp removeFromSuperview];
                }];
            };
            /// 跳转2
            alert.QuitGroupBlock = ^(){
                NSLog(@"跳转退会页2");
                SystomoGropEditViewController *GropEditVC = [[SystomoGropEditViewController alloc] init];
                GropEditVC.refreshBlock = ^(){
                    NSLog(@"编辑后返回刷新,下拉刷新");
                    [self.groupArr removeAllObjects];
                    [self.singleArr removeAllObjects];
                    UserModel *user = [UserModel unpackUserInfo];
                    [self creatDataWithUser_id:user.user_id Num:@"1"];
                };
                
                GropEditVC.model = alertTemp.groupModel;
                [systomo.navigationController pushViewController:GropEditVC animated:YES];
                [UIView animateWithDuration:0.8f animations:^{
                    alertTemp.alpha = 0;
                } completion:^(BOOL finished) {
                    [alertTemp removeFromSuperview];
                }];
                
            };
        }
            break;
        case 1:
        {
            //个人id传值
            SystomoList *model = self.singleArr[indexPath.row];
            ChatViewController *chat = [[ChatViewController alloc] init];
            chat.member_id = model.member_id;
            [self.navigationController pushViewController:chat animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark   新建群
- (void)rightIndividualAction:(UIButton *)button{
    
    SystomoGropAddViewController *gropAdd = [[SystomoGropAddViewController alloc] init];
    gropAdd.refreshBlock = ^(){
        UserModel *user = [UserModel unpackUserInfo];
        [self.progress show:YES];
        [self.tableView removeFromSuperview];
        [self.selectView removeFromSuperview];
        [self.singleArr removeAllObjects];
        [self.groupArr removeAllObjects];
        [self creatView];
        [self creatDataWithUser_id:user.user_id Num:@"1"];
    };
    [self.navigationController pushViewController:gropAdd animated:YES];
    
}
#pragma mark-
#pragma mark 检索
- (void)rightGropAction:(UIButton *)button{

    //跳转检索界面
    SystomoSearchViewController *searchVC = [[SystomoSearchViewController alloc] init];
    searchVC.refreshBlock = ^(){
        UserModel *user = [UserModel unpackUserInfo];
        [self.progress show:YES];
        [self.tableView removeFromSuperview];
        [self.selectView removeFromSuperview];
        [self.singleArr removeAllObjects];
        [self.groupArr removeAllObjects];
        [self creatView];
        [self creatDataWithUser_id:user.user_id Num:@"1"];
    };
    [self.navigationController pushViewController:searchVC animated:YES];
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
