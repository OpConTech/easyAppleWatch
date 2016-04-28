//
//  DetailViewController.h
//  MasterDetail
//
//  Created by Thomas Neary on 4/27/16.
//  Copyright © 2016 OpCon Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

