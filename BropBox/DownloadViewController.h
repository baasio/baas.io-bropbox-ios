//
//  DownloadViewController.h
//  BropBox
//
//  Created by cetauri on 12. 9. 18..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import <QuickLook/QuickLook.h>
#import <UIKit/UIKit.h>
#import <baas.io/baas.h>

@interface DownloadViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource>
- (void)download:(NSDictionary *)info;
@end
