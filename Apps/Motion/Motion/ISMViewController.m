//
//  ISMViewController.m
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISMViewController.h"

@interface ISMViewController ()
@end

@implementation ISMViewController

@synthesize dataSaver, managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Managed Object Context for Data_CollectorAppDelegate
    if (managedObjectContext == nil) {
        managedObjectContext = [(ISMAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    // DataSaver from Data_CollectorAppDelegate
    if (dataSaver == nil)
        dataSaver = [(ISMAppDelegate *) [[UIApplication sharedApplication] delegate] dataSaver];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopOnClick:(id)sender {
    
    QueueUploaderView *queueUploader = [[QueueUploaderView alloc] initWithParentName:PARENT_AUTOMATIC];
    queueUploader.title = @"Step 3: Upload";
    [self.navigationController pushViewController:queueUploader animated:YES];

}
@end
