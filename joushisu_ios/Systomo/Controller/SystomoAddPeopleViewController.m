//
//  SystomoAddPeopleViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/8.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoAddPeopleViewController.h"
#import "SystomoSelectGoodFirendCell.h"
#import "FriendsDataViewController.h"   /// 好友详情页
#import "GroupSelectFriendCell.h"       /// 添加好友cell


#import "SystomoList.h"
@interface SystomoAddPeopleViewController () <UITableViewDataSource, UITableViewDelegate, NADViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, strong) NADView *ADView;
//@property (nonatomic, strong) NSMutableArray *friendArray;
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation SystomoAddPeopleViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        self.friendArray = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.friendArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_systomo" titleName:@"メンバー招待"];
    CGPoint temp = view.center;
    temp.x -= 0;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width += 0;
    view.frame = tempSize;
    
    
    [self creatTableView];
    UserModel *user = [UserModel unpackUserInfo];

    [self creatDataWithUser_id:user.user_id];
    
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
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT -_ADView.frame.size.height);
}
/// 返回
- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_systomo" titleName:@"グループ作成"];
    CGPoint temp = view.center;
    temp.x += 0;
    view.center = temp;
    
    CGRect tempSize = view.frame;
    tempSize.size.width -= 0;
    view.frame = tempSize;
    //            @property (assign, nonatomic) BOOL comYes;
            self.comYes = YES;
    //
    //        if (self.comYes ) {
    //            return;
    //        }    self.MyFriendsBlock(self.friendArray);
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
        [view setTitleImage:@"micon_systomo" titleName:@"グループ作成"];
        CGPoint temp = view.center;
        temp.x += 0;
        view.center = temp;
        
        CGRect tempSize = view.frame;
        tempSize.size.width -= 0;
        view.frame = tempSize;

        NSLog(@"返回");
    }
}


- (void)creatDataWithUser_id:(NSString *)user_id
{

    self.tableArr = [NSMutableArray array];
////        [self.tableArr removeAllObjects];
        NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SystomoAddPeopleUrl];
        //传入的参数
        NSDictionary *parameters = @{@"user_id" : user_id};
        
        __weak SystomoAddPeopleViewController *systomoAddVC = self;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//               NSLog(@"======%@", responseObject);
            NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
            if ([tempArr isEqual:@""]) {
                return ;
            }
            for (NSMutableDictionary *dic in tempArr) {
                SystomoList *systomo = [[SystomoList alloc] init];
                [systomo setValuesForKeysWithDictionary:dic];
                [systomoAddVC.tableArr addObject:systomo];
            }
            
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // NSLog(@"%@", error);
        }];       
}



- (void)creatTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT -_ADView.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //除去线
    self.tableView.separatorStyle = NO;
    self.tableView.sectionHeaderHeight = 25;
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"selectFriend";
    GroupSelectFriendCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (!cell) {
        cell = [[GroupSelectFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SystomoList *systomo = [self.tableArr objectAtIndex:indexPath.row];
    
    cell.model = systomo;
    
    for (SystomoList *model in self.friendArray) {
        if ([model.member_id isEqualToString:systomo.member_id]) {
            cell.model.selectCount = @"1";
            break;
        }
    }
    
    
    cell.profileBlock = ^(){
        NSLog(@"点击进入好友预览界面");
        FriendsDataViewController *friendData = [[FriendsDataViewController alloc] init];
        friendData.member_id = systomo.member_id;
        [self.navigationController pushViewController:friendData animated:YES];
    };
    cell.selectFriendBlock = ^(SystomoList *model){
        NSLog(@"选择添加好友");
        [self.friendArray addObject:model];
    };
    cell.disSelectFriendBlock = ^(SystomoList *model){
        NSLog(@"选择删除好友");
        for (SystomoList *model2 in self.friendArray) {
            if ([model2.member_id isEqualToString:model.member_id]) {
                [self.friendArray removeObject:model2];
                break;
            }
        }
    };
    
    return cell;
}
//  section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
///  自定义section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 25)];
    view.backgroundColor = [UIColor colorWithString:@"d0d0d0" alpha:1];
    
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 , 5, CON_WIDTH - 21, 12)];
    sectionTitle.font = FONT_SIZE_6(12.f);
    sectionTitle.text = @"シストモ";
    sectionTitle.textColor = [UIColor colorWithString:@"8f8f8f" alpha:1];
    [view addSubview:sectionTitle];
    return view;
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
