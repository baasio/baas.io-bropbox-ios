//
//  DownloadViewController.m
//  BropBox
//
//  Created by cetauri on 12. 9. 18..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "DownloadViewController.h"
#import "Baas_SDK.h"
#import "PreviewViewController.h"
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
        self.tabBarItem.image = [UIImage imageNamed:@"second"];

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
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:nil];
    for (NSString *path in array){
        if (![path hasPrefix:@"."]){
            [list addObject:path];
        }
    }
    return list;

}
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

    NSString *resourcePath = [NSString stringWithFormat:@"https://stageapi.baas.io/test-organization/bropbox/files/%@", [[[dictionary objectForKey:@"entities"] objectAtIndex:0] objectForKey:@"path"]];
    NSString *targetPath = [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), [dictionary objectForKey:@"filename"]];

    FileUtils *fileUtils = [[FileUtils alloc]init];
    [fileUtils download:resourcePath
                   path:targetPath
             successBlock:^(void){
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
                 NSLog(@"progress  :%f", progress);
                UIProgressView *progressView = (UIProgressView *)[dictionary objectForKey:@"progressView"];
                progressView.progress = progress;
             }];

}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [_downloadFileList objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]){
        PreviewViewController *previewViewController = [[PreviewViewController alloc] init];

        [self.navigationController pushViewController:previewViewController animated:YES];
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
    NSLog(@"indexPath.row : %i", indexPath.row);
    id obj = [_downloadFileList objectAtIndex:indexPath.row];
    __block NSMutableDictionary *info;
    NSString *filename;
    if ([obj isKindOfClass:[NSString class]]){
        filename = obj;
    } else{
        info = obj;
        filename = [info objectForKey:@"filename"];

        NSMutableDictionary *downloadInfo = [info objectForKey:@"downloadInfo"];
        UIProgressView *progressView = (UIProgressView *)[info objectForKey:@"progressView"];

//        if (downloadInfo != nil) {
//            int fSize = [[downloadInfo objectForKey:@"size"] intValue];
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[downloadInfo objectForKey:@"date"]longLongValue] / 1000 ];
//
//            listCell.textLabel.text = filename;
//            listCell.detailTextLabel.text = [NSString stringWithFormat:@"%iKB, %@", fSize, date.description];
//        }else{
             if(progressView) [listCell addSubview:progressView];
            listCell.detailTextLabel.text = @" ";
//        }

    }

    listCell.textLabel.text = filename;


    return listCell;
}

@end