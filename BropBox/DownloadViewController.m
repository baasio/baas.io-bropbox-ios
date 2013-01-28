//
//  DownloadViewController.m
//  BropBox
//
//  Created by cetauri on 12. 9. 18..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "DownloadViewController.h"
#import <baas.io/Baas.h>
@interface DownloadViewController ()  {
    UITableView *_tableView ;
    NSMutableArray *_downloadFileList;
}
@end

@implementation DownloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"다운로드";
        self.tabBarItem.image = [UIImage imageNamed:@"star.png"];

        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49  - 44);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];

        _downloadFileList = [self getLocalFileList];
    }
    return self;
}

#pragma mark - event

- (NSMutableArray*)getLocalFileList{
    NSMutableArray *list = [NSMutableArray array];
    NSString *localPath = [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), @"download"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:localPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:localPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPath error:nil];
    for (NSString *path in array){
        if (![path hasPrefix:@"."]){
            [list addObject:path];
        }
    }
    return list;

}

//XXX BaasioFile 처리
- (void)download:(NSDictionary *)info{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:info];
//    [dictionary setValue:nil forKey:@"downloadInfo"];

    UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    CGRect frame = progressView.frame;
    frame.origin.x +=5;
    frame.origin.y +=30;
    frame.size.width = self.view.frame.size.width - 10;
    progressView.frame = frame;
    [dictionary setObject:progressView forKey:@"progressView"];

    [_downloadFileList addObject:dictionary];

    int index = _downloadFileList.count - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0] ;
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    NSString *targetPath = [NSString stringWithFormat:@"%@/%@/%@", NSTemporaryDirectory(), @"download", [dictionary objectForKey:@"filename"]];

    BaasioFile *file = [[BaasioFile alloc]init];
    file.uuid = info[@"uuid"];
    [file fileDownloadInBackground:targetPath
                      successBlock:^(NSString *path){
                          UIProgressView *progressView = (UIProgressView *)[dictionary objectForKey:@"progressView"];
                          [progressView removeFromSuperview];
                          [dictionary removeObjectForKey:@"progressView"];
                          [_downloadFileList replaceObjectAtIndex:index withObject:[info objectForKey:@"filename"]];
                          [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

                      }
                      failureBlock:^(NSError *error){
                          NSLog(@"error : %@, %@", error.description, error.domain);
                          
                          UITableViewCell *listCell =  [_tableView cellForRowAtIndexPath:indexPath];
                          listCell.detailTextLabel.text = error.description;
                          
                          UIProgressView *progressView = (UIProgressView *)[dictionary objectForKey:@"progressView"];
                          [progressView removeFromSuperview];
                      }
                     progressBlock:^(float progress){
                         UIProgressView *progressView = (UIProgressView *)[dictionary objectForKey:@"progressView"];
                         progressView.progress = progress;
                     }];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [_downloadFileList objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]){

        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
        previewController.delegate = self;

        // start previewing the document at the current section index
        previewController.currentPreviewItemIndex = 0;

        [self.navigationController pushViewController:previewController animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _downloadFileList.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"uploadCell";

    UITableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (listCell == nil) {
        listCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }

    id obj = [_downloadFileList objectAtIndex:indexPath.row];
    __block NSMutableDictionary *info;
    NSString *filename;
    if ([obj isKindOfClass:[NSString class]]){
        filename = obj;
    } else{
        info = obj;
        filename = [info objectForKey:@"filename"];

//        NSMutableDictionary *downloadInfo = [info objectForKey:@"downloadInfo"];
        UIProgressView *progressView = (UIProgressView *)[info objectForKey:@"progressView"];

        if(progressView) [listCell addSubview:progressView];
        listCell.detailTextLabel.text = @" ";
    }

    listCell.textLabel.text = filename;

    return listCell;
}
#pragma mark - QLPreviewControllerDelegate
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    return 1;
}

- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    NSIndexPath *selectedIndexPath = [_tableView indexPathForSelectedRow];
    NSURL *qURL = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@/%@/%@", NSTemporaryDirectory(), @"download", [_downloadFileList objectAtIndex:selectedIndexPath.row]]];
    return qURL;
}

@end
