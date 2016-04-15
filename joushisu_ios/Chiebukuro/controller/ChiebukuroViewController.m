//
//  ChiebukuroViewController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "ChiebukuroViewController.h"
#import "NADView.h"



@interface ChiebukuroViewController () <NADViewDelegate>
 @property (assign, nonatomic) BOOL comYes;
@property (strong, nonatomic) NADView *ADView;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation ChiebukuroViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //数组初始化
        self.tabelArr = [[NSMutableArray alloc] init];
        //选择标识
        self.selectCount = [[NSString alloc] init];
        self.selectCount = @"1";
        self.pageNumder1 = [[NSString alloc] init];
        self.pageNumder2 = [[NSString alloc] init];
        self.pageNumder3 = [[NSString alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"知恵袋";
    
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋"];
    CGPoint temp = view.center;
    temp.x += 30;
    view.center = temp;

    CGRect tempSize = view.frame;
    tempSize.size.width -= 45;
    view.frame = tempSize;
    
    [self createTableView];
//    self.selectCount = @"1";
//    [self creatDataWithType:self.selectCount page:@"1"];
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
    _ADView.delegate = self;
    [_ADView load];
    [self.view addSubview:_ADView];
    //加菊花
//    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
//    self.progress.labelText = LODEING;
////    [self.progress show:YES];
//    [self.view addSubview:self.progress];
}
#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
    self.tableView.frame = CGRectMake(0, CON_WIDTH / 480 * 70, CON_WIDTH, CON_HEIGHT - 64 - CON_WIDTH / 480 * 70 -_ADView.frame.size.height);
}
/// 返回
- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"SYSZO"];
    CGPoint temp = view.center;
    temp.x -= 30;
    view.center = temp;
    
    CGRect tempSize = view.frame;
    tempSize.size.width += 45;
    view.frame = tempSize;
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:59 / 255.0 green:58 / 255.0 blue:56/ 255.0 alpha:1];
    //        @property (assign, nonatomic) BOOL comYes;
            self.comYes = YES;
    //
    //        if (self.comYes ) {
    //            return;
    //        }
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
        temp.x -= 30;
        view.center = temp;
        
        CGRect tempSize = view.frame;
        tempSize.size.width += 45;
        view.frame = tempSize;
        self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:59 / 255.0 green:58 / 255.0 blue:56/ 255.0 alpha:1];
        NSLog(@"返回");
    }
}
- (void)creatDataWithType:(NSString *)type page:(NSString *)page
{
//    [self.progress show:YES];
    [self.tabelArr removeAllObjects];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroListUrl];
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];
    NSDictionary *parameters = [NSDictionary dictionary];
    if (!user) {
        parameters = @{@"type":type,@"p_num":page,@"p_size":@"20"};
    } else {
        parameters = @{@"type":type,@"p_num":page,@"p_size":@"20",@"user_id": user.user_id};
    }
//    NSLog(@"网络请求里面的type:%@, page:%@", type, page);
    __weak ChiebukuroViewController *chieVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//         NSLog(@"%@", responseObject);
        NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
        
        for (NSDictionary *dic in tempArr) {
            ChiebukuroList *chieList = [[ChiebukuroList alloc] init];
            [chieList setValuesForKeysWithDictionary:dic];
            [chieVC.tabelArr addObject:chieList];
//            NSLog(@"%@", chieVC.tabelArr);
        }
//        [self.progress hide:YES];

        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"operation =====%@", operation.responseString);
    }];
}
- (void)createTableView
{
    // 设置右上角导航栏
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_post_off"] style:UIBarButtonItemStyleDone target:self action:@selector(rightEditAction:)];
    UIImage *searcg_g = [[UIImage imageNamed:@"btn_search_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:searcg_g style:UIBarButtonItemStyleDone target:self action:@selector(rightSearchAction:)];
    self.navigationItem.rightBarButtonItems = @[edit, search];
    
    SelectHeaderView *selectView = [[SelectHeaderView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_WIDTH / 480 * 70)];
    selectView.viewControllerTag = @"elephant";
#warning 图片位置
    // 传出tag值，并可以执行方法
    selectView.SelectTableView = ^(NSInteger tag){
        NSLog(@"%ld", (long)tag);
        self.selectCount = [NSString stringWithFormat:@"%ld", (long)(tag - 19190)];
//        // 网络请求，刷新列表
//        [self creatDataWithType:self.selectCount page:@"1"];
        [self.tableView headerBeginRefreshing];
        
    };
    [self.view addSubview:selectView];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CON_WIDTH / 480 * 70, CON_WIDTH, CON_HEIGHT - 64 - CON_WIDTH / 480 * 70 -_ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //除去线
//    self.tableView.separatorStyle = NO;
    [self setupRefresh];
    [self.view addSubview:self.tableView];
}
//右上角方法
/// 编辑
- (void)rightEditAction:(UIButton *)bar
{
    __block ChiebukuroViewController *chiebukuro = self;
    UserModel *user = [UserModel unpackUserInfo];
    if (!user) {
        EnterController *enter = [[EnterController alloc] init];
        AppDelegate *appdele = [UIApplication sharedApplication].delegate;
        [appdele.navi presentViewController:enter animated:YES completion:^{
            
        }];
        enter.comeBackBlock = ^(){
            /// 不做登陆操作, 直接返回上一页
//            [self comeBack];
            [chiebukuro.tableView headerBeginRefreshing];
        };
        return;
    }
    ChiebukuroEditInfoViewController *editvc = [[ChiebukuroEditInfoViewController alloc] init];
    editvc.refreshEditBlock =^(){
        [chiebukuro.tableView headerBeginRefreshing];
    };
    [self.navigationController pushViewController:editvc animated:YES];
}
/// 检索
- (void)rightSearchAction:(UIButton *)bar
{
    SysteerSearchViewController *search = [[SysteerSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark -
#pragma mark 刷新加载实现
/**
*  集成刷新控件
*/
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
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
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self creatDataWithType:self.selectCount page:@"1"];
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
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tabelArr];
            [self creatDataWithType:self.selectCount page:self.pageNumder1];
            _count1 ++;
            for (ChiebukuroList *model in temp) {
                [self.tabelArr insertObject:model atIndex:self.tabelArr.count];
            }
            //    [self.tabelArr addObjectsFromArray:temp];
        }
            break;
        case 2:
        {
            self.pageNumder2 = [NSString stringWithFormat:@"%ld", (long)_count2];
            NSLog(@"页码_count2----%@", self.pageNumder2);
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tabelArr];
            [self creatDataWithType:self.selectCount page:self.pageNumder2];
            _count2++;
            for (ChiebukuroList *model in temp) {
                [self.tabelArr insertObject:model atIndex:self.tabelArr.count];
            }
            //    [self.tabelArr addObjectsFromArray:temp];
        }
            break;
        case 3:
        {
            self.pageNumder3 = [NSString stringWithFormat:@"%ld", (long)_count3];
            NSLog(@"页码_count3----%@", self.pageNumder3);
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tabelArr];
            [self creatDataWithType:self.selectCount page:self.pageNumder3];
            _count3 ++;
            for (ChiebukuroList *model in temp) {
                [self.tabelArr insertObject:model atIndex:self.tabelArr.count];
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
    ChiebukuroList *chieList = [self.tabelArr objectAtIndex:indexPath.row];
    // 1不加急, 2加急
    BOOL outDate = NO;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *oldate = [formater dateFromString:chieList.time];
    NSDate *now = [NSDate date];
    NSTimeInterval time = [now timeIntervalSinceDate:oldate];
    if (time > 36 * 60 * 60) {
        outDate = YES;
    }
    
    if (chieList.urgent == 1 || (chieList.urgent == 2 && outDate)) {
            /// 普通消息cell
            static NSString *ordinary = @"ordinaryCellID";
            ChiebukuroListCell *cell = [tableView dequeueReusableCellWithIdentifier:ordinary];
            if (!cell) {
                cell = [[ChiebukuroListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ordinary];
            }
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = CELL_COLOR;
            } else {
                cell.backgroundColor = [UIColor whiteColor];
            }
            cell.infoLabel.text = chieList.title;
            //    UILabel设置行间距等属性：
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:cell.infoLabel.text];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:LineSpacing];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, cell.infoLabel.text.length)];
            cell.infoLabel.attributedText = attributedString;
            
            cell.chatLabel.text = [NSString stringWithFormat:@"%ld",(long)chieList.comment_sum];
            cell.timeLabel.text = chieList.time;
            //是否是自己的 1 不是 2 是
            if (chieList.comments == 1) {
                cell.chatLabel.textColor = Ashen;
                cell.chatImageView.image = [UIImage imageNamed:@"icon_comment_off"];
            }
            if (chieList.comments == 2) {
                cell.chatLabel.textColor = Yellow;
                cell.chatImageView.image = [UIImage imageNamed:@"icon_comment_on"];
            }
            return cell;
    }
   else if(chieList.urgent == 2 || !outDate)
    {/// 加急消息cell
        static NSString *urgent = @"urgent";
        ChiebukuroListCell *cell = [tableView dequeueReusableCellWithIdentifier:urgent];
        if (!cell) {
            cell = [[ChiebukuroListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:urgent];
        }
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = CELL_COLOR;
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.infoLabel.text = chieList.title;
        
        //    UILabel设置行间距等属性：
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:cell.infoLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:LineSpacing];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, cell.infoLabel.text.length)];
        cell.infoLabel.attributedText = attributedString;
        
        cell.chatLabel.text = [NSString stringWithFormat:@"%ld",(long)chieList.comment_sum];
        cell.timeLabel.text = chieList.time;
        if (chieList.urgent == 2) {
            //加急界面铺设
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 49)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CON_WIDTH  / 3, 0, CON_WIDTH  / 3, 40)];
            imageView.userInteractionEnabled = YES;
            imageView.image = [UIImage imageNamed:@"trouble"];
            [view addSubview:imageView];
            UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH  / 3, 40)];
            imageView1.userInteractionEnabled = YES;
            imageView1.image = [UIImage imageNamed:@"trouble_repeat"];
            [view addSubview:imageView1];
            UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CON_WIDTH * 2 / 3, 0, CON_WIDTH  / 3, 40)];
            imageView2.image = [UIImage imageNamed:@"trouble_repeat"];
            imageView2.userInteractionEnabled = YES;
            [view addSubview:imageView2];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(urgentNetWarking:)];
            [view addGestureRecognizer:tap];
            
            self.tableView.tableHeaderView = view;
            
            cell.contentView.backgroundColor = [UIColor colorWithRed:189/255.f green:89/255.f blue:89/255.f alpha:1];
            cell.chatImageView.image = [UIImage imageNamed:@"icon_comment_w"];
            cell.infoLabel.textColor = [UIColor whiteColor];
            cell.chatLabel.textColor = [UIColor whiteColor];
            cell.timeLabel.textColor = [UIColor whiteColor];
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NULLCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NULLCell"];
        }
        return cell;
    }
}
/// 点击加急
- (void)urgentNetWarking:(UITapGestureRecognizer *)sender
{
//    NSLog(@"加急置顶");
//    self.selectCount = @"4";
//    [self.tableView headerBeginRefreshing];
    UrgentViewController *urgent = [[UrgentViewController alloc] init];
    [self.navigationController pushViewController:urgent animated:YES];
    

}
/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QandAViewController *qAndA = [[QandAViewController alloc] init];
    __block ChiebukuroViewController *chiebukuro = self;
    qAndA.refreshBlock =^(){
//        [chiebukuro.tableView headerBeginRefreshing];
    };
    
    ChiebukuroList *model = self.tabelArr[indexPath.row];
    qAndA.chieburoList = model;
    
    [self.navigationController pushViewController:qAndA animated:YES];
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
