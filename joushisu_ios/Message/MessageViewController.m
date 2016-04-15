//
//  MessageViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
//#import "MessageList.h"
//#import "GlistModel.h"
#import "MessagesModel.h"
#import "FriendsModel.h"
#import "ChatViewController.h"
#import "ChatGroupViewController.h"
#import "NADView.h"
@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate, NADViewDelegate>
@property (nonatomic, strong) NSMutableArray *glistTableArr;
@property (nonatomic, strong) NSMutableArray *mlistTableArr;
@property (nonatomic, strong) NADView *ADView;
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation MessageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        self.glistTableArr = [NSMutableArray array];
//        self.mlistTableArr = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSMutableArray *)glistTableArr{
    if (!_glistTableArr) {
        _glistTableArr = [NSMutableArray array];
    }
    return _glistTableArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"メッセージ";
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_message" titleName:@"メッセージ"];
    CGPoint temp = view.center;
    temp.x += 15;
    view.center = temp;
    UserModel *user = [UserModel unpackUserInfo];
    [self creatDataWithUser_id:user.user_id];
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
    
    self.ADView = [[NADView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50) isAdjustAdSize:YES];
    [_ADView setNendID:NAND_ID spotID:NAND_SPOT_ID];
    _ADView.delegate = self;
    [_ADView load];
    _ADView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height);
}
#pragma mark 聊天页的刷新加载
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    //    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = WILL_LODE;
    self.tableView.headerReleaseToRefreshText = DID_LODE;
    self.tableView.headerRefreshingText = LODEING;
    
    self.tableView.footerPullToRefreshText = WILL_LODE;
    self.tableView.footerReleaseToRefreshText = DID_LODE;
    self.tableView.footerRefreshingText = LODEING;
}

#pragma mark 开始进入加载状态

//加载方法
- (void)headerRereshing
{
    
    UserModel *user = [UserModel unpackUserInfo];
    [self creatDataWithUser_id:user.user_id];
    //自动刷新
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self.tableView headerEndRefreshing];
//        
//    });
    
}
#pragma mark -



- (void)creatDataWithUser_id:(NSString *)user_id
{
    if (!self.glistTableArr) {
        self.glistTableArr = [[NSMutableArray alloc] init];
        
    }
    if (!self.mlistTableArr) {
        self.mlistTableArr = [[NSMutableArray alloc] init];
        
    }

    [self.progress show:YES];

    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,MessageListUrl];
    //传入的参数
    NSDictionary *parameters = @{@"user_id":user_id};
    
    __weak MessageViewController *messageVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"海豚海豚%@", responseObject);
        
//        NSMutableDictionary *tempDic = [responseObject objectForKey:@"data"];
//        if ([tempDic isEqual:@""]) {
//            [self.progress hide:YES];
//            return;
//            
//        }
//        NSMutableArray *glistArr = [tempDic objectForKey:@"glist"];
//        NSMutableArray *mlistArr = [tempDic objectForKey:@"mlist"];
//        
//        [self.glistTableArr removeAllObjects];
//        [self.mlistTableArr removeAllObjects];
//        
//        for (NSDictionary *dic in glistArr) {
//            GlistModel *message = [[GlistModel alloc] init];
//            [message setValuesForKeysWithDictionary:dic];
//            [messageVC.glistTableArr addObject:message];
//        }
//        for (NSDictionary *dic in mlistArr) {
//            MessageList *message = [[MessageList alloc] init];
//            [message setValuesForKeysWithDictionary:dic];
//            [messageVC.mlistTableArr addObject:message];
//            
//        }
        [messageVC.mlistTableArr removeAllObjects];
        [messageVC.glistTableArr removeAllObjects];
        id stems = [responseObject objectForKey:@"data"];
        if ([stems isKindOfClass:[NSString class]]) {
             return ;
        }
        
        NSMutableArray *groupArray = [responseObject objectForKey:@"data"];
        for (int i = 0 ; i < groupArray.count; i++) {
            if ([[[groupArray objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"1"]) {
                MessagesModel *message = [[MessagesModel alloc] init];
                [message setValuesForKeysWithDictionary:[groupArray objectAtIndex:i]];
                [messageVC.glistTableArr addObject:message];

            }else{
                FriendsModel *friend = [[FriendsModel alloc] init];
                [friend setValuesForKeysWithDictionary:[groupArray objectAtIndex:i]];
                [messageVC.glistTableArr addObject:friend];
            }
        }
        [self.tableView reloadData];
        [self.progress hide:YES];
        // 结束加载
        [self.tableView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
    
}
- (void)creatView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height) style:(UITableViewStylePlain)];
    // self.tableView.backgroundColor =[UIColor colorWithRed:0.29f green:.74f blue:0.61f alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 25;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self setupRefresh];
}


/// 返回
- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"SYSZO"];
    CGPoint temp = view.center;
    temp.x -= 15;
    view.center = temp;
    //        @property (assign, nonatomic) BOOL comYes;
            self.comYes = YES;
    //
    //        if (self.comYes ) {
    //            return;
    //        }
    //改导航栏颜色
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:59 / 255.0 green:58 / 255.0 blue:56/ 255.0 alpha:1];
    [self.navigationController  popViewControllerAnimated:YES];
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
        temp.x -= 15;
        view.center = temp;
        //改导航栏颜色
        self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:59 / 255.0 green:58 / 255.0 blue:56/ 255.0 alpha:1];
        NSLog(@"返回");
    }
}



#pragma mark tabelView协议

///  返回tableView里的cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *string = @"cellID";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    
    id stmeModel= [self.glistTableArr objectAtIndex:indexPath.row];
    if ([stmeModel isKindOfClass:[MessagesModel class]]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        MessagesModel *message = [self.glistTableArr objectAtIndex:indexPath.row];
        cell.timeLabel.text = message.insert_time;
        if ([message.ginfo_content isEqualToString:@""] && [message.ginfo_img isEqualToString:@"[图片消息]"]) {
            cell.infoLabel.text = @"[画像]";
            //                cell.infoLabel.textColor = [UIColor colorWithString:@"acacac" alpha:1.f];
        } else {
            cell.infoLabel.text = message.ginfo_content;
        }
        cell.titleLabel.text =  [NSString stringWithFormat:@"%@ (%@)",message.group_name, message.ginfo_sum];
        
        
        return cell;
        
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FriendsModel *message = [self.glistTableArr objectAtIndex:indexPath.row];
        if ([message.minfo_content isEqualToString:@""] && [message.minfo_img isEqualToString:@"[图片消息]"]) {
            cell.infoLabel.text = @"[画像]";
            //                cell.infoLabel.textColor = [UIColor colorWithString:@"acacac" alpha:1.f];
        } else {
            cell.infoLabel.text = message.minfo_content;
        }
        cell.timeLabel.text = message.insert_time_m;
        cell.titleLabel.text = message.user_name;
        
        
        return cell;
 
    }
    
    
    
//    switch (indexPath.section) {
//        case 0:
//        {
//            static NSString *string = @"cellID";
//            MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
//            if (!cell) {
//                cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            MessagesModel *message = [self.glistTableArr objectAtIndex:indexPath.row];
//            cell.timeLabel.text = message.insert_time;
//            if ([message.ginfo_content isEqualToString:@""] && [message.ginfo_img isEqualToString:@"[图片消息]"]) {
//                cell.infoLabel.text = @"[画像]";
////                cell.infoLabel.textColor = [UIColor colorWithString:@"acacac" alpha:1.f];
//            } else {
//                cell.infoLabel.text = message.ginfo_content;
//            }
//            cell.titleLabel.text =  [NSString stringWithFormat:@"%@ (%@)",message.group_name, message.ginfo_sum];
//            
//            
//            return cell;
//        }
//            break;
//        case 1:
//        {
//            static NSString *string = @"cellID";
//            MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
//            if (!cell) {
//                cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            FriendsModel *message = [self.mlistTableArr objectAtIndex:indexPath.row];
//            if ([message.minfo_content isEqualToString:@""] && [message.minfo_img isEqualToString:@"[图片消息]"]) {
//                cell.infoLabel.text = @"[画像]";
////                cell.infoLabel.textColor = [UIColor colorWithString:@"acacac" alpha:1.f];
//            } else {
//                cell.infoLabel.text = message.minfo_content;
//            }
//            cell.timeLabel.text = message.insert_time_m;
//            cell.titleLabel.text = message.user_name;
//            
//            
//            return cell;
//        }
//            break;
//            
//        default:
//        {
//            static NSString *string = @"nullCell";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
//            if (!cell) {
//                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            return cell;
//        }
//            break;
//            
//    }
//    
//    return nil;
    
}
/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
//  section 个数
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
///  每个section里的row的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    switch (section) {
//        case 0:
//            return self.glistTableArr.count;
//            break;
//        case 1:
//            return self.mlistTableArr.count;
//            break;
//        default:
//            return 0;
//            break;
//    }
    return self.glistTableArr.count;
}

/////  自定义section
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 25)];
//    view.backgroundColor = [UIColor colorWithString:@"d0d0d0" alpha:1];
//    
//    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 , 5, CON_WIDTH - 21, 12)];
//    sectionTitle.font = FONT_SIZE_6(12.f);
//    sectionTitle.textColor = [UIColor colorWithString:@"8f8f8f" alpha:1];
//    [view addSubview:sectionTitle];
//    switch (section) {
//        case 0:
//            sectionTitle.text = [NSString stringWithFormat:@"グループ"];
//            break;
//        case 1:
//            sectionTitle.text = [NSString stringWithFormat:@"シストモ"];
//            break;
//            
//        default:
//            break;
//    }
//    
//    return view;
//}
    
    /// 点击cell的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id stmeModel= [self.glistTableArr objectAtIndex:indexPath.row];
    if ([stmeModel isKindOfClass:[MessagesModel class]]) {
        MessagesModel *model = [self.glistTableArr objectAtIndex:indexPath.row];
        ChatGroupViewController *chatGroup = [[ChatGroupViewController alloc] init];
        chatGroup.group_id = model.group_id;
        [self.navigationController pushViewController:chatGroup animated:YES];
    }else{
        FriendsModel *message = [self.glistTableArr objectAtIndex:indexPath.row];
        ChatViewController *chat = [[ChatViewController alloc] init];
        chat.member_id = message.user_id;
        [self.navigationController pushViewController:chat animated:YES];
    }
    
//    switch (indexPath.section) {
//        case 0:
//        {
//            MessagesModel *model = [self.glistTableArr objectAtIndex:indexPath.row];
//            ChatGroupViewController *chatGroup = [[ChatGroupViewController alloc] init];
//            chatGroup.group_id = model.group_id;
//            [self.navigationController pushViewController:chatGroup animated:YES];
//        }
//            break;
//        case 1:
//        {
//            FriendsModel *message = [self.mlistTableArr objectAtIndex:indexPath.row];
//            ChatViewController *chat = [[ChatViewController alloc] init];
//            chat.member_id = message.user_id;
//            [self.navigationController pushViewController:chat animated:YES];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
