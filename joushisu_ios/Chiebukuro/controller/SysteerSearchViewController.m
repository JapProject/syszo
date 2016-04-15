//
//  SysteerSearchViewController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/4/27.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SysteerSearchViewController.h"
#import "QandAViewController.h"
#import "SearchResultsCell.h"
#import "SeachIndexModel.h"
#import "SeachModel.h"
#import "ChiebukuroSearchResultsViewController.h"
@interface SysteerSearchViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,NADViewDelegate>
@property (nonatomic, strong)NSMutableArray *dataArray; // 数据数组
@property (nonatomic, strong)UIView *topView;           // 搜索输入框
@property (nonatomic, strong)UITableView *tableView;    // 列表
@property (nonatomic, strong)NSString *time;            // 时间
@property (nonatomic, strong)UITextField *search;       // 输如框
@property (nonatomic, strong) NADView *ADView;
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation SysteerSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.time = [[NSString alloc] init];
    
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋-検索"];
    CGPoint temp = view.center;
    temp.x -= 30;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width += 30;
    view.frame = tempSize;
    // 网络请求
    [self netWorking];
    // 视图布局
    [self createTopView];
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
    self.tableView.frame = CGRectMake(0, self.topView.frame.size.height, CON_WIDTH, CON_HEIGHT - self.topView.frame.size.height - 64 - _ADView.frame.size.height);
}
-(void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋"];
    CGPoint temp = view.center;
    temp.x += 30;
    view.center = temp;
    
    CGRect tempSize = view.frame;
    tempSize.size.width -= 30;
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
        [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋"];
        CGPoint temp = view.center;
        temp.x += 30;
        view.center = temp;
        
        CGRect tempSize = view.frame;
        tempSize.size.width -= 30;
        view.frame = tempSize;

        NSLog(@"返回");
    }
}
#pragma mark 网络请求方法
- (void)netWorking
{
    self.dataArray = [[NSMutableArray alloc] init];
    [self.progress show:YES];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroSearchIndex];
    //传入的参数
    NSDictionary *parameters = @{@"p_size":@"10"};
    
    __weak SysteerSearchViewController *seachVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *tempDic = [responseObject objectForKey:@"data"];
        if (![[tempDic objectForKey:@"list"] isKindOfClass:[NSString class]]) {
            NSMutableArray *tempArr = [tempDic objectForKey:@"list"];
            for (NSDictionary *dic in tempArr) {
                SeachIndexModel *model = [[SeachIndexModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [seachVC.dataArray addObject:model];
            }
        }
        self.time = [tempDic objectForKey:@"time"];
        [self.progress hide:YES];

        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
    
}

#pragma mark---
- (void)createTopView
{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 100)];
    [self.view addSubview:self.topView];
    // 线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.topView.frame.size.height - 1, self.topView.frame.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.topView addSubview:line];
    // 自由字搜索
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.topView.frame.size.width - 20, 17)];
    label.text = @"フリーワード検索";
    label.font = FONT_SIZE_6(17.f);
    [self.topView addSubview:label];
    // 搜索框
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20+17+9, self.topView.frame.size.width - 20, self.topView.frame.size.height - 20 -17-9-15)];
    imageView.userInteractionEnabled = YES;
    imageView.image =[UIImage imageNamed:@"searchbox"];
    [self.topView addSubview:imageView];
    
    // 搜索框-输入
    self.search = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, imageView.frame.size.width - 42, imageView.frame.size.height-10)];
    self.search.delegate = self;
//    self.search.backgroundColor = [UIColor cyanColor];
    self.search.keyboardType = UIKeyboardTypeWebSearch;
    [imageView addSubview:self.search];
    
    // 搜索框-放大镜按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(imageView.frame.size.width - 33, (imageView.frame.size.height - 28)/2, 28, 28);
    [button setBackgroundImage:[UIImage imageNamed:@"btn_search_g_off"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];

}

#pragma mark 放大镜按钮
/// 点击放大镜执行的搜索方法
- (void)searchAction:(UIButton *)button
{
    if (![self.search.text isEqualToString:@""]) {
        
        [self textFieldShouldReturn:self.search];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"すみません" message:@"内容を入力してください" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alertView show];
    }
        
}

#pragma mark TextField协议-代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    ChiebukuroSearchResultsViewController *searchResultsVC = [[ChiebukuroSearchResultsViewController alloc] init];
    searchResultsVC.searchResults = self.search.text;
    [self.navigationController pushViewController:searchResultsVC animated:YES];
    // 回收键盘
    [textField resignFirstResponder];
    return YES;
}

#pragma mark tableView搜索结果列表

- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topView.frame.size.height, CON_WIDTH, CON_HEIGHT - self.topView.frame.size.height - 64 - _ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.sectionHeaderHeight = 47;
    //除去线
   // self.tableView.separatorStyle = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

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
    static NSString *string = @"searchResults";
    SearchResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[SearchResultsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.rankingNumder.text = [NSString stringWithFormat:@"%ld", (long)(indexPath.row + 1)];
    NSString *imageName = @"";
    if (indexPath.row < 3) {
        imageName = [NSString stringWithFormat:@"icon_rank%ld", (long)indexPath.row + 1];
    } else {
        imageName = [NSString stringWithFormat:@"icon_rankfree"];
    }
    cell.rankingImage.image = [UIImage imageNamed:imageName];
     SeachIndexModel *model = [self.dataArray objectAtIndex:indexPath.row];
        cell.details.text = model.keyword;
        

    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = CELL_COLOR;
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}
/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}
///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SeachIndexModel *model = [self.dataArray objectAtIndex:indexPath.row];
    ChiebukuroSearchResultsViewController *searchResultsVC = [[ChiebukuroSearchResultsViewController alloc] init];
    searchResultsVC.searchResults = model.keyword;
    [self.navigationController pushViewController:searchResultsVC animated:YES];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 47)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *ladel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, (CON_WIDTH - 20)/2, 17)];
    ladel.textAlignment = NSTextAlignmentLeft;
    ladel.font = FONT_SIZE_6(17.f);
    ladel.textColor = DarkGreen;
    ladel.text = @"急上昇ワード";
    [view addSubview:ladel];
    
    UILabel *dataLadel = [[UILabel alloc] initWithFrame:CGRectMake(10 + (CON_WIDTH - 20)/2, 17.5, (CON_WIDTH - 20)/2, 12)];
    dataLadel.textAlignment = NSTextAlignmentRight;
    dataLadel.font = FONT_SIZE_6(12.f);
    dataLadel.textColor = DarkGreen;
    dataLadel.text = [NSString stringWithFormat:@"%@更新", self.time];//@"2015-05-10 20:00更新";
    [view addSubview:dataLadel];
    
    return view;
}
#pragma mark -
//回收键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
