//
//  ISWProjectController.m
//  Writer
//
//  Created by Mike Stowell on 11/5/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISWProjectController.h"

@interface ISWProjectController ()

@end

@implementation ISWProjectController

@synthesize projectLbl, enterProjIDBtn, browseProjBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dm = [DataManager getInstance];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    dm = [DataManager getInstance];
    int curProjID = [dm getProjectID];
    NSString *curProjIDStr = (curProjID > 0) ? [NSString stringWithFormat:@"%d", curProjID] : kNO_PROJECT;

    [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %@", curProjIDStr]];
}

- (void)viewDidLoad {

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (IBAction)enterProjIDBtnOnClick:(id)sender {

    // check for connectivity
    if (![API hasConnectivity]) {
        [self.view makeWaffle:@"No internet connectivity - cannot enter a project ID" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        return;
    }

    UIAlertView *enterProjAlert = [[UIAlertView alloc] initWithTitle:@"Enter Project ID #" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];

    enterProjAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    enterProjAlert.tag = kPROJ_MANUAL_ENTRY_DIALOG;

    [enterProjAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [enterProjAlert show];
}

- (IBAction)noProjBtnOnClick:(id)sender {

    [dm setProjectID:0];
    [dm retrieveProjectFields];

    NSString *curProjIDStr = kNO_PROJECT;
    [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %@", curProjIDStr]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (alertView.tag) {
        case kPROJ_MANUAL_ENTRY_DIALOG:
        {
            if (buttonIndex != 0) {
                NSString *projAsString = [[alertView textFieldAtIndex:0] text];
                [dm setProjectID:[projAsString intValue]];

                [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %@", projAsString]];
            }
            break;
        }
        default:
            NSLog(@"Unrecognized dialog!");
            break;
    }
}

- (IBAction)browseProjBtnOnClick:(id)sender {

    // check for connectivity
    if (![API hasConnectivity]) {
        [self.view makeWaffle:@"No internet connectivity - cannot browse projects" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        return;
    }

    ProjectBrowserViewController *browser = [[ProjectBrowserViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:browser animated:YES];
}

- (void) didFinishChoosingProject:(ProjectBrowserViewController *) browser withID: (int) project_id {

    NSLog(@"ID = %d", project_id);
    [dm setProjectID:project_id];

    NSString *curProjIDStr = (project_id > 0) ? [NSString stringWithFormat:@"%d", project_id] : kNO_PROJECT;
    [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %@", curProjIDStr]];
}

// Default dispatch_async dialog with custom spinner
- (UIAlertView *) getDispatchDialogWithMessage:(NSString *)dString {

    UIAlertView *message = [[UIAlertView alloc] initWithTitle:dString
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(139.5, 75.5);
    [message addSubview:spinner];
    [spinner startAnimating];
    return message;
}

@end

