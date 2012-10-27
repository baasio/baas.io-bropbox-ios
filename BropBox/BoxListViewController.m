//
//  BoxListViewController+.m
//  BropBox
//
//  Created by cetauri on 12. 9. 18..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "BoxListViewController.h"
#import "BaasClient.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "DownloadViewController.h"

@interface BoxListViewController ()    {
    UITableView *_tableView;
    NSMutableArray *_array;

}
@end

@implementation BoxListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Bropbox";
        self.tabBarItem.image = [UIImage imageNamed:@"dropbox.png"];

        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49  - 44);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.allowsSelection = NO;
        [self.view addSubview:_tableView];

        _array = [NSMutableArray array];
    }
    return self;
}
							
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSString *uuid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user"] objectForKey:@"uuid"];
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] ;
    BaasQuery *query = [[BaasQuery alloc] init];
    [query addRequirement:[NSString stringWithFormat:@"user = %@" ,uuid]];

    BaasClient *client = [BaasClient createInstance];
    [client setDelegate:self];
    [client setAuth:access_token];
    [client getEntities:@"directories" query:query];
}

- (void)ugClientResponse:(UGClientResponse *)response
{
    _array = [NSMutableArray arrayWithArray:[response.rawResponse objectForKey:@"entities"]];
    [_tableView reloadData];;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.tabBarController setSelectedIndex:1];

    UINavigationController *viewControllers = (UINavigationController *)[delegate.tabBarController selectedViewController];
    DownloadViewController *downloadViewController  = [viewControllers.viewControllers objectAtIndex:0];
    [downloadViewController download:_array[indexPath.row]];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] ;

    BaasClient *client = [BaasClient createInstance];
    [client setAuth:access_token];
    for (NSDictionary *dic in [_array[indexPath.row] objectForKey:@"entities"]){

        if ([[dic objectForKey:@"size"] intValue] != 0){
            [client delete:[dic objectForKey:@"uuid"]
                 successBlock:^(NSDictionary *response){

                     BaasClient *client = [BaasClient createInstance];
                    [client setAuth:access_token];
                    [client removeEntity:@"directories" entityID:[_array[indexPath.row] objectForKey:@"uuid"]];

                     [_tableView beginUpdates];
                     [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                     [_array removeObjectAtIndex:indexPath.row];
                     [_tableView endUpdates];
                     [_tableView reloadData];
                 }
                 failureBlock:^(NSError *error){
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"실패하였습니다.\n다시 시도해주세요."
                                                                         message:error.localizedDescription
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                     [alertView show];
                 }];
            break;
        }

    }}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"listCell";

    UITableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (listCell == nil) {
        listCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }

    NSDictionary *object = [_array objectAtIndex:indexPath.row] ;
    NSString *filename = [object objectForKey:@"filename"];
    NSString *path = @"";//[NSString stringWithFormat:@"%@/%@/%@/%@", BAAS_BASE_URL, BAAS_APPLICATION_ID, @"files", [[[object objectForKey:@"entities"] objectAtIndex:0] objectForKey:@"path"]];

    listCell.textLabel.text = filename;
    listCell.textLabel.font = [UIFont boldSystemFontOfSize:17.];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    [imageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"directory-icon.png"]];
    listCell.imageView.image  = imageView.image;
    return listCell;
}
@end
