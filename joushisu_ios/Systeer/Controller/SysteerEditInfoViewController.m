//
//  SysteerEditInfoViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/25.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//
/*鸟-投稿*/

#import "SysteerEditInfoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "SystterInfoList.h"

@interface SysteerEditInfoViewController () <NADViewDelegate>
@property (nonatomic, strong)UILabel *lable;
@property (nonatomic, strong)NSString *picUrlString;
@property (nonatomic, strong)NADView *ADView;
@end

@implementation SysteerEditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UserModel *user = [UserModel unpackUserInfo];
//    if (!user) {
//        EnterController *enter = [[EnterController alloc] init];
//        AppDelegate *appdele = [UIApplication sharedApplication].delegate;
//        [appdele.navi presentViewController:enter animated:YES completion:^{
//            
//        }];
//        enter.comeBackBlock = ^(){
//            /// 不做登陆操作, 直接返回上一页
//            [self comeBack];
//        };
//
//    }
    self.NameLabel.text = user.user_name;
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_hitorigoto" titleName:@"シスッター-投稿"];
    CGPoint temp = view.center;
    temp.x -= 20;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width += 45;
    view.frame = tempSize;
    
    [self creatView];
    //添加广告
//    bannerView_ = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(CON_WIDTH, 50))
//                                                 origin:CGPointMake(
//                                                                    0,
//                                                                    CON_HEIGHT - 64
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

    //加菊花
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
//    [self.progress show:YES];
    [self.view addSubview:self.progress];

}

#pragma mark - NADViewの広告ロードが初めて成功した際に通知されます
- (void)nadViewDidFinishLoad:(NADView *)adView {
    _ADView.frame = CGRectMake(0, self.view.frame.size.height - _ADView.frame.size.height, self.view.frame.size.width, _ADView.frame.size.height);
}

- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_hitorigoto" titleName:@"シスッター"];
    CGPoint temp = view.center;
    temp.x += 20;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width -= 45;
    view.frame = tempSize;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)comeEditBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_hitorigoto" titleName:@"シスッター"];
    CGPoint temp = view.center;
    temp.x += 20;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width -= 45;
    view.frame = tempSize;
    self.refreshEditBlock();
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark 传进来判断
- (void)setModel:(SystterInfoList *)model
{
    if (_model != model) {
        _model = model;
    }
    self.textField.text = _model.content;
    self.picUrlString = _model.pic;
}
#pragma mark -
- (void)creatView
{
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, CON_WIDTH - 20, 160)];
    lineImage.image = [UIImage imageNamed:@"commentbox_r"];
    [self.view addSubview:lineImage];
    
    
    
    self.textField = [[UITextView alloc] initWithFrame:CGRectMake(15, 75, CON_WIDTH - 30 , 130)];
    self.textField.font = FONT_SIZE_6(17);
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
    self.lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 160 - 25, CON_WIDTH - 40, 20)];
    self.lable.textAlignment = NSTextAlignmentRight;
    self.lable.font = FONT_SIZE_6(14.f);
    self.lable.textColor = [UIColor colorWithString:@"a7aca9" alpha:1.f];
    self.lable.text = @"残り140文字";
    [lineImage addSubview:self.lable];
    
    //创建投稿按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_add_off@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(barButtonAction:)];
    
}
//回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/// 点击发送
- (void)barButtonAction:(UIBarButtonItem *)button
{
    if (self.postStr != nil ) {
        NSString *str = [NSString string];
        NSLog(@"%@", self.model);
        if (self.model) {
            str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerEditUrl];
            NSLog(@"编辑");
        } else {
            str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerAddUrl];
            NSLog(@"添加");
        }

        
//        NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerEditUrl];
        //传入的参数
        UserModel *user = [UserModel unpackUserInfo];
        [self.progress show:YES];
        NSLog(@"self.pic== %@", self.picUrlString);
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.postStr, @"content",user.user_id , @"user_id", nil];
        if (self.picUrlString && ![self.picUrlString isEqualToString:@""]) {
            [parameters setObject:self.picUrlString forKey:@"img"];
        }
        if (self.bird_id) {
            [parameters setObject:self.bird_id forKey:@"bird_id"];
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //  NSLog(@"%@", responseObject);
            [self.progress hide:YES];
            [self comeEditBack];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //  NSLog(@"%@", error);
        }];

    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"すみません" message:@"内容を入力してください" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    }
- (IBAction)postImage:(UIButton *)sender {
    //相册是可以用模拟器打开的
    UIImagePickerController *imapic = [[UIImagePickerController alloc] init];
    imapic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imapic.delegate = self;
    imapic.allowsEditing = YES;//yes时打开编辑
    [self presentViewController:imapic animated:YES completion:^{
        
    }];

}
//拍摄完成执行方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获得图片,和图片地址
    [self uploadingImage:info];
}
/// 上传图片获得URL接口
- (void)uploadingImage:(NSDictionary *)info
{
    //得到图片
    UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    //图片存入相册
    //    UIImageWriteToSavedPhotosAlbum(self.ima, nil, nil, nil);
    [self dismissViewControllerAnimated:YES completion:^{
        // 选完图片返回
    }];
    //选择完图片进行网络请求 获得图片地址
    NSData *data = [[NSData alloc] init];
    data = UIImageJPEGRepresentation(image, 0.3);
    //    data = UIImagePNGRepresentation(self.image);
    // NSLog(@"=====%@", data);
    
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerPostImageUrl];
    //传入的参数
    NSDictionary *parameters = @{@"file_path":data};
    [self.progress show:YES];
    
    __weak SysteerEditInfoViewController *systomoGropAddVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file_path" fileName:@"photo.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"上传图片结果========%@", responseObject);
        NSString *result = [responseObject objectForKey:@"result"];
        if (result == 0) {
            return;
        }
        else {
            NSMutableDictionary *dic = [responseObject objectForKey:@"data"];
            systomoGropAddVC.picUrlString = [dic objectForKey:@"url"];
        }
        NSLog(@"上传图片URL=====%@", self.picUrlString);
        [self.progress hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取图片URL未遂==%@", error);
        NSLog(@"operation =====%@", operation.responseString);
        [self.progress hide:YES];
        
    }];
    
}

////当选择一张图片后进入
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    //当选择的类型是图片
//    if ([type isEqualToString:@"public.image"]) {
//        //先把图片转成2进制
//        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        self.imageData = [NSData data];
//        if (UIImagePNGRepresentation(image) == nil) {
//            self.imageData = UIImageJPEGRepresentation(image, 0.3);
//        }
//        else {
//            self.imageData = UIImagePNGRepresentation(image);
//        }
// 
//    }
//}
//取消上传图片方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *string = [NSString stringWithFormat:@"%@%@", textView.text, text];
    self.lable.text = [NSString stringWithFormat:@"残り%ld文字", (long)(140 - string.length)];
    if (string.length > 140) {
        return NO;
    }
    
    return YES;    
    
}
//将要结束编辑
- (void)textViewDidChange:(UITextView *)textView
{
    self.postStr = textView.text;
    
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
