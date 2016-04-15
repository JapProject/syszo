//
//  ChatViewController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/21.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "ChatViewController.h"
#import "APService.h"
#import "ChatModel.h"
#import "ChatLeftImageCell.h"
#import "ChatLeftStringCell.h"
#import "ChatRightImageCell.h"
#import "ChatRightStringCell.h"
#import "ImageShowViewController.h"

#import "ModalMessageViewController.h"

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, AppDelegateViewControllerDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UIView *sendView;
@property (nonatomic, strong)UIButton *picMessenger;
@property (nonatomic, strong)UITextView *send;
@property (nonatomic, strong)UIButton *messenger;
@property (nonatomic, strong)NSString *postEmall;
@property (nonatomic, assign)NSInteger page;

// 上传图片
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSString *picUrlString;

@end

@implementation ChatViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dataArray = [[NSMutableArray alloc] init];
        self.page = 2;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //获取即时通讯对方信息
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    appdele.infoDelegate = self;
    
    [super viewWillDisappear:animated];
}
- (void)passValue:(NSDictionary *)dic
{
    
    NSLog(@"传聊天消息+++++++\n dic ==== %@", dic);
    //    ChatModel *model = [[ChatModel alloc] init];
    //    [model setValuesForKeysWithDictionary:dic];
    //    [self.dataArray addObject:model];
    /// 改成网络请求刷新列表
    
    NSString *rec_id = [dic valueForKey:@"user_id"];
    if ([self.member_id isEqualToString:rec_id]) {
        /// 判断推送的是否是当前消息
        [self.dataArray removeAllObjects];
        [self PostMessageWithMember_id:self.member_id page:@"1"];
        [self.tableView reloadData];
    }
    
    
}

- (void)setMember_id:(NSString *)member_id
{
    if (_member_id != member_id) {
        _member_id = member_id;
    }
    [self createSend];
    [self createTableView];
    NSLog(@"member:%@", self.member_id);
    [self PostMessageWithMember_id:self.member_id page:@"1"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self createSend];
    //    [self createTableView];
    // 注册两个通知来监听键盘高度变化
    // 键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘收回
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)comeBack
{
    NSArray *arrTap = self.navigationController.viewControllers;
    if ([[arrTap objectAtIndex:arrTap.count - 2] isKindOfClass:[ModalMessageViewController class]]) {
        [self.navigationController.navigationBar setHidden:YES];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createTableView
{
    if ([self.previousPage isEqualToString:@"modalMessage"]) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 44) style:(UITableViewStylePlain)];
    } else {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 - 44) style:(UITableViewStylePlain)];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.view sendSubviewToBack:self.tableView];
    
    // 集成刷新控件
    [self setupRefresh];
}
- (void)createSend
{
    if ([self.previousPage isEqualToString:@"modalMessage"]) {
        self.sendView = [[UIView alloc] initWithFrame:CGRectMake(0, CON_HEIGHT - 44, CON_WIDTH, 44)];
    } else {
        self.sendView = [[UIView alloc] initWithFrame:CGRectMake(0, CON_HEIGHT - 44 - 64, CON_WIDTH, 44)];
    }
    self.sendView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.sendView];
    [self.view bringSubviewToFront:self.sendView];
    
    self.picMessenger = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.picMessenger.frame = CGRectMake(5, 5, 50, 30);
    [self.picMessenger setBackgroundImage:[UIImage imageNamed:@"groupphoto"] forState:UIControlStateNormal];
    [self.picMessenger addTarget:self action:@selector(sendPicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendView addSubview:self.picMessenger];
    
    self.send = [[UITextView alloc] initWithFrame:CGRectMake(60, 5, CON_WIDTH - 80 - 55, 30)];
    //    self.send.keyboardType = UITextBorderStyleRoundedRect;
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
    [self.messenger addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendView addSubview:self.messenger];
    
}



//一旦有消息 走这方法
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    //      NSLog(@"%@00000", notification);
    
}

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
    UserModel *user = [UserModel unpackUserInfo];
    ChatModel *model = [self.dataArray objectAtIndex:indexPath.row];
    //isMy 是2是别人发的 1是自己发的
    if (![model.user_id isEqualToString:user.user_id]) {
        //隔壁老王发内容
        // 图片
        if ([model.info_content isEqualToString:@""] && ![model.info_img isEqualToString:@""]) {
            static NSString *othersImage = @"othersImage";
            ChatLeftImageCell *cell = [tableView dequeueReusableCellWithIdentifier:othersImage];
            if (!cell) {
                cell = [[ChatLeftImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:othersImage];
            }
            cell.clickImageBlock = ^(){
                [self clickImageWithUrl:model.info_img];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //给内容赋值
            cell.name.text = model.uname;
            [cell.myImageView setImageWithURL:[NSURL URLWithString:model.info_img]];
            return cell;
            
        } else {
            // 字符串
            static NSString *othersString = @"othersString";
            ChatLeftStringCell *cell = [tableView dequeueReusableCellWithIdentifier:othersString];
            if (!cell) {
                cell = [[ChatLeftStringCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:othersString];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //给内容赋值
            cell.model = [self.dataArray objectAtIndex:indexPath.row];
            return cell;
        }
    } else {
        //自己发的内容
        //图片
        if ([model.info_content isEqualToString:@""] && ![model.info_img isEqualToString:@""]) {
            static NSString *mineimage = @"mineimage";
            ChatRightImageCell *cell = [tableView dequeueReusableCellWithIdentifier:mineimage];
            if (!cell) {
                cell = [[ChatRightImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineimage];
            }
            cell.clickImageBlock = ^(){
                [self clickImageWithUrl:model.info_img];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //给内容赋值
            [cell.myImageView setImageWithURL:[NSURL URLWithString:model.info_img] placeholderImage:[UIImage imageNamed:@"group_waku_mini"]];
            return cell;
            
        } else {
            //字符串
            static NSString *mineString = @"mineString";
            
            ChatRightStringCell *cell = [tableView dequeueReusableCellWithIdentifier:mineString];
            if (!cell) {
                cell = [[ChatRightStringCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineString];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //给内容赋值
            cell.model = [self.dataArray objectAtIndex:indexPath.row];
//            //获取当前时间
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"YYYY-MM-DD HH:mm"];
//            NSString *dataTime = [formatter stringFromDate:[NSDate date]];
//            cell.time.text = dataTime;
            
            return cell;
        }
    }
}
/// 点击看大图
- (void)clickImageWithUrl:(NSString *)urlStr
{
    NSLog(@"点击看大图, 图片地址==%@", urlStr);
    
    ImageShowViewController *imageShow = [[ImageShowViewController alloc] init];
    imageShow.imageStr = urlStr;
    
    [self presentViewController:imageShow animated:YES completion:^{
        
    }];
}

/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    ChatModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    CGFloat imageH = 150 + 25 + 10 + 10;
    //    if ([model.info_content isEqualToString:@""] && ![model.info_img isEqualToString:@""]) {
    //        return 150 + 25 + 10 + 10;
    //    }
    NSString *string = model.info_content;
    UIFont *font = FONT_SIZE_6(14.f);
    CGSize size = [self sizeWithString:string font:font];
    CGFloat h = 55 + size.height + 15;
    //    return h;
    
    UserModel *user = [UserModel unpackUserInfo];
    //isMy 是2是别人发的 1是自己发的
    if (![model.user_id isEqualToString:user.user_id]) {
        //隔壁老王发内容
        
        if ([model.info_content isEqualToString:@""] && ![model.info_img isEqualToString:@""]) {
            
            // 图片
            return imageH;
        } else {
            // 字符串
            ChatLeftStringCell *chat = [[ChatLeftStringCell alloc] init];
            chat.model = model;
            return chat.cellH;
            //            return h;
        }
    } else {
        //自己发的内容
        //图片
        if ([model.info_content isEqualToString:@""] && ![model.info_img isEqualToString:@""]) {
            //图
            return imageH;
        } else {
            //字符串
            ChatRightStringCell *chat = [[ChatRightStringCell alloc] init];
            chat.model = model;
            return chat.cellH;
        }
    }
    
    
    
}
///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CON_WIDTH / 3 * 2, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName:  [UIFont systemFontOfSize:font.pointSize]}//传入的字体字典
                                       context:nil];
    
    return rect.size;
}

#pragma mark -
#pragma mark 发送消息的实现
/// 发送文字消息的实现
- (void)chatAction:(UIButton *)sender
{
    [self.send resignFirstResponder];
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChatSendUrl];
    UserModel *user = [UserModel unpackUserInfo];
    //    //传入的参数 单聊 group_id 为空
    //    self.postEmall = @"";
    self.send.text = @"";
    if (![self.postEmall isEqualToString:@""]) {
        NSLog(@"self.postEmall==%@", self.postEmall);
        NSDictionary *parameters = @{@"user_id":user.user_id,@"rec_id":self.member_id,@"info_content":self.postEmall,@"info_img":@""};
        __weak ChatViewController *chatViewC = self;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"结果%@", responseObject);
            NSString *result = [responseObject objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                NSLog(@"失败");
                return;
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArray.count-1 inSection:0];
            [chatViewC.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            //            self.postEmall = @"";
            //            chatViewC.send.text = @"";
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"失败2");
            //            self.postEmall = @"";
            //            chatViewC.send.text = @"";
        }];
    } else {
        NSLog(@"没发出去,消息为%@", self.postEmall);
    }
    //在本地显示一下
    ChatModel *model = [[ChatModel alloc] init];
    model.info_content = self.postEmall;
    model.info_img = @"";
    model.user_id = user.user_id;
    [self.dataArray addObject:model];
    [self.tableView reloadData];
    
}
/// 发送图片图片消息的实现
- (void)sendPicture:(UIButton *)sender
{
    [self postImageView];
    NSLog(@"发送图片");
    
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
//点击Cancela按钮执行方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//拍摄完成执行方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获得图片,和图片地址
    [self uploadingImage:info];
    // 发送图片
    //    [self sendImage];
    
}
/// 上传图片获得URL接口
- (void)uploadingImage:(NSDictionary *)info
{
    //得到图片
    self.image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    //图片存入相册
    //    UIImageWriteToSavedPhotosAlbum(self.ima, nil, nil, nil);
    [self dismissViewControllerAnimated:YES completion:^{
        // 选完图片返回
    }];
    
    //加菊花
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.labelText = LODEING;
    [self.progress show:YES];
    [self.view addSubview:self.progress];
    
    //选择完图片进行网络请求 获得图片地址
    NSData *data = [[NSData alloc] init];
    data = UIImageJPEGRepresentation(self.image, 0.3);
    //    data = UIImagePNGRepresentation(self.image);
    // NSLog(@"=====%@", data);
    
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,SysteerPostImageUrl];
    //传入的参数
    NSDictionary *parameters = @{@"file_path":data};
    
    __weak ChatViewController *systomoGropAddVC = self;
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
            systomoGropAddVC.picUrlString = [dic objectForKey:@"url"];
            [self sendImage];
        }
        NSLog(@"=====%@", self.picUrlString);
        [self.progress hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取图片URL==%@", error);
        NSLog(@"operation =====%@", operation.responseString);
        [self.progress hide:YES];
        
    }];
    
}
/// 发送图片
- (void)sendImage
{
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChatSendUrl];
    UserModel *user = [UserModel unpackUserInfo];
    //传入的参数 单聊 group_id 为空
    NSDictionary *parameters = @{@"user_id":user.user_id,@"rec_id":self.member_id,@"info_content":@"",@"info_img":self.picUrlString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            return;
        }
        [self.progress hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.progress hide:YES];
    }];
    //    //在本地显示一下
    ChatModel *model = [[ChatModel alloc] init];
    model.info_img = self.picUrlString;
    //    model.send_Image = self.image;
    model.user_id = user.user_id;
    model.info_content = @"";
    [self.dataArray addObject:model];
    [self.tableView reloadData];
    
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
    
    [UIView animateWithDuration:duration animations:^{
        [self.sendView setFrame:CGRectMake(0, CON_HEIGHT - 44 - 64 - keyboardSize.height, CON_WIDTH, 44)];
    }];
}
/// 键盘收回
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.sendView setFrame:CGRectMake(0, CON_HEIGHT - 44 - 64, CON_WIDTH, 44)];
    }];
}
//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.send resignFirstResponder];
}
#pragma 输入框协议-代理方法

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    /// 让最后一个cell在tableView最低端
    if (self.dataArray.count != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArray.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    NSLog(@"1");
    return YES;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    /// 让最后一个cell在tableView最低端
//    if (self.dataArray.count != 0) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArray.count-1 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
//    NSLog(@"1");
//    return YES;
//}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"2");
}

///// 点击“完成”时，执行的方法
//
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
////    [self.send resignFirstResponder];
//    NSLog(@"3");
//    return YES;
//}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"4");
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.postEmall = [NSString stringWithFormat:@"%@", textView.text];
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
////    textField.text = @"";
//    self.postEmall = [NSString stringWithFormat:@"%@", textField.text];
//
//    NSLog(@"5");
//}
/// 点击联想的时候出发
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return  YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSLog(@"6");
////    self.postEmall = [NSString stringWithFormat:@"%@%@", textField.text, string];
//    return YES;
//}
///// 点击“退格”时，执行的方法
//- (BOOL)textFieldShouldClear:(UITextField *)textField
//{
//    NSLog(@"7");
//    if (textField.text.length == 0) {
//        [self.send resignFirstResponder];
//    }
//    return YES;
//}
/// 网络请求列表
- (void)PostMessageWithMember_id:(NSString *)member_id page:(NSString *)page
{
    NSString *str = [NSString stringWithFormat:@"%@%@", TiTleUrl,ChatInfoUrl];
    UserModel *user = [UserModel unpackUserInfo];
    //传入的参数
    NSDictionary *parameters = [NSDictionary dictionary];
    if (!user) {
        parameters = @{@"rec_id":member_id,@"p_num":page, @"p_size":@"20"};
    } else {
        parameters = @{@"user_id":user.user_id,@"rec_id":member_id,@"p_num":page, @"p_size":@"20"};
    }
    __weak ChatViewController *chieVC = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            return;
        }
        NSMutableDictionary *tempDic = [responseObject objectForKey:@"data"];
        NSMutableArray *tempArr = [tempDic objectForKey:@"group_info"];
        
        NSArray *tmp = [NSArray arrayWithArray:self.dataArray];
        [self.dataArray removeAllObjects];
        
        for (NSDictionary *dic in tempArr) {
            ChatModel *model = [[ChatModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [chieVC.dataArray addObject:model];
            NSLog(@"内容==%@", model.info_content);
        }
        
        for (ChatModel *model in tmp) {
            [self.dataArray addObject:model];
        }
        
        [self.tableView reloadData];
        
        if ([page isEqualToString:@"1"] && self.dataArray.count != 0) {
            /// 让最后一个cell在tableView最低端
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArray.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
    
}


-(void)dealloc {
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [defaultCenter removeObserver:self];
    
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
- (void)headerRereshing
{
    // 1.添加数据
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld", (long)self.page];
    [self PostMessageWithMember_id:self.member_id page:pageStr];
    self.page ++;
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
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
