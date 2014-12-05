//
//  ISWViewController.m
//  Writer
//
//  Created by Mike Stowell on 11/4/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISWViewController.h"
#import "ISWAppDelegate.h"

@interface ISWViewController ()
@end

// Forward declared interface
@interface DLAVAlertViewController ()
+ (instancetype)sharedController;
- (void)setBackdropColor:(UIColor *)color;
- (void)addAlertView:(DLAVAlertView *)alertView;
- (void)removeAlertView:(DLAVAlertView *)alertView;
@end

@implementation ISWViewController

// Queue Saver Properties
@synthesize dataSaver, managedObjectContext;
// UI
@synthesize credentialBarBtn, dataSetNameLbl, dataSetNameTxt, projectBtn, saveRowBtn, saveDataSetBtn, contentView, uploadBtn;


#pragma mark - View and UI code

- (void)viewDidLoad {

    [super viewDidLoad];

    // Managed Object Context for ISWAppDelegate
    if (managedObjectContext == nil) {
        managedObjectContext = [(ISWAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }

    // DataSaver from ISWAppDelegate
    if (dataSaver == nil) {
        dataSaver = [(ISWAppDelegate *) [[UIApplication sharedApplication] delegate] dataSaver];
    }

    // Initialize API and start separate thread to reload any user that has been saved to preferences
    api = [API getInstance];
    [api useDev:USE_DEV];
    [self createDevUILabel];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [api loadCurrentUserFromPrefs];
    });

    // Load the last used project from prefs, if available
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int projID = (int) [prefs integerForKey:kPREFS_PROJ];
    if (projID > 0) {

        dm = [DataManager getInstance];
        [dm setProjectID:projID];
        [dm retrieveProjectFields];
    }

    // Set disabled state text of the two save buttons
    [saveRowBtn setTitle:@"..." forState:UIControlStateDisabled];
    [saveDataSetBtn setTitle:@"..." forState:UIControlStateDisabled];

    // Create the keyboard toolbar with an attached "Done" button
    doneKeyboardView = [self createDoneKeyboardView];

    // Set the data set name label to be our secret dev/non-dev switch
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDev)];
    tapGestureRecognizer.numberOfTapsRequired = 7;
    [dataSetNameLbl addGestureRecognizer:tapGestureRecognizer];
    dataSetNameLbl.userInteractionEnabled = YES;

    // Attach the data set name text field to the application delegate to restrict character input
    dataSetNameTxt.delegate = self;
    dataSetNameTxt.inputAccessoryView = doneKeyboardView;
    dataSetNameTxt.tag = kDATA_SET_NAME_TAG;

    // Set navigation bar color
    @try {
        if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]) {
            // for iOS 7 and higher devices
            [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
            [self.navigationController.navigationBar setTintColor:UIColorFromHex(cNAV_WHITE_TINT)];
            [self.navigationController.navigationBar setBarTintColor:UIColorFromHex(cNAV_WRITER_GREEN_TINT)];
        } else {
            // for iOS 6 and lower devices
            [self.navigationController.navigationBar setTintColor:UIColorFromHex(cNAV_WRITER_GREEN_TINT)];
        }
    } @catch (NSException *e) {
        // could not set navigation color - ignore the error
    }

    // make table clear
    contentView.backgroundColor = [UIColor clearColor];
    contentView.backgroundView = nil;

    // present dialog if location is not authorized yet
    [self isLocationAuthorized];
}

- (void)viewWillAppear:(BOOL)animated {

    dm = [DataManager getInstance];

    // Add an observer to track the keyboard showing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];

    // get the fields for the project and display them for manual entry
    int projID = [dm getProjectID];
    if (projID > 0) {

        dataArr = [[NSMutableArray alloc] init];
        NSArray *fields = [dm getProjectFields];

        for (RProjectField *field in fields) {

            FieldData *data = [[FieldData alloc] init];
            data.fieldName = field.name;
            data.fieldType = field.type;
            [dataArr addObject:data];
        }

        // save the project in preferences
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:projID forKey:kPREFS_PROJ];
        [prefs synchronize];
    }

    // set the project button text
    [projectBtn setTitle:[NSString stringWithFormat:@"Uploading to Project: %@",
                          (projID > 0 ? [NSNumber numberWithInt:projID] : kNO_PROJECT)]
                forState:UIControlStateNormal];

    // reload the content view
    [contentView layoutIfNeeded];
    [contentView reloadData];

    // initialize the location manager and register for updates
    [self registerLocationUpdates];

    // add timestamps and geospatial data to appropriate field cells
    [self setupTimeAndGeospatialData];
}

- (void)viewWillDisappear:(BOOL)animated {

    // remove the keyboard observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // unregister location updates
    [self unregisterLocationUpdates];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (IBAction)saveRowBtnOnClick:(id)sender {

    // if no project has been set yet, do not enable row saving
    int projectID = [dm getProjectID];
    if (projectID <= 0) {

        [self.view makeWaffle:@"Cannot save data without a project" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        return;
    }

    // get the project's field IDs from the DataManager
    NSArray *fieldIDs = [dm getProjectFieldIDs];

    // initialize the data dictionary if nil
    if (!dataToUpload) {

        dataToUpload = [[NSMutableDictionary alloc] init];
    }

    int i = 0;
    for (NSNumber *fieldID in fieldIDs) {

        NSMutableArray *arr = [dataToUpload objectForKey:[NSString stringWithFormat:@"%@", fieldID]];

        // if array does not yet exist, create it
        if (!arr) {

            arr = [[NSMutableArray alloc] init];
            [dataToUpload setObject:arr forKey:[NSString stringWithFormat:@"%@", fieldID]];
        }

        NSString *data = ((FieldData *)[dataArr objectAtIndex:i++]).fieldData;
        if (data == nil) {

            data = @"";
        }

        [arr addObject:data];
    }

    // reset the timestamps and geospatial data
    [self setupTimeAndGeospatialData];

    [self.view makeWaffle:@"Row of data saved" duration:WAFFLE_LENGTH_SHORT position:WAFFLE_BOTTOM image:WAFFLE_CHECKMARK];
}

- (IBAction)saveDataSetBtnOnClick:(id)sender {

    NSString *dataSetName = dataSetNameTxt.text;

    // saving data requires a data set name
    if (dataSetName.length == 0) {

        [self.view makeWaffle:@"Please enter a data set name first" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        return;
    }

    // saving data requires a project
    if ([dm getProjectID] <= 0) {

        [self.view makeWaffle:@"Please select a project to upload to" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        return;
    }

    // saving data requires data
    if (dataToUpload == nil || dataToUpload.count == 0) {

        [self.view makeWaffle:@"Please enter some data before saving" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        return;
    }

    // save the data set
    [dataSaver addDataSetWithContext:managedObjectContext
                                name:dataSetName
                          parentName:PARENT_WRITER
                         description:@"Recorded from iOS Writer"
                           projectID:[dm getProjectID]
                                data:[dataToUpload copy]
                          mediaPaths:nil
                          uploadable:true
                   hasInitialProject:true
                           andFields:nil];

    // reset the data dictionary
    dataToUpload = [[NSMutableDictionary alloc] init];

    [self.view makeWaffle:@"Data set saved" duration:WAFFLE_LENGTH_SHORT position:WAFFLE_BOTTOM image:WAFFLE_CHECKMARK];
}

- (IBAction)credentialBarBtnOnClick:(id)sender {

    [self createCredentialManagerDialog];
}

- (IBAction)uploadBtnOnClick:(id)sender {

    QueueUploaderView *queueUploader = [[QueueUploaderView alloc] initWithParentName:PARENT_WRITER andDelegate:self];
    queueUploader.title = @"Upload";
    [self.navigationController pushViewController:queueUploader animated:YES];
}

- (void) setSaveButtonsEnabled:(bool)enabled {

    saveRowBtn.enabled = enabled;
    saveDataSetBtn.enabled = enabled;
}

#pragma end - View and UI code

#pragma mark - TableView code

// There is a single column in this table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

// There are as many rows as there are DataSets
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return dataArr.count;
}

// Initialize a single object in the table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = [NSString stringWithFormat:@"FieldCellIdentifier%ld", (long)indexPath.row];
    FieldCell *cell = (FieldCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        UIViewController *tmpVC = [[UIViewController alloc] initWithNibName:@"FieldCell" bundle:nil];
        cell = (FieldCell *) tmpVC.view;
    }

    FieldData *tmp = [dataArr objectAtIndex:indexPath.row];

    [cell setupCellWithField:tmp.fieldName andData:tmp.fieldData];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    // tag the cell's UITextField with the indexPath of the cell
    cell.fieldDataTxt.tag = indexPath.row;
    cell.fieldDataTxt.delegate = self;

    // add a done button to the keyboard
    cell.fieldDataTxt.inputAccessoryView = doneKeyboardView;

    // set up the cell textfields depending on the type of field data
    if (tmp.fieldType.intValue == TYPE_TIMESTAMP || tmp.fieldType.intValue == TYPE_LAT || tmp.fieldType.intValue == TYPE_LON) {

        // disable timestamp and geospatial fields
        cell.fieldDataTxt.enabled = false;
        cell.fieldDataTxt.backgroundColor = UIColorFromHex(cTEXT_FIELD_DISABLED);

    } else if (tmp.fieldType.intValue == TYPE_NUMBER) {

        // set numbers only for numeric fields
        cell.fieldDataTxt.keyboardType = UIKeyboardTypeNumberPad;
    }

    return cell;
}

#pragma end - TableView code

#pragma mark - Keyboard code

- (void)keyboardWillShow:(NSNotification *)notification {

    if (!isKeyboardDisplaying) {

        isKeyboardDisplaying = true;

        CGRect dimen = [self getKeyboardDimensions:notification];
        [self animateTextFieldUp:true withKeyboardDimensions:dimen];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {

    if (isKeyboardDisplaying) {

        isKeyboardDisplaying = false;

        CGRect dimen = [self getKeyboardDimensions:notification];
        [self animateTextFieldUp:false withKeyboardDimensions:dimen];
    }
}

- (CGRect)getKeyboardDimensions:(NSNotification *)notification {

    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    return [keyboardFrameBegin CGRectValue];
}

- (void)animateTextFieldUp:(BOOL)up withKeyboardDimensions:(CGRect)dimen {

    const int keyboardHeight = dimen.size.height;

    int textFieldHeight = activeTextField.frame.size.height;
    int padding = textFieldHeight;

    if (activeTextField != nil && activeTextField.tag == kDATA_SET_NAME_TAG) {
        // do not consider a keyboard shift for the data set name textfield
        return;
    }

    // map the textfield's dimensions to the superview and get its Y coordinate
    CGPoint point = [activeTextField convertPoint:activeTextField.frame.origin toView:self.view];
    int textY = point.y;

    // calculate the remaining space in the view not overlapped by the keyboard
    int spaceAboveKeyboard = self.view.frame.size.height - keyboardHeight;

    if (textY < spaceAboveKeyboard - textFieldHeight) {
        // do not shift view up if the tapped textfield will be visible when the keyboard is shown
        return;
    }

    // if the textfield will be overlapped by the keyboard but also will be pushed too far up,
    // only push the view up to the height of the area above the keyboard (with some padding)
    int movementValue = (textY - textFieldHeight < keyboardHeight) ? (spaceAboveKeyboard - padding) : keyboardHeight;

    if (!up) {
        // reset the active text field if we're moving the keyboard back down
        activeTextField = nil;
    }

    // animate the keyboard
    const float movementDuration = 0.3f;
    int movementDirection = (up ? -movementValue : movementValue);

    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movementDirection);
    [UIView commitAnimations];
}

- (IBAction)doneClicked:(id)sender {

    [self.view endEditing:YES];
}

- (UIToolbar *) createDoneKeyboardView {

    // create a toolbar with a done button to be displayed over the keyboard
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *flexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:NULL];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexableItem, doneButton, nil]];

    // color the toolbar the same as the navigation bar
    @try {
        if ([UIToolbar instancesRespondToSelector:@selector(barTintColor)]) {
            // for iOS 7 and higher devices
            [keyboardDoneButtonView setBarStyle:UIBarStyleBlack];
            [keyboardDoneButtonView setTintColor:UIColorFromHex(cNAV_WHITE_TINT)];
            [keyboardDoneButtonView setBarTintColor:UIColorFromHex(cNAV_WRITER_GREEN_TINT)];
        } else {
            // for iOS 6 and lower devices
            [keyboardDoneButtonView setTintColor:UIColorFromHex(cNAV_WRITER_GREEN_TINT)];
        }
    } @catch (NSException *e) {
        // could not set toolbar color - ignore the error
    }

    return keyboardDoneButtonView;
}

#pragma end - Keyboard code

#pragma mark - UITextField code


- (void)textFieldDidBeginEditing:(UITextField *)textField {

    if (!isKeyboardDisplaying) {

        activeTextField = textField;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    [textField resignFirstResponder];

    if (activeTextField != nil && activeTextField.tag == kDATA_SET_NAME_TAG) {
        // textfield is data set name - do not need to save data in the dataArr
        return;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    // if the tag is a data textfield, save the new text entered into the data array
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField.tag != kDATA_SET_NAME_TAG) {

        FieldData *data = [dataArr objectAtIndex:textField.tag];
        data.fieldData = newText;
    }

    // restrict length of text entered
    // 90 is chosen because 128 is the limit on iSENSE, and the app will eventually append
    // a ~20 character timestamp to the data set name
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength <= 90);
}

#pragma end - UITextField code

#pragma mark - iSENSE and API code

- (void)toggleDev {

    [api useDev:![api isUsingDev]];
    [self.view makeWaffle:([api isUsingDev] ? @"Using dev" : @"Using production")];
    [self createDevUILabel];
}

- (void)createDevUILabel {

    if ([api isUsingDev]) {

        devLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 80, 30)];
        devLbl.font = [UIFont fontWithName:@"Helvetica" size:12];
        devLbl.backgroundColor = [UIColor clearColor];
        devLbl.text = @"USING DEV";
        devLbl.textColor = [UIColor redColor];
        [self.view addSubview:devLbl];

    } else if (devLbl) {

        [devLbl removeFromSuperview];
    }
}

- (void)didPressLogin:(CredentialManager *)mngr {

    [credentialMngrAlert dismissWithClickedButtonIndex:0 animated:NO];
    credentialMngrAlert = nil;

    UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login to iSENSE"
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"OK", nil];
    [loginAlert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    loginAlert.tag = kLOGIN_DIALOG_TAG;

    [loginAlert textFieldAtIndex:0].delegate = self;
    [loginAlert textFieldAtIndex:0].placeholder = @"Email";

    // since the CredentialManager takes a moment to dismiss and allow the login AlertView become a first responder,
    // we have to sleep the first responder action for 1.5 seconds.  this can be removed once the Credential Manager
    // is rewritten
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[loginAlert textFieldAtIndex:0] becomeFirstResponder];
    });

    [loginAlert textFieldAtIndex:1].delegate = self;

    [loginAlert show];
}

// Login to iSENSE
- (void)login:(NSString *)email withPassword:(NSString *)pass {

    UIAlertView *spinnerDialog = [self getDispatchDialogWithMessage:@"Logging in..."];
    [spinnerDialog show];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        RPerson *currUser = [api createSessionWithEmail:email andPassword:pass];

        dispatch_async(dispatch_get_main_queue(), ^{

            if (currUser != nil) {

                [self.view makeWaffle:[NSString stringWithFormat:@"Login as %@ successful", email]
                             duration:WAFFLE_LENGTH_SHORT
                             position:WAFFLE_BOTTOM
                                image:WAFFLE_CHECKMARK];
            } else {

                [self.view makeWaffle:@"Login failed"
                             duration:WAFFLE_LENGTH_SHORT
                             position:WAFFLE_BOTTOM
                                image:WAFFLE_RED_X];
            }
            [spinnerDialog dismissWithClickedButtonIndex:0 animated:YES];
        });
    });
}

- (void)didFinishUploadingDataWithStatus:(QueueUploadStatus *)status {

    int uploadStatus = [status getStatus];
    int project = [status getProject];
    int dataSetID = [status getDataSetID];

    if (uploadStatus == DATA_NONE_UPLOADED) {

        [self.view makeWaffle:@"No data uploaded"];
        return;

    } else if (uploadStatus == DATA_UPLOAD_FAILED && project <= 0) {

        [self.view makeWaffle:@"All data set(s) failed to upload" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        return;
    }

    NSString *prependMessage = (uploadStatus == DATA_UPLOAD_FAILED) ?
    @"Some data set(s) failed to upload, but at least one succeeded." :
    @"All data set(s) uploaded successfully.";

    NSString *message = [NSString stringWithFormat:@"%@ Would you like to visualize the last successfully uploaded data set?", prependMessage];

    UIAlertView *visDataAlert = [[UIAlertView alloc] initWithTitle:@"Visualize Data"
                                                           message:message
                                                          delegate:self
                                                 cancelButtonTitle:@"No"
                                                 otherButtonTitles:@"Yes", nil];
    visDataAlert.tag = kVISUALIZE_DIALOG_TAG;
    [visDataAlert show];

    visURL = [NSString stringWithFormat:@"%@/projects/%d/data_sets/%d?embed=true",
              [api isUsingDev] ? BASE_DEV_URL : BASE_LIVE_URL,
              project, dataSetID];
}


- (void)createCredentialManagerDialog {

    credentialMngr = [[CredentialManager alloc] initWithDelegate:self];
    DLAVAlertViewController *parent = [DLAVAlertViewController sharedController];
    [parent addChildViewController:credentialMngr];

    credentialMngrAlert = [[DLAVAlertView alloc] initWithTitle:@"Account Credentials"
                                                      message:@"Need an account? Visit isenseproject.org/users/new to register."
                                                     delegate:nil
                                            cancelButtonTitle:@"Close"
                                            otherButtonTitles:nil];


    [credentialMngrAlert setContentView:credentialMngr.view];
    [credentialMngrAlert setDismissesOnBackdropTap:YES];
    [credentialMngrAlert show];
}

#pragma mark - iSENSE and API code

#pragma mark - UIAlertView code

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (alertView.tag) {

        case kLOGIN_DIALOG_TAG:
        {
            NSString *user = [alertView textFieldAtIndex:0].text;
            NSString *pass = [alertView textFieldAtIndex:1].text;

            if ([user length] != 0 && [pass length] !=0)
                [self login:user withPassword:pass];

            break;
        }
        case kLOCATION_DIALOG_IOS_8_AND_LATER_TAG:
        case kLOCATION_DIALOG_IOS_7_AND_EARLIER_TAG:
        {
            if (buttonIndex == OPTION_CANCELED) {

                // user does not wish to have location data recorded, save this choice in prefs
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setBool:true forKey:kOPT_OUT_LOCATION];
                [prefs synchronize];

                return;
            }

            if (alertView.tag == kLOCATION_DIALOG_IOS_8_AND_LATER_TAG) {

                // Send the user to the Settings for this app to allow them to change location settings.
                @try {

                    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:settingsURL];

                } @catch (NSException *e) {

                    // in the event that versions beyond iOS 8 re-disable the ability to launch app settings, we will
                    // display a dialog to the user
                    alertView = [[UIAlertView alloc] initWithTitle:@"Cannot navigate to settings"
                                                           message:@"We are sorry, but it seems Apple disabled our ability to bring you to the settings.  Please manually go to the Location Services settings and enable location updates for this app."
                                                          delegate:self
                                                 cancelButtonTitle:@"Okay"
                                                 otherButtonTitles:nil];
                    [alertView show];
                }
            }
            
            break;
        }
        case kVISUALIZE_DIALOG_TAG:
        {
            if (buttonIndex != OPTION_CANCELED) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:visURL]];
            }

            break;
        }
        default:
        {
            break;
        }
    }
}

// Default dispatch_async dialog with custom spinner
- (UIAlertView *)getDispatchDialogWithMessage:(NSString *)dString {

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

#pragma end - UIAlertView code

#pragma mark - Location

// Initializes the location manager to begin receiving location updates
- (void) registerLocationUpdates {

    if (!locationManager) {

        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;

        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }

    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }

    [locationManager startUpdatingLocation];
}

// Stops the location manager from receiving location updates
- (void) unregisterLocationUpdates {

    if (locationManager)
        [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
}

// check to see if the location was authorized for use (iOS 8 and later)
- (BOOL) isLocationAuthorized {

    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL userOptOutLocation = [prefs boolForKey:kOPT_OUT_LOCATION];

    // If the status is denied and user hasn't yet opted out entirely from being tracked, display an alert that can take the
    // user to the settings to enable location.  Note this only works in iOS 8 and above since the settings access API has been
    // removed in iOS versions 5 and 6.  By checking that this app responds to isOperatingSystemAtLeastVersion, we can tell
    // if this app is running on a device greater than iOS 8.  For all other versions, we will show a dialog that asks the user
    // to manually navigate to settings to enable location.
    if (!userOptOutLocation && status == kCLAuthorizationStatusDenied) {

        NSString *title = @"Location services are off";
        NSString *message;
        UIAlertView *alertView;

        if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {

            message = @"This app requires location data.  To enable location, select 'Settings' and turn on 'While Using the App' in the Location settings.  Select 'Cancel' if you do not wish to have your location recorded.";

            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Settings", nil];
            alertView.tag = kLOCATION_DIALOG_IOS_8_AND_LATER_TAG;

        } else {

            message = @"This app requires location data.  To enable location, navigate to the Location Services in Settings and turn on location for this application.  To be warned again when location is turned off for this app, select 'Okay'.  If you do not wish to have your location recorded, select 'Cancel'.";

            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Okay", nil];
            alertView.tag = kLOCATION_DIALOG_IOS_7_AND_EARLIER_TAG;
            
        }
        
        [alertView show];
        return false;
    }
    
    return true;
}

#pragma end - Location

#pragma mark - Data setup

- (void)setupTimeAndGeospatialData {

    for (int i = 0; i < dataArr.count; i++) {

        FieldCell *cell = (FieldCell *) [contentView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        FieldData *tmp = [dataArr objectAtIndex:i];

        // clear out pre-existing data
        tmp.fieldData = nil;

        // set up the cell depending on the type of field data
        if (tmp.fieldType.intValue == TYPE_TIMESTAMP) {

            // automatically fill in the timestamp
            NSString *timeStamp = [API getTimeStamp];
            tmp.fieldData = timeStamp;
            cell.fieldDataTxt.text = timeStamp;

        } else if (tmp.fieldType.intValue == TYPE_LAT || tmp.fieldType.intValue == TYPE_LON) {

            // automatically fill in geospatial data
            CLLocationCoordinate2D lc2d = [[locationManager location] coordinate];
            NSString *geospatialPoint = [NSString stringWithFormat:@"%f",
                                         (tmp.fieldType.intValue == TYPE_LAT ? lc2d.latitude : lc2d.longitude)];

            tmp.fieldData = geospatialPoint;
            cell.fieldDataTxt.text = geospatialPoint;

        } else {

            // reset any other text or numeric field
            cell.fieldDataTxt.text = @"";
        }
    }
}

#pragma end - Data setup

@end
