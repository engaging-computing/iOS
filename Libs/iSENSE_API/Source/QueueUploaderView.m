//
// QueueUploaderView.m
// iSENSE_API
//
// Created by Jeremy Poulin on 6/26/13.
// Modified by Mike Stowell
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import "QueueUploaderView.h"

@implementation QueueUploaderView

@synthesize delegate, api, mTableView, currentIndex, dataSaver, managedObjectContext, lastClickedCellIndex, parent, limitedTempQueue;

- (IBAction)enterEditMode:(id)sender {

    [self setTableToEditMode:![self.mTableView isEditing]];
}

- (void)setTableToEditMode:(BOOL)isEditing {

    [self.mTableView setEditing:isEditing animated:YES];
    [self.editButtonItem setTitle:(isEditing ? @"Done" : @"Edit")];
}


- (id)initWithParentName:(NSString *)parentName andDelegate:(id <QueueUploaderDelegate>)delegateObj {

    self = [super init];

    if (self) {
        delegate = delegateObj;

        api = [API getInstance];
        parent = parentName;
        
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"iSENSE_API_Bundle" withExtension:@"bundle"];
        isenseBundle = [NSBundle bundleWithURL:bundleURL];
    }

    return self;
}

// Upload button control
- (IBAction)upload:(id)sender {

    // check for connectivity
    if (![API hasConnectivity]) {
        [self.view makeWaffle:@"No internet connectivity - cannot upload data" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
        return;
    }

    if ([api getCurrentUser] != nil) {

        UIAlertView *message = [self getDispatchDialogWithMessage:@"Uploading data sets..."];
        [message show];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            QueueUploadStatus *uploadStatus = [dataSaver upload:parent];

            dispatch_async(dispatch_get_main_queue(), ^{

                [self.delegate didFinishUploadingDataWithStatus:uploadStatus];
                
                [message dismissWithClickedButtonIndex:0 animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            });
        });

    } else {

        NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
        NSString *user = [prefs objectForKey:KEY_USERNAME];
        NSString *pass = [prefs objectForKey:KEY_PASSWORD];
        

        if (user == nil || pass == nil) {

            UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"Would you like to use a contributor key or login with an account?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Key", @"Account", nil];
            message.tag = QUEUE_SELECT_USER_OR_KEY;
            [message setAlertViewStyle:UIAlertViewStyleDefault];
            [message show];
        } else {
            [self loginAndUploadWithUsername:user withPassword:pass];
        }
    }
}

// displays the correct xib based on orientation and device type - called automatically upon view controller entry
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [isenseBundle loadNibNamed:@"QueueLayout-landscape"
                             owner:self
                           options:nil];
    } else {
        [isenseBundle loadNibNamed:@"QueueLayout"
                             owner:self
                           options:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:YES];
    
    // Autorotate
    [self willRotateToInterfaceOrientation:(self.interfaceOrientation) duration:0];
}

// Do any additional setup after loading the view.
- (void)viewDidLoad {

    [super viewDidLoad];
    
    // Note: if an app crashes while loading the QueueUploaderView, please check to ensure
    // the application's delegate has implemented a managedObjectContext and dataSaver
    // variable, named exactly like that.
    
    // Managed Object Context for App Delegate (where id = the application delegate)
    if (managedObjectContext == nil) {
        managedObjectContext = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    // Get dataSaver from the App Delegate
    if (dataSaver == nil) {
        dataSaver = [(id)[[UIApplication sharedApplication] delegate] dataSaver];
    }
    
    currentIndex = 0;
    
    // make table clear
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.backgroundView = nil;
    
    // Initialize My Limited Queue
    limitedTempQueue = [[NSMutableDictionary alloc] init];
    
    NSArray *keys = [dataSaver.dataQueue allKeys];
    for (int i = 0; i < keys.count; i++) {

        QDataSet *tmp = [dataSaver.dataQueue objectForKey:keys[i]];

        if ([tmp.parentName isEqualToString:parent]) {
            [limitedTempQueue setObject:tmp forKey:keys[i]];
        } else {
            // shouldn't get here: if user wants to remove garbage data sets,
            // he/she should first call by dataSetCountWithParentName: before
            // loading the QueueUploaderView.m.  Cleaning can't be done here or
            // else data sets with a new project can be treated as garbage, thus
            // changing a data set's project kills it completely.  And that's bad.
        }
    }
        
    self.editButtonItem.target = self;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.action = @selector(enterEditMode:);

    // set an observer for the field matched array caught from FieldMatching.  start by removing the observer
    // to reset any other potential observers registered
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveFieldMatchedArray:) name:kFIELD_MATCHED_ARRAY object:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    QueueCell *cell;

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        // Delete the row from the data source
        cell = (QueueCell *) [self.mTableView cellForRowAtIndexPath:indexPath];

        [limitedTempQueue removeObjectForKey:[cell getKey]];
        [dataSaver removeDataSet:[cell getKey]];

        [self.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.mTableView reloadData];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIAlertView *message;
    QueueCell *cell;
    
	switch (buttonIndex) {
            
        case QUEUE_RENAME:

            message = [[UIAlertView alloc] initWithTitle:@"Enter new data set name:"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"OK", nil];
            
            message.tag = QUEUE_RENAME;
            [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [message textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
            [message textFieldAtIndex:0].tag = TAG_QUEUE_RENAME;
            [message textFieldAtIndex:0].delegate = self;
            [message show];
            
            break;
            
        case QUEUE_CHANGE_DESC:

            message = [[UIAlertView alloc] initWithTitle:@"Enter new data set description:"
                                                 message:nil
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"OK", nil];
            
            message.tag = QUEUE_CHANGE_DESC;
            [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [message textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
            [message textFieldAtIndex:0].tag = TAG_QUEUE_DESC;
            [message textFieldAtIndex:0].delegate = self;
            [message show];
            
            break;
            
        case QUEUE_SELECT_PROJ:

            // check for connectivity
            if (![API hasConnectivity]) {
                [self.view makeWaffle:@"No internet connectivity - cannot select a project" duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM image:WAFFLE_RED_X];
                return;
            }
            
            cell = (QueueCell *) [self.mTableView cellForRowAtIndexPath:lastClickedCellIndex];
            if (![cell dataSetHasInitialProject]) {
                
                message = [[UIAlertView alloc] initWithTitle:nil
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Enter Project #", @"Browse Projects", nil];
                message.tag = QUEUE_SELECT_PROJ;
                [message show];
            }
            
			break;
            
		default:
			break;
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == QUEUE_LOGIN) {
        
        if (buttonIndex != OPTION_CANCELED) {
            NSString *usernameInput = [[alertView textFieldAtIndex:0] text];
            NSString *passwordInput = [[alertView textFieldAtIndex:1] text];
            [self loginAndUploadWithUsername:usernameInput withPassword:passwordInput];
        }
        
    } else if (alertView.tag == QUEUE_RENAME) {
        
        if (buttonIndex != OPTION_CANCELED) {
            
            NSString *newDataSetName = [[alertView textFieldAtIndex:0] text];
            QueueCell *cell = (QueueCell *) [self.mTableView cellForRowAtIndexPath:lastClickedCellIndex];
            [cell setDataSetName:newDataSetName];
        }
        
    } else if (alertView.tag == QUEUE_SELECT_PROJ) {
        
        if (buttonIndex == OPTION_ENTER_PROJECT) {
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Enter Project #:"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"OK", nil];
            
            message.tag = OPTION_PROJECT_MANUAL_ENTRY;
            [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [message textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
            [message textFieldAtIndex:0].tag = TAG_QUEUE_PROJ;
            [message textFieldAtIndex:0].delegate = self;
            [message show];
            
        } else if (buttonIndex == OPTION_BROWSE_PROJECTS) {
            
            ProjectBrowserViewController *browseView = [[ProjectBrowserViewController alloc] initWithDelegate:self];
            browseView.title = @"Browse Projects";
            [self.navigationController pushViewController:browseView animated:YES];
        }
        
    } else if (alertView.tag == OPTION_PROJECT_MANUAL_ENTRY) {
        
        if (buttonIndex != OPTION_CANCELED) {
            
            NSString *projIDString = [[alertView textFieldAtIndex:0] text];
            projID = [projIDString intValue];
            
            QueueCell *cell = (QueueCell *) [self.mTableView cellForRowAtIndexPath:lastClickedCellIndex];
            [cell setProjID:projIDString];
            [dataSaver editDataSetWithKey:cell.mKey andChangeProjIDTo:[NSNumber numberWithInt:projID]];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setInteger:projID forKey:KEY_PROJECT_ID];
            
            [self launchFieldMatchingViewControllerFromBrowse:FALSE];
        }
        
    } else if (alertView.tag == QUEUE_CHANGE_DESC) {
        
        if (buttonIndex != OPTION_CANCELED) {

            NSString *newDescription = [[alertView textFieldAtIndex:0] text];
            QueueCell *cell = (QueueCell *) [self.mTableView cellForRowAtIndexPath:lastClickedCellIndex];
            [cell setDesc:newDescription];
            [dataSaver editDataSetWithKey:cell.mKey andChangeDescription:newDescription];
        }

    } else if (alertView.tag == OPTION_APPLY_PROJ_AND_FIELDS) {

        if (buttonIndex != OPTION_CANCELED) {

            for (int i = 0; i < [mTableView numberOfRowsInSection:0]; i++) {

                QueueCell *thisCell = (QueueCell *) [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (![thisCell dataSetHasInitialProject] && ![thisCell dataSetSetupWithProjectAndFields]) {

                    // this cell does not currently have a project or fields, but the user wishes to
                    // assign the last chosen project/fields to it
                    [self setCell:thisCell withProjectID:projID andFields:lastSelectedFields];
                }
            }
        }

    } else if (alertView.tag == QUEUE_SELECT_USER_OR_KEY) {

        if (buttonIndex == INDEX_LOGIN) {

            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Okay", nil];
            message.tag = QUEUE_LOGIN;
            [message setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            [message show];

        } else if (buttonIndex == INDEX_CONTRIB_KEY) {

            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Enter Contributor Key"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Okay", nil];
            message.tag = QUEUE_CONTRIB_KEY;
            [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [message show];

        }

    } else if (alertView.tag == QUEUE_CONTRIB_KEY) {

        if (buttonIndex != OPTION_CANCELED) {

            NSString *contribKey = [[alertView textFieldAtIndex:0] text];
            NSLog(@"contribKey = %@", contribKey);
            [self loginAndUploadWithContributorKey:contribKey];
        }
    }

    [self.mTableView reloadData];
}

- (void)didFinishChoosingProject:(ProjectBrowserViewController *)browser withID:(int)project_id {

    projID = project_id;
    
    if (projID != 0) {
        QueueCell *cell = (QueueCell *) [self.mTableView cellForRowAtIndexPath:lastClickedCellIndex];
        
        [cell setProjID:[NSString stringWithFormat:@"%d", projID]];
        [cell.dataSet setProjID:[NSNumber numberWithInt:projID]];
        [dataSaver editDataSetWithKey:cell.mKey andChangeProjIDTo:[NSNumber numberWithInt:projID]];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:projID forKey:KEY_PROJECT_ID];
        
        [self launchFieldMatchingViewControllerFromBrowse:TRUE];
    }
}

// Dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

// Allows the device to rotate as necessary.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    // Overriden to allow any orientation.
    return YES;
}

// iOS6 enable rotation
- (BOOL)shouldAutorotate {

    return YES;
}

// iOS6 enable rotation
- (NSUInteger)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskAll;
}

// There is a single column in this table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

// There are as many rows as there are DataSets
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return limitedTempQueue.count;
}

// Initialize a single object in the table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIndetifier = @"QueueCellIdentifier";
    QueueCell *cell = (QueueCell *)[tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        UIViewController *tmpVC = [[UIViewController alloc] initWithNibName:@"QueueCell" bundle:isenseBundle];
        cell = (QueueCell *) tmpVC.view;
    }
    
    NSArray *keys = [limitedTempQueue allKeys];
    QDataSet *tmp = [limitedTempQueue objectForKey:keys[indexPath.row]];
    [cell setupCellWithDataSet:tmp andKey:keys[indexPath.row]];
    
    return cell;
}

// Log you into to iSENSE using the iSENSE API and uploads data
- (void)loginAndUploadWithUsername:(NSString *)usernameInput withPassword:(NSString *)passwordInput {
    
    UIAlertView *message = [self getDispatchDialogWithMessage:@"Logging in..."];
    [message show];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        RPerson *user = [api createSessionWithEmail:usernameInput andPassword:passwordInput];

        dispatch_async(dispatch_get_main_queue(), ^{

            if (user != nil) {
                
                // upload data
                [message setTitle:@"Uploading data sets..."];

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                    QueueUploadStatus *uploadStatus = [dataSaver upload:parent];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate didFinishUploadingDataWithStatus:uploadStatus];

                        [message dismissWithClickedButtonIndex:0 animated:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                    });

                });

            } else {
                [self.view makeWaffle:@"Login Failed"
                             duration:WAFFLE_LENGTH_SHORT
                             position:WAFFLE_BOTTOM
                                image:WAFFLE_RED_X];
                [message dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }
        });
    });
}

// Logs into iSENSE with a contributor key and attempts to upload data
- (void)loginAndUploadWithContributorKey:(NSString *)contribKey {

    UIAlertView *message = [self getDispatchDialogWithMessage:@"Validating key..."];
    [message show];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        QDataSet *firstDataSet = (QDataSet *) [dataSaver getDataSet];
        int pid = [firstDataSet projID].intValue;

        bool isKeyValid = [api validateKey:contribKey forProject:pid];

        dispatch_async(dispatch_get_main_queue(), ^{

            if (!isKeyValid) {
                [self.view makeWaffle:[NSString stringWithFormat:@"Invalid contributor key for project %d", pid]
                             duration:WAFFLE_LENGTH_SHORT
                             position:WAFFLE_BOTTOM
                                image:WAFFLE_RED_X];
                [message dismissWithClickedButtonIndex:0 animated:YES];
                return;
            }

            // upload data
            [message setTitle:@"Uploading data sets..."];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                QueueUploadStatus *uploadStatus = [dataSaver upload:parent];

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate didFinishUploadingDataWithStatus:uploadStatus];

                    [message dismissWithClickedButtonIndex:0 animated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
        });
    });
}

// This is for the loading spinner when the app starts automatic mode
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView reloadData];
    
    QueueCell *cell = (QueueCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (![cell isEditing]) {
    
        [NSThread sleepForTimeInterval:0.07];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        [cell toggleChecked];
    } else {
        if (![cell dataSetHasInitialProject]) {
            UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                         initWithTitle:nil
                                         delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                         otherButtonTitles:@"Rename", @"Change Description", @"Select Project", nil];
            popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [popupQuery showInView:self.view];
        } else {
            UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                         initWithTitle:nil
                                         delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                         otherButtonTitles:@"Rename", @"Change Description", nil];
            popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [popupQuery showInView:self.view];
        }
 
    }
    
    lastClickedCellIndex = indexPath;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

- (BOOL)containsAcceptedCharacters:(NSString *)mString {

    NSCharacterSet *unwantedCharacters =
    [[NSCharacterSet characterSetWithCharactersInString:kACCEPTED_CHARS] invertedSet];
    
    return ([mString rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}

- (BOOL)containsAcceptedDigits:(NSString *)mString {

    NSCharacterSet *unwantedCharacters =
    [[NSCharacterSet characterSetWithCharactersInString:kACCEPTED_DIGITS] invertedSet];
    
    return ([mString rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    switch (textField.tag) {
            
        case TAG_QUEUE_RENAME:
            if (![self containsAcceptedCharacters:string])
                return NO;

            // 127 character limit - 27 characters for the timestamp of the data set
            return (newLength > 100) ? NO : YES;
            
        case TAG_QUEUE_DESC:
            if (![self containsAcceptedCharacters:string])
                return NO;

            // 255 character limit
            return (newLength > 255) ? NO : YES;
            
        case TAG_QUEUE_PROJ:
            if (![self containsAcceptedDigits:string])
                return NO;

            // doubtedly any project # will surpass 63 digits long; nevertheless, some limit is imposed
            return (newLength > 63) ? NO : YES;
            
        default:
            return YES;
    }
}

- (void)launchFieldMatchingViewControllerFromBrowse:(bool)fromBrowse {

    // get the fields to field match
    // an explicit new instance of the DataManager is used to avoid interfering with the singleton instance
    // maintained by other apps
    DataManager *dm = [[DataManager alloc] init];
    [dm setProjectID:projID];
    
    UIAlertView *message = [self getDispatchDialogWithMessage:@"Loading fields..."];
    [message show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [dm retrieveProjectFields];

        dispatch_async(dispatch_get_main_queue(), ^{

            // launch the field matching dialog
            FieldMatchingViewController *fmvc = [[FieldMatchingViewController alloc]
                                                 initWithMatchedFields:[dm getRecognizedFields]
                                                 andProjectFields:[dm getUserDefinedFields]];
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

- (void)retrieveFieldMatchedArray:(NSNotification *)obj {

    // reset the edit menu option
    [self setTableToEditMode:![self.mTableView isEditing]];

    NSMutableArray *fieldMatch =  (NSMutableArray *)[obj object];

    if (fieldMatch != nil) {
        // user pressed okay button - set the cell's project and fields
        QueueCell *cell = (QueueCell *) [self.mTableView cellForRowAtIndexPath:lastClickedCellIndex];
        [self setCell:cell withProjectID:projID andFields:fieldMatch];

        lastSelectedFields = [fieldMatch mutableCopy];

        // if any other cells contain data sets with no project yet, present a dialog that allows
        // the user to set these with the matched project and fields as well
        for (int i = 0; i < [mTableView numberOfRowsInSection:0]; i++) {

            QueueCell *thisCell = (QueueCell *) [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (![thisCell dataSetHasInitialProject] && ![thisCell dataSetSetupWithProjectAndFields]) {

                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Apply to Other Data Sets"
                                                                    message:@"Would you like to apply this project and selected fields for all other data sets that do not currently have a project yet?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"No"
                                                          otherButtonTitles:@"Yes", nil];
                alertView.tag = OPTION_APPLY_PROJ_AND_FIELDS;
                [alertView show];

                // once a match is found, we can immediately break the loop
                return;
            }
        }
    }
    // else user canceled
}

- (void)setCell:(QueueCell *)cell withProjectID:(int)projectID andFields:(NSMutableArray *)fields {

    [cell setProjID:[NSString stringWithFormat:@"%d", projectID]];
    [cell.dataSet setProjID:[NSNumber numberWithInt:projectID]];
    [dataSaver editDataSetWithKey:cell.mKey andChangeProjIDTo:[NSNumber numberWithInt:projectID]];

    [cell setFields:fields];
    [cell.dataSet setFields:fields];
    [dataSaver editDataSetWithKey:cell.mKey andChangeFieldsTo:fields];

    [self.mTableView reloadData];
}

@end
