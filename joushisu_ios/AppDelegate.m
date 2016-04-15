//
//  AppDelegate.m
//  joushisu_ios
//
//  Created by 常宽 on 15/4/24.
//  Copyright (c) 2015年 SGKJ. All rights reserved.
//

#import "AppDelegate.h"
#import "menuViewController.h"
#import "EnterController.h"
#import "APService.h"
#import "ModalMessageViewController.h"
#import <IgaworksCore/IgaworksCore.h>
#import <AdSupport/AdSupport.h>
@interface AppDelegate ()
//@property (nonatomic, strong)UINavigationController *navi;
@end

@implementation AppDelegate

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"获取推送出错");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [IgaworksCore igaworksCoreWithAppKey:@"229489808" andHashKey:@"dcd674adee22407f" andIsUseIgaworksRewardServer:YES];
   // 3，定义一下log的级别
    // IgaworksCoreLogInfo 或者IgaworksCoreLogDebug  或者IgaworksCoreLogTrace
    
    [IgaworksCore setLogLevel:IgaworksCoreLogTrace];
    
    if (NSClassFromString(@"ASIdentifierManager")){
        
        NSUUID *ifa =[[ASIdentifierManager sharedManager]advertisingIdentifier];
        
        BOOL isAppleAdvertisingTrackingEnalbed = [[ASIdentifierManager sharedManager]isAdvertisingTrackingEnabled];
        
        [IgaworksCore setAppleAdvertisingIdentifier:[ifa UUIDString] isAppleAdvertisingTrackingEnabled:isAppleAdvertisingTrackingEnalbed];
        
        NSLog(@"[ifa UUIDString] %@", [ifa UUIDString]);
        
    }
    
   
    //==============================JPush===============================================
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    menuViewController *menuVC = [[menuViewController alloc] init];
    self.navi = [[UINavigationController alloc] initWithRootViewController:menuVC];
    self.navi.navigationBar.translucent = NO;
    NavbarView *navView = [NavbarView sharedInstance];
    navView.frame = CGRectMake(0, 0, 140, 18);
    navView.center = self.navi.navigationBar.center;
    [self.navi.navigationBar addSubview:navView];
    self.navi.navigationBar.barTintColor = [UIColor colorWithRed:59/255.f green:58/255.f blue:56/255.f alpha:1];
    self.window.rootViewController = self.navi;
    
    
//    UserModel *user = [UserModel unpackUserInfo];
//    NSLog(@"%@", user.user_id);
//    if (!user) {
//        EnterController *enter = [[EnterController alloc] init];
//        enter.comeBackBlock = ^(){
//            /// AppDelegate不作操作
//        };
//        [self.navi presentViewController:enter animated:YES completion:^{
//            
//        }];
//    }

    

    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    


    [APService setTags:nil alias:[APService registrationID] callbackSelector:nil object:nil];
    NSLog(@"registrationID = %@", [APService registrationID]);
    //==============================JPush===============================================
//    //打开推送或关闭推送
//    [self openPush];

    //运行次数
    static dispatch_once_t onceToke;
    dispatch_once(&onceToke,^{
        self.appIsNum = 0 ;
    });
    self.appIsNum++;
    
    /// 点击收到的消息
    if (application.applicationState != UIApplicationStateActive && application.applicationIconBadgeNumber != 0)
    {
        [self presentViewControllerWithUserInfo];
    }
    [application cancelAllLocalNotifications];
    application.applicationIconBadgeNumber = 0;
   
    return YES;
}

#pragma mark - JPush
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"获取推送成功");
    // Required
    [self openPushWithDeviceToken:deviceToken];
//    [APService registerDeviceToken:deviceToken];
}
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    
//    // Required
//    [APService handleRemoteNotification:userInfo];
//
//    /// 点击收到的消息
//    if (application.applicationState != UIApplicationStateActive && application.applicationIconBadgeNumber != 0)
//    {
//        [self presentViewControllerWithUserInfo];
//        [application cancelAllLocalNotifications];
//    }
//    application.applicationIconBadgeNumber = 0;
//  
//}
/// ios7 方法用处同上
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [APService handleRemoteNotification:userInfo];
    
    NSLog(@"聊天消息 %@" ,userInfo);

    [self.infoDelegate passValue:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    /// 点击收到的消息
        if (application.applicationState != UIApplicationStateActive && application.applicationIconBadgeNumber != 0)
        {
            [self presentViewControllerWithUserInfo];
            [application cancelAllLocalNotifications];
        }
        application.applicationIconBadgeNumber = 0;
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma mark - 消息跳转页面
- (void)presentViewControllerWithUserInfo//:(NSDictionary *)userInfo
{
    NSLog(@"收到推送");
    //拿出你的消息内容，跳转即可~~
    ModalMessageViewController *enterVC = [[ModalMessageViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:enterVC];
    nav.navigationBar.barTintColor =[UIColor colorWithRed:231 / 255.0 green:187 / 255.0 blue:34/ 255.0 alpha:1];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}
#pragma mark - JPush 通知

- (void)networkDidSetup:(NSNotification *)notification {
    
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    
    NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    
    NSLog(@"已注册");
    
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"已登录");
    
    [APService setTags:nil alias:[APService registrationID] callbackSelector:nil object:nil];
    
//    HOTUserInfo *userInfo = [HOTUserInfo defaultUser];
//    
//    userInfo.push_token = [APService registrationID];
    NSLog(@"registrationID = %@＝＝＝＝＝", [APService registrationID]);

}
- (void)openPushWithDeviceToken:(NSData *)deviceToken
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"night" object:nil];//接收到了消息之后执行的操作
    NSLog(@"%d推送开关",[[NSUserDefaults standardUserDefaults] boolForKey:@"kj"]);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kj"]) {
//        self.nightView.hidden = NO;
        NSLog(@"程序启动,推送判断关闭");
        [APService registerDeviceToken:nil];
    }
    else
    {
//        self.nightView.hidden = YES;
        NSLog(@"程序启动,推送判断开启");
        [APService registerDeviceToken:deviceToken];
    }

}
- (void)receiveMessage:(NSNotification *)center
{
    NSLog(@"%d推送开关",[[NSUserDefaults standardUserDefaults] boolForKey:@"kj"]);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kj"]) {
        NSLog(@"已关闭");
    }
    else
    {
        NSLog(@"已开启");
    }
}
- (void)dealloc
{
    
    //移除自己的观察着身份
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.vicgoo.joushisu_ios" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"joushisu_ios" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"joushisu_ios.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
