//
//  BoxListViewController+.m
//  BropBox
//
//  Created by cetauri on 12. 9. 18..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "BoxListViewController.h"
#import <baas.io/Baas.h>
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

    BaasioQuery *query = [BaasioQuery queryWithCollection:@"files"];
    [query setWheres:[NSString stringWithFormat:@"user = %@" ,[BaasioUser currentUser].uuid]];
    [query queryInBackground:^(NSArray *array){
                    _array = [NSMutableArray arrayWithArray:array];
                    [_tableView reloadData];;
                }
                failureBlock:nil];
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
    
    NSDictionary *dic = _array[indexPath.row] ;
    BaasioFile *file = [[BaasioFile alloc]init];
    file.uuid = [dic objectForKey:@"uuid"];
    [file deleteInBackground:^(void){
    
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

}

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

//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
//    [imageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"directory-icon.png"]];
//    listCell.imageView.image  = imageView.image;
    return listCell;
}
@end
