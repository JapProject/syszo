//
//  MPSEditViewController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/5.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MPSEditViewController.h"
#import "MyResumeCell.h"
#import "MPSEditTableController.h"  /// 内容列表
#import "MyDataEditAddressModel.h"  /// 内容列表model
#import "MyDataCheckCell.h"         /// userNamecell
#import "MyDataCheckController.h"   /// 查看自己资料
#import "FriendsDataViewController.h"   // 同上
#import "MyDataIntroduceCell.h"     /// 自我介绍cell
#import "MyDataEditModels.h"
#import "MultiSelectionTableViewCell.h"
#import "MPSAccountEditViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


@interface MPSEditViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, NADViewDelegate,UITextFieldDelegate> {
    BOOL isAddProfile;
    NSInteger seletedIndex;
    NSArray *urlArray;
    UITextField *nameField;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray; /// 类型
@property (nonatomic, strong)NSMutableArray *MyDataArray; /// 内容
@property (nonatomic, strong) NADView *ADView;

//@property (nonatomic, strong)NSMutableArray *upLoadArray;   //数据上传用的临时数组


@property (nonatomic, strong)UserModel *user;
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation MPSEditViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        self.MyDataArray = [[NSMutableArray alloc] init];
        self.user = [UserModel unpackUserInfo];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"返回传参数" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoti:) name:@"返回传参数" object:nil];
//    urlArray = [NSArray arrayWithObjects:@"性别", MypageEditAddress, MypageEditIndustry, MypageEditGetSize, MypageEditJob, MypageEditGetRegMoney, MypageEditGetUse, MypageEditGetSoft, MypageEditGetHard, MypageEditGetQualified, MypageEditGetAllYear, @"シストモ", @"いいね！数",  nil];
    urlArray = [NSArray arrayWithObjects:@"性别", MypageEditAddress, MypageEditIndustry, MypageEditGetSize, MypageEditJob, MypageEditGetRegMoney, MypageEditGetUse, MypageEditGetAllYear, @"シストモ", @"いいね！数",  nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_save_off@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(barButtonAction:)];

    
    // 注册两个通知来监听键盘高度变化
    // 键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘收回
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
//    self.dataArray = [NSMutableArray arrayWithObjects:@"性別", @"現在地", @"業種", @"会社規模", @"役職・役割", @"年間予算", @"情シス歴", @"ソフトウェア", @"ハードウェア", @"保有資格", @"シストモ", @"いいね！数", nil];
    self.dataArray = [NSMutableArray arrayWithObjects:@"性別", @"現在地", @"業種", @"会社規模", @"役職・役割", @"年間予算", @"情シス歴", @"シストモ", @"いいね！数", nil];
    
    // 获取存入本地临时文件夹的数组
    NSString *path2 = NSTemporaryDirectory();
    NSString *arrPath = [path2 stringByAppendingPathComponent:@"MyData.xml"];
    self.MyDataArray = [NSMutableArray arrayWithContentsOfFile:arrPath];
    //数组
    NSLog(@"从本地取出的数组%@", self.MyDataArray);
    
//    /// 数据上传
//    if (!upLoadArray) {
//        upLoadArray = [NSMutableArray arrayWithArray:self.MyDataArray];
//    }
    
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
    _ADView.delegate = self;
    [_ADView load];
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
#pragma 键盘
/// 键盘弹出
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    //  NSLog(@"%@", info);
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (![nameField isFirstResponder]) {
        [UIView animateWithDuration:duration animations:^{
            [self.tableView setCenter:CGPointMake(self.view.center.x, self.view.center.y - keyboardSize.height)];
            //  NSLog(@"keyBoard:%f", keyboardSize.height);  //216
        }];
    }
    
}
/// 键盘收回
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (![nameField isFirstResponder]) {
        [UIView animateWithDuration:duration animations:^{
            [self.tableView setFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height)];
        }];
    }
}
//回收键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

/// 返回
- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:nil titleName:@"設定"];
    
    CGPoint temp = view.center;
    temp.x += 45;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width -= 45;
    view.frame = tempSize;
    //        @property (assign, nonatomic) BOOL comYes;
            self.comYes = YES;
    //
    //        if (self.comYes ) {
    //            return;
    //        }
    [self.navigationController popViewControllerAnimated:YES];
//    /// 保存时,进行网络请求
//    UserModel *user = [UserModel unpackUserInfo];
//    [self saveNetWorkWithUserID:user.user_id];
    
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
        [view setTitleImage:nil titleName:@"設定"];
        
        CGPoint temp = view.center;
        temp.x += 45;
        view.center = temp;
        CGRect tempSize = view.frame;
        tempSize.size.width -= 45;
        view.frame = tempSize;
        
        NSLog(@"返回");
    }
}




/// 保存
- (void)barButtonAction:(UIBarButtonItem *)sender
{
    /// 保存时,进行网络请求
    [nameField resignFirstResponder];
    UserModel *user = [UserModel unpackUserInfo];
    [self saveNetWorkWithUserID:user.user_id];
}
#pragma mark 保存时进行的网络请求
- (void)saveNetWorkWithUserID:(NSString *)userId
{
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,MyPageEdit];
    //传入的参数
//    NSArray *keys = [NSArray arrayWithObjects:@"user_sex", @"address", @"industry", @"size_company", @"job", @"reg_money", @"calendar", @"software", @"hardware", @"qualified", @"number", @"price", @"introduction",nil];
    NSArray *keys = [NSArray arrayWithObjects:@"user_sex", @"address", @"industry", @"size_company", @"job", @"reg_money", @"calendar", @"number", @"price", @"introduction",nil];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < keys.count; i ++) {
        [dic setValue:upLoadArray[i] forKey:keys[i]];
    }
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[self.MyDataArray lastObject] forKey:@"introduction"];
    [dic setValue:nameField.text forKey:@"user_nick"];
    
    NSLog(@"dic========%@", dic);
    
    [self.progress show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        // 获取到数据后存入本地临时文件夹
        NSString *path2 = NSTemporaryDirectory();
        NSString *arrPath = [path2 stringByAppendingPathComponent:@"MyData.xml"];
        
        self.user.user_name = nameField.text;
        [MPSAccountEditViewController saveUserInfo:self.user];
        // 写入
        BOOL result2 = [self.MyDataArray writeToFile:arrPath atomically:YES];
//        NSLog(@"数组写入结果: %d, 地址:%@, 数组:%@", result2, path2, self.MyDataArray);
        [self.progress hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
    }];

}

#pragma mark -
- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 25;
    //除去线
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark tabelView协议
///  section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
///  每个section里的row的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.dataArray.count;
            break;
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}
///  返回tableView里的cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *string = @"MPSEditFrist";
            MyDataCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[MyDataCheckCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            nameField = cell.userName;
            nameField.delegate = self;
            cell.userName.text = self.user.user_name;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.block = ^(){
                NSLog(@"点击进入预览自己界面");

                MyDataCheckController *myDataCheck = [[MyDataCheckController alloc] init];
                [self.navigationController pushViewController:myDataCheck animated:YES];
            };
            return cell;
        }
            break;
        case 1:
        {
            NSString *content = self.MyDataArray[indexPath.row];
//            if ((indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9) && content && ![content isEqualToString:@""]) {
//                NSArray  *nib= [[NSBundle mainBundle] loadNibNamed:@"MultiSelectionTableViewCell" owner:self options:nil];
//                MultiSelectionTableViewCell *MSCell = [nib objectAtIndex:0];
//                MSCell.titleLabel.text = self.dataArray[indexPath.row];
//                [MSCell.addbutton addTarget:self action:@selector(addQualifiekd:) forControlEvents:UIControlEventTouchUpInside];
//                MSCell.addbutton.tag = indexPath.row;
//                NSArray *contents = [content componentsSeparatedByString:@","];
//                
//                float cellHight;
//                NSString *content = self.MyDataArray[indexPath.row];
//                if (!content || [content isEqualToString:@""]) {
//                    cellHight = 45;
//                }
//                else if (![content containsString:@","]) {
//                    cellHight = 75;
//                }
//                else {
//                    cellHight = contents.count * 35 + 35 + 10;
//                }
//                MSCell.titleLabel.frame = CGRectMake(5, (cellHight - MSCell.titleLabel.frame.size.height) / 2, (SCREEN_WIDTH - 10) / 5 * 2 - 15, MSCell.titleLabel.frame.size.height);
//                MSCell.addbutton.frame = CGRectMake(10 + (SCREEN_WIDTH - 10) / 5 * 2, 5 + contents.count * 35, SCREEN_WIDTH - (10 + (SCREEN_WIDTH - 10) / 5 * 2) - 29, 30);
//                for (int i = 0; i < contents.count; i ++) {
//                    UIButton *contentButton = [[UIButton alloc] initWithFrame:CGRectMake(10 + (SCREEN_WIDTH - 10) / 5 * 2, 5 + i * 35, SCREEN_WIDTH - (10 + (SCREEN_WIDTH - 10) / 5 * 2) - 60, 35)];
//                    [contentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                    [contentButton addTarget:self action:@selector(chooseQualified:) forControlEvents:UIControlEventTouchUpInside];
//                    contentButton.tag = indexPath.row * 100 + i;
//                    contentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                    [contentButton setTitle:contents[i] forState:UIControlStateNormal];
//                    MSCell.contentButton = contentButton;
//                    [MSCell addSubview:contentButton];
//                    
//                    UIButton *deleteBUtton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, CGRectGetMinY(contentButton.frame), 30, 30)];
//                    [deleteBUtton setImage:[UIImage imageNamed:@"btn_deleteprofile_on"] forState:UIControlStateNormal];
//                    deleteBUtton.tag = contentButton.tag;
//                    [deleteBUtton addTarget:self action:@selector(deleteQualified:) forControlEvents:UIControlEventTouchUpInside];
//                    MSCell.deleteBUtton = deleteBUtton;
//                    [MSCell addSubview:deleteBUtton];
//                }
//                
//                return MSCell;
//            }
            static NSString *string = @"MPSEditCell";
            MyResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[MyResumeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            // 标题数组
            cell.categoryTitle.text = self.dataArray[indexPath.row];
            // 数据数组
//            if (indexPath.row == 11) {
            if (indexPath.row == 7) {
                cell.contentTitle.text = [NSString stringWithFormat:@"%@ 人", self.MyDataArray[indexPath.row]];
                cell.myImage.image = nil;
//            } else if(indexPath.row == 12){
            } else if(indexPath.row == 8){
                cell.contentTitle.text = [NSString stringWithFormat:@"%@ いいね", self.MyDataArray[indexPath.row]];
                cell.myImage.image = nil;
            } else {
                cell.contentTitle.text = self.MyDataArray[indexPath.row];
                UIImage *image = [UIImage imageNamed:@"arrowRight"];
                cell.myImage.image = image;
            }
            return cell;

        }
            break;
        case 2:
        {
            static NSString *string = @"MPSEditThi";
            MyDataIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[MyDataIntroduceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.selfIntroduce.text = [self.MyDataArray lastObject];
            cell.selfIntroduce.delegate = self;
            return cell;
        }
            break;
            
        default:
        {
            static NSString *string = @"MPSEditnull";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            return cell;
        }
            break;
    }
}


//uitextfield delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}


- (void)addQualifiekd:(UIButton *)btton {

    int index = (int)btton.tag;
    isAddProfile = YES;
    MPSEditTableController *table = [[MPSEditTableController alloc] init];
    table.url = [NSString stringWithFormat:@"%@%@", TiTleUrl,urlArray[index]];
    table.index = index;
    table.dicId = nil;
    [self.navigationController pushViewController:table animated:YES];
}

- (void)deleteQualified:(UIButton *)button {
    int index = (int)button.tag / 100;
    seletedIndex = (int)button.tag % 100;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.MyDataArray];
    NSMutableArray *temp2 = [NSMutableArray arrayWithArray:upLoadArray];

    NSArray *pre = [temp[index] componentsSeparatedByString:@","];
    NSMutableArray *preS = [NSMutableArray arrayWithArray:pre];
    [preS removeObjectAtIndex:seletedIndex];
    NSString *new;
    if (preS.count == 1) {
        new = preS[0];
    }
    else {
         new = preS.count > 0 ? [preS componentsJoinedByString:@","] : @"";
    }
    [temp replaceObjectAtIndex:index withObject:new];
    self.MyDataArray = [NSMutableArray arrayWithArray:temp];
    
    /// 修改数据上传
    NSArray *preIDs = [temp2[index] componentsSeparatedByString:@","];
    NSMutableArray *preSIDS = [NSMutableArray arrayWithArray:preIDs];
    [preSIDS removeObjectAtIndex:seletedIndex];
    NSString *newId;
    if (preS.count == 1) {
        newId = preSIDS[0];
    }
    else {
        newId = preSIDS.count > 0 ? [preSIDS componentsJoinedByString:@","] : @"";
    }
    [temp2 replaceObjectAtIndex:index withObject:newId];
    upLoadArray = [NSMutableArray arrayWithArray:temp2];
    [self.tableView reloadData];
}

- (void)chooseQualified:(UIButton *)button {
    int index = (int)button.tag / 100;
    seletedIndex = button.tag % 100;
    isAddProfile = NO;
    MPSEditTableController *table = [[MPSEditTableController alloc] init];
    table.url = [NSString stringWithFormat:@"%@%@", TiTleUrl,urlArray[index]];
    table.index = index;
    table.dicId = nil;
    [self.navigationController pushViewController:table animated:YES];
}

/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 65;
            break;
        case 1:
//            if (indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9) {
//                NSString *content = self.MyDataArray[indexPath.row];
//                if (!content || [content isEqualToString:@""]) {
//                    return 45;
//                }
//                if (![content containsString:@","]) {
//                    return 75;
//                }
//                NSArray *contents = [content componentsSeparatedByString:@","];
//                return contents.count * 35 + 35 + 5;
//            }
            return 45;
            break;
        case 2:
            return 60;
            break;
            
        default:
            return 0;
            break;
    }
}


static NSMutableArray *upLoadArray = nil;



- (void)setMyDataArray:(NSMutableArray *)MyDataArray
{
    if (_MyDataArray != MyDataArray) {
        _MyDataArray = MyDataArray;
    }
    /// 数据上传
    if (!upLoadArray) {
        upLoadArray = [NSMutableArray arrayWithArray:self.MyDataArray];
    }
}

///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [nameField resignFirstResponder];
    }
//    if ((indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9) && self.MyDataArray[indexPath.row] && ![self.MyDataArray[indexPath.row] isEqualToString:@""]) {
//        [tableView deselectRowAtIndexPath:indexPath animated:NO];
//        return;
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ///后面两个自己填
    if (indexPath.section == 1 && indexPath.row < 7) {

        MPSEditTableController *table = [[MPSEditTableController alloc] init];
        table.url = [NSString stringWithFormat:@"%@%@", TiTleUrl,urlArray[indexPath.row]];
        table.index = indexPath.row;
        table.dicId = nil;
        __block MPSEditViewController *edit = self;
        
        
        
//        table.saveBlock = ^(id model){
//            /// 视图显示
//            NSMutableArray *temp = [NSMutableArray arrayWithArray:edit.MyDataArray];
//            NSMutableArray *temp2 = [NSMutableArray arrayWithArray:upLoadArray];
//
//            if ([model isKindOfClass:[MyDataEditAddressModel class]]) {
//                MyDataEditAddressModel *modelss = model;
//                [temp replaceObjectAtIndex:indexPath.row withObject:modelss.area_name];
//                edit.MyDataArray = [NSMutableArray arrayWithArray:temp];
//                
//                /// 修改数据上传
//                [temp2 replaceObjectAtIndex:indexPath.row withObject:modelss.area_id];
//            }else
//            {
//                MyDataEditModels * modelss = ( MyDataEditModels *)model;
//                [temp replaceObjectAtIndex:indexPath.row withObject:modelss.area_name];
//                edit.MyDataArray = [NSMutableArray arrayWithArray:temp];
//                
//                /// 修改数据上传
//                [temp2 replaceObjectAtIndex:indexPath.row withObject:modelss.area_id];
//            }
//            
//         
//            upLoadArray = [NSMutableArray arrayWithArray:temp2];
//            
//            [self.tableView reloadData];
//        };
        [self.navigationController pushViewController:table animated:YES];
    }
}

- (void)receiveNoti:(NSDictionary *)dic{
    id model =  [dic objectForKey:@"model"];
    NSString *indexs = [dic objectForKey:@"index"];
    NSInteger index = [indexs integerValue];
    {
        /// 视图显示
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.MyDataArray];
        NSMutableArray *temp2 = [NSMutableArray arrayWithArray:upLoadArray];
        
        if ([model isKindOfClass:[MyDataEditAddressModel class]]) {
            MyDataEditAddressModel *modelss = model;
            [temp replaceObjectAtIndex:index withObject:modelss.area_name];
            self.MyDataArray = [NSMutableArray arrayWithArray:temp];
            
            /// 修改数据上传
            [temp2 replaceObjectAtIndex:index withObject:modelss.area_id];
        }else
        {
//            if ((index == 7 || index == 8 || index == 9) && self.MyDataArray[index] && ![self.MyDataArray[index] isEqualToString:@""]) {
//                if (isAddProfile) {
//                    MyDataEditModels * modelss = ( MyDataEditModels *)model;
//                    NSString *new;
//                    if (temp[index] && ![temp[index] isEqualToString:@""]) {
//                        new = [NSString stringWithFormat:@"%@,%@",temp[index],modelss.area_name];
//                    }
//                    else {
//                        new = modelss.area_name;
//                    }
//                    
//                    [temp replaceObjectAtIndex:index withObject:new];
//                    self.MyDataArray = [NSMutableArray arrayWithArray:temp];
//                    
//                    /// 修改数据上传
//                    NSString *newId;
//                    if (temp2[index] && ![temp2[index] isEqualToString:@""]) {
//                        newId = [NSString stringWithFormat:@"%@,%@",temp2[index],modelss.area_id];
//                    }
//                    else {
//                        newId = modelss.area_id;
//                    }
//                    [temp2 replaceObjectAtIndex:index withObject:newId];
//                }
//                else {
//                    MyDataEditModels * modelss = ( MyDataEditModels *)model;
//                    NSArray *pre = [temp[index] componentsSeparatedByString:@","];
//                    NSMutableArray *preS = [NSMutableArray arrayWithArray:pre];
//                    [preS replaceObjectAtIndex:seletedIndex withObject:modelss.area_name];
//                    NSString *new = [preS componentsJoinedByString:@","];
//                    [temp replaceObjectAtIndex:index withObject:new];
//                    self.MyDataArray = [NSMutableArray arrayWithArray:temp];
//                    
//                    /// 修改数据上传
//                    NSArray *preIDs = [temp2[index] componentsSeparatedByString:@","];
//                    NSMutableArray *preSIDS = [NSMutableArray arrayWithArray:preIDs];
//                    [preSIDS replaceObjectAtIndex:seletedIndex withObject:modelss.area_id];
//                    NSString *newId = [preSIDS componentsJoinedByString:@","];
//                    [temp2 replaceObjectAtIndex:index withObject:newId];
//                }
//                
//            }
//            else {
                MyDataEditModels * modelss = ( MyDataEditModels *)model;
                [temp replaceObjectAtIndex:index withObject:modelss.area_name];
                self.MyDataArray = [NSMutableArray arrayWithArray:temp];
                
                /// 修改数据上传
                [temp2 replaceObjectAtIndex:index withObject:modelss.area_id];
//            }
            
        }
        
        
        upLoadArray = [NSMutableArray arrayWithArray:temp2];
        
        [self.tableView reloadData];
    }
    
}
///  自定义section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 25)];
    view.backgroundColor = [UIColor colorWithString:@"d0d0d0" alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 11, 12)];
    imageView.image = [UIImage imageNamed:@"icon_donguri@2x"];
    [view addSubview:imageView];
    
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 + 11, 6, CON_WIDTH - 21, 12)];
    sectionTitle.font = FONT_SIZE_6(12.f);
    sectionTitle.textColor = [UIColor colorWithString:@"8f8f8f" alpha:1];
    [view addSubview:sectionTitle];
    switch (section) {
        case 0:
            sectionTitle.text = @"マイネーム";
            break;
        case 1:
            sectionTitle.text = @"Profile";
            break;
        case 2:
            sectionTitle.text = @"自己紹介";
            break;
            
        default:
            break;
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 2:
            return 20;
            break;
            
        default:
            return 0;
            break;
    }
}
#pragma mark -
#pragma mark textView 协议-方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"1");
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.MyDataArray setObject:textView.text atIndexedSubscript:13];
    NSLog(@"2");
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"3");
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.MyDataArray setObject:textView.text atIndexedSubscript:13];
    NSLog(@"4");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *selfAssessment = [NSString stringWithFormat:@"%@%@", textView.text, text];
    NSLog(@"自我评价===%@", selfAssessment);
    [self.MyDataArray setObject:selfAssessment atIndexedSubscript:13];//self.MyDataArray.count -1];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self.MyDataArray setObject:textView.text atIndexedSubscript:13];
    NSLog(@"5");
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    [self.MyDataArray setObject:textView.text atIndexedSubscript:13];
    NSLog(@"6");
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0)
{
    NSLog(@"7");
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0)
{
    NSLog(@"8");
    return YES;
}
#pragma mark -
#pragma mark alertView 协议-方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    switch (alertView.tag) {
//        case 20110 + 11:
//        {
//            NSString *contentStr = [alertView textFieldAtIndex:buttonIndex].text;
//            NSLog(@"alertContext1 = %@", contentStr);
//            NSString *content = [NSString stringWithFormat:@"%@ 人", contentStr];
//            [self.MyDataArray setObject:content atIndexedSubscript:11];
//        }
//            break;
//        case 20110 + 12:
//        {
//            NSString *contentStr = [alertView textFieldAtIndex:buttonIndex].text;
//            NSString *content = [NSString stringWithFormat:@"%@ いいね", contentStr];
//            [self.MyDataArray setObject:content atIndexedSubscript:12];
//            NSLog(@"alertContext2 = %@", contentStr);
//        }
//            break;
//            
//        default:
//            break;
//    }
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
