//
//  ISDRProjectManager.m
//  iSENSE Dice Roller
//
//  Created by Rajia Abdelaziz Stowell on 11/28/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISDRProjectManager.h"

@interface ISDRProjectManager ()
@end

@implementation ISDRProjectManager

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
    
    pm = [ [ISDRProjectManager alloc] init];
    
    bool projectValid = [pm projectHasValidFields];
    
    //RAjaToDo So this only changes initally so depending on actual condition, is default project actully have correct fields and does project selected from browse projects actually have correct fields. We need to implement a check as well in the area where enter project button changes.
    if( projectValid ){
        
        int curProjID = [dm getProjectID];
        NSString *curProjIDStr = (curProjID > 100) ? [NSString stringWithFormat:@"%d", curProjID] : kNO_PROJECT;
        //RAjaToDo Changes Inital Text and when browse button is clicked.
        [projectLbl setText:[NSString stringWithFormat:@"WhatUploading to Project: %@", curProjIDStr]];
    }else{
        //Rajia: If we are in here it means that the project selected does not have properly formatted fields.
        //We need to present a statement informing the user.
        //Set back to default project.
        
        //Testing: Start off with correct project number and make sure that it uploads properly. Change via enter proj and make sure it does not upload. Finally, Change via browse and make sure uploads back to default.
        //RAjaToDo Testing Passed! Need to implement this same feature when project number is manually entered.
        [self.view makeWaffle:@"Error: Selected Project did not have properly formatted fields. " duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        int curProjID = 876;
        [dm setProjectID:curProjID];
        NSString *curProjIDStr = (curProjID > 100) ? [NSString stringWithFormat:@"%d", curProjID] : kNO_PROJECT;
        [projectLbl setText:[NSString stringWithFormat:@"WhatUploading to Project: %@", curProjIDStr]];

    }
}


- (bool) projectHasValidFields {
    //this still needs to be implemented.
    
    //Create an instance of dataManager
    //dm = [DataManager getInstance];
    
    if([dm getProjectID] <= 1000){
        return true;
    }
    else{
        return false;
    }
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
    //RajiaTODo Seems to never be encountered.
    [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %@", curProjIDStr]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case kPROJ_MANUAL_ENTRY_DIALOG:
        {
            if (buttonIndex != 0) {
                NSString *projAsString = [[alertView textFieldAtIndex:0] text];
                [dm setProjectID:[projAsString intValue]];
                bool projectisValid = [pm projectHasValidFields];

                if(projectisValid){
                    //RAjaToDo Changes when the project number that is entered is valid.
                    [projectLbl setText:[NSString stringWithFormat:@"NotUploading to Project: %@", projAsString]];
                }else{
                    //Rajia: If we are in here it means that the project entered does not have properly formatted fields.
                    //We need to present a statement informing the user.
                    //Set back to default project.
                    
                    //Testing: Start off with correct project number and make sure that it uploads properly. Change via enter proj and make sure it does not upload. Finally, Change via browse and make sure uploads back to default.
                    
                    [self.view makeWaffle:@"Error: Entered Project did not have properly formatted fields. " duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
                    
                    //Set back to default project
                    int curProjID = 876;
                    [dm setProjectID:curProjID];
                    NSString *curProjIDStr = (curProjID > 100) ? [NSString stringWithFormat:@"%d", curProjID] : kNO_PROJECT;
                    [projectLbl setText:[NSString stringWithFormat:@"WhatUploading to Project: %@", curProjIDStr]];
                    
                }

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
    [self presentViewController:browser animated:YES completion:nil];
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

- (IBAction)closeBtnOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
