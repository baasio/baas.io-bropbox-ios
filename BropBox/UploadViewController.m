//
//  UploadViewController+.m
//  BropBox
//
//  Created by cetauri on 12. 9. 18..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "UploadViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Baas_SDK.h"

@interface UploadViewController ()    {
    UITableView *_tableView ;
    NSMutableArray *_uploadFileList;

}
@end

@implementation UploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"업로드";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];

        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49  - 44);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];

        _uploadFileList = [NSMutableArray array];

        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                           target:self
                                                                                           action:@selector(getPhoto:)];
        self.navigationItem.rightBarButtonItem = leftBarButtonItem;
    }
    return self;
}
							
-(void)getPhoto:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

    [self presentViewController:picker animated:YES completion:^(void){}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^(void){}];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:info];
    [dictionary setValue:NO forKey:@"uploaded"];
    [_uploadFileList addObject:dictionary];
    
    [_tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _uploadFileList.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"uploadCell";

    UITableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (listCell == nil) {
        listCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    
    NSMutableDictionary *info = [_uploadFileList objectAtIndex:indexPath.row];
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    listCell.imageView.image = image;
    listCell.textLabel.font = [UIFont boldSystemFontOfSize:17.];
    
    NSURL *url = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:url
                  resultBlock:^(ALAsset *asset){
                      ALAssetRepresentation *rep = [asset defaultRepresentation];
                      
                      listCell.textLabel.text = [NSString stringWithFormat:@"%@" , rep.filename];
//                      listCell.detailTextLabel.text = [NSString stringWithFormat:@"%lld Kb", rep.size/1000];
//                      
//                      listCell.detailTextLabel.hidden = YES;
                  }
                 failureBlock:^(NSError *err) {
                     NSLog(@"Error: %@",[err localizedDescription]);
                 }];
    if (![info objectForKey:@"uploaded"]) {

        BaasFileUtils *fileUtils = [[BaasFileUtils alloc]init];
        
        UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        CGRect frame = progressView.frame;
        frame.origin.x +=40;
        frame.origin.y +=30;
        frame.size.width = self.view.frame.size.width - 50;
        progressView.frame = frame;
        [listCell addSubview:progressView];
        
        [fileUtils upload:UIImageJPEGRepresentation(image, 1.0)
            successBlock:^(NSDictionary *response){
//                NSLog(@"%@", response.description);
                NSMutableDictionary *info = [_uploadFileList objectAtIndex:indexPath.row];
                [info setValue:@"YES" forKey:@"uploaded"];
                [_tableView reloadData];
                
//                listCell.detailTextLabel.text = [[response  objectForKey:@"entities"] objectForKey:@"size"];
                
                [progressView removeFromSuperview];
            }
            failureBlock:^(NSError *error){
                NSLog(@"error : %@, %@", error.description, error.domain);
                listCell.detailTextLabel.text = error.description;
                [progressView removeFromSuperview];
            }
            progressBlock:^(float progress){
                NSLog(@"progress : %f", progress);
                progressView.progress = progress;
            }];
        
    }
    return listCell;
}

@end
