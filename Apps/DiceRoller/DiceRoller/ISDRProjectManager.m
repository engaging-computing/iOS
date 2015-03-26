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
    
    bool projectValid = [self projectHasValidFields];
    
    if (projectValid) {
        
        int curProjID = [dm getProjectID];
        NSString *curProjIDStr = (curProjID > 100) ? [NSString stringWithFormat:@"%d", curProjID] : kNO_PROJECT;
        [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %@", curProjIDStr]];
        [dm setProjectID:curProjID];
        } else {
        
        // If we are in here it means that the project selected does not have properly formatted fields.
        // Present an error message to the user and set project back to default project.
        [self.view makeWaffle:@"Error: Selected Project did not have properly formatted fields. " duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        int curProjID = 876;
        [dm setProjectID:curProjID];
        NSString *curProjIDStr = (curProjID > 100) ? [NSString stringWithFormat:@"%d", curProjID] : kNO_PROJECT;
        [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %@", curProjIDStr]];
        [dm setProjectID:curProjID];
    }
}


- (bool) projectHasValidFields {
    
    //Checks whether a method has three fields named yellow, white and sum. If it the project does, then returns true. If not, returns false.
    
    bool hasWhiteDieField = false;
    bool hasYellowDieField = false;
    bool hasSumField = false;
    
    //Declares an instance of API
    api = [API getInstance];
    
    //Pulls down fields for the iSENSE project
    NSArray *projectFields = [api getProjectFieldsWithId:[dm getProjectID]];
    
    //Loop through all the project fields to see if they are the required fields.
    for (RProjectField *field in projectFields) {
        
        if ([field.name.lowercaseString rangeOfString:@"white"].location != NSNotFound) {
            // if we're here, this means the project has a field for the white die.
            hasWhiteDieField = true;
        } else if ([field.name.lowercaseString rangeOfString:@"yellow"].location != NSNotFound) {
            // if we're here, this means the project has a field for the yellow die.
            hasYellowDieField = true;
            
        } else if ([field.name.lowercaseString rangeOfString:@"sum"].location != NSNotFound) {
            // if we're here, this means the project has a field for the sum.
            hasSumField = true;
            
        }
    }
    
    //Check to see if all three booleans are true. If they are, the project is valid! If not the project is invalid.
    return (hasWhiteDieField && hasYellowDieField && hasSumField);
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
                bool projectisValid = [self projectHasValidFields];

                if(projectisValid){
                    
                    [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %@", projAsString]];
                    break;
                    
                }
                
                //Project entered does not have properly formatted fields.
                //Present an error message informing the user and set project back to default.
                
                [self.view makeWaffle:@"Error: Entered Project did not have properly formatted fields. " duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
                int curProjID = 876;
                [dm setProjectID:curProjID];
                NSString *curProjIDStr = (curProjID > 100) ? [NSString stringWithFormat:@"%d", curProjID] : kNO_PROJECT;
                [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %@", curProjIDStr]];
                break;
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
    [self dismissViewControllerAnimated:YES completion:nil];
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
