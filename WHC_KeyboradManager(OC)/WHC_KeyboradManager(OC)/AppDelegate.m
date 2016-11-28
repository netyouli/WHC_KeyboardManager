//
//  AppDelegate.m
//  WHC_KeyboradManager(OC)
//
//  Created by WHC on 16/11/20.
//  Copyright © 2016年 WHC. All rights reserved.
//

#import "AppDelegate.h"
#import "StyleVC1.h"
#import "StyleVC2.h"
#import "StyleVC3.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UITabBarController * tabbarVC = [UITabBarController new];
    UINavigationController * nav1 = [[UINavigationController alloc] initWithRootViewController:[StyleVC1 new]];
    UINavigationController * nav2 = [[UINavigationController alloc] initWithRootViewController:[StyleVC2 new]];
    UINavigationController * nav3 = [[UINavigationController alloc] initWithRootViewController:[StyleVC3 new]];
    nav1.tabBarItem.title = @"样式1";
    nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    nav1.tabBarItem.image = [UIImage imageNamed:@"op_uncheck"];
    nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    nav2.tabBarItem.title = @"样式2";
    nav2.tabBarItem.image = [UIImage imageNamed:@"op_uncheck"];
    nav3.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    nav3.tabBarItem.title = @"样式3";
    nav3.tabBarItem.image = [UIImage imageNamed:@"op_uncheck"];
    tabbarVC.viewControllers = @[nav1,nav2,nav3];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];

    _window.rootViewController = tabbarVC;
    [_window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
