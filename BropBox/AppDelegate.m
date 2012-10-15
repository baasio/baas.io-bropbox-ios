//
//  AppDelegate.m
//  BropBox
//
//  Created by cetauri on 12. 9. 18..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "BaasFileUtils.h"
#import "SignInViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    UGClient *client = [[UGClient alloc] initWithApplicationID:BAAS_APPLICATION_ID];
//    [client setDelegate:self];
//    [client logInUser:@"cetauri" password:@"cetDauri"];
    BaasFileUtils *file = [[BaasFileUtils alloc]init];
//    [file download];

//    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"first.png"]);

    [file delete:@""
      successBlock:^(NSDictionary *response) {
          NSLog(@"response.description : %@", response.description);
      }
      failureBlock:^(NSError *error) {
          NSLog(@"error : %@, %@", error.description, error.domain);
      }
     ];


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

    if (true){  //로그인 됨?
        SignInViewController *controller = [[SignInViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    } else{
        [self startApplication:nil];
    }
    [self.window makeKeyAndVisible];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startApplication:)
                                                 name:APP_LOGIN_FINISH_NOTIFICATION object:nil];
    return YES;
}

- (void)startApplication:(NSNotification*) noti
{
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    UIViewController *viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];

    UIViewController *viewController3 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    UIViewController *viewController4 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2, viewController3, viewController4];
    self.window.rootViewController = self.tabBarController;

}
- (void)ugClientResponse:(UGClientResponse *)response
{
    NSLog(@"------------ %@, %@", response.rawResponse, response.response);
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
