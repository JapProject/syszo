//
//  menuViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "menuViewController.h"
#import "menuTableViewCell.h"
#import "ChiebukuroViewController.h"
#import "SysteerViewController.h"
#import "MessageViewController.h"
#import "ModalMessageViewController.h"
#import "SystomoViewController.h"
#import "MyPageViewController.h"
#import "EnterController.h"
#import "APService.h"
#import "NADView.h"
#import "SDCycleScrollView.h"
@import GoogleMobileAds;
@interface menuViewController ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate,NADViewDelegate,SDCycleScrollViewDelegate>
{
    
    GADBannerView *bannerView_;
    SDCycleScrollView *_adScrollView;
}
@property (strong, nonatomic) NADView *ADView;
@end

@implementation menuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *str = [APService registrationID];
    //添加菜单图片
    self.tabArr = [NSMutableArray arrayWithObjects:@"nav1",@"nav2",@"nav3",@"nav4",@"nav5",nil];
    self.tabArrOn = [NSMutableArray arrayWithObjects:@"nav1_on",@"nav2_on",@"nav3_on",@"nav4_on",@"nav5_on",nil];
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"SYSZO"];
    CGPoint temp = view.center;
    temp.x += 18;
    view.center = temp;
    [self creatView];
    
    //广告条
    _adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, 150) delegate:self placeholderImage:[UIImage imageNamed:@"ad"]];
    _adScrollView.autoScrollTimeInterval = 3.0;
    _adScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    //_adScrollView.titlesGroup = titles;
    _adScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _adScrollView.imageURLStringsGroup = self.tabArr;
    [self.view addSubview:_adScrollView];
    
    //添加广告 kGADAdSizeBanner 替换为 GADAdSizeFromCGSize(CGSizeMake(CON_WIDTH, 50)
//    bannerView_ = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(CON_WIDTH, 50))
//                                                 origin:CGPointMake(
//                                                                    0,
//                                                                    self.view.bounds.size.height-kGADAdSizeBanner.size.height - 64
//                                                                    )];
//    bannerView_.adUnitID = adunitID;
//    bannerView_.rootViewController = self;
//    [self.view addSubview:bannerView_];
//    [bannerView_ loadRequest:[GADRequest request]];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.ADView = [[NADView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50) isAdjustAdSize:YES];
    [_ADView setNendID:NAND_ID spotID:NAND_SPOT_ID];
    _ADView.delegate = self;
    [_ADView load];
    _ADView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_ADView];
    
    [self getAdimage];
}


-(void)getAdimage{
   NSString * url = [NSString stringWithFormat:@"%@%@",TiTleUrl,getAdImage];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:@{@"type":@"1"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"结果%@", responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"1"]) {
            NSMutableArray * imageArray = [NSMutableArray array];
            NSDictionary * tempDic = responseObject[@"data"];
           // for (int i=0; i<tempArray.count; i++) {
                [imageArray addObject:[NSString stringWithFormat:@"%@%@",AdMainUrl,tempDic[@"ad_img"]]];
            //}
            _adScrollView.imageURLStringsGroup = imageArray;
            if (imageArray.count ==1) {
                _adScrollView.autoScroll = NO;
            }
            
        }else{
            NSLog(@"失败");
            return;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];


}


-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
}

- (void)creatView
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建菜单
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, self.view.width, self.view.height-150-50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //除去线
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    UIView *viewss = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, self.view.height)];
//    viewss.backgroundColor = [UIColor redColor];
//    [self.view addSubview:viewss];
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabArr.count;
//    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cellID";

    menuTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (cell == nil) {
        cell = [[menuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    if (indexPath.row < self.tabArr.count) {
//        cell.titleImage.image = [UIImage imageNamed:[self.tabArr objectAtIndex:indexPath.row]];
        cell.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.tabArr objectAtIndex:indexPath.row]]];
        cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.tabArrOn objectAtIndex:indexPath.row]]];
    } else {
        cell.textLabel.text = @"模态海豚UI测试";
    }

   // NSLog(@"%@", [self.tabArr objectAtIndex:indexPath.row]);
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//一行cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat n = width/320;
    CGFloat h = n * 80;
    return h;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.tag == 0){
        cell.selected = NO;
    }else {
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
    //大象
    if (indexPath.row == 0) {
        ChiebukuroViewController *chieVC = [[ChiebukuroViewController alloc] init];
        self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:59 / 255.0 green:58 / 255.0 blue:56/ 255.0 alpha:1];
        [self.navigationController pushViewController:chieVC animated:YES];

    }
    //小鸟
    if (indexPath.row == 1) {
        SysteerViewController *systVC = [[SysteerViewController   alloc] init];
        //改导航栏颜色
        self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:59 / 255.0 green:58 / 255.0 blue:56/ 255.0 alpha:1];
        [self.navigationController pushViewController:systVC animated:YES];
        
    }
    //袋鼠
    if (indexPath.row == 2) {
        UserModel *user = [UserModel unpackUserInfo];
        if (!user) {
            EnterController *enter = [[EnterController alloc] init];
            AppDelegate *appdele = [UIApplication sharedApplication].delegate;
            [appdele.navi presentViewController:enter animated:YES completion:^{
                
            }];
            enter.comeBackBlock = ^(){
                /// 不做登陆操作, 直接返回上一页
//                [self comeBack];
            };
            return;
        }
        SystomoViewController *systVC = [[SystomoViewController alloc] init];
        [self.navigationController pushViewController:systVC animated:YES];
    }
    //海豚
    if (indexPath.row == 3) {
        UserModel *user = [UserModel unpackUserInfo];
        if (!user) {
            EnterController *enter = [[EnterController alloc] init];
            AppDelegate *appdele = [UIApplication sharedApplication].delegate;
            [appdele.navi presentViewController:enter animated:YES completion:^{
                
            }];
            enter.comeBackBlock = ^(){
                /// 不做登陆操作, 直接返回上一页
//                [self comeBack];
            };
            return;
        }
        MessageViewController *messVC = [[MessageViewController   alloc] init];
        self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:59 / 255.0 green:58 / 255.0 blue:56/ 255.0 alpha:1];

        [self.navigationController pushViewController:messVC animated:YES];
    }
    //人
    if (indexPath.row == 4) {
        UserModel *user = [UserModel unpackUserInfo];
        if (!user) {
            EnterController *enter = [[EnterController alloc] init];
            AppDelegate *appdele = [UIApplication sharedApplication].delegate;
            [appdele.navi presentViewController:enter animated:YES completion:^{
                
            }];
            enter.comeBackBlock = ^(){
                /// 不做登陆操作, 直接返回上一页
//                [self comeBack];
            };
            return;
        }
        MyPageViewController *myPageVC = [[MyPageViewController alloc] init];
        [self.navigationController pushViewController:myPageVC animated:YES];
    }
//    if (indexPath.row == 5) {
//        ModalMessageViewController *enterVC = [[ModalMessageViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:enterVC];
//        nav.navigationBar.barTintColor =[UIColor colorWithRed:231 / 255.0 green:187 / 255.0 blue:34/ 255.0 alpha:1];
//        [self presentViewController:nav animated:YES completion:nil];
//    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
{
return NO;
}
else
{
return YES;
}
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
   
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
