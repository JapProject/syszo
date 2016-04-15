//
//  ImageShowViewController.m
//  joushisu_ios
//
//  Created by 常宽 on 15/5/28.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "ImageShowViewController.h"

@interface ImageShowViewController ()

@end

@implementation ImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor]; // colorWithAlphaComponent:0.3];
    
    UIImageView *bigImage = [[UIImageView alloc] init];
    bigImage.userInteractionEnabled = YES;
    NSURL *url = [NSURL URLWithString:self.imageStr];
    __block UIImageView *image1= bigImage;
    [bigImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"group_waku_mini"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [image1 setFrame:CGRectMake(0, 0, CON_WIDTH - 20, ((CON_WIDTH - 20)/image.size.width) * image.size.height)];
        [image1 setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    }];
    [self.view addSubview:bigImage];
    
    UITapGestureRecognizer *backImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageView:)];
    [self.view addGestureRecognizer:backImage];
    
}

/// 点大图返回
- (void)backImageView:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
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
