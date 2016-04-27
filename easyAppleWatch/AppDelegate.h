//
//  AppDelegate.h
//  easyAppleWatch
//
//  Created by Thomas Neary on 4/27/16.
//  Copyright © 2016 OpCon Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

