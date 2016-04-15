//
//  SearchResultPeopelViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/13.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SearchResultPeopelViewController.h"
#import "SystomoSelectGoodFirendCell.h"
//#import "systomocell."
#import "SystomoSearch.h"
#import "FriendsDataViewController.h"
@interface SearchResultPeopelViewController () <UITableViewDataSource, UITableViewDelegate, NADViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NADView *ADView;
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation SearchResultPeopelViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 2;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_systomo" titleName:@"シストモ追加"];
    CGPoint temp = view.center;
    temp.x -= 0;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width += 0;
    view.frame = tempSize;
    
    [self creatView];
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
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT-_ADView.frame.size.height);
}
/// 返回
- (void)comeBack
{
    
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_systomo" titleName:@"シストモ検索"];
    CGPoint temp = view.center;
    temp.x += 0;
    view.center = temp;
    
    CGRect tempSize = view.frame;
    tempSize.size.width -= 0;
    view.frame = tempSize;
    
    //        @property (assign, nonatomic) BOOL comYes;
            self.comYes = YES;
    //
    //        if (self.comYes ) {
    //            return;
    //        }
    [self.navigationController popViewControllerAnimated:YES];
    self.block();
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject: self])
    {//        @property (assign, nonatomic) BOOL comYes;
        //        self.comYes = YES;
        //
                if (self.comYes ) {
                    return;
                }
        
        NavbarView *view = [NavbarView sharedInstance];
        [view setTitleImage:@"micon_systomo" titleName:@"シストモ検索"];
        CGPoint temp = view.center;
        temp.x += 0;
        view.center = temp;
        
        CGRect tempSize = view.frame;
        tempSize.size.width -= 0;
        view.frame = tempSize;
            self.block();
        NSLog(@"返回");
    }
}


- (void)setCat_id:(NSString *)cat_id
{
    if (_cat_id != cat_id) {
        _cat_id = cat_id;
    }
    [self creatData];
    [self headRefreshing];

   // NSLog(@"======%@", cat_id);
}
- (void)creatData
{
    self.tableArr = [NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SearchResultResultUrl];
    NSLog(@"网址==%@", str);
    UserModel *user = [UserModel unpackUserInfo];
    //传入的参数
    NSDictionary *parameters = @{@"cat_sonType":self.cat_id, @"p_size":@"20",@"p_num":@"1", @"user_id":user.user_id, @"cat_type":self.urlType};
    
    __weak SearchResultPeopelViewController *RequestPeople = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"==+++++%@", responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            return;
        }
        if ([result isEqualToString:@"1"]) {
            NSLog(@"%@=====", responseObject);
            }
        NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
        for (NSDictionary *dic in tempArr) {
            SystomoSearch *resultSearch = [[SystomoSearch alloc] init];
            [resultSearch setValuesForKeysWithDictionary:dic];
            [RequestPeople.tableArr addObject:resultSearch];
        }
            [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)headRefreshing
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = WILL_LODE;
    self.tableView.headerReleaseToRefreshText = DID_LODE;
    self.tableView.headerRefreshingText = LODEING;
    
    self.tableView.footerPullToRefreshText = WILL_LODE;
    self.tableView.footerReleaseToRefreshText = DID_LODE;
    self.tableView.footerRefreshingText = LODEING;
}
- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
  
        NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SearchResultPeopleUrl];
        //传入的参数
        NSDictionary *parameters = @{@"cat_sonType":self.cat_id, @"p_size":@"20",@"p_num":[NSString stringWithFormat:@"%ld", (long)self.page]};
        self.page += 1;
        __weak SearchResultPeopelViewController *RequestPeople = self;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result = [responseObject objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                return;
            }
            if ([result isEqualToString:@"1"]) {
                NSLog(@"%@=====", responseObject);
            }
            NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in tempArr) {
                SystomoSearch *resultSearch = [[SystomoSearch alloc] init];
                [resultSearch setValuesForKeysWithDictionary:dic];
                [RequestPeople.tableArr addObject:resultSearch];
            }
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        [self.tableView footerEndRefreshing];
        
    });
    
    
}
- (void)creatView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT-_ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    NSString *str = @"searchResultCell";
    SystomoSelectGoodFirendCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (!cell) {
        cell = [[SystomoSelectGoodFirendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SystomoSearch *resultSearch = [self.tableArr objectAtIndex:indexPath.row];
    
    if ([resultSearch.if_member isEqualToString:@"2"]) {
        cell.userImage.image = [UIImage imageNamed:@"icon_nofollow"];
    } else {
        cell.userImage.image = [UIImage imageNamed:@"icon_follow"];
    }    
//    cell.userImage.image = [UIImage imageNamed:@"btn_nofollow_big"];
    [cell.proFileBtn setBackgroundImage:[UIImage imageNamed:@"btn_profile_off"] forState:UIControlStateNormal];
    cell.titleLabel.text = resultSearch.member_name;
    cell.proFileAction = ^(){
        NSLog(@"点击进入好友预览界面");
        FriendsDataViewController *friendData = [[FriendsDataViewController alloc] init];
        friendData.member_id = resultSearch.member_id;
        [self.navigationController pushViewController:friendData animated:YES];
    };

    return cell;
}
//  section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}
///  自定义section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 25)];
    view.backgroundColor = [UIColor colorWithString:@"d0d0d0" alpha:1];
    
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 , 5, CON_WIDTH - 21, 12)];
    sectionTitle.font = FONT_SIZE_6(12.f);
    sectionTitle.textColor = [UIColor colorWithString:@"8f8f8f" alpha:1];
    [view addSubview:sectionTitle];
    sectionTitle.text = [NSString stringWithFormat:@"カテゴリ検索 - (%ld)",(long)self.tableArr.count];
    
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
