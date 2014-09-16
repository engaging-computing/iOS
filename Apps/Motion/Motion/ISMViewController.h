//
//  ISMViewController.h
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueueUploaderView.h"

@interface ISMViewController : UIViewController {
    
}

// Queue Saver Variables
@property (nonatomic, strong) DataSaver              *dataSaver;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *credentialBarBtn;

@property (weak, nonatomic) IBOutlet UIButton *startStopBtn;
- (IBAction)startStopOnClick:(id)sender;

@end