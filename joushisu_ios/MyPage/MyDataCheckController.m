//
//  MyDataCheckController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/22.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MyDataCheckController.h"
#import "FriendNickCell.h"
#import "MyResumeCell.h"
#import "MyDataIntroduceCell.h"
#import "MPSEditViewController.h"

@interface MyDataCheckController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *friendDataArray;

@property (nonatomic, strong)UserModel *user;
@end

@implementation MyDataCheckController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.user = [UserModel unpackUserInfo];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
//    self.dataArray = [NSMutableArray arrayWithObjects:@"性別", @"現在地", @"業種", @"会社規模", @"役職・役割", @"年間予算", @"情シス歴", @"ソフトウェア", @"ハードウェア", @"保有資格", @"シストモ", @"いいね！数", nil];
    self.dataArray = [NSMutableArray arrayWithObjects:@"性別", @"現在地", @"業種", @"会社規模", @"役職・役割", @"年間予算", @"情シス歴", @"シストモ", @"いいね！数", nil];
//    self.view.userInteractionEnabled = NO;
    // 获取存入本地临时文件夹的数组
    NSString *path2 = NSTemporaryDirectory();
    NSString *arrPath = [path2 stringByAppendingPathComponent:@"MyData.xml"];
    self.friendDataArray = [NSMutableArray arrayWithContentsOfFile:arrPath];
    //数组
    NSLog(@"从本地取出的数组%@", self.friendDataArray);

}
- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64) style:(UITableViewStylePlain)];
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
            static NSString *string = @"FriendDataFrist";
            FriendNickCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[FriendNickCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.user.user_name, @"name", @"2" , @"isMember", self.user.user_id, @"rec_id", nil];
            cell.dic = dic;
            
            cell.sessionBlock = ^(){
                NSLog(@"发起会话2");
            };
            cell.delDuddyBlock = ^(){
                NSLog(@"删除好友2");
            };
            cell.addDuddyBlock = ^(){
                NSLog(@"添加好友2");
            };
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            static NSString *string = @"mineDatasec";
            MyResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[MyResumeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.categoryTitle.text = self.dataArray[indexPath.row];
            cell.contentTitle.text = self.friendDataArray[indexPath.row];
            //            NSLog(@"%d", indexPath.row);
            return cell;
            
        }
            break;
        case 2:
        {
            static NSString *string = @"mineDatathe";
            MyDataIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[MyDataIntroduceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selfIntroduce.text = [self.friendDataArray lastObject];
            cell.selfIntroduce.editable = NO;
            return cell;
        }
            break;
            
        default:
        {
            static NSString *string = @"mineDataull";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
            break;
    }
}
/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 65;
            break;
        case 1:
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
///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
