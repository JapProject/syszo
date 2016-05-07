//
//  SysteerInfoViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/6.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SysteerInfoViewController.h"
#import "SysteerSearchViewController.h"
#import "SysteerEditInfoViewController.h"
#import "ChiebukuroCommentsList.h"
#import "SystterInfoList.h" // 表头model
#import "ChiebukuroCommentsList.h" // 列表model
#import "AnswerCellOne.h"   // 自己的
#import "AnswerCellTwo.h"   // 别人的

#import "MPHistroyViewController.h"

#import "AFHTTPRequestOperationManager.h"

#import "DetailsHeadView.h"
#import "FriendsDataViewController.h"
@interface SysteerInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIAlertViewDelegate>
///
@property (nonatomic, strong) UITableView *tableView;
/// 表头视图
@property (nonatomic, strong) DetailsHeadView *headerView;
/// 要发送的内容
@property (nonatomic, strong) NSString *postEmall;
/// 列表数组
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong)UIView *sendView;  // 输入框-底层
@property (nonatomic, strong)UITextView *send; // 输入框-输入
@property (nonatomic, strong)UIButton *messenger;// 输入框-送信

/// 刷新加载
@property (nonatomic, assign)NSInteger count;
//@property (strong, nonatomic) ChiebukuroCommentsList *chiebukuro;
@property(copy, nonatomic) void(^deleteCell)();
@end

@implementation SysteerInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //数组初始化
        self.dataArray = [[NSMutableArray alloc] init];
        self.count = 2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_hitorigoto" titleName:@"シスッター"];
    //    view.backgroundColor = [UIColor yellowColor];
    //    CGPoint temp = view.center;
    //    temp.x += 30;
    //    view.center = temp;
    //
    NSArray *arrTap = self.navigationController.viewControllers;
    //    NSLog(@"%@", arrTap);
        CGRect tempSize = view.frame;
        tempSize.size.width += 20;
        view.frame = tempSize;
    
    //写死就可以
    CGFloat h = 186;
    self.headerView = [[DetailsHeadView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, h)];
    __block SysteerInfoViewController *infoVC = self;
    self.headerView.goodActionBlock = ^(){//表头视图点赞
        [infoVC headerGood];
    };
    self.headerView.deleteActionBlock = ^(){// 表头视图(整个帖子)删除
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"投稿を削除しますか" delegate:infoVC cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        alert.tag = 123456;
        [alert show];
    };
    self.headerView.tapUserName = ^(){
        NSLog(@"点击进入好友预览界面");
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

        FriendsDataViewController *friendData = [[FriendsDataViewController alloc] init];
        friendData.refreshBlock = ^(){
            
        };
        friendData.member_id =[NSString stringWithFormat:@"%ld",infoVC.headerView.InfoModel.user_id] ;
        [infoVC.navigationController pushViewController:friendData animated:YES];
    };
    
    
    // 设置右上角导航栏
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_post_off"] style:UIBarButtonItemStyleDone target:self action:@selector(rightEditAction:)];
    self.navigationItem.rightBarButtonItem = edit;
    
    // 注册两个通知来监听键盘高度变化
    // 键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘收回
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    //加菊花
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    [self.view addSubview:self.progress];
    
    [self createSend];
    [self createTableView];

}
- (void)setSysteerList:(SystterList *)systeerList
{
    if (_systeerList != systeerList) {
        _systeerList = systeerList;
    }
    NSLog(@"id == %ld, birdid == %ld", (long)_systeerList.user_id,  (long)_systeerList.bird_id);
    [self creatDataBird:[NSString stringWithFormat:@"%ld", (long)_systeerList.bird_id]];
    [self creatDataListWithBird:[NSString stringWithFormat:@"%ld", (long)_systeerList.bird_id] page:@"1"];
}
- (void)comeBack
{
    NSArray *arrTap = self.navigationController.viewControllers;
    //    NSLog(@"%@", arrTap);
    NavbarView *view = [NavbarView sharedInstance];
    if ([[arrTap objectAtIndex:arrTap.count - 2] isKindOfClass:[MPHistroyViewController class]]) {
        [view setTitleImage:nil titleName:@"投稿履歴"];
    }
    CGRect tempSize = view.frame;
    tempSize.size.width -= 20;
    view.frame = tempSize;
    [self.navigationController popViewControllerAnimated:YES];
    self.refreshBlock();
}
#pragma mark 表头视图的删除方法
- (void)deleteNetWorkingWith
{
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerDeleteUrl];
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];
    NSString *bird_id = [NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id];
    NSDictionary *parameters = @{@"user_id":user.user_id, @"bird_id":bird_id};
    //加菊花
    [self.progress show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.progress hide:YES];
        [self comeBack];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

/// 表头视图的点赞
- (void)headerGood
{
//    [self.progress show:YES];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerGoodUrl];
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];
    if (!user) {
        EnterController *enter = [[EnterController alloc] init];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        enter.comeBackBlock = ^(){
            /// 没做操作时刷新视图
            [self.dataArray removeAllObjects];
            [self creatDataListWithBird:[NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id] page:@"1"];
            [self creatDataBird:[NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id]];
        };
        [appDelegate.navi presentViewController:enter animated:YES completion:^{
//
        }];
        return;
    }

    NSDictionary *parameters = @{@"user_id":user.user_id,@"bird_id":[NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.progress hide:YES];
//        [self creatDataListWithBird:[NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id] page:@"1"];
//        [self creatDataBird:[NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
#pragma mark-

- (void)createSend
{
    self.sendView = [[UIView alloc] initWithFrame:CGRectMake(0, CON_HEIGHT - 40 - 64, CON_WIDTH, 40)];
    self.sendView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.sendView];
    //    [self.view bringSubviewToFront:self.sendView];
    
    self.send = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, CON_WIDTH - 80, 30)];
    self.send.layer.cornerRadius = 10;
    self.send.clipsToBounds = YES;
    self.send.font = FONT_SIZE_8(17.f);
    self.send.delegate = self;
    [self.sendView addSubview:self.send];
    
    
    self.messenger = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.messenger.frame = CGRectMake(self.send.frame.size.width + self.send.frame.origin.x + 5, self.send.frame.origin.y, 80 - 15, 30);
    [self.messenger setBackgroundColor:[UIColor lightGrayColor]];
    //    self.messenger.layer.cornerRadius = 10;
    self.messenger.clipsToBounds = YES;
    [self.messenger setBackgroundImage:[UIImage imageNamed:@"btn_send_off"] forState:UIControlStateNormal];
    [self.messenger addTarget:self action:@selector(messengerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendView addSubview:self.messenger];
    
}

- (void)createTableView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 - 40) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //除去线
    self.tableView.separatorStyle = NO;
    self.tableView.tableHeaderView = self.headerView;
    [self setupRefresh];
    [self.view addSubview:self.tableView];
    [self.view sendSubviewToBack:self.tableView];

}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    
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
- (void)footerRereshing
{
    // 1.添加假数据
    NSString *pageNumder = [NSString stringWithFormat:@"%ld", (long)_count];
    NSLog(@"页码_count1----%@", pageNumder);
    //    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tabelArr];
    NSString *bird_id = [NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id];
    [self creatDataListWithBird:bird_id page:pageNumder];
    _count ++;
    //    for (ChiebukuroList *model in temp) {
    //        [self.tabelArr insertObject:model atIndex:self.tabelArr.count];
    //    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}
#pragma mark ---------

#pragma mark -
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
    ChiebukuroCommentsList *chiebukuroCommentsList = [self.dataArray objectAtIndex:indexPath.row];
    __block SysteerInfoViewController *QandAVC = self;

//    self.chiebukuro = chiebukuroCommentsList;
    UserModel *user = [UserModel unpackUserInfo];
    if (chiebukuroCommentsList.user_id == [user.user_id integerValue]) {
        
        static NSString *string = @"isMineEdit";
        AnswerCellOne *cell = [tableView dequeueReusableCellWithIdentifier:string];
        
        if (!cell) {
            cell = [[AnswerCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = chiebukuroCommentsList;
        [cell setUPs];
        cell.asImage.hidden = YES;
        //编辑操作
        cell.editAction = ^(){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"編集" message:@"内容を入力してください" delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag = 23010 + indexPath.row;
            [alertView show];
            
        };
        
        
        NSString *bird_id = [NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id];
        //删除操作
        cell.delAction = ^(){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"投稿を削除しますか" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
            alert.tag = 1234567;
            [alert show];
            QandAVC.deleteCell = ^(){
                
            NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerInfoListDel];
            //传入的参数
            //加菊花
            [self.progress show:YES];
            
            NSDictionary *parameters = @{@"user_id":[NSString stringWithFormat:@"%ld", (long)chiebukuroCommentsList.user_id], @"bird_id":[NSString stringWithFormat:@"%ld", (long)chiebukuroCommentsList.comments_id]};
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self creatDataBird:bird_id];
                
                [self.tableView removeFromSuperview];
                [self.dataArray removeAllObjects];
                [self createTableView];
                [self creatDataListWithBird:bird_id page:@"1"];
                [self.progress hide:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // NSLog(@"%@", error);
            }];
        };
            
        };
        return cell;
        
    } else {
        static NSString *string = @"isOtherGood";
        AnswerCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (!cell) {
            cell = [[AnswerCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = chiebukuroCommentsList;
        [cell setUps];
        cell.asImage.hidden = YES;
        NSString *bird_id = [NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id];
        cell.didUserName = ^(){
            NSLog(@"点击进入好友预览界面");
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

            FriendsDataViewController *friendData = [[FriendsDataViewController alloc] init];
            friendData.refreshBlock = ^(){
                
            };
            friendData.member_id = [NSString stringWithFormat:@"%ld",(long)chiebukuroCommentsList.user_id];
            [QandAVC.navigationController pushViewController:friendData animated:YES];
        };
        
        //点赞操作
        cell.goodAction = ^(){
            
            NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerInfoListGood];
            
            UserModel *user = [UserModel unpackUserInfo];
            if (!user) {
                EnterController *enter = [[EnterController alloc] init];
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                enter.comeBackBlock = ^(){
                    //刷新回复列表的时候，清空数组
                    [self.dataArray removeAllObjects];
                    [self creatDataListWithBird:bird_id page:@"1"];
                };
                [appDelegate.navi presentViewController:enter animated:YES completion:^{
                    
                }];
                return;
            }
            
       
            //传入的参数
            NSDictionary *parameters = @{@"bird_id":bird_id,@"user_id":user.user_id, @"comments_id":[NSString stringWithFormat:@"%ld", (long)chiebukuroCommentsList.comments_id]};
            
            //加菊花
//            [self.progress show:YES];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                [self.tableView removeFromSuperview];
//                [self.dataArray removeAllObjects];
//                [self createTableView];
//                [self creatDataListWithBird:bird_id page:@"1"];
//                [self.progress hide:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // NSLog(@"%@", error);
            }];
        };
        return cell;
    }
}
/// 编辑请求
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123456) {
        if (buttonIndex == 1) {
            [self deleteNetWorkingWith];
        }
        
        return ;
    }
    if (alertView.tag == 1234567) {
        if (buttonIndex == 1) {
            
            self.deleteCell();
            
        }
        return;
    }
    
    
    NSString *contentStr = [alertView textFieldAtIndex:buttonIndex].text;
    NSLog(@"alertContext = %@", contentStr);
    
    ChiebukuroCommentsList *chiebukuroCommentsList = [self.dataArray objectAtIndex:alertView.tag - 23010];
    
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerInfoListEdit];
    //传入的参数
//    NSString *bird_id = [NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id];
    UserModel *user = [UserModel unpackUserInfo];
    NSDictionary *parameters = @{@"user_id":user.user_id, @"bird_id":[NSString stringWithFormat:@"%ld", (long)chiebukuroCommentsList.comments_id], @"content":contentStr};
    //加菊花
    [self.progress show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        chiebukuroCommentsList.comments = contentStr;
        [self.tableView reloadData];
        [self.progress hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ChiebukuroCommentsList *model = self.dataArray[indexPath.row];
//    CGSize size = [self sizeWithString:model.comments font:FONT_SIZE_6(23.f)];
//    NSLog(@"cell里row的size的高==%f", size.height);
//    CGFloat h = size.height + 48 + 8 + 28 + 10 + 20;
//    return h;
    
    
    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[AnswerCellOne class]]) {
        AnswerCellOne *cells = cell;
        return cells.cellH;
    }else{
        AnswerCellTwo *cells = cell;
        return cells.cellH;
    }

}
///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark 表头视图的网络请求
/// 网络请求内容详情
- (void)creatDataBird:(NSString *)bard
{
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerInfoUrl];
    //传入的参数
    
    UserModel *user2 = [UserModel unpackUserInfo];
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (!user2) {
        parameters = @{@"bird_id":bard};
    } else {
        parameters = @{@"user_id":user2.user_id,@"bird_id":bard};
    }
    
//    NSDictionary *parameters = @{@"user_id":user,@"bird_id":bard};
    //加菊花
    [self.progress show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"鸟表头详情%@", responseObject);
        
        NSMutableDictionary *tempDic = [responseObject objectForKey:@"data"];
        SystterInfoList *systterInfo = [[SystterInfoList alloc] init];
        [systterInfo setValuesForKeysWithDictionary:tempDic];
        
        self.headerView.InfoModel = systterInfo;
        
        //获取数据后,自适应
        CGSize size = [self sizeWithString:self.headerView.InfoModel.content font:FONT_SIZE_6(20.f)];
        CGFloat h = self.headerView.infoLabel.height + 88 + 48;
        
        if (![systterInfo.pic isEqualToString:@""]) {
            UIImageView *tempImageView = [[UIImageView alloc] init];
            __block UIImageView *blockimage = tempImageView;
            [tempImageView setImageWithURL:[NSURL URLWithString:systterInfo.pic] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
                [self.tableView removeFromSuperview];
                
                blockimage.frame =CGRectMake(0, 0, CON_WIDTH - 20, image.size.height * ((CON_WIDTH - 20) / image.size.width));
                self.headerView.frame = CGRectMake(0, 0, CON_WIDTH, h + blockimage.frame.size.height);
                
                [self createTableView];
            }];
        } else {
            [self.tableView removeFromSuperview];
            self.headerView.frame = CGRectMake(0, 0, CON_WIDTH, h);
            [self createTableView];
        }
        
        
        [self.progress hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
}
#pragma mark -
#pragma mark 列表的网络请求
/// 网络请求内容详情
- (void)creatDataListWithBird:(NSString *)bard page:(NSString *)page
{
    if (!self.dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerInfoList];
    //传入的参数
    
    UserModel *user2 = [UserModel unpackUserInfo];
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (!user2) {
        parameters = @{@"bird_id":bard, @"p_num":page, @"p_size":@"10"};
    } else {
        parameters = @{@"user_id":user2.user_id,@"bird_id":bard, @"p_num":page, @"p_size":@"10"};
    }
    
    //加菊花
    [self.progress show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"鸟详情回复列表%@", responseObject);
        
        NSArray *tempArray = [responseObject objectForKey:@"data"];
        for (NSDictionary *dic in tempArray) {
            ChiebukuroCommentsList *model = [[ChiebukuroCommentsList alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self.progress hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
}

#pragma mark - 
// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CON_WIDTH - 20, 1000000)//限制最大的宽度和高度
                                       options:
                   NSStringDrawingTruncatesLastVisibleLine //| NSStringDrawingUsesFontLeading
                   |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HiraSansOldStd-W6" size:font.pointSize] }//传人的字体字典
                                       context:nil];
    
    return rect.size;
}
#pragma mark 鸟编辑
//右上角方法
- (void)rightEditAction:(UIButton *)bar
{
    UserModel *user = [UserModel unpackUserInfo];
    if (self.systeerList.user_id == [user.user_id integerValue]) {
        __block SysteerInfoViewController *infoVC = self;
        SysteerEditInfoViewController *systeerEditVC = [[SysteerEditInfoViewController alloc] init];
        systeerEditVC.bird_id = [NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id];
        systeerEditVC.model = infoVC.headerView.InfoModel;
        systeerEditVC.refreshEditBlock =^(){
            [infoVC creatDataBird:[NSString stringWithFormat:@"%ld", (long)_systeerList.bird_id]];
        };
        [self.navigationController pushViewController:systeerEditVC animated:YES];
    }
}
#pragma mark -
#pragma mark 输入框协议-代理方法
/// 点击“完成”时，执行的方法
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.postEmall = [NSString stringWithFormat:@"%@", textView.text];
    NSLog(@"输入==%@", self.postEmall);
}

#pragma mark -
#pragma 键盘
/// 键盘弹出
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    //  NSLog(@"%@", info);
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.sendView setFrame:CGRectMake(0, CON_HEIGHT - 40 - 64 - keyboardSize.height, CON_WIDTH, 40)];
        //  NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    }];
}
/// 键盘收回
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.sendView setFrame:CGRectMake(0, CON_HEIGHT - 40 - 64, CON_WIDTH, 40)];
    }];
}
//回收键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        [self.send resignFirstResponder];
    }
}
#pragma mark -
#pragma mark 发送消息的实现
- (void)messengerAction:(UIButton *)sender
{
    [self.send resignFirstResponder];
    //    self.send.text = @"";
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerInfoListSender];
    NSString *bird_id = [NSString stringWithFormat:@"%ld", (long)self.systeerList.bird_id];
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];
    if (!user) {
        EnterController *enter = [[EnterController alloc] init];
        enter.comeBackBlock = ^(){
        };
        [self presentViewController:enter animated:YES completion:^{
            
        }];
        return;
    }
    NSLog(@"postEmall == %@", self.postEmall);
    if (![self.postEmall isEqualToString:@""]) {
        //加菊花
        [self.progress show:YES];
        NSDictionary *parameters = @{@"user_id":user.user_id,@"bird_id":bird_id,@"reply_content":self.postEmall};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.dataArray removeAllObjects];
            [self creatDataListWithBird:bird_id page:@"1"];
            [self creatDataBird:[NSString stringWithFormat:@"%ld", (long)_systeerList.bird_id]];
            _count = 2;
            self.send.text = @"";
            [self.progress hide:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    
    
}
#pragma mark -
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
