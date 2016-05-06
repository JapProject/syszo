//
//  SysteerViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SysteerViewController.h"
#import "SysteerHomeCell.h"
#import "SelectHeaderView.h"
#import "SysteerEditInfoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SysteerSearchViewController.h"
#import "SystterList.h"
#import "SysteerInfoViewController.h"
@interface SysteerViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,NADViewDelegate>
@property (nonatomic, strong)SelectHeaderView *selectView;  //  表头视图
@property (nonatomic, strong)UISearchBar *bar;
@property (nonatomic, strong) NSString *selectCount;
@property (nonatomic, strong) NSString *pageNumder1;
@property (nonatomic, strong) NSString *pageNumder2;
@property (nonatomic, strong) NSString *pageNumder3;
@property (nonatomic, strong) NSString *KayWordText;
@property (nonatomic, strong) NADView *ADView;
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation SysteerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //选择标识
        self.selectCount = [[NSString alloc] init];
        self.selectCount = @"1";
        self.pageNumder1 = [[NSString alloc] init];
        self.pageNumder2 = [[NSString alloc] init];
        self.pageNumder3 = [[NSString alloc] init];
        self.KayWordText = [[NSString alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavbarView *view = [NavbarView sharedInstance];
    self.tabArr = [NSMutableArray array];
    [view setTitleImage:@"micon_hitorigoto" titleName:@"シスッター"];
    CGRect tempSize = view.frame;
    tempSize.size.width -= 15;
    view.frame = tempSize;

    [self createView];
//    [self creatDataWithType:@"1" Keyword:@""];
    
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
    self.tableView.frame = CGRectMake(0, CON_WIDTH / 480 * 70, CON_WIDTH, CON_HEIGHT - 64 - CON_WIDTH / 480 * 70 - _ADView.frame.size.height);
}

- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"SYSZO"];
    CGRect tempSize = view.frame;
    tempSize.size.width += 15;
    view.frame = tempSize;
    //改导航栏颜色
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:59 / 255.0 green:58 / 255.0 blue:56/ 255.0 alpha:1];
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
        CGRect tempSize = view.frame;
        tempSize.size.width += 15;
        view.frame = tempSize;
        //改导航栏颜色
        self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:59 / 255.0 green:58 / 255.0 blue:56/ 255.0 alpha:1];
        NSLog(@"返回");
    }
}

- (void)createView
{
    
    // 设置右上角导航栏
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_post_off"] style:UIBarButtonItemStyleDone target:self action:@selector(rightEditAction:)];
    UIImage *searcg_g = [[UIImage imageNamed:@"btn_search_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:searcg_g style:UIBarButtonItemStyleDone target:self action:@selector(rightSearchAction:)];
    self.navigationItem.rightBarButtonItems = @[edit, search];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:132 green:162 blue:202 alpha:1];

    
    self.selectView = [[SelectHeaderView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_WIDTH / 480 * 70)];
    self.selectView.viewControllerTag = @"bird";

    // 传出tag值，并可以执行方法
    __block SysteerViewController *vc = self;
    self.selectView.SelectTableView = ^(NSInteger tag){
       // NSLog(@"%ld", tag);
        // 网络请求，刷新列表
        vc.KayWordText = @"";
        vc.selectCount = [NSString stringWithFormat:@"%ld", (long)(tag - 19190)];
        [vc.tableView headerBeginRefreshing];
//        [vc creatDataWithType:[NSString stringWithFormat:@"%ld", (long)(tag - 19190)] Keyword:@""];
    };
    [self.view addSubview:self.selectView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CON_WIDTH / 480 * 70, CON_WIDTH, CON_HEIGHT - 64 - CON_WIDTH / 480 * 70 -_ADView.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //除去线
    self.tableView.separatorStyle = NO;
    self.tableView.sectionHeaderHeight = 0;
    [self setupRefresh];
    [self.view addSubview:self.tableView];

}

/// keyWord搜索
- (void)creatDataWithType:(NSString *)type Keyword:(NSString *)keyword pageNumder:(NSString *)pageNum
{
    [self.tabArr removeAllObjects];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl, SysteerListUrl];
    __weak SysteerViewController *systeerVC = self;
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];
    NSDictionary *parameters = [NSDictionary dictionary];
    if (!user) {
        parameters = @{@"type":type,@"p_num":pageNum,@"p_size":@"20",@"keyword":keyword};
    } else {
        parameters = @{@"type":type,@"p_num":pageNum,@"p_size":@"20",@"user_id":user.user_id,@"keyword":keyword};
    }
    [self.progress show:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
        //NSLog(@"%@========2313", tempArr);
        if ([pageNum isEqualToString:@"1"]) {
            [self.tabArr removeAllObjects];
        }
        if (tempArr.count != 0) {
            
            for (NSDictionary *dic in tempArr) {
                SystterList *systList = [[SystterList alloc] init];
                [systList setValuesForKeysWithDictionary:dic];
                [systeerVC.tabArr addObject:systList];
            }
            [self.progress  hide:YES];
            [self.tableView reloadData];
        } else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SearchEmpty message:nil delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
            [alertView show];
            [self.progress hide:YES];
            return;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"operation =====%@", operation.responseString);

    }];
}
#pragma mark 刷新加载实现
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = WILL_LODE;
    self.tableView.headerReleaseToRefreshText = DID_LODE;
    self.tableView.headerRefreshingText = LODEING;
    
    self.tableView.footerPullToRefreshText = WILL_LODE;
    self.tableView.footerReleaseToRefreshText = DID_LODE;
    self.tableView.footerRefreshingText = LODEING;
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    _count1 = 2;
    _count2 = 2;
    _count3 = 2;
    //    self.selectCount = @"1";
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self creatDataWithType:self.selectCount Keyword:self.KayWordText pageNumder:@"1"];
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}
static NSInteger _count1 = 2;
static NSInteger _count2 = 2;
static NSInteger _count3 = 2;
- (void)footerRereshing
{
    // 1.添加假数据
    switch ([self.selectCount integerValue]) {
        case 1:
        {
            self.pageNumder1 = [NSString stringWithFormat:@"%ld", (long)_count1];
            NSLog(@"页码_count1----%@", self.pageNumder1);
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tabArr];
            [self creatDataWithType:self.selectCount Keyword:self.KayWordText pageNumder:self.pageNumder1];
            _count1 ++;
            for (SystterList *model in temp) {
                [self.tabArr insertObject:model atIndex:self.tabArr.count];
            }
            //    [self.tabelArr addObjectsFromArray:temp];
        }
            break;
        case 2:
        {
            self.pageNumder2 = [NSString stringWithFormat:@"%ld", (long)_count2];
            NSLog(@"页码_count2----%@", self.pageNumder2);
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tabArr];
            [self creatDataWithType:self.selectCount Keyword:self.KayWordText pageNumder:self.pageNumder2];
            _count2 ++;
            for (SystterList *model in temp) {
                [self.tabArr insertObject:model atIndex:self.tabArr.count];
            }
            //    [self.tabelArr addObjectsFromArray:temp];
        }
            break;
        case 3:
        {
            self.pageNumder3 = [NSString stringWithFormat:@"%ld", (long)_count3];
            NSLog(@"页码_count3----%@", self.pageNumder3);
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tabArr];
            [self creatDataWithType:self.selectCount Keyword:self.KayWordText pageNumder:self.pageNumder3];
            _count3 ++;
            for (SystterList *model in temp) {
                [self.tabArr insertObject:model atIndex:self.tabArr.count];
            }
            //    [self.tabelArr addObjectsFromArray:temp];
        }
            break;
            
        default:
            break;
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}
#pragma mark - tableView协议
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystterList *systList = [self.tabArr objectAtIndex:indexPath.row];
    static NSString *string = @"dfafqwefq";
    SysteerHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[SysteerHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = CELL_COLOR;
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.UserName.text = systList.user_name;
    cell.infoLabel.text = systList.content;
    //设置会员图标



    //    UILabel设置行间距等属性：
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:cell.infoLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:LineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, cell.infoLabel.text.length)];
    cell.infoLabel.attributedText = attributedString;
    

    cell.timeLabel.text = systList.time;
    
    cell.list = systList;
    
    return cell;
}
//一行cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    SysteerInfoViewController *systeerInfo = [[SysteerInfoViewController alloc] init];
    systeerInfo.systeerList = [self.tabArr objectAtIndex:indexPath.row];
    systeerInfo.refreshBlock = ^(){
        [self.tableView headerBeginRefreshing];
    };
    [self.navigationController pushViewController:systeerInfo animated:YES];
}
//右上角方法
- (void)rightEditAction:(UIButton *)bar
{
    __block SysteerViewController *systeerVC = self;
    UserModel *user = [UserModel unpackUserInfo];
    if (!user) {
        EnterController *enter = [[EnterController alloc] init];
        AppDelegate *appdele = [UIApplication sharedApplication].delegate;
        [appdele.navi presentViewController:enter animated:YES completion:^{
            
        }];
        enter.comeBackBlock = ^(){
            /// 不做登陆操作, 直接返回上一页
            //            [self comeBack];
            [systeerVC.tableView headerBeginRefreshing];
        };
        return;
    }
    SysteerEditInfoViewController *systeerEditVC = [[SysteerEditInfoViewController alloc] init];
    systeerEditVC.refreshEditBlock =^(){
        [systeerVC.tableView headerBeginRefreshing];
    };
    [self.navigationController pushViewController:systeerEditVC animated:YES];
}
static NSInteger search_count = 0;
- (void)rightSearchAction:(UIButton *)bar
{
        if (search_count % 2 == 0) {
            [self.tableView setSectionHeaderHeight:50];
            search_count++;
        } else {
            [self.tableView setSectionHeaderHeight:0];
            search_count++;
        }
        [self.tableView reloadData];
}

#pragma mark 搜索栏的创建以及协议-代理方法

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{/// 创建searchBar
    self.bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    self.bar.delegate = self;
    self.bar.keyboardType = UIKeyboardTypeWebSearch;
    return self.bar;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{/// 文本改变时
    //NSLog(@"searchText====%@", searchText);
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSLog(@"text======%@", text);
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{/// 点击键盘上的搜索时执行的方法
    [searchBar resignFirstResponder];
    self.KayWordText = searchBar.text;
    [self.tableView headerBeginRefreshing];
//    [self.tabArr removeAllObjects];
//    [self creatDataWithType:self.selectCount Keyword:searchBar.text pageNumder:nil];
  //  NSLog(@"%@============", searchBar.text);
}
#pragma mark 回收键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.bar resignFirstResponder];
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
