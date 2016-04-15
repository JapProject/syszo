//
//  SystomoSearchViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoSearchViewController.h"
#import "SystomoSearchHeaderView.h"
#import "SystomoGropAddViewController.h"
#import "SystomoSearchButtonView.h"
#import "SystomoSearchTableListViewController.h"
#import "SystomoSearchButtonInfoViewController.h"
@interface SystomoSearchViewController () <NADViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArr;
//把按钮界面设为属性
@property (nonatomic, strong) SystomoSearchButtonView *buttonView;

//放大镜按钮
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) NADView *ADView;
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation SystomoSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_systomo" titleName:@"シストモ検索"];
    CGPoint temp = view.center;
    temp.x -= 0;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width += 20;
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
    [view setTitleImage:@"micon_systomo" titleName:@"シストモ"];
    CGPoint temp = view.center;
    temp.x += 0;
    view.center = temp;
    
    CGRect tempSize = view.frame;
    tempSize.size.width -= 20;
    view.frame = tempSize;
    
    [self.navigationController popViewControllerAnimated:YES];
    self.refreshBlock();

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
        [view setTitleImage:@"micon_systomo" titleName:@"シストモ"];
        CGPoint temp = view.center;
        temp.x += 0;
        view.center = temp;
        
        CGRect tempSize = view.frame;
        tempSize.size.width -= 20;
        view.frame = tempSize;
        
        self.refreshBlock();
    }
}

- (void)creatView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT)];
    scrollView.contentSize = CGSizeMake(0, CON_HEIGHT + 1);
    [self.view addSubview:scrollView];
    
    SystomoSearchHeaderView *searchHeader = [[SystomoSearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 50)];
    
    //添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [searchHeader addGestureRecognizer:tap];
    [scrollView addSubview:searchHeader];
    
    UILabel *searchOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, CON_WIDTH - 10, 30)];
    searchOneLabel.textAlignment = NSTextAlignmentLeft;
    searchOneLabel.textColor = DarkGreen;
    searchOneLabel.font = FONT_SIZE_6(17.f);
    searchOneLabel.text = @"ニックネーム検索";
    [scrollView addSubview:searchOneLabel];
    
    // 搜索框
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 90, CON_WIDTH - 10, 35)];
    imageView.userInteractionEnabled = YES;
    imageView.image =[UIImage imageNamed:@"searchbox"];
    [scrollView addSubview:imageView];
    // 搜索框-输入
    self.searchNameText = [[UITextField alloc] initWithFrame:CGRectMake(10, 90, imageView.frame.size.width - 36, imageView.frame.size.height)];
    self.searchNameText.delegate = self;
    self.searchNameText.keyboardType = UIKeyboardTypeWebSearch;
    [scrollView addSubview:self.searchNameText];
    // 搜索框-放大镜按钮
    self.searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.searchButton.frame = CGRectMake(imageView.frame.size.width - 26, (imageView.frame.size.height - 21)/2, 21, 21);
    [self.searchButton setBackgroundImage:[UIImage imageNamed:@"btn_search_g_off"] forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchNameOrIDAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:self.searchButton];
    
    
    
    self.buttonView = [[SystomoSearchButtonView alloc] initWithFrame:CGRectMake(0, 150, CON_WIDTH, 200)];
    __block SystomoSearchViewController *SearchVC = self;
    self.buttonView.ButtonAction = ^(NSInteger buttonTag, NSString* tempStr){
       //button的值传出来了
//        NSLog(@"%ld", buttonTag);
        SystomoSearchButtonInfoViewController *buttonInfoVC = [[SystomoSearchButtonInfoViewController alloc] init];
        buttonInfoVC.type = buttonTag - 100;
        buttonInfoVC.HeaderTitle = tempStr;
        [SearchVC.navigationController pushViewController:buttonInfoVC animated:YES];
    };
    [scrollView addSubview:self.buttonView];
}
/// 放大镜搜索
- (void)searchNameOrIDAction:(UIButton *)button
{
    SystomoSearchTableListViewController *systomoTable = [[SystomoSearchTableListViewController alloc] init];
    systomoTable.resultName = self.searchNameText.text;
    [self.navigationController pushViewController:systomoTable animated:YES];
    self.searchNameText.text = @"";
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [self searchNameOrIDAction:self.searchButton];
    return YES;
}
//点击手势的方法
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    SystomoGropAddViewController *GropAdd = [[SystomoGropAddViewController alloc] init];
    NavbarView *view = [NavbarView sharedInstance];
    CGPoint temp = view.center;
    temp.x += 0;
    view.center = temp;
    
    CGRect tempSize = view.frame;
    tempSize.size.width -= 20;
    view.frame = tempSize;
    
    __block SystomoSearchViewController *myss = self;
    // 先不做操作
    GropAdd.refreshBlock = ^(){
//        NavbarView *view = [NavbarView sharedInstance];
//        [view setTitleImage:@"micon_systomo" titleName:@"シストモ"];
//        CGPoint temp = view.center;
//        temp.x += 0;
//        view.center = temp;
//        
//        CGRect tempSize = view.frame;
//        tempSize.size.width -= 20;
//        view.frame = tempSize;
//        
//        [myss.navigationController popViewControllerAnimated:NO];
//        myss.refreshBlock();

    };
    [self.navigationController pushViewController:GropAdd animated:YES];
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
