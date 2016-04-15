//
//  MPSEditTableController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/7.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "MPSEditTableController.h"
#import "MyDataEditAddressModel.h"
#import "MyDataEditModels.h"
#import "MPSEditViewController.h"

@interface MPSEditTableController ()<UITableViewDataSource, UITableViewDelegate,NADViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong) NADView *ADView;

@end

@implementation MPSEditTableController

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
    [self createTableView];

//    [self netWorkWithUrl:self.url];
    
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
    self.tableView.frame = CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64-_ADView.frame.size.height);
}
- (void)setUrl:(NSString *)url
{
    if (_url != url) {
        _url = url;
    }
    
}
- (void)setDicId:(NSDictionary *)dicId
{
    if (_dicId != dicId) {
        _dicId = dicId;
    }
    [self netWorkWithUrl:self.url];

}

- (void)comeBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
#pragma mark 网络请求
- (void)netWorkWithUrl:(NSString *)url
{
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", TiTleUrl, @"性别"]]) {
        MyDataEditAddressModel *model1 = [[MyDataEditAddressModel alloc] init];
        model1.area_id = @"1";
        model1.area_name = @"男";
        [self.dataArray addObject:model1];
        MyDataEditAddressModel *model2 = [[MyDataEditAddressModel alloc] init];
        model2.area_id = @"2";
        model2.area_name = @"女";
        [self.dataArray addObject:model2];
        MyDataEditAddressModel *model3 = [[MyDataEditAddressModel alloc] init];
        model3.area_id = @"3";
        model3.area_name = @"その他";
        [self.dataArray addObject:model3];
        return;
    }
    
    
    
//    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@", TiTleUrl, MypageEditGetHard]] ||
//        [url isEqualToString:[NSString stringWithFormat:@"%@%@", TiTleUrl,MypageEditGetSoft]] ||
//        [url isEqualToString:[NSString stringWithFormat:@"%@%@", TiTleUrl, MypageEditGetQualified]]) {
//        
//        
//        
//        __weak MPSEditTableController *edit = self;
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        [manager POST:url parameters:self.dicId success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    NSLog(@"%@", responseObject);
//            NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
//            for (NSDictionary *dic in tempArr) {
//                MyDataEditModels *model = [[MyDataEditModels alloc] init];
//                [model setValuesForKeysWithDictionary:dic];
//                [edit.dataArray addObject:model];
//                //            NSLog(@"%@", model.area_name);
//            }
//            [self.tableView reloadData];
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            // NSLog(@"%@", error);
//        }];
//        
//        
//        return;
//        
//    }
    
    
    
    
    __weak MPSEditTableController *edit = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
        NSMutableArray *tempArr = [responseObject objectForKey:@"data"];
        for (NSDictionary *dic in tempArr) {
            MyDataEditAddressModel *model = [[MyDataEditAddressModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [edit.dataArray addObject:model];
//            NSLog(@"%@", model.area_name);
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
}
#pragma mark -
- (void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CON_WIDTH, CON_HEIGHT - 64-_ADView.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
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
    
//    MyDataEditAddressModel *model = self.dataArray[indexPath.row];

    id model = self.dataArray[indexPath.row];
    
    if ([model isKindOfClass:[MyDataEditAddressModel class]]) {
        MyDataEditAddressModel *models = model;
        
        static NSString *string = @"details";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
//            UIImage *image = [UIImage imageNamed:@"arrowRight"];
            //        cell.myImage.image = image;
            
        }
        cell.textLabel.text = models.area_name;
        
        return cell;

    }else{
        MyDataEditModels *models = model;
        static NSString *string = @"details";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
            UIImage *image = [UIImage imageNamed:@"arrowRight"];
            //        cell.myImage.image = image;
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(CON_WIDTH - 10 - 30, 20, 11, 17)];
            imageview.center = CGPointMake(imageview.centerX, 20);
            imageview.image = image;
            if ([models.last_flg isEqualToString:@"1"] ) {
                imageview.hidden = YES;
            }else{
                imageview.hidden = NO;
            }
            
            [cell addSubview:imageview];
        }
        cell.textLabel.text = models.area_name;
        
        return cell;

    }

    
    
    
   }
/// 返回row的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
///  选中cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MyDataEditAddressModel *model = self.dataArray[indexPath.row];
    id model = self.dataArray[indexPath.row];
    
    if ([model isKindOfClass:[MyDataEditAddressModel class]]) {
//        MyDataEditAddressModel *model = model;
//        self.saveBlock(model);
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:model,@"model",[NSString stringWithFormat:@"%ld",self.index],@"index", nil];
        


//        [[NSNotificationCenter defaultCenter] postNotificationName:@"返回传参数" object:nil userInfo:dic];
        [self comeBack];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[MPSEditViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
                MPSEditViewController *mps = (MPSEditViewController *)temp;
                [mps receiveNoti:dic];
            }
        }
    }else
    {
        MyDataEditModels * modelss = model;
        if ([modelss.last_flg isEqualToString:@"1"]) {
            
            
//            self.saveBlock(model);
            
            NSString *str = [NSString stringWithFormat:@"%ld",self.index];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:model,@"model",str,@"index", nil];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"返回传参数" object:nil userInfo:dic];
            
            
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[MPSEditViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    MPSEditViewController *mps = (MPSEditViewController *)temp;
                    [mps receiveNoti:dic];
                }
            }
        }else {
            MPSEditTableController *table = [[MPSEditTableController alloc] init];
            table.url = self.url;
            table.index = self.index;
            table.dicId = [NSDictionary dictionaryWithObjectsAndKeys:modelss.area_id,@"parent_id", nil];
            [self.navigationController pushViewController:table animated:YES];
        }
        
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
