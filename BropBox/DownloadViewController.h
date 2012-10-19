//
//  DownloadViewController.h
//  BropBox
//
//  Created by cetauri on 12. 9. 18..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>
- (void)download:(NSDictionary *)info;
@end
