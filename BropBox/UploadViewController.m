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
//        _tableView.delegate = self;
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
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes =
            [UIImagePickerController availableMediaTypesForSourceType:
                    UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:^(void){}];
}

- (void)fileUpload:(NSDictionary *)info{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:info];
    [dictionary setValue:nil forKey:@"uploadedInfo"];

    UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    CGRect frame = progressView.frame;
    frame.origin.x +=45;
    frame.origin.y +=30;
    frame.size.width = self.view.frame.size.width - 50;
    progressView.frame = frame;
    [dictionary setObject:progressView forKey:@"progressView"];

    int index = [_uploadFileList count];
    [_uploadFileList insertObject:dictionary atIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0] ;

    NSData *data = nil;

    if ([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqualToString:@"public.movie"]) {
        NSURL * furl = [info objectForKey:@"UIImagePickerControllerMediaURL"];
        data = [NSData dataWithContentsOfURL:furl];
    } else{
        UIImage *image = [dictionary objectForKey:@"UIImagePickerControllerOriginalImage"];
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    FileUtils *fileUtils = [[FileUtils alloc]init];
    [fileUtils upload:data
        successBlock:^(NSDictionary *response){
            NSLog(@"response : %@", response.description);
            NSMutableDictionary *uploadedInfo = [NSMutableDictionary dictionary];
            for (NSDictionary *dic in [response  objectForKey:@"entities"]){
                float size = [[dic objectForKey:@"size"] floatValue];
                if (size !=  0){
                    [uploadedInfo setValue:[NSString stringWithFormat:@"%f",size / 1000.f ] forKey:@"size"];
                    [uploadedInfo setValue:[dic objectForKey:@"modified"] forKey:@"date"];

                    break;
                }
            }
            [dictionary setValue:uploadedInfo forKey:@"uploadedInfo"];

            //insert directories Collection
            NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
            UGClient *client = [[UGClient alloc] initWithApplicationID:BAAS_APPLICATION_ID];
            [client setLogging:NO];
            [client setAuth:access_token];

            NSMutableDictionary *entity = [NSMutableDictionary dictionaryWithDictionary:response];
            [entity setObject:@"directories" forKey:@"type"];
            [entity setObject:[dictionary objectForKey:@"filename"] forKey:@"filename"];

            UGClientResponse *clientResponse = [client createEntity:entity];
            NSLog(@"response.transactionID : %i", clientResponse.transactionID);

            UIProgressView *progressView = (UIProgressView *)[dictionary objectForKey:@"progressView"];
            [progressView removeFromSuperview];
            [dictionary removeObjectForKey:@"progressView"];

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


    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^(void){}];

    NSURL *url = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:url
                  resultBlock:^(ALAsset *asset){
                      ALAssetRepresentation *rep = [asset defaultRepresentation];
                      NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:info];
                      [dictionary setObject:rep.filename forKey:@"filename"];
                      [self fileUpload:dictionary];
                  }
                 failureBlock:^(NSError *err) {
                     NSLog(@"Error: %@",[err localizedDescription]);
                 }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _uploadFileList.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"uploadCell";

    UITableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (listCell == nil) {
        listCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }

    __block NSMutableDictionary *info = [_uploadFileList objectAtIndex:indexPath.row];

    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    listCell.imageView.image = image;
    listCell.textLabel.font = [UIFont boldSystemFontOfSize:17.];

    NSString *filename = [info objectForKey:@"filename"];
    if (filename != nil){
        listCell.textLabel.text = filename;
    } else{
        listCell.textLabel.text = @"Uploading...";
        listCell.detailTextLabel.text = @" ";

    }

    NSMutableDictionary *uploadedInfo = [info objectForKey:@"uploadedInfo"];
    UIProgressView *progressView = (UIProgressView *)[info objectForKey:@"progressView"];

    if (uploadedInfo != nil) {
        int fSize = [[uploadedInfo objectForKey:@"size"] intValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[uploadedInfo objectForKey:@"date"]longLongValue] / 1000 ];

        listCell.textLabel.text = filename;
        listCell.detailTextLabel.text = [NSString stringWithFormat:@"%iKB, %@", fSize, date.description];
    }else{
         if(progressView) [listCell addSubview:progressView];
    }

    return listCell;
}

@end
