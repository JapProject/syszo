//
//  SystomoGropEditViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/13.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "SystomoGropEditViewController.h"
#import "SystomoGropEditHeaderView.h"
#import "FirendCell.h"
#import "SystomoAddPeopleViewController.h" // 替代GropEditPeopleListViewController
#import "SystomoSearch.h"
#import "UIButton+WebCache.h"
@interface SystomoGropEditViewController () <UITableViewDelegate, UITableViewDataSource, NADViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    SystomoGropEditHeaderView *EditHeader;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
        @property (assign, nonatomic) BOOL comYes;
@property (nonatomic, strong) NADView *ADView;
@property (nonatomic ,strong) UIButton *deleteImageButton;
@property (nonatomic, strong) UIImage *ima;
//        self.comYes = YES;
//
//        if (self.comYes ) {
//            return;
//        }
@end

@implementation SystomoGropEditViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tableArr = [[NSMutableArray alloc] init];
        //选择标识
        self.page = 2;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_systomo" titleName:@"メンバー"];
    CGPoint temp = view.center;
    temp.x -= 0;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width += 20;
    view.frame = tempSize;
    
    //创建保存按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_save_off"] style:UIBarButtonItemStyleDone target:self action:@selector(barSaveAction:)];
    
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
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT-_ADView.frame.size.height);
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


- (void)setModel:(SystomoList *)model
{
    if (_model != model) {
        _model = model;
    }
    [self creatView];
    [self creatDataWithGroup_id:model.group_id];
//  NSLog(@"%@========", model.member_name);
}
- (void)creatDataWithGroup_id:(NSString *)group_id
{
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SystomoGroup_read];
    //传入的参数
    NSDictionary *parameters = @{@"group_id":group_id, @"p_num":@"1", @"p_size":@"500"};
    
    __weak SystomoGropEditViewController *EditVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
        if ([tempArr isEqual:@""]) {
            return;
        }
        for (NSDictionary *dic in tempArr) {
            SystomoSearch *model = [[SystomoSearch alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [EditVC.tableArr addObject:model];
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];

}

- (void)deleteImage {
    [EditHeader.gropImageView setImage:[UIImage imageNamed:@"group_waku_mini"] forState:UIControlStateNormal];
    self.model.group_img = nil;
    [self.deleteImageButton removeFromSuperview];
}



- (void)creatView
{
     EditHeader = [[SystomoGropEditHeaderView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, 160)];
    [EditHeader.gropImageView setImageWithURL:[NSURL URLWithString:self.model.group_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"group_waku_mini"]];
    if (self.model.group_img && ![self.model.group_img isEqualToString:@""]) {
        self.deleteImageButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteImageButton  setTitle:@"x" forState:UIControlStateNormal];
        self.deleteImageButton .frame = CGRectMake(75, 2, 24, 24);
        self.deleteImageButton .backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.8];
        self.deleteImageButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);
        [self.deleteImageButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        self.deleteImageButton .layer.cornerRadius = 12;
        [EditHeader addSubview:self.deleteImageButton];
    }
    
    EditHeader.gropNameLabel.text = self.model.group_name;
    __block SystomoGropEditViewController *groupEdit = self;
    //点击追加

    EditHeader.addPeopleAction = ^(){
        SystomoAddPeopleViewController *addPeopleVC = [[SystomoAddPeopleViewController alloc] init];
        addPeopleVC.friendArray = groupEdit.tableArr;
        addPeopleVC.MyFriendsBlock = ^(NSMutableArray *selectFriend){
            
            for (SystomoList * model in selectFriend) {
                NSLog(@"被选召的孩子们==%@", model.member_name);
            }
            groupEdit.tableArr = [NSMutableArray arrayWithArray:selectFriend];
            NSLog(@"选择好友后的数据数组:%@", groupEdit.tableArr);
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:addPeopleVC animated:YES];
        
    };
    
    EditHeader.gropChangeImageAction = ^() {
        [groupEdit postImageView];
    };
    
    EditHeader.leaveAction = ^(){
        NSLog(@"点击退会");
        UserModel *user = [UserModel unpackUserInfo];
        [self leaveGroupWithGroup_id:self.model.group_id user_id:user.user_id];
    };
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT-_ADView.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //除去线
    self.tableView.separatorStyle = NO;
    self.tableView.tableHeaderView = EditHeader;
    [self.view addSubview:self.tableView];

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"SystomoGropEditCell";
    FirendCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (!cell) {
        cell = [[FirendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SystomoList *model = self.tableArr[indexPath.row];
    cell.titleLabel.text = model.member_name;
    cell.userImage.image = [UIImage imageNamed:@"icon_follow"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

//保存按钮
- (void)barSaveAction:(UIBarButtonItem *)button
{
    NSLog(@"点击保存");
    
    //添加参数++++++++++++++++++群id 群名称 用户id 群头像 用户添加成员id 用户删除成员id
    
    NSString *str = [NSString stringWithFormat:@"%@%@",TiTleUrl,SystomoEditGroup];
    //传入的参数
    UserModel *user = [UserModel unpackUserInfo];

    NSMutableArray *array = [NSMutableArray array];
    for (SystomoList * model in self.tableArr) {
        [array addObject:model.member_id];
        NSLog(@"被选召的孩子们==%@", model.member_name);
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str1 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters;
    if (self.model.group_img) {
        parameters = @{@"group_id":self.model.group_id,@"group_name":self.model.group_name,@"user_id":user.user_id,@"group_img":self.model.group_img,@"aid_type":str1};
    }
    else {
        parameters = @{@"group_id":self.model.group_id,@"group_name":self.model.group_name,@"user_id":user.user_id,@"group_img":@"",@"aid_type":str1};
    }
    //    __weak SystomoGropEditViewController *systomoGropVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
    [self comeBack];
}
//点击退会
- (void)leaveGroupWithGroup_id:(NSString *)group_id user_id:(NSString *)user_id
{
    //添加参数++++++++++++++++++++++++++群id 成员id
    
    NSString *str = [NSString stringWithFormat:@"%@%@",TiTleUrl,SystomoDelGroup];
    //传入的参数
    NSDictionary *parameters = @{@"group_id":group_id,@"member_id":user_id};
//    __weak SystomoGropEditViewController *systomoGropVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self comeBack];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
  
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
    [EditHeader.gropImageView setImage:self.ima forState:UIControlStateNormal];
    if (!self.deleteImageButton) {
        self.deleteImageButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteImageButton  setTitle:@"x" forState:UIControlStateNormal];
        self.deleteImageButton .frame = CGRectMake(75, 2, 24, 24);
        self.deleteImageButton .backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.8];
        self.deleteImageButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);
        [self.deleteImageButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        self.deleteImageButton .layer.cornerRadius = 12;
        [EditHeader addSubview:self.deleteImageButton];
    }
    else {
        [EditHeader addSubview:self.deleteImageButton];
    }
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
    
    __weak SystomoGropEditViewController *systomoGropAddVC = self;
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
            systomoGropAddVC.model.group_img = [dic objectForKey:@"url"];
        }
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
