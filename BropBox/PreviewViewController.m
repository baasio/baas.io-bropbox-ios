//
//  PreviewViewController.m
//  BropBox
//
//  Created by cetauri on 12. 10. 19..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "PreviewViewController.h"
#import <QuickLook/QuickLook.h>

@interface PreviewViewController (){
    QLPreviewController *previewController;
}

@end

@implementation PreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title  = @"미리보기";

        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49  - 44);
        previewController = [[QLPreviewController alloc] init];
        previewController.dataSource = self;
//        webView = [[UIWebView alloc] initWithFrame:frame];
        [self.view addSubview:previewController];
//        [webView loadHTMLString:@"IMG_3925.JPG" baseURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"file:/%@", NSTemporaryDirectory() ]]];
    }
    return self;
}

#pragma mark - QLPreviewControllerDelegate
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSString *documentLocation = [[NSBundle mainBundle] pathForResource:@"IMG_3925" ofType:@"JPG" inDirectory:NSTemporaryDirectory()];
    NSURL *qURL = [NSURL URLWithString:documentLocation];
    return qURL;
}

@end
