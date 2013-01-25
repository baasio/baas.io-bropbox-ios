//
//  AppDelegate.m
//  BropBox
//
//  Created by cetauri on 12. 9. 18..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "AppDelegate.h"
#import "BoxListViewController.h"
#import "DownloadViewController.h"
#import "UploadViewController.h"
#import <baas.io/Baas.h>
#import "SignInViewController.h"
#import "SettingViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Baasio setApplicationInfo:@"https://stgapi.baas.io" baasioID:@"baas107" applicationName:@"bropbox"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    BaasioUser *currentUser = [BaasioUser currentUser];
    if (currentUser == nil) {
        [self login];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startApplication:)
                                                     name:APP_LOGIN_FINISH_NOTIFICATION object:nil];
    }else{
        [self startApplication:nil];
    }

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)login{
    SignInViewController *controller = [[SignInViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
}

- (void)startApplication:(NSNotification*) noti
{
    BoxListViewController *boxListViewController = [[BoxListViewController alloc] init];
    UIViewController *viewController1 = [[UINavigationController alloc] initWithRootViewController:boxListViewController];

    DownloadViewController *downloadViewController = [[DownloadViewController alloc] init];
    UIViewController *viewController2 = [[UINavigationController alloc] initWithRootViewController:downloadViewController];

    UploadViewController *uploadViewController = [[UploadViewController alloc] init];
    UIViewController *viewController3 = [[UINavigationController alloc] initWithRootViewController:uploadViewController];

    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    UIViewController *viewController4 = [[UINavigationController alloc] initWithRootViewController:settingViewController];


    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3, viewController4];
    self.window.rootViewController = self.tabBarController;

}


@end
