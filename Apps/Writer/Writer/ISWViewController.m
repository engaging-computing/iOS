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
    [self checkAPIOnDev];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [api loadCurrentUserFromPrefs];
    });

    // Load the last used project from prefs, if available
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int projID = [prefs integerForKey:kPREFS_PROJ];
    if (projID > 0) {

        dm = [DataManager getInstance];
        [dm setProjectID:projID];
        [dm retrieveProjectFields];
    }

    // Set the data set name label to be our secret dev/non-dev switch
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDev)];
    tapGestureRecognizer.numberOfTapsRequired = 7;
    [dataSetNameLbl addGestureRecognizer:tapGestureRecognizer];
    dataSetNameLbl.userInteractionEnabled = YES;

    // Attach the data set name text field to the application delegate to restrict character input
    dataSetNameTxt.delegate = self;
    dataSetNameTxt.returnKeyType = UIReturnKeyDone;
    dataSetNameTxt.tag = kDATA_SET_NAME_TAG;

    // Set navigation bar color
    @try {
        if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]) {
            // for iOS 7 and higher devices
            [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
            [self.navigationController.navigationBar setTintColor:UIColorFromHex(0xFFFFFF)];
            [self.navigationController.navigationBar setBarTintColor:UIColorFromHex(0x89D986)];
        } else {
            // for iOS 6 and lower devices
            [self.navigationController.navigationBar setTintColor:UIColorFromHex(0x89D986)];
        }
    } @catch (NSException *e) {
        // could not set navigation color - ignore the error
    }

    // make table clear
    contentView.backgroundColor = [UIColor clearColor];
    contentView.backgroundView = nil;
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
    }

    // reload the content view
    [contentView reloadData];

    // save the project in preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:projID forKey:kPREFS_PROJ];
    [prefs synchronize];
}

- (void)viewWillDisappear:(BOOL)animated {

    // remove the keyboard observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

        NSMutableArray *arr = [dataToUpload objectForKey:fieldID];

        // if array does not yet exist, create it
        if (!arr) {
            arr = [[NSMutableArray alloc] init];
            [dataToUpload setObject:arr forKey:fieldID];
        }

        NSString *data = ((FieldData *)[dataArr objectAtIndex:i++]).fieldData;
        if (data == nil) data = @"";

        [arr addObject:data];
    }
}

- (IBAction)saveDataSetBtnOnClick:(id)sender {
    // TODO
}

- (IBAction)credentialBarBtnOnClick:(id)sender {

    [self createCredentialManagerDialog];
}

- (IBAction)uploadBtnOnClick:(id)sender {

    QueueUploaderView *queueUploader = [[QueueUploaderView alloc] initWithParentName:PARENT_MOTION andDelegate:self];
    queueUploader.title = @"Upload";
    [self.navigationController pushViewController:queueUploader animated:YES];
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

    NSString *cellIdentifier = [NSString stringWithFormat:@"FieldCellIdentifier%d", indexPath.row];
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
    //cell.fieldDataTxt.returnKeyType = UIReturnKeyDone;

    // add a done button to the keyboard
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
    cell.fieldDataTxt.inputAccessoryView = keyboardDoneButtonView;


    // set up the cell depending on the type of field data
    if (tmp.fieldType.intValue == TYPE_TIMESTAMP) {

        // TODO

    } else if (tmp.fieldType.intValue == TYPE_NUMBER) {

        // TODO
        cell.fieldDataTxt.keyboardType = UIKeyboardTypeNumberPad;

    } else if (tmp.fieldType.intValue == TYPE_LAT || tmp.fieldType.intValue == TYPE_LON) {

        // TODO

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
    int padding = textFieldHeight;// * 3 / 2;

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

#pragma end - Keyboard code

#pragma mark - UITextField code


- (void)textFieldDidBeginEditing:(UITextField *)textField {

    if (!isKeyboardDisplaying)
        activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    [textField resignFirstResponder];

    if (activeTextField != nil && activeTextField.tag == kDATA_SET_NAME_TAG) {
        // textfield is data set name - do not need to save data in the dataArr
        return;
    }

    // retrieve the cell at the given indexPath using the UITextField's tag that was assigned in cellForRowAtIndexPath
    FieldCell *editCell = (FieldCell *) [contentView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    NSString *dataStr = editCell.fieldDataTxt.text;

    // store the data in the data array now that the user is no longer editing the cell
    FieldData *data = [dataArr objectAtIndex:textField.tag];
    data.fieldData = dataStr;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

// restrict length of text entered
// 90 is chosen because 128 is the limit on iSENSE, and the app will eventually append
// a ~20 character timestamp to the data set name
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength <= 90);
}

#pragma end - UITextField code

#pragma mark - iSENSE and API code

- (void)toggleDev {

    [api useDev:![api isUsingDev]];
    [self.view makeWaffle:([api isUsingDev] ? @"Using dev" : @"Using production")];
    [self checkAPIOnDev];
}

- (void)checkAPIOnDev {

    if ([api isUsingDev]) {
        devLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 30)];
        devLbl.font = [UIFont fontWithName:@"Helvetica" size:8];
        devLbl.backgroundColor = [UIColor clearColor];
        devLbl.text = @"USING DEV";
        devLbl.textColor = [UIColor redColor];
        [self.view addSubview:devLbl];
    } else if (devLbl) {
        [devLbl removeFromSuperview];
    }
}

- (void)didPressLogin:(CredentialManager *)mngr {

    [credentialMgrAlert dismissWithClickedButtonIndex:0 animated:NO];
    credentialMgrAlert = nil;

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

    credentialMgr = [[CredentialManager alloc] initWithDelegate:self];
    DLAVAlertViewController *parent = [DLAVAlertViewController sharedController];
    [parent addChildViewController:credentialMgr];

    credentialMgrAlert = [[DLAVAlertView alloc] initWithTitle:@"Account Credentials"
                                                      message:@"Need an account? Visit isenseproject.org/users/new to register."
                                                     delegate:nil
                                            cancelButtonTitle:@"Close"
                                            otherButtonTitles:nil];


    [credentialMgrAlert setContentView:credentialMgr.view];
    [credentialMgrAlert setDismissesOnBackdropTap:YES];
    [credentialMgrAlert show];
}

#pragma mark - iSENSE and API code

#pragma mark - UIAlertView code

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    // TODO add cases for alert dialogs
    switch (alertView.tag) {

        case kLOGIN_DIALOG_TAG:
        {
            NSString *user = [alertView textFieldAtIndex:0].text;
            NSString *pass = [alertView textFieldAtIndex:1].text;

            if ([user length] != 0 && [pass length] !=0)
                [self login:user withPassword:pass];

            break;
        }
        case kVISUALIZE_DIALOG_TAG:
        {
            if (buttonIndex != 0) {
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

@end
