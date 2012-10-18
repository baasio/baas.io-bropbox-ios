//
//  AppDelegate.m
//  BropBox
//
//  Created by cetauri on 12. 9. 18..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "AppDelegate.h"
#import "BoxListViewController.h"
#import "SecondViewController.h"
#import "UploadViewController.h"
#import "Baas_SDK.h"
#import "SignInViewController.h"
#import "SettingViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    UGClient *client = [[UGClient alloc] initWithApplicationID:BAAS_APPLICATION_ID];
//    [client setDelegate:self];
//    [client logInUser:@"cetauri" password:@"cetDauri"];
    BaasFileUtils *file = [[BaasFileUtils alloc]init];
//    [file download];

//    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"first.png"]);

//    [file delete:@""
//      successBlock:^(NSDictionary *response) {
//          NSLog(@"response.description : %@", response.description);
//      }
//      failureBlock:^(NSError *error) {
//          NSLog(@"error : %@, %@", error.description, error.domain);
//      }
//     ];


//    [file download:@"@\"https://github.com/AFNetworking/AFNetworking/zipball/master\""
//            successBlock:^(NSString *path){
//                NSLog(@"%@", path);
//            }
//            failureBlock:^(NSError *error){
//                NSLog(@"error : %@, %@", error.description, error.domain);
//            }
//      progressBlock:^(float progress){
//          NSLog(@"progress : %f", progress);
//      }];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
//    NSLog(@"access_token : %@", access_token);
    if (access_token == nil){
        [self login];
    } else{
        [self startApplication:nil];
    }
    [self.window makeKeyAndVisible];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startApplication:)
                                                 name:APP_LOGIN_FINISH_NOTIFICATION object:nil];
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

    UIViewController *viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];

    UploadViewController *uploadViewController = [[UploadViewController alloc] init];
    UIViewController *viewController3 = [[UINavigationController alloc] initWithRootViewController:uploadViewController];

    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    UIViewController *viewController4 = [[UINavigationController alloc] initWithRootViewController:settingViewController];


    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3, viewController4];
    self.window.rootViewController = self.tabBarController;

}
- (void)ugClientResponse:(UGClientResponse *)response
{
    NSLog(@"------------ %@", response.rawResponse);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
