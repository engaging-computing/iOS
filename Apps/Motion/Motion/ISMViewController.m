//
//  ISMViewController.m
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISMViewController.h"
#import "QueueUploaderView.h"

@interface ISMViewController ()

@end

@implementation ISMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    QueueUploaderView *queueUploader = [[QueueUploaderView alloc] initWithParentName:PARENT_AUTOMATIC];
    queueUploader.title = @"Step 3: Upload";
    [self.navigationController pushViewController:queueUploader animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
