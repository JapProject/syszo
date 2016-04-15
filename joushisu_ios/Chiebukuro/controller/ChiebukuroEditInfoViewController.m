//
//  ChiebukuroEditInfoViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/4/27.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "ChiebukuroEditInfoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "ChiebukuroView.h"
#import "QHeaderModel.h"


@interface ChiebukuroEditInfoViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)NSString *picUrlString;
@property (nonatomic, strong)UILabel *lable;
@property (nonatomic, strong)UIButton *urgencybutton;
        @property (assign, nonatomic) BOOL comYes;

@end

@implementation ChiebukuroEditInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        self.urgent = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋"];
    CGPoint temp = view.center;
    temp.x -= 45;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width += 70;
    view.frame = tempSize;
    
//    self.urgent = 0;
    
//    UserModel *user = [UserModel unpackUserInfo];
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
    
    [self creatView];
    
    //加菊花
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    //    [self.progress show:YES];
    [self.view addSubview:self.progress];
    [self.view bringSubviewToFront:self.progress];
    
}
- (void)comeBack
{
    NavbarView *view = [NavbarView sharedInstance];
    [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋"];
    CGPoint temp = view.center;
    temp.x += 45;
    view.center = temp;
    CGRect tempSize = view.frame;
    tempSize.size.width -= 70;
    view.frame = tempSize;
    //        @property (assign, nonatomic) BOOL comYes;
            self.comYes = YES;
    //
    //        if (self.comYes ) {
    //            return;
    //        }
    [self.navigationController popViewControllerAnimated:YES];
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
        [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋"];
        CGPoint temp = view.center;
        temp.x += 45;
        view.center = temp;
        CGRect tempSize = view.frame;
        tempSize.size.width -= 70;
        view.frame = tempSize;
        NSLog(@"返回");
    }
}



- (void)comeEditBack
{
//    NavbarView *view = [NavbarView sharedInstance];
//    [view setTitleImage:@"micon_chiebukuro" titleName:@"知恵袋"];
//    CGPoint temp = view.center;
//    temp.x += 45;
//    view.center = temp;
//    CGRect tempSize = view.frame;
//    tempSize.size.width -= 70;
//    view.frame = tempSize;
    self.refreshEditBlock();
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)creatView
{
    
    //创建送信按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_send_off@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(barButtonAction:)];

    UILabel *quLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 120, 30)];
    quLabel.text = @"タイトル";
    quLabel.font = FONT_SIZE_6(17.f);
    [self.view addSubview:quLabel];
    
    UIImageView *lineQuImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, CON_WIDTH - 20, 30)];
    lineQuImage.image = [UIImage imageNamed:@"textbox"];
    [self.view addSubview:lineQuImage];
    
    self.quText = [[UITextField alloc] initWithFrame:CGRectMake(12, 62, CON_WIDTH - 22, 28)];
    self.quText.placeholder = @"残り25文字";
//    self.quText.text.length < 25;
    self.quText.delegate = self;
    self.quText.font = FONT_SIZE_6(16.f);
    [self.view addSubview:self.quText];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, CON_WIDTH, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    UILabel *awLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, 120, 30)];
    awLabel.text = @"投稿内容";
    awLabel.font = FONT_SIZE_6(17.f);
    [self.view addSubview:awLabel];
    
    
    UIImageView *lineAwImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 155, CON_WIDTH - 20, 120)];
    lineAwImage.image = [UIImage imageNamed:@"commentbox"];
    [self.view addSubview:lineAwImage];
    
    self.awText = [[UITextView alloc] initWithFrame:CGRectMake(15, 160, CON_WIDTH - 30, 90)];
    self.awText.font = FONT_SIZE_6(16.f);
    self.awText.delegate = self;
    [self.view addSubview:self.awText];
    
    self.lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 120 - 25, CON_WIDTH - 40, 20)];
    self.lable.textAlignment = NSTextAlignmentRight;
    self.lable.font = FONT_SIZE_6(14.f);
    self.lable.textColor = [UIColor colorWithString:@"a7aca9" alpha:1.f];
    self.lable.text = @"残り1000文字";
    [lineAwImage addSubview:self.lable];
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, 290, CON_WIDTH, 1)];
    line2View.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2View];
    
    UILabel *poLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 305, 120, 30)];
    poLabel.text = @"マルチメディア";
    poLabel.font = FONT_SIZE_6(17.f);
    [self.view addSubview:poLabel];
    
    UIButton *poImagebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    poImagebutton.frame = CGRectMake(10, 340, 140, 30);
    [poImagebutton setBackgroundImage:[UIImage imageNamed:@"btn_upload_g"] forState:UIControlStateNormal];
    [poImagebutton addTarget:self action:@selector(poImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:poImagebutton];
    
    UILabel *ImgLabel = [[UILabel alloc] initWithFrame:CGRectMake(161, 340, 150, 30)];
    ImgLabel.text = @"2MBまでのJPEG画像";
    ImgLabel.textColor = [UIColor grayColor];
    ImgLabel.font = FONT_SIZE_6(14.f);
    [self.view addSubview:ImgLabel];
    
    UIView *line3View = [[UIView alloc] initWithFrame:CGRectMake(0, 390, CON_WIDTH, 1)];
    line3View.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line3View];
    
    self.urgencybutton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.urgencybutton.frame = CGRectMake(10, 410, 50, 50);

    [self.urgencybutton setBackgroundImage:[UIImage imageNamed:@"icon_nocheck"] forState:UIControlStateNormal];

    [self.urgencybutton addTarget:self action:@selector(urgencyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.urgencybutton];
    
    
    UIImageView *errImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 410, 180, 50)];
    errImage.image = [UIImage imageNamed:@"cautiontext"];
    [self.view addSubview:errImage];
    
    
}

- (void)setModel:(QHeaderModel *)model
{
    if (_model != model) {
        _model = model;
    }
    self.quText.text = _model.title;
    self.awText.text = _model.content;
    self.picUrlString = _model.info_img;
    if (self.urgent == 0) {
        [self.urgencybutton setBackgroundImage:[UIImage imageNamed:@"icon_nocheck"] forState:UIControlStateNormal];
    }
    if (self.urgent == 1) {
        [self.urgencybutton setBackgroundImage:[UIImage imageNamed:@"icon_checked"] forState:UIControlStateNormal];
        
    }
}

//点击回车收回键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *string = [NSString stringWithFormat:@"%@%@", textView.text, text];
    self.lable.text = [NSString stringWithFormat:@"残り%ld文字", (long)(1000 - string.length)];
    if (string.length > 1000) {
        return NO;
    }
    
    return YES;
    
}
//将要结束编辑
- (void)textViewDidChange:(UITextView *)textView
{
    self.awStr = textView.text;
    
}
#pragma mark 选择图片并上传
//选择图片
- (void)poImageButton:(UIButton *)button
{
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
    
    __weak ChiebukuroEditInfoViewController *systomoGropAddVC = self;
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
//点击是否加急
- (void)urgencyButton:(UIButton *)button
{
    if (self.urgent == 0) {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_checked"] forState:UIControlStateNormal];
    }
    if (self.urgent == 1) {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_nocheck"] forState:UIControlStateNormal];

    }
    self.urgent = !self.urgent;
//    NSLog(@"%d", self.urgent);
}

//点击送信按钮
- (void)barButtonAction:(UIBarButtonItem *)button
{
    UserModel *user = [UserModel unpackUserInfo];
    if (!user) {
        EnterController *enter = [[EnterController alloc] init];
        [self presentViewController:enter animated:YES completion:^{
            
        }];
        enter.comeBackBlock = ^(){
            /// 送不出信,不做任何操作
        };
        return;
    }
    NSLog(@"user_id == %@", user.user_id);
    self.quStr =  self.quText.text;
    self.awStr = self.awText.text;
    if (![self.quStr isEqualToString:@""] && ![self.awStr isEqualToString:@""]) {
        [self.progress show:YES];
        NSString *str = [NSString string];
        NSLog(@"%@", self.model);
        if (self.model) {
            str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroEditUrl];
            NSLog(@"编辑");
        } else {
            str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChiebukuroAddUrl];
            NSLog(@"添加");
        }
        //传入的参数
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:user.user_id, @"user_id", self.quStr, @"title",self.awStr, @"content", [NSString stringWithFormat:@"%d", self.urgent + 1],@"urgent", nil];
        if (self.picUrlString && ![self.picUrlString isEqualToString:@""]) {
            [parameters setObject:self.picUrlString forKey:@"img"];
        }
        if (self.know_id) {
            [parameters setObject:self.know_id forKey:@"know_id"];
        }
        NSLog(@"picUrlString==%@", self.picUrlString);

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.progress hide:YES];
            [self comeEditBack];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"すみません" message:@"タイトルと内容を入力してください" delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil, nil];
        [alertView show];
    }


}
//回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
/// 限制25字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (str.length > 25) {
        return NO;
    }
    return YES;
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
