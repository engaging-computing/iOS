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
// ISWViewController.h
// Writer
//
// Created by Mike Stowell on 11/4/14.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Constants.h"
#import "API.h"
#import "DataManager.h"
#import "QueueUploaderView.h"
#import "CredentialManager.h"
#import "DLAVAlertViewController.h"
#import "Waffle.h"
#import "FieldCell.h"
#import "FieldData.h"
#import "GlobalColors.h"

#define USE_DEV false

@interface ISWViewController : UIViewController
    <UIAlertViewDelegate, UITextFieldDelegate, CredentialManagerDelegate, QueueUploaderDelegate,
    UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIPickerViewDelegate,
    UIPickerViewDataSource> {

    // iSENSE API, DataManager, and dev switch
    API *api;
    DataManager *dm;
    UILabel *devLbl;

    // Credentials
    CredentialManager *credentialMngr;
    DLAVAlertView *credentialMngrAlert;

    // Location Manager
    CLLocationManager *locationManager;

    // Visualization URL constructed after data is uploaded
    NSString *visURL;

    // Array to hold data for manual entry
    NSMutableArray *dataArr;

    // Dictionary of data to upload
    NSMutableDictionary *dataToUpload;

    // Current data source array for a restricted text field's picker view
    NSArray *pickerDataSource;

    // Reference to the active TextField, last clicked TextField, and current keyboard display
    // The active TextField is the TextField used to display the keyboard/picker, whereas the
    // last clicked TextField is always whatever was tapped last
    UITextField *activeTextField;
    UITextField *lastClickedTextField;
    bool isKeyboardDisplaying;

    // Toolbar with a "Done" button to be attached to all textfield keyboards
    UIToolbar *doneKeyboardView;

    // Amount of pixels the keyboard was shifted
    int keyboardShift;

    // Footer view for the table view
    UILabel *tableFooter;

    // UIView to display the splash screen and a boolean to track if it is displaying
    UIView *splashView;
    bool isSplashDisplaying;
}

// Queue Saver properties
@property (nonatomic, strong) DataSaver *dataSaver;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// UI properties
@property (weak, nonatomic) IBOutlet UIBarButtonItem *credentialBarBtn;
- (IBAction)credentialBarBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarBtn;
- (IBAction)menuBarBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *dataSetNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *dataSetNameTxt;

@property (weak, nonatomic) IBOutlet UIButton *projectBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveRowBtn;
- (IBAction)saveRowBtnOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveDataSetBtn;
- (IBAction)saveDataSetBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadBtnOnClick:(id)sender;

@end

