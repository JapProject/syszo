//
//  QandAViewController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "QandAViewController.h"
#import "SysteerSearchViewController.h"
#import "QuestionHeaderView.h"  //问题表头视图
#import "AnswerCellOne.h"       //回答自定义cell - 我发的
#import "AnswerCellTwo.h"       //回答自定义cell - 别人发的
#import "QHeaderModel.h"        //头视图model
#import "MPHistroyViewcontroller.h"
#import "ChiebukuroSearchResultsViewController.h"
#import "ChiebukuroCommentsList.h"
#import "ChiebukuroEditInfoViewController.h"
#import "FriendsDataViewController.h"
@interface QandAViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, strong)UIView *sendView;  // 输入框-底层
@property (nonatomic, strong)UITextView *send; // 输入框-输入
@property (nonatomic, strong)UIButton *messenger;// 输入框-送信
//@property (nonatomic, strong)NSMutableArray *headerDataArray;   //表头数据数组
@property (nonatomic, strong)QuestionHeaderView *questionView;  //表头视图

@property (nonatomic, strong)NSMutableArray *tabelArr;
//送信
@property (nonatomic, strong)NSString *postEmall;
//知恵袋点赞
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger comments_id;

@property (nonatomic, assign) NSInteger row;

// 翻页
@property (nonatomic, assign) NSInteger count;
//@property (strong, nonatomic) ChiebukuroCommentsList *chiebukuroCommentsList;
@property (strong, nonatomic) void (^delteCell)();
@end

@implementation QandAViewController

//- (void)dealloc
//{
//    // 移除当前对象监听的事件
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //数组初始化
        self.tabelArr = [[NSMutableArray alloc] init];
        self.count = 2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋"];
    //写死就可以
    CGFloat h = 165;
    self.questionView = [[QuestionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, h)];
    __block QandAViewController *QandAVC = self;
    self.questionView.tableView = self.tableView;
    self.questionView.delBlock = ^(){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"投稿を削除しますか" delegate:QandAVC cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        alert.tag = 12345;
        [alert show];
    };
#pragma mark 点击名字跳转到详情
    self.questionView.tapUserName = ^(){
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
        friendData.member_id = QandAVC.questionView.model.user_id;
        [QandAVC.navigationController pushViewController:friendData animated:YES];
    };
    
    self.questionView.tapLikeButton = ^() {
        NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,@"index.php/know/good"];
        
        UserModel *user = [UserModel unpackUserInfo];
        if (!user) {
            EnterController *enter = [[EnterController alloc] init];
            enter.comeBackBlock = ^(){
                [QandAVC createDataWithknowID:[NSString stringWithFormat:@"%ld", (long)QandAVC.chieburoList.know_id] pageNumder:@"1"];
            };
            [QandAVC presentViewController:enter animated:YES completion:^{
                
            }];
            return;
        }
        
        
        //传入的参数
        NSDictionary *parameters = @{@"know_id":[NSString stringWithFormat:@"%ld", (long)QandAVC.chieburoList.know_id],@"user_id":user.user_id, @"comments_id":@"0"};
        
        //加菊花
//                    [self.progress show:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [QandAVC.questionView getLikeCount];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // NSLog(@"%@", error);
            [QandAVC.questionView likeFail];
        }];
    };
    
    [self createTableView];
    [self createSend];
    // 注册两个通知来监听键盘高度变化
    // 键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘收回
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    [self.view addSubview:self.progress];
    
    // 设置右上角导航栏
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_post_off"] style:UIBarButtonItemStyleDone target:self action:@selector(rightEditAction:)];
    self.navigationItem.rightBarButtonItem = edit;
}

#pragma mark 表头视图的删除方法
- (void)deleteNetWorkingWith
{
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroDelUrl];
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];
    NSString *knowid = [NSString stringWithFormat:@"%ld", (long)_chieburoList.know_id];
    NSDictionary *parameters = @{@"user_id":user.user_id, @"know_id":knowid};
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
#pragma mark-
#pragma mark 大象编辑按钮
- (void)rightEditAction:(UIBarButtonItem *)sender
{
    UserModel *user = [UserModel unpackUserInfo];
    // 点击编辑
    if(self.questionView.model && [self.questionView.model.user_id isEqualToString:user.user_id]){
        NSString *knowid = [NSString stringWithFormat:@"%ld", (long)_chieburoList.know_id];
        __block QandAViewController *QandAVC = self;
        ChiebukuroEditInfoViewController *editvc = [[ChiebukuroEditInfoViewController alloc] init];
        editvc.know_id = knowid;
        if (self.chieburoList.urgent == 2) {
            editvc.urgent = YES;
        } else {
            editvc.urgent = NO;
        }
        editvc.model = QandAVC.questionView.model;
        editvc.refreshEditBlock =^(){
            [QandAVC networkingWithKnowID:knowid];
        };
        [self.navigationController pushViewController:editvc animated:YES];
    }
}
- (void)setChieburoList:(ChiebukuroList *)chieburoList
{
    if (_chieburoList != chieburoList) {
        _chieburoList = chieburoList;
    }
    NSString *knowid = [NSString stringWithFormat:@"%ld", (long)_chieburoList.know_id];

    [self networkingWithKnowID:knowid];
    [self createDataWithknowID:knowid pageNumder:@"1"];
}
- (void)comeBack
{
    NSArray *arrTap = self.navigationController.viewControllers;
//    NSLog(@"%@", arrTap);
    if ([[arrTap objectAtIndex:arrTap.count - 2] isKindOfClass:[ChiebukuroSearchResultsViewController class]]) {
        NavbarView *view = [NavbarView sharedInstance];
        [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋-検索"];
        CGPoint temp1 = view.center;
        temp1.x -= 30;
        view.center = temp1;
        CGRect tempSize = view.frame;
        tempSize.size.width += 30;
        view.frame = tempSize;
        self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:59 / 255.0 green:58 / 255.0 blue:56/ 255.0 alpha:1];

    } else if([[arrTap objectAtIndex:arrTap.count - 2] isKindOfClass:[MPHistroyViewController class]]){
        NavbarView *view = [NavbarView sharedInstance];
        [view setTitleImage:nil titleName:@"投稿履歴"];
        CGPoint temp1 = view.center;
        temp1.x -= 30;
        view.center = temp1;
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.refreshBlock();
}


- (void)createSend
{
    self.sendView = [[UIView alloc] initWithFrame:CGRectMake(0, CON_HEIGHT - 40 - 64, CON_WIDTH, 40)];
    self.sendView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.sendView];
//    [self.view bringSubviewToFront:self.sendView];
    
    self.send = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, CON_WIDTH - 80, 30)];
    self.send.layer.cornerRadius = 10;
    self.send.clipsToBounds = YES;
    self.send.font = FONT_SIZE_10(15.f);
    self.send.delegate = self;
//    self.send.
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


- (void)createDataWithknowID:(NSString *)knowid pageNumder:(NSString *)pageNum
{
    
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroCommentsListUrl];
//    NSInteger know_id = self.chieburoList.know_id;
//    NSString *string = [NSString stringWithFormat:@"%ld", (long)know_id];
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];
    NSDictionary *parameters = [NSDictionary dictionary];
    if (!user) {
        parameters = @{@"know_id":knowid,@"p_num":pageNum,@"p_size":@"5"};
    } else {
        parameters = @{@"know_id":knowid,@"p_num":pageNum,@"p_size":@"5",@"user_id":user.user_id};
    }
    [self.progress show:YES];
    __weak QandAViewController *qandVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"列表%@========", responseObject);
        NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
        for (NSDictionary *dic in tempArr) {
           ChiebukuroCommentsList *chiebukuroCommentsList = [[ChiebukuroCommentsList alloc] init];
            [chiebukuroCommentsList setValuesForKeysWithDictionary:dic];
            [qandVC.tabelArr addObject:chiebukuroCommentsList];
        }
        [self.progress hide:YES];
        [self.tableView reloadData];
//        if (tempArr.count != 0) {
//            _count ++;
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
 
}



#pragma mark 发送消息的实现
- (void)messengerAction:(UIButton *)sender
{
    [self.send resignFirstResponder];
//    self.send.text = @"";
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroCommentsListInfoUrl];
    NSString *know_id = [NSString stringWithFormat:@"%ld", (long)self.chieburoList.know_id];
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];
    if (!user) {
        EnterController *enter = [[EnterController alloc] init];
        enter.comeBackBlock = ^(){
//            return;
        };
        [self presentViewController:enter animated:YES completion:^{
            
        }];
        return;
    }

    NSLog(@"postEmall == %@", self.postEmall);
    if (![self.postEmall isEqualToString:@""]) {
        //加菊花
        [self.progress show:YES];
        NSDictionary *parameters = @{@"user_id":user.user_id,@"know_id":know_id,@"reply_content":self.postEmall};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self networkingWithKnowID:know_id];
//            [self.tableView removeFromSuperview];
            [self.tabelArr removeAllObjects];
//            [self createTableView];
            [self createDataWithknowID:know_id pageNumder:@"1"];
            _count = 2;
            self.send.text = @"";
            [self.progress hide:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    
    
}
#pragma mark 键盘
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
#pragma mark 输入框协议-代理方法
/// 点击联想的时候出发

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.postEmall = [NSString stringWithFormat:@"%@", textView.text];
    NSLog(@"输入==%@", self.postEmall);
}
#pragma mark -
#pragma mark   列表
- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 - 40) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //除去线
    self.tableView.separatorStyle = NO;
    self.tableView.tableHeaderView = self.questionView;
    
    [self setupRefresh];
    
    [self.view addSubview:self.tableView];
    [self.view sendSubviewToBack:self.tableView];
}
// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CON_WIDTH - 20, 10000)//限制最大的宽度和高度
                                       options:
                   NSStringDrawingTruncatesLastVisibleLine //| NSStringDrawingUsesFontLeading
                  | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName:  font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

#pragma mark -
#pragma mark 表头视图的网络请求
- (void)networkingWithKnowID:(NSString *)knowID
{
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroInfoUrl];
    
    UserModel *user = [UserModel unpackUserInfo];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (!user) {
        parameters = @{@"know_id":knowID};
    } else {
        parameters = @{@"user_id":user.user_id,@"know_id":knowID};
    }
    
    //传入的参数
    
    //加菊花
    [self.progress show:YES];
    
    __weak QandAViewController *chieVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"数据数据===%@", responseObject);
        NSMutableDictionary *tempArr = [responseObject objectForKey:@"data"];
        
        
        QHeaderModel *model = [[QHeaderModel alloc]init];
        [model setValuesForKeysWithDictionary:tempArr];
        model.topicID = chieVC.chieburoList.know_id;
//        [chieVC.headerDataArray addObject:model];
        self.questionView.model = model;//[self.headerDataArray lastObject];
        //获取数据后,自适应
        CGSize size = self.questionView.content.size;
        
//        [self sizeWithString:self.questionView.content.text font: [UIFont fontWithName:@"HiraSansOldStd-W6" size:20.f] ];
        
        CGSize size2 = self.questionView.questionTitle.size;
//        [self sizeWithString:self.questionView.questionTitle.text font:[UIFont fontWithName:@"HiraSansOldStd-W6" size:20.f]];
        CGFloat h = size.height + 120  + size2.height ;
        
        if (![model.info_img isEqualToString:@""]) {
            UIImageView *tempImageView = [[UIImageView alloc] init];
            __block UIImageView *blockimage = tempImageView;
            NSURL *url = [NSURL URLWithString:[model.info_img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [tempImageView setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
                [self.tableView removeFromSuperview];
               
                blockimage.frame =CGRectMake(10, h - 5, CON_WIDTH - 20, image.size.height * ((CON_WIDTH - 20) / image.size.width));
                self.questionView.frame = CGRectMake(0, 0, CON_WIDTH, h + blockimage.frame.size.height + 35);
                [self.questionView addSubview:blockimage];
                [self createTableView];
            }];
        }
        else {
            self.questionView.frame = CGRectMake(0, 0, CON_WIDTH, h + 20);
        }
        [self.tableView removeFromSuperview];
        [self createTableView];
        [self.progress hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
//    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
//#warning 自动刷新(一进入程序就下拉刷新)
//    [self.tableView headerBeginRefreshing];
    
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
//- (void)headerRereshing
//{
//    // 1.添加假数据
//    
//    
//    // 2.2秒后刷新表格UI
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [self.tableView reloadData];
//        
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [self.tableView headerEndRefreshing];
//    });
//}
//static NSInteger _count = 2;
- (void)footerRereshing
{    
    // 1.添加假数据
    NSString *pageNumder = [NSString stringWithFormat:@"%ld", (long)_count];
    NSLog(@"页码_count1----%@", pageNumder);
//    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tabelArr];
    NSString *knowid = [NSString stringWithFormat:@"%ld", (long)self.chieburoList.know_id];
    [self createDataWithknowID:knowid pageNumder:pageNumder];
    
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
#pragma mark tabelView协议
///  section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
///  每个section里的row的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tabelArr.count;
}
//  返回tableView里的cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChiebukuroCommentsList *chiebukuroCommentsList = [self.tabelArr objectAtIndex:indexPath.row];
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

        __block QandAViewController *qandAv = self;
        //编辑操作
        cell.editAction = ^(){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"編集" message:@"内容を入力してください" delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag = 20010 + indexPath.row;
            [alertView show];
        };
        
        
        NSString *knowid = [NSString stringWithFormat:@"%ld", (long)_chieburoList.know_id];
        //删除操作
        cell.delAction = ^(){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"投稿を削除しますか" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
            alert.tag = 123456;
            [alert show];
            qandAv.delteCell = ^(){
                NSString *knowid = [NSString stringWithFormat:@"%ld", (long)_chieburoList.know_id];
                
                NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroCommentsDelUrl];
                //传入的参数
                //加菊花
                [self.progress show:YES];
                
                NSDictionary *parameters = @{@"user_id":[NSString stringWithFormat:@"%ld", (long)chiebukuroCommentsList.user_id], @"info_id":[NSString stringWithFormat:@"%ld", (long)chiebukuroCommentsList.comments_id]};
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                                    [self networkingWithKnowID:knowid];
                    
                    [self.tableView removeFromSuperview];
                    [self.tabelArr removeAllObjects];
                    [self createTableView];
                    [self createDataWithknowID:[NSString stringWithFormat:@"%ld", (long)self.chieburoList.know_id] pageNumder:@"1"];
                    [self.progress hide:YES];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    // NSLog(@"%@", error);
                }];
            };
            
            
            
//            NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroCommentsDelUrl];
//            //传入的参数
//            //加菊花
//            [self.progress show:YES];
//            
//            NSDictionary *parameters = @{@"user_id":[NSString stringWithFormat:@"%ld", (long)chiebukuroCommentsList.user_id], @"info_id":[NSString stringWithFormat:@"%ld", (long)chiebukuroCommentsList.comments_id]};
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//            [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                
//                [self networkingWithKnowID:knowid];
//                
//                [self.tableView removeFromSuperview];
//                [self.tabelArr removeAllObjects];
//                [self createTableView];
//                [self createDataWithknowID:[NSString stringWithFormat:@"%ld", (long)self.chieburoList.know_id] pageNumder:@"1"];
//                [self.progress hide:YES];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                // NSLog(@"%@", error);
//            }];
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
        __block QandAViewController *QandAVC = self;
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
        __block AnswerCellTwo *blockCell = cell;
        //点赞操作
        cell.goodAction = ^(){
            
            NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroGoodUrl];
            
            UserModel *user = [UserModel unpackUserInfo];
            if (!user) {
                EnterController *enter = [[EnterController alloc] init];
                enter.comeBackBlock = ^(){
                    [self createDataWithknowID:[NSString stringWithFormat:@"%ld", (long)self.chieburoList.know_id] pageNumder:@"1"];
                };
                [self presentViewController:enter animated:YES completion:^{
                    
                }];
                return;
            }
            
            
            //传入的参数
            NSDictionary *parameters = @{@"know_id":[NSString stringWithFormat:@"%ld", (long)self.chieburoList.know_id],@"user_id":user.user_id, @"comments_id":[NSString stringWithFormat:@"%ld", (long)chiebukuroCommentsList.comments_id]};
            
            //加菊花
//            [self.progress show:YES];

            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
#warning 点赞是否刷新
//                [self.tableView removeFromSuperview];
//                [self.tabelArr removeAllObjects];
//                [self createTableView];
//                [self createDataWithknowID:[NSString stringWithFormat:@"%ld", (long)self.chieburoList.know_id] pageNumder:@"1"];
//                [self.progress hide:YES];
                [blockCell getLikeCount];
                [QandAVC.questionView getLikeCount];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // NSLog(@"%@", error);
                [blockCell likeFail];
            }];
        };
        
        return cell;
    }
}

/// 编辑请求
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //表头视图删除
    if (alertView.tag == 12345) {
        switch (buttonIndex) {
            case 1:
            [self deleteNetWorkingWith];
                break;
            default:
                break;
        }
        
        return;
    }
    if (alertView.tag == 123456) {
        if (buttonIndex == 1) {
            self.delteCell();
 
        }
        return;
    }
    
    NSString *contentStr = [alertView textFieldAtIndex:buttonIndex].text;
    NSLog(@"alertContext = %@", contentStr);
    
    ChiebukuroCommentsList *chiebukuroCommentsList = [self.tabelArr objectAtIndex:alertView.tag - 20010];
    
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroCommentsEditUrl];
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];
    NSDictionary *parameters = @{@"user_id":user.user_id, @"info_id":[NSString stringWithFormat:@"%ld", (long)chiebukuroCommentsList.comments_id], @"content":contentStr};
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
//    ChiebukuroCommentsList *model = self.tabelArr[indexPath.row];
//    CGSize size = [self sizeWithString:model.comments font: [UIFont fontWithName:@"HiraSansOldStd-W6" size:23.f]];
//    CGFloat h = size.height + 48 + 8 + 28 + 10 + 20;
    
    ChiebukuroCommentsList *chiebukuroCommentsList = [self.tabelArr objectAtIndex:indexPath.row];
    UserModel *user = [UserModel unpackUserInfo];
    if (chiebukuroCommentsList.user_id == [user.user_id integerValue]) {
        
        AnswerCellOne *cell =[[AnswerCellOne alloc] init];
        cell.model = chiebukuroCommentsList;
        [cell setUPs];
        return cell.cellH;
    }else{
        AnswerCellTwo *cell = [[AnswerCellTwo alloc] init];
        cell.model = chiebukuroCommentsList;
        [cell setUps];
        return cell.cellH;
        
    }
    
    
}
//  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
