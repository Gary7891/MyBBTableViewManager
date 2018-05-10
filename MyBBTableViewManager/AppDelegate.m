//
//  AppDelegate.m
//  MyBBTableViewManager
//
//  Created by Gary on 5/5/16.
//  Copyright © 2016 Gary. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <BBNetwork.h>
#import "BBTableViewDataSourceConfig.h"
#import "Utility.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    [[BBNetworkConfig sharedInstance] setBaseUrl:TT_Global_Api_Domain];
    NSString *deviceId = [Utility getUniqueDeviceID];
    NSDictionary *dic =@{
                         @"Authorization"       : DEFAULT_ACCESS_TOKEN,
                         @"VERSION"     : @"3.0.0",
                         @"x-platform"    : @"iOS",
                         @"x-client"      : @"store",
                         @"x-equCode"     : deviceId?: @"dsdsdsdsdsddsds"
                         };
    [[BBNetworkConfig sharedInstance] setRequestHeaderFieldValueDictionary:dic];
    
    
    [[BBTableViewDataSourceConfig sharedInstance] mapWithMappingInfo:@{
                                                                       
                                                                       
                                                                       @(1) :@{
                                                                               kBBTableViewDataSourceClassKey :  @"DemoTableViewDataSource",
                                                                               kBBTableViewUrlKey:INTERFACE_PRODUCTS,
                                                                               kBBTableViewDataManagerClassKey:@"DemoASTableViewDataManager"
                                                                               },
                                                                       @(2) :@{
                                                                               kBBTableViewDataSourceClassKey :  @"DemoTableViewDataSource",
                                                                               kBBTableViewUrlKey:INTERFACE_PRODUCTS,
                                                                               kBBTableViewDataManagerClassKey:@"DemoTableViewDataManager"
                                                                               }
                                                                       }];
    
    RootViewController *rootViewController = [[RootViewController alloc]init];
    self.window.rootViewController = rootViewController;
    
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
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
}

@end
