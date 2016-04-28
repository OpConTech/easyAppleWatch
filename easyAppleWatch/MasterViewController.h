//
//  MasterViewController.h
//  MasterDetail
//
//  Created by Thomas Neary on 4/27/16.
//  Copyright © 2016 OpCon Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <WCSessionDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

