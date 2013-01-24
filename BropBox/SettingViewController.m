//
//  SettingViewController.m
//  BropBox
//
//  Created by cetauri on 12. 10. 17..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <baas.io/baas.h>
@interface SettingViewController ()  {
    UITableView *_tableView ;
}
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"설정";
        self.tabBarItem.image = [UIImage imageNamed:@"setting.png"];
        
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49  - 44);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return self;
}

#pragma mark - event
- (void)signOutButtonPressed
{
    [BaasioUser signOut];

    id<UIApplicationDelegate> applicationDelegate = [UIApplication sharedApplication].delegate;
    [applicationDelegate performSelector:@selector(login)];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    headerView.backgroundColor = [UIColor clearColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.text = @"계정";
    [headerView addSubview:label];

    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    headerView.backgroundColor = [UIColor clearColor];

    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutButton.frame = CGRectMake(10, 10, 300, 44);
    [logoutButton setTitle:@"로그아웃" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(signOutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"redButton.png"] forState:UIControlStateNormal];

    [headerView addSubview:logoutButton];

    return headerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }

    cell.detailTextLabel.text = [BaasioUser currentUser].username ;
    cell.textLabel.text = @"아이디";

    return cell;
}
@end
