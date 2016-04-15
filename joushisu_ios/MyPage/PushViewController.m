//
//  PushViewController.m
//  joushisu_ios
//
//  Created by 曾凯峻 on 15/5/20.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "PushViewController.h"
#import "SettingCell.h"
@interface PushViewController () <UITableViewDataSource, UITableViewDelegate, NADViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArr;
@property (nonatomic, strong) NADView *ADView;
@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.tableArr = [NSMutableArray arrayWithObject:@"プッシュ通知"];
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

- (void)creatView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64 -_ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    CGSize size = [self sizeWithString:PushString font:FONT_SIZE_6(17.f)];
    self.tableView.sectionHeaderHeight = size.height + 160;
    //除去线
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
}
/// 返回Cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    UILabel *label1 = [[UILabel alloc] init];
//    label1.backgroundColor = [UIColor cyanColor];
    label1.numberOfLines = 0;
    label1.text = PushString;
    label1.font = FONT_SIZE_10(10.f);
    CGSize size = [self sizeWithString:label1.text font:FONT_SIZE_10(10.f)];
    [label1 setFrame:CGRectMake(10, 10, CON_WIDTH - 20, size.height+130)];
    
    [view setFrame:CGRectMake(0, 0, CON_WIDTH, size.height + 160)];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, size.height + 159, CON_WIDTH, 1)];
    line1.backgroundColor = [UIColor colorWithString:@"eeeeee" alpha:1];
    [view addSubview:line1];
    [view addSubview:label1];
    
    return view;
}
//- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//     CGSize size = [self sizeWithString:PushString font:FONT_SIZE_6(17.f)];
//    return size.height + 20;
//}

// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CON_WIDTH - 20, 10000)//限制最大的宽度和高度
                                       options:
                   NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading
                   | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName:  [UIFont systemFontOfSize:font.pointSize]}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *str = @"result";
    SettingCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (!cell) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.backgroundColor = [UIColor colorWithString:@"ffffff" alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.settingTitle.text = self.tableArr[indexPath.row];
    [cell.arrow removeFromSuperview];
    //创建开关
    if (indexPath.row == 0) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 5, 30, 30)];
        sw.on = ![[NSUserDefaults standardUserDefaults] boolForKey:@"kj"];
        [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:sw];
        
    }

    return cell;
}
- (void)switchAction:(UISwitch *)sender
{
//    UISwitch *mySwitch = (UISwitch *)sender;
    //单例
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //将上面是否开启的这个bool值 存到 NSUserdefaults 中
    [defaults setBool:!sender.isOn forKey:@"kj"];
    [defaults synchronize];
    //发送push模式消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"night" object:nil];
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
