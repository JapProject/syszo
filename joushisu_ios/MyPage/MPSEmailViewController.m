//
//  MPSEmailViewController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MPSEmailViewController.h"

#import "MPSEditTitleCell.h"
#import "MPSTextFCell.h"

/****修改密码****/

@interface MPSEmailViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, NADViewDelegate> {
    UITextField *newMailTextfield;
}

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *titleArray;
@property (nonatomic, strong)NSMutableArray *titleArray1;

/// 现密码
@property (nonatomic, strong)NSString *oldPassWord;
/// 新密码
@property (nonatomic, strong)NSString *nePassWord;
/// 新密码(重复)
@property (nonatomic, strong)NSString *nePassWord2;

@property (nonatomic, strong)UserModel *user;

@property (nonatomic, strong) NADView *ADView;

@end

@implementation MPSEmailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [UserModel unpackUserInfo];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_save_off"] style:UIBarButtonItemStylePlain target:self action:@selector(saveBarButtonAction:)];

    self.titleArray = [NSMutableArray arrayWithObjects:@"現在のメールアドレス:", nil];
    self.titleArray1 = [NSMutableArray arrayWithObjects:@"新しいメールアドレス:", nil];
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

}

#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height);
}
- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 修改密码
- (void)saveBarButtonAction:(UIBarButtonItem *)sender
{
    [newMailTextfield resignFirstResponder];
    if (newMailTextfield.text && ![newMailTextfield.text isEqualToString:@""]) {
        [self creatDataWithUser_id:self.user.user_id newmaile:newMailTextfield.text];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"内容を入力してください" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
}

- (void)creatDataWithUser_id:(NSString *)user_id newmaile:(NSString *)newmail
{
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,MyPageEdit];
    //传入的参数
    NSDictionary *parameters = @{@"user_id":user_id,@"user_email":newmail};
    //    NSLog(@"网络请求里面的type:%@, page:%@", type, page);
    __weak MPSEmailViewController *chieVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"1"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"パスワードを変更しました" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            alertView.tag = 20499;
            [alertView show];
            
            return;
        } else {
            NSString *errer = [responseObject objectForKey:@"msg"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errer delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 20499) {
        
        UserModel *user = [UserModel unpackUserInfo];
        user.user_email = newMailTextfield.text;
        [self deleteDocumentFile];
        [self deleteTmpFile];
        [self saveUserInfo:user];
        [self comeBack];
    }
}

+ (BOOL)saveUserInfo:(UserModel *)userInfo {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths lastObject];
    NSString *userInfoPath = [documentPath stringByAppendingPathComponent:@"userInfo.xml"];
    
    NSString *path2 = NSTemporaryDirectory();
    NSString *userInfoPath2 = [path2 stringByAppendingPathComponent:@"userInfo.xml"];
    // 归档类 将一个实现了NSCoding协议的对象 写入本地
    BOOL result = [NSKeyedArchiver archiveRootObject:userInfo toFile:userInfoPath];
    NSLog(@"用户信息存入:%d 地址---%@", result, userInfoPath);
    result = [NSKeyedArchiver archiveRootObject:userInfo toFile:userInfoPath2];
    return result;
}
/// 归档方法
- (BOOL)saveUserInfo:(UserModel *)userInfo
{
    NSString *path = [NSString string];

    NSString *tmpDir = NSTemporaryDirectory();
    path = tmpDir;
    
    NSString *userInfoPath = [path stringByAppendingPathComponent:@"userInfo.xml"];
    // 归档类 将一个实现了NSCoding协议的对象 写入本地
    BOOL result = [NSKeyedArchiver archiveRootObject:userInfo toFile:userInfoPath];
    NSLog(@"用户信息存入:%d 地址---%@", result, userInfoPath);
    return result;
}
/// 删除Document文件(归档)
-(void)deleteDocumentFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths lastObject];
    //文件名
    NSString *uniquePath = [documentPath stringByAppendingPathComponent:@"userInfo.xml"];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"document没找到文件");
        return ;
    }else {
        NSLog(@" document找到文件");
        
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}
/// 删除临时文件(归档)
-(void)deleteTmpFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    // 临时文件名
    NSString *path2 = NSTemporaryDirectory();
    NSString *uniquePath2 = [path2 stringByAppendingPathComponent:@"userInfo.xml"];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath2];
    if (!blHave) {
        NSLog(@"tmp没找到文件");
        return ;
    }else {
        NSLog(@" tmp找到文件");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath2 error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}

#pragma mark 创建视图
- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark tabelView协议
///  section 个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}
/// section 背景图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    return backView;
}
/// section 高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    return 20;
}
///  每个section里的row的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
            
        default:
            return 0;
            break;
    }
}
///  返回tableView里的cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            static NSString *string = @"AccountEditTitle";
            MPSEditTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[MPSEditTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.formail = YES;
            cell.maileLabel.text = self.user.user_email;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = self.titleArray[indexPath.section];
            return cell;
        }
            break;
                    
        default:
        {
            static NSString *string = @"AccountEditText";
            MPSTextFCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[MPSTextFCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.formail= YES;
            cell.textField.delegate = self;
            newMailTextfield = cell.textField;
            cell.textField.tag = 23840 + (indexPath.row * (indexPath.section + 1));
            cell.passWordTitle.text = self.titleArray1[indexPath.row - 1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
    }
}
/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// tableView设置Cell的格式 方框
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        
        CGFloat cornerRadius = 5.f;
        cell.backgroundColor = [UIColor clearColor];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
        // 一般要－20
        bounds.size.width = CON_WIDTH - 20;
        
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        } else if (indexPath.row  == 0) {
            
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
        layer.strokeColor = [UIColor colorWithString:@"76be9d" alpha:1.f].CGColor;
        
        if (addLine == YES) {
            
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
    
}
#pragma mark -
#pragma mark 输入框要执行的协议
/// 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    [self.view endEditing:YES];
}
/// 键盘弹出
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
//    NSLog(@"%@", info);
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.tableView setCenter:CGPointMake(self.view.center.x, self.view.center.y - keyboardSize.height)];
        //  NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    }];
}
/// 键盘收回
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.tableView setFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height)];
    }];
}
/// 即将开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    

}


/// 点击“完成”时，执行的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
/// 点击联想的时候出发
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
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
