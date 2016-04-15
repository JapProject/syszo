//
//  ChiebukuroSearchResultsViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/4.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "ChiebukuroSearchResultsViewController.h"
#import "ChiebukuroListCell.h"
#import "ChiebukuroList.h"
#import "QandAViewController.h"
#import "ChiebukuroViewController.h"
#import "NADView.h"
@interface ChiebukuroSearchResultsViewController () <UITableViewDataSource, UITableViewDelegate,NADViewDelegate>
@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) NSMutableArray *tabelArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NADView *ADView;
@end

@implementation ChiebukuroSearchResultsViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.page = 2;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋-検索"];
//    NSLog(@"%@0000000000" , self.searchResults);
    

//    CGPoint temp = view.center;
//    temp.x -= 0;
//    view.center = temp;
//    CGRect tempSize = view.frame;
//    tempSize.size.width += 30;
//    view.frame = tempSize;
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
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    [self.progress show:YES];
    [self.view addSubview:self.progress];
    
    UIImage *imageEd = [self OriginImage:[UIImage imageNamed:@"btn_totop_off"] scaleToSize:CGSizeMake(40, 25)];
    
    // 设置右上角导航栏
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithImage:imageEd style:UIBarButtonItemStyleDone target:self action:@selector(rightEditAction)];
    self.navigationItem.rightBarButtonItem = edit;
    
}

#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}


- (void)rightEditAction{
    
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋"];
//    CGPoint temp = view.center;
//    temp.x -= 0;
//    view.center = temp;
//    
//    CGRect tempSize = view.frame;
//    tempSize.size.width += 30;
//    view.frame = tempSize;
    CGPoint temp1 = view.center;
    temp1.x += 10;
    view.center = temp1;
    CGRect tempSize = view.frame;
    
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[ChiebukuroViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }

    }
    
}

- (void)headRefreshing
{
    [self.tabelView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tabelView.headerPullToRefreshText = WILL_LODE;
    self.tabelView.headerReleaseToRefreshText = DID_LODE;
    self.tabelView.headerRefreshingText = LODEING;
    
    self.tabelView.footerPullToRefreshText = WILL_LODE;
    self.tabelView.footerReleaseToRefreshText = DID_LODE;
    self.tabelView.footerRefreshingText = LODEING;
}

- (void)setSearchResults:(NSString *)searchResults
{
    if (_searchResults != searchResults) {
        _searchResults = searchResults;
    }
    [self creatViewWithKeyWrod:self.searchResults];
    [self netWorkingWithKeyWrod:self.searchResults];
}
- (void)footerRereshing
{
    UserModel *user = [UserModel unpackUserInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroSearchUrl];
        //传入的参数
        NSDictionary *parameters = [NSDictionary dictionary];
        UserModel *user = [UserModel unpackUserInfo];
        if (!user) {
            parameters = @{@"keyword":self.searchResults,@"p_num":[NSString stringWithFormat:@"%ld", (long)self.page],@"p_size":@"20"};
        } else {
            parameters = @{@"keyword":self.searchResults,@"p_num":[NSString stringWithFormat:@"%ld", (long)self.page],@"p_size":@"20",@"user_id":user.user_id};
        }
        self.page += 1;
        __weak ChiebukuroSearchResultsViewController *chieVC = self;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableDictionary *tempDic = [responseObject objectForKey:@"data"];
            NSMutableArray *tempArr = [tempDic objectForKey:@"list"];
            for (NSDictionary *dic in tempArr) {
                ChiebukuroList *chieList = [[ChiebukuroList alloc] init];
                [chieList setValuesForKeysWithDictionary:dic];
                [chieVC.tabelArr addObject:chieList];
            }
            [self.tabelView reloadData];
            [self.tabelView footerEndRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

 });


}
- (void)netWorkingWithKeyWrod:(NSString *)string
{
//    [self.progress show:YES];
    UserModel *user = [UserModel unpackUserInfo];
    self.tabelArr = [NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroSearchUrl];
    //传入的参数
    NSDictionary *parameters = @{@"keyword":string,@"p_num":@"1",@"p_size":@"20"};
    
    __weak ChiebukuroSearchResultsViewController *chieVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSMutableDictionary *tempDic = [responseObject objectForKey:@"data"];
        NSMutableArray *tempArr = [tempDic objectForKey:@"list"];
        if (tempArr.count != 0) {
            for (NSDictionary *dic in tempArr) {
                ChiebukuroList *chieList = [[ChiebukuroList alloc] init];
                [chieList setValuesForKeysWithDictionary:dic];
                [chieVC.tabelArr addObject:chieList];
            }
            [self.progress hide:YES];
            [self.tabelView reloadData];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SearchEmpty message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [self.progress hide:YES];
            return;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

- (void)creatViewWithKeyWrod:(NSString *)string
{
    self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 60)];
    self.tabelView.dataSource = self;
    self.tabelView.delegate = self;
    [self headRefreshing];
    [self.view addSubview:self.tabelView];
    
    UIView *Headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 50)];
    UILabel *tabelHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CON_WIDTH - 20, 30)];
    tabelHeader.backgroundColor = [UIColor colorWithRed:72/255.f green:121/255.f blue:136/255.f alpha:1];
    tabelHeader.layer.cornerRadius = 6;
    tabelHeader.layer.masksToBounds = YES;
    tabelHeader.textAlignment = NSTextAlignmentCenter;
    tabelHeader.text = [NSString stringWithFormat:@"「%@」の検索结果", self.searchResults];
    tabelHeader.font = FONT_SIZE_6(15);
    tabelHeader.textColor = [UIColor whiteColor];
    [Headerview addSubview:tabelHeader];
    self.tabelView.tableHeaderView = Headerview;
}
//  每个section里的row的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabelArr.count;
}
///  返回tableView里的cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string = @"cellSearchID";
    ChiebukuroListCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[ChiebukuroListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    
    //往cell上铺
    ChiebukuroList *chieList = [self.tabelArr objectAtIndex:indexPath.row];
    if (chieList.comments == 1) {
        cell.chatLabel.textColor = Ashen;
        cell.infoLabel.text = chieList.title;
        cell.chatLabel.text = [NSString stringWithFormat:@"%ld",(long)chieList.comment_sum];
        cell.chatImageView.image = [UIImage imageNamed:@"icon_comment_off"];
        cell.timeLabel.text = chieList.time;
    }
    if (chieList.comments == 2) {
        cell.chatLabel.textColor = Yellow;
        cell.infoLabel.text = chieList.title;
        cell.chatLabel.text = [NSString stringWithFormat:@"%ld",(long)chieList.comment_sum];
        cell.chatImageView.image = [UIImage imageNamed:@"icon_comment_on"];
        cell.timeLabel.text = chieList.time;
    }
    


    
    
    return cell;
}
/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}
///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QandAViewController *qAndA = [[QandAViewController alloc] init];
    qAndA.refreshBlock =^(){
    };
    ChiebukuroList *model = self.tabelArr[indexPath.row];
    qAndA.chieburoList = model;
    
    NavbarView *view = [NavbarView sharedInstance];
    CGPoint temp1 = view.center;
    temp1.x += 10;
    view.center = temp1;
    CGRect tempSize = view.frame;
//    tempSize.size.width -= 30;
//    view.frame = tempSize;
    
    [self.navigationController pushViewController:qAndA animated:YES];
}

/// 返回
- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
