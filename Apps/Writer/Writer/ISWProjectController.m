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
// ISWProjectController.m
// Writer
//
// Created by Mike Stowell on 11/5/14.
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (alertView.tag) {
        case kPROJ_MANUAL_ENTRY_DIALOG:
        {
            if (buttonIndex != 0) {
                NSString *projAsString = [[alertView textFieldAtIndex:0] text];
                [dm setProjectID:[projAsString intValue]];
                [dm retrieveProjectFields];

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

    [dm setProjectID:project_id];
    [dm retrieveProjectFields];

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

