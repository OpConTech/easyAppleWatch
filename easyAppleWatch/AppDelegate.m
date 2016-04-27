//
//  AppDelegate.m
//  easyAppleWatch
//
//  Created by Thomas Neary on 4/27/16.
//  Copyright © 2016 OpCon Technologies, Inc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // If network is reachable ready the Apple Watch
    [self readyTheAppleWatch];
    
    return YES;
}


- (void)readyTheAppleWatch
{
    
    NSLog(@"Checking for Apple Watch...");
    
    if ([WCSession isSupported]) {
        WCSession *watchSession = [WCSession defaultSession];
        watchSession.delegate = self;
        [watchSession activateSession];
        
        if (watchSession.paired) {
            NSLog(@"WatchSession is Paired and Ready √");
        }
        
        if (watchSession.watchAppInstalled == NO) {
            
            NSLog(@"WatchKit app is not installed");
            
        } else {
            
            NSLog(@"KnowledgeKeeper for Apple Watch is Installed on Watch √");
            // Do Something...
            
        }
        
    } else {
        
        NSLog(@"WatchConnectivity is not supported on this device");
    }
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIApplication *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier bgTask = 0;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
}



-(void)session:(WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)dataFromWatch replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * _Nonnull))reply
{
    
    NSLog(@"handleWatchKitExtensionRequest:(NSDictionary *)userInfo -- Request No %@ is From: %@", [dataFromWatch objectForKey:@"requestNumber"], [dataFromWatch objectForKey:@"requestFrom"]);
    //NSLog(@"handleWatchKitExtensionRequest:(NSDictionary *)userInfo -- The Request is From: %@", [userInfo valueForKey:@"requestFrom"]);
                                    
    // Setup results dictionary...
    NSDictionary *result = [[NSMutableDictionary alloc] init];
    
    // Setup dictionary to send to Apple Watch
    result = @{@"Data Point One From iPhone": @(1), @"Data Point Two From iPhone": @(2), @"Data Point Three From iPhone": @"Hello Apple Watch!"};

    // Sending to Apple Watch
    NSLog(@"Sending Reply Back to GLANCE");
    reply(result);
    
} 

@end
