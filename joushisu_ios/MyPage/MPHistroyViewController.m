//
//  MPHistroyViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/5.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MPHistroyViewController.h"
#import "ChiebukuroList.h"
#import "ChiebukuroListCell.h"
#import "MJRefresh.h"
#import "QandAViewController.h"
#import "SystterList.h"
#import "MyIsPastes.h"
#import "SysteerInfoViewController.h"

@interface MPHistroyViewController () <UITableViewDataSource, UITableViewDelegate,NADViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tabelArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NADView *ADView;
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation MPHistroyViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //数组初始化
        self.tabelArr = [[NSMutableArray alloc] init];
        //选择标识
        self.page = 2;
    }
    return self;
}
- (void)headRefreshing
{
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshingMP)];
    
    [self.tableView headerBeginRefreshing];

    [self.tableView addFooterWithTarget:self action:@selector(footerRereshingMP)];

    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = WILL_LODE;
    self.tableView.headerReleaseToRefreshText = DID_LODE;
    self.tableView.headerRefreshingText = LODEING;
    
    self.tableView.footerPullToRefreshText = WILL_LODE;
    self.tableView.footerReleaseToRefreshText = DID_LODE;
    self.tableView.footerRefreshingText = LODEING;
}
- (void)headerRereshingMP
{
    //自动刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,MyPageFolist];
        //传入的参数
        UserModel *user = [UserModel unpackUserInfo];

        NSDictionary *parameters = @{@"user_id":user.user_id,@"p_num":@"1",@"p_size":@"20"};
        __weak MPHistroyViewController *chieVC = self;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //  NSLog(@"%@=======", responseObject);
            [chieVC.tabelArr removeAllObjects];
            NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in tempArr) {
                    MyIsPastes *chieList = [[MyIsPastes alloc] init];
                    [chieList setValuesForKeysWithDictionary:dic];
                    [chieVC.tabelArr addObject:chieList];
                
            }
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
        [self.tableView headerEndRefreshing];

        });

}
- (void)footerRereshingMP
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,MyPageFolist];
        //传入的参数
        UserModel *user = [UserModel unpackUserInfo];

        NSDictionary *parameters = @{@"type":@"3",@"p_num":[NSString stringWithFormat:@"%ld", (long)self.page],@"p_size":@"20",@"user_id":user.user_id};
        self.page += 1;
        __weak MPHistroyViewController *chieVC = self;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in tempArr) {
                MyIsPastes *chieList = [[MyIsPastes alloc] init];
                [chieList setValuesForKeysWithDictionary:dic];
                [chieVC.tabelArr addObject:chieList];
            }
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
        [self.tableView footerEndRefreshing];

    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"投稿履歴"];
    CGRect tempSize = view.frame;
    tempSize.size.width -= 15;
    view.frame = tempSize;

    [self creatView];
    [self headRefreshing];
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
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height);
}
/// 返回
- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"マイページ"];
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
        [view setTitleImage:nil titleName:@"マイページ"];
        CGRect tempSize = view.frame;
        tempSize.size.width += 15;
        view.frame = tempSize;
        

        NSLog(@"返回");
    }
}


- (void)creatView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //除去线
    //    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];

}
#pragma mark tabelView协议
///  section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//  每个section里的row的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabelArr.count;
}
///  返回tableView里的cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string = @"HistroyCellID";
    ChiebukuroListCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[ChiebukuroListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = CELL_COLOR;
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //往cell上铺
    MyIsPastes *chieList = [self.tabelArr objectAtIndex:indexPath.row];

        cell.chatLabel.textColor = Yellow;
        cell.infoLabel.text = chieList.title;
        cell.chatLabel.text = chieList.comment_sum;
        cell.chatImageView.image = [UIImage imageNamed:@"icon_comment_on"];
        cell.timeLabel.text = chieList.time;

    return cell;
}
/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
/// 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyIsPastes *models = self.tabelArr[indexPath.row];
    if ([models.type isEqualToString:@"1"]) {
  
    QandAViewController *QAVc = [[QandAViewController alloc] init];
        NavbarView *view = [NavbarView sharedInstance];
//    [view setTitleImage:nil titleName:@"SYSZO"];
    CGPoint temp = view.center;
    temp.x += 30;
    view.center = temp;
    
//    CGRect tempSize = view.frame;
//    tempSize.size.width += 15;
//    view.frame = tempSize;
    ChiebukuroList *modelTo = [[ChiebukuroList alloc] init];
        modelTo.know_id =[ models.info_id integerValue] ;
        modelTo.time = models.time;
        modelTo.title = models.title ;
        modelTo.comment_sum = [models.comment_sum integerValue];
    QAVc.chieburoList = modelTo;
        
    QAVc.refreshBlock = ^(){
        [self.tabelArr removeAllObjects];
        [self.tableView headerBeginRefreshing];
    };
    [self.navigationController pushViewController:QAVc animated:YES];
        
    }else{
        SysteerInfoViewController *systeerInfo = [[SysteerInfoViewController alloc] init];
        
        SystterList *systter = [[SystterList alloc] init];
        systter.bird_id = [models.info_id integerValue];
        systter.time = models.time;
        systter.content = models.title ;
        
        systeerInfo.systeerList = systter;
        systeerInfo.refreshBlock = ^(){
            [self.tabelArr removeAllObjects];
            [self.tableView headerBeginRefreshing];
        };
        [self.navigationController pushViewController:systeerInfo animated:YES];
    }
    
}


#pragma mark --
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
