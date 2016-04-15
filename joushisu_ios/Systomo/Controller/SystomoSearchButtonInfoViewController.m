//
//  SystomoSearchButtonInfoViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/12.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoSearchButtonInfoViewController.h"
#import "SearchListCell.h"
#import "SearchButtonInfo.h"
#import "SearchResultPeopelViewController.h"
@interface SystomoSearchButtonInfoViewController () <UITableViewDataSource, UITableViewDelegate, NADViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArr;
        @property (assign, nonatomic) BOOL comYes;
@property (nonatomic, strong) NADView *ADView;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation SystomoSearchButtonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_systomo" titleName:@"シストモ検索"];
    CGPoint temp = view.center;
    temp.x -= 0;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width += 0;
    view.frame = tempSize;
    
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
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - _ADView.frame.size.height);
}
/// 返回
- (void)comeBack
{
    //        @property (assign, nonatomic) BOOL comYes;
            self.comYes = YES;
    //
    //        if (self.comYes ) {
    //            return;
    //        }
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_systomo" titleName:@"シストモ検索"];
    CGPoint temp = view.center;
    temp.x += 0;
    view.center = temp;
    
    CGRect tempSize = view.frame;
    tempSize.size.width -= 0;
    view.frame = tempSize;
    
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
        [view setTitleImage:@"micon_systomo" titleName:@"シストモ検索"];
        CGPoint temp = view.center;
        temp.x += 0;
        view.center = temp;
        
        CGRect tempSize = view.frame;
        tempSize.size.width -= 0;
        view.frame = tempSize;

    }
}

- (void)setHeaderTitle:(NSString *)HeaderTitle
{
    if (_HeaderTitle != HeaderTitle) {
        _HeaderTitle = HeaderTitle;
    }
}
- (void)setType:(NSInteger)type
{
    if (_type != type) {
        _type = type;
    }
    [self creatView];
    [self creatData];
}
- (void)creatData
{
    self.tableArr = [NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SystomoButtonInfoUrl];
    //传入的参数
    NSDictionary *parameters = @{@"cat_type":[NSString stringWithFormat:@"%ld",(long)self.type],@"p_num":@"1",@"p_size":@"20"};
    
    __weak SystomoSearchButtonInfoViewController *systomoButtonInfoVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"分类检索=====%@", responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            return;
        }
        if ([result isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
            for (NSDictionary *dic in tempArr) {
                SearchButtonInfo *searchInfo = [[SearchButtonInfo alloc] init];
                [searchInfo setValuesForKeysWithDictionary:dic];
                [systomoButtonInfoVC.tableArr addObject:searchInfo];
            }
            
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
- (void)creatView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - _ADView.frame.size.height) style:(UITableViewStylePlain)];
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
    NSString *str = @"searchButtonInfoCell";
    SearchListCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (!cell) {
        cell = [[SearchListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SearchButtonInfo *searchInfo = [self.tableArr objectAtIndex:indexPath.row];
    cell.titleLabel.text = searchInfo.cat_name;
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
    sectionTitle.text = [NSString stringWithFormat:@"カテゴリ検索 - %@", self.HeaderTitle];
    
    return view;
}
/// 点击cell的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *urlArray = [NSArray arrayWithObjects:SearchResultPeopleUrl, SearchResultJobUrl, SearchResultSoftwareUrl, SearchResultHardwareUrl, SearchResultQualifiedUrl, SearchResultUserTimeUrl, nil];
    NSArray *urlArray = [NSArray arrayWithObjects:SearchResultPeopleUrl, SearchResultJobUrl, SearchResultUserTimeUrl, nil];
    SearchResultPeopelViewController *resultPeopelVC = [[SearchResultPeopelViewController alloc] init];
    resultPeopelVC.block = ^(){
        [self.tableArr removeAllObjects];
        [self creatData];
    };
    SearchButtonInfo *searchInfo = [self.tableArr objectAtIndex:indexPath.row];
//    resultPeopelVC.urlString = urlArray[self.type - 1];
    resultPeopelVC.urlType = [NSString stringWithFormat:@"%ld", (long)self.type];
    resultPeopelVC.cat_id = searchInfo.cat_id;
    [self.navigationController pushViewController:resultPeopelVC animated:YES];
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
