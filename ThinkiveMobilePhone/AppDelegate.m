//
//  AppDelegate.m
//  ThinkiveMobilePhone
//
//  Created by kill on 15/12/30.
//  Copyright © 2015年 kill. All rights reserved.
//

#import "AppDelegate.h"
#import "YLTabBarController.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "YLLoginController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    YLTabBarController *tabbarController = [[YLTabBarController alloc]init];
    self.window.backgroundColor = [UIColor grayColor];
    self.window.rootViewController = tabbarController;
    dispatch_async(dispatch_get_main_queue(), ^{
        //启动基本SDK
        [[PgyManager sharedPgyManager] startManagerWithAppId:pgyAppKey];
        [[PgyManager sharedPgyManager] setEnableFeedback:NO];
        //启动更新检查SDK
        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:pgyAppKey];
        
        [[PgyUpdateManager sharedPgyManager] checkUpdate];
    });
    
    return YES;
}


@end
