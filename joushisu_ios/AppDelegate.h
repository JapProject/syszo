//
//  AppDelegate.h
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

/// 协议传值,把聊天信息传到指定页面去
@protocol AppDelegateViewControllerDelegate <NSObject>

@optional
///  传值的方法一般都带有一个或多个参数
- (void)passValue:(NSDictionary *)dic;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, weak)id<AppDelegateViewControllerDelegate> infoDelegate;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (assign, nonatomic) NSInteger appIsNum;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, strong)UINavigationController *navi;

@end

