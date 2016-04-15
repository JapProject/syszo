//
//  SystomoSearchTableListViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/12.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoSearchTableListViewController.h"
#import "SystomoSelectGoodFirendCell.h"
#import "SystomoGropAddViewController.h"
#import "SystomoSearchHeaderView.h"
#import "SystomoSearch.h"
#import "FriendsDataViewController.h"

@interface SystomoSearchTableListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, assign) NSInteger page;
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation SystomoSearchTableListViewController
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
    [view setTitleImage:@"micon_systomo" titleName:@"シストモ検索"];
    CGPoint temp = view.center;
    temp.x -= 0;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width += 0;
    view.frame = tempSize;
    [self creatTableView];
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    [self.progress show:YES];
    [self.view addSubview:self.progress];

}

- (void)setResultName:(NSString *)resultName
{
    if (_resultName != resultName) {
        _resultName = resultName;
    }
    [self creatDataWithUser_nick:self.resultName];
    [self headRefreshing];
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
        NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SystomoSearchTableUrl];
        //传入的参数
        NSDictionary *parameters = @{@"user_nick":self.resultName,@"p_num":[NSString stringWithFormat:@"%ld", (long)self.page],@"p_size":@"20"};
        self.page += 1;
        __weak SystomoSearchTableListViewController *systomoTableListVCVC = self;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result = [responseObject objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SearchEmpty message:nil delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            if ([result isEqualToString:@"1"]) {
                NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
                for (NSMutableDictionary *dic in tempArr) {
                    SystomoSearch *search = [[SystomoSearch alloc] init];
                    [search setValuesForKeysWithDictionary:dic];
                    [systomoTableListVCVC.tableArr addObject:search];
                }
            }
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    [self.tableView footerEndRefreshing];

    });
    

}

- (void)creatDataWithUser_nick:(NSString *)user_nick
{
    self.tableArr = [NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SystomoSearchTableUrl];
    //传入的参数
    NSDictionary *parameters = @{@"user_nick":user_nick,@"p_num":@"1",@"p_size":@"20"};
    
    __weak SystomoSearchTableListViewController *systomoTableListVCVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [responseObject objectForKey:@"result"];
        [self.progress hide:YES];
        if ([result isEqualToString:@"0"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:SearchEmpty message:nil delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        if ([result isEqualToString:@"1"]) {
            NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
            for (NSMutableDictionary *dic in tempArr) {
                SystomoSearch *search = [[SystomoSearch alloc] init];
                [search setValuesForKeysWithDictionary:dic];
                [systomoTableListVCVC.tableArr addObject:search];
            }
        }
    [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)creatTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 25;
    //除去线
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 25)];
    view.backgroundColor = [UIColor colorWithString:@"d0d0d0" alpha:1];
    
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 , 5, CON_WIDTH - 21, 12)];
    sectionTitle.font = FONT_SIZE_6(12.f);
    sectionTitle.textColor = [UIColor colorWithString:@"8f8f8f" alpha:1];
    [view addSubview:sectionTitle];
    sectionTitle.text = [NSString stringWithFormat:@"検索結果(%ld) - %@",(long)self.tableArr.count , self.resultName];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"SystomoSearchCell";
    SystomoSelectGoodFirendCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (!cell) {
        cell = [[SystomoSelectGoodFirendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SystomoSearch *search = [self.tableArr objectAtIndex:indexPath.row];
    cell.titleLabel.text = search.member_name;
    cell.userImage.image = [UIImage imageNamed:@"btn_nofollow_big"];
    [cell.proFileBtn setBackgroundImage:[UIImage imageNamed:@"btn_profile_off"] forState:UIControlStateNormal];
    
    cell.proFileAction = ^(){
        NSLog(@"点击进入好友预览界面");
        FriendsDataViewController *friendData = [[FriendsDataViewController alloc] init];
        friendData.member_id = search.member_id;
        [self.navigationController pushViewController:friendData animated:YES];
    };
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


//回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
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
