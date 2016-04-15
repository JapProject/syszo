//
//  SystomoGropAddViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoGropAddViewController.h"
#import "SystomoGropHeaderView.h"
#import "FirendCell.h"
#import "SystomoAddPeopleViewController.h"
#import "SystomoList.h" //model
#import "SystomoSearchViewController.h" /// 判断上级页面
#import "SystomoViewController.h"
#import "MessageViewController.h"
@interface SystomoGropAddViewController () <UITableViewDataSource, UITableViewDelegate, NADViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *imageView;
//用于接图片的
@property (nonatomic, strong) UIImage *ima;
//用来接图片地址
@property (nonatomic, strong) NSString *photoUrl;
//用于接编辑群名字的
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) SystomoGropHeaderView *gropHeader;
@property (nonatomic, strong) NADView *ADView;
@property (nonatomic, strong) UIButton *deleteImageButton;
        @property (assign, nonatomic) BOOL comYes;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation SystomoGropAddViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_systomo" titleName:@"グループ作成"];
    CGPoint temp = view.center;
    temp.x -= 0;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width += 20;
    view.frame = tempSize;
    
    //创建保存按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_save_off"] style:UIBarButtonItemStyleDone target:self action:@selector(barButtonAction:)];
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
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT -_ADView.frame.size.height);
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
    NSArray *arrTap = self.navigationController.viewControllers;
    if ([[arrTap objectAtIndex:arrTap.count - 2] isKindOfClass:[SystomoSearchViewController class]]) {
        [view setTitleImage:@"micon_systomo" titleName:@"シストモ検索"];

        CGRect tempSize = view.frame;
        tempSize.size.width -= 0;
        view.frame = tempSize;
     
        [self.navigationController popViewControllerAnimated:YES];
        self.refreshBlock();
        return;
    }
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
        NSArray *arrTap = self.navigationController.viewControllers;
        if ([[arrTap objectAtIndex:arrTap.count - 2] isKindOfClass:[SystomoSearchViewController class]]) {
            [view setTitleImage:@"micon_systomo" titleName:@"シストモ検索"];
            
            CGRect tempSize = view.frame;
            tempSize.size.width -= 0;
            view.frame = tempSize;
            self.refreshBlock();
            return;
        }
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
    self.gropHeader = [[SystomoGropHeaderView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 160)];
    self.gropHeader.gropNameTextField.placeholder = @"グループ名";
    __block SystomoGropAddViewController *systomoVC = self;
    //点击替换图片
    self.gropHeader.gropChangeImageAction = ^(){
        [systomoVC postImageView];
    };
    //点击追加
    self.gropHeader.addPeopleAction = ^(){
        NSLog(@"点击追加");
        
        SystomoAddPeopleViewController *AddPeopleVC = [[SystomoAddPeopleViewController alloc] init];
        AddPeopleVC.friendArray = systomoVC.dataArray;
        AddPeopleVC.MyFriendsBlock = ^(NSMutableArray *selectFriend){
            
            for (SystomoList * model in selectFriend) {
                NSLog(@"被选召的孩子们==%@", model.member_name);
            }
            systomoVC.dataArray = [NSMutableArray arrayWithArray:selectFriend];
            NSLog(@"选择好友后的数据数组:%@", systomoVC.dataArray);
            [systomoVC.tableView reloadData];
            
        };
        [systomoVC.navigationController pushViewController:AddPeopleVC animated:YES];
        
    };
    
    //有个界面需要用到 ，不用的话block里面不写就行
    [self.gropHeader.gropBtn setBackgroundImage:[UIImage imageNamed:@"groupphoto"] forState:UIControlStateNormal];


    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT-_ADView.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //除去线
    self.tableView.separatorStyle = NO;
    self.tableView.tableHeaderView = self.gropHeader;
    [self.view addSubview:self.tableView];

    self.deleteImageButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteImageButton  setTitle:@"x" forState:UIControlStateNormal];
    self.deleteImageButton .frame = CGRectMake(75, 2, 24, 24);
    self.deleteImageButton .backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.8];
    self.deleteImageButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);
    [self.deleteImageButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    self.deleteImageButton .layer.cornerRadius = 12;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"SystomoGropCell";
    FirendCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (!cell) {
        cell = [[FirendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.userImage.image = [UIImage imageNamed:@"icon_group"];
    SystomoList *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.member_name;
    cell.userImage.image = [UIImage imageNamed:@"icon_follow"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}
- (void)barButtonAction:(UIButton *)button
{
    NSLog(@"保存时走的网络请求");
    self.groupName = self.gropHeader.gropNameTextField.text;
    
    if (![self.groupName isEqualToString:@""]) {
        NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SystomoGropAddUrl];
    //点击保存时候补全参数++++++++++++++++++++++++++++++++
        UserModel *user = [UserModel unpackUserInfo];
        NSMutableArray *array = [NSMutableArray array];
        for (SystomoList * model in self.dataArray) {
            [array addObject:model.member_id];
//            NSLog(@"被选召的孩子们==%@", model.member_name);
        }
        NSDictionary *parameters = [NSDictionary dictionary];
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str1);
        NSLog(@"%@", array);
        if (self.photoUrl != nil) {
            parameters = @{@"group_name":self.groupName,@"user_id":user.user_id,@"group_img":self.photoUrl, @"member_id": str1};
        } else {
            parameters = @{@"group_name":self.groupName,@"user_id":user.user_id, @"member_id": str1};
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"====%@", responseObject);

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"新建群%@", error);
            NSLog ( @"operation: %@" , operation.responseString);
            
        }];
//        [self comeBack];
        [self returnViewController];
        
//        NavbarView *view = [NavbarView sharedInstance];
//        [view setTitleImage:@"micon_systomo" titleName:@"シストモ"];
//        CGPoint temp = view.center;
//        temp.x -= 0;
//        view.center = temp;
//        
//        CGRect tempSize = view.frame;
//        tempSize.size.width -= 20;
//        view.frame = tempSize;
//        MessageViewController *systomViews = [[MessageViewController alloc] init];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"通知" object:nil userInfo:nil];
//
//        [self.navigationController popToViewController:systomViews animated:YES];
        


    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"すみません" message:@"内容を入力してください" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

- (void)returnViewController{
    
    
    NavbarView *view = [NavbarView sharedInstance];

    [view setTitleImage:@"micon_systomo" titleName:@"シストモ"];
    CGPoint temp = view.center;
    temp.x -= 10;
    view.center = temp;
    
    CGRect tempSize = view.frame;
    tempSize.size.width -= 0;
    view.frame = tempSize;
    

    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[SystomoViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
      [[NSNotificationCenter defaultCenter] postNotificationName:@"通知" object:nil userInfo:nil];
    
}

//回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)postImageView
{
    //相册是可以用模拟器打开的
    UIImagePickerController *imapic = [[UIImagePickerController alloc] init];
    imapic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imapic.delegate = self;
    imapic.allowsEditing = NO;//yes时打开编辑
    [self presentViewController:imapic animated:YES completion:^{
        
    }];

}

- (void)setPhotoUrl:(NSString *)photoUrl {
    _photoUrl = photoUrl;
    if (photoUrl && ![photoUrl isEqualToString:@""]) {
        [self.gropHeader addSubview:self.deleteImageButton];
    }
    else {
        [self.deleteImageButton removeFromSuperview];
        [self.gropHeader.gropBtn setBackgroundImage:[UIImage imageNamed:@"groupphoto"] forState:UIControlStateNormal];
    }
}

- (void)deleteImage {
    self.photoUrl = nil;
}

//点击Cancela按钮执行方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//拍摄完成执行方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    self.ima = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
//    //图片存入相册
//    UIImageWriteToSavedPhotosAlbum(self.ima, nil, nil, nil);
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.gropHeader.gropBtn setBackgroundImage:self.ima forState:UIControlStateNormal];
    
    //加菊花
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    [self.progress show:YES];
    [self.view addSubview:self.progress];
    
    //选择完图片进行网络请求 获得图片地址
    NSData *data = [[NSData alloc] init];
//    data = UIImagePNGRepresentation(self.ima);
    data = UIImageJPEGRepresentation(self.ima, 0.3);
//    NSLog(@"=====%@", data);

    
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerPostImageUrl];
    //传入的参数
    NSDictionary *parameters = @{@"file_path":data};
    
    __weak SystomoGropAddViewController *systomoGropAddVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:data name:@"file_path" fileName:@"photo.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
     //   NSLog(@"========%@", responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        if (result == 0) {
            return;
        }
        else {
            NSMutableDictionary *dic = [responseObject objectForKey:@"data"];
            systomoGropAddVC.photoUrl = [dic objectForKey:@"url"];
        }
        NSLog(@"=====%@", self.photoUrl);
        [self.progress hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取图片字符串%@", error);
        NSLog ( @"operation: %@" , operation.responseString);

    }];
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
