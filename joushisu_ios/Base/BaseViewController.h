//
//  BaseViewController.h
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <GoogleMobileAds/GoogleMobileAds.h>
@import GoogleMobileAds;
@interface BaseViewController : UIViewController
{
    
    GADBannerView *bannerView_;
}
@property (nonatomic, retain) MBProgressHUD *progress;
- (void)comeBack;
@end
