//
//  InterfaceController.m
//  easyAppleWatchApp Extension
//
//  Created by Thomas Neary on 4/27/16.
//  Copyright © 2016 OpCon Technologies, Inc. All rights reserved.
//

#import "InterfaceController.h"

@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    // Open the Session Tunnel to the iPhone
    if ([WCSession isSupported]) {
        
        NSLog(@"Apple Watch: WC Session is Supported...");
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        
    }
    
    // Fire a Request to the iPhone
    if ([[WCSession defaultSession] isReachable]) {
        
        NSLog(@"And the iPhone is Reachable...");
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self comminicateToiPhone];
            
        });
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (void)comminicateToiPhone {
    
    // Use openParentApp to get data from iPhone
    // if no data or error suggest to person that they need to login on the iPhone
    
    // Here we go...
    
    // Setup dictionary to send to iPhone
    NSDictionary *watchData = @{@"Data Point One From Watch": @(1), @"Data Point Two From Watch": @(2), @"Data Point Three From Watch": @"Hello iPhone World"};
    
    
    if ([[WCSession defaultSession] isReachable]) {
        NSLog(@"Data Ready to send to iPhone: %@", watchData);
        //NSDictionary *applicationDict = @{@"action": @"pause"};
        [[WCSession defaultSession] sendMessage:watchData replyHandler:^(NSDictionary *phoneData) {
            
            NSLog(@"Sending Data to iPhone...");
            
            // Receive iPhone Data
            NSLog(@"Reply From iPhone: %@", phoneData);
            
        }
         
           errorHandler:^(NSError *error) {
               
               // Log error
               NSLog(@"Error: %@", error);
               
        }];
        
    } else {
        
        //we aren't in range of the phone, they didn't bring it on their run
        
        NSLog(@"Unable to connect to iPhone");

        
    }
    

    
}


@end



