/*
 * iSENSE Project - isenseproject.org
 * This file is part of the iSENSE iOS API and applications.
 *
 * Copyright (c) 2015, University of Massachusetts Lowell. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer. Redistributions in binary
 * form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials
 * provided with the distribution. Neither the name of the University of
 * Massachusetts Lowell nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * BSD 3-Clause License
 * http://opensource.org/licenses/BSD-3-Clause
 *
 * Our work is supported by grants DRL-0735597, DRL-0735592, DRL-0546513, IIS-1123998,
 * and IIS-1123972 from the National Science Foundation and a gift from Google Inc.
 *
 */

//
// ISMProjectManager.m
// Motion
//
// Created by Mike Stowell on 9/9/14.
//

#import "ISMProjectManager.h"

@interface ISMProjectManager ()
@end

@implementation ISMProjectManager

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

    // set an observer for the field matched array caught from FieldMatching.  start by removing the observer
    // to reset any other potential observers registered
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveFieldMatchedArray:) name:kFIELD_MATCHED_ARRAY object:nil];
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

    // save the new project selection in prefs
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:[dm getProjectID] forKey:pPROJECT_ID];
    [prefs synchronize];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (alertView.tag) {
        case kPROJ_MANUAL_ENTRY_DIALOG:
        {
            if (buttonIndex != 0) {
                NSString *projAsString = [[alertView textFieldAtIndex:0] text];
                [dm setProjectID:[projAsString intValue]];
            
                [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %@", projAsString]];
            
                [self launchFieldMatchingViewControllerFromBrowse:FALSE];
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
    
    [self launchFieldMatchingViewControllerFromBrowse:TRUE];
}

// Each call to set a new project ID requires the user to explicitly field match
- (void) launchFieldMatchingViewControllerFromBrowse:(bool)fromBrowse {

    UIAlertView *message = [self getDispatchDialogWithMessage:@"Loading fields..."];
    [message show];
    
    dispatch_queue_t queue = dispatch_queue_create("loading_project_fields", NULL);
    dispatch_async(queue, ^{
        
        [dm retrieveProjectFields];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            // launch the field matching dialog
            FieldMatchingViewController *fmvc = [[FieldMatchingViewController alloc] initWithMatchedFields:[dm getRecognizedFields] andProjectFields:[dm getUserDefinedFields]];
            fmvc.title = @"Field Matching";
            
            [message dismissWithClickedButtonIndex:0 animated:NO];
            
            if (fromBrowse) {
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.navigationController pushViewController:fmvc animated:YES];
                });
            } else
                [self.navigationController pushViewController:fmvc animated:YES];            
        });
    });
}

// Retrieve the field-matched array and update DM
- (void) retrieveFieldMatchedArray:(NSNotification *)obj {
    
    NSMutableArray *fieldMatch =  (NSMutableArray *)[obj object];
    
    if (fieldMatch) {
        // user pressed okay button, so update the DM's fields with field-matched equivalents
        NSMutableArray *updatedProjectFields = [[NSMutableArray alloc] init];
        
        int index = 0;
        for (RProjectField *field in [dm getProjectFields]) {
            field.recognized_name = [fieldMatch objectAtIndex:index++];
            [updatedProjectFields addObject:field];
        }
        
        [dm setProjectFields:updatedProjectFields];

        // save the new project selection in prefs
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:[dm getProjectID] forKey:pPROJECT_ID];
        [prefs synchronize];
    }
    // else user canceled
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
