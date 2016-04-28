//
//  MasterViewController.m
//  MasterDetail
//
//  Created by Thomas Neary on 4/27/16.
//  Copyright © 2016 OpCon Technologies, Inc. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"


@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // If network is reachable ready the Apple Watch
    [self readyTheAppleWatch];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
    // Clear NSUserDefaults
    //[[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
    
    // Retrieve the Stored Data on the Device  (non mutable array...can't use in tableview)
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //self.objects = [defaults objectForKey:@"objects"];
    
    // Retrieve the Stored Data on the Device (mutable array to be used in tableview)
    // The array read out of NSUserDefaults is not a Mutable Array so copy it into a mutable array
    self.objects = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"objects"]];
    for(int i = 0; i < self.objects.count; i++) {
        NSArray *tempArray = self.objects[i];
        self.objects[i] = [tempArray mutableCopy];
    }

    //NSDictionary *dict = [NSDictionary dictionaryWithObject:self.objects forKey:@"Spaghetti"];
    //NSLog(@"Dictionary %@", dict);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    NSArray *spaghetti = @[@"Spaghetti Pasta", @"Tomato Sauce",  @"Meat Sauce", @"Meat Balls", @"Mmmmm Spaghetti"];
    [self.objects insertObject:[spaghetti objectAtIndex:(rand() % 5)] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // Store this Data on the Device
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.objects forKey:@"objects"];
    [defaults synchronize];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}




#pragma mark - Apple Watch

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
            
            NSLog(@"The App for Apple Watch is Installed on Watch √");
            // Do Something...
            
        }
        
    } else {
        
        NSLog(@"WatchConnectivity is not supported on this device");
    }
    
}


-(void)session:(WCSession *)session didReceiveMessage:(nonnull NSDictionary<NSString *,id> *)dataFromWatch replyHandler:(nonnull void (^)(NSDictionary<NSString *,id> * _Nonnull))reply
{// When Watch app is activated it will call to iPhone and this method will execute
    
    //
    // Receive Data back to the Watch
    //
    NSLog(@"handleWatchKitExtensionRequest:(NSDictionary *)userInfo -- Request No %@ is From: %@", [dataFromWatch objectForKey:@"requestNumber"], [dataFromWatch objectForKey:@"requestFrom"]);
    
    // Do Something...
    
    
    
    //
    // Send Data back to the Watch
    //
    
    // Retrieve the Stored Data on the Device
    // The array read out of NSUserDefaults is not a Mutable Array so copy it into a mutable array
    self.objects = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"objects"]];
    for(int i = 0; i < self.objects.count; i++) {
        NSArray *tempArray = self.objects[i];
        self.objects[i] = [tempArray mutableCopy];
    }
    // Setup results dictionary
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.objects, @"Spaghetti",
                          [NSArray arrayWithObjects:@"Fettuccine Pasta", @"Alfredo Sauce", nil], @"Fettuccine Alfredo",
                          [NSArray arrayWithObjects:@"Lettuce", @"Grilled Chicken", @"Croutons", nil], @"Grilled Chicken Salad",
                          nil];
    // Push to Apple Watch
    NSLog(@"Sending Reply Back to Watch App");
    reply(result);
    
}

@end
