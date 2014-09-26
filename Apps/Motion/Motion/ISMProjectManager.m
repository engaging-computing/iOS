//
//  ISMProjectManager.m
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ISMProjectManager.h"

@interface ISMProjectManager ()
@end

@implementation ISMProjectManager

@synthesize projectLbl, enterProjIDBtn, browseProjBtn, createProjBtn;

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
    [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %d", [dm getProjectID]]];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)enterProjIDBtnOnClick:(id)sender {
    
    UIAlertView *enterProjAlert = [[UIAlertView alloc] initWithTitle:@"Enter Project ID #" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    enterProjAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    enterProjAlert.tag = kPROJ_MANUAL_ENTRY_DIALOG;
    [enterProjAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case kPROJ_MANUAL_ENTRY_DIALOG:
        {
            NSString *projAsString = [[alertView textFieldAtIndex:0] text];
            [dm setProjectID:[projAsString intValue]];
            
            [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %@", projAsString]];
            
            [self launchFieldMatchingViewControllerFromBrowse:FALSE];
            break;
        }
        default:
            NSLog(@"Unrecognized dialog!");
            break;
    }
}

- (IBAction)browseProjBtnOnClick:(id)sender {
    
    ProjectBrowserViewController *browser = [[ProjectBrowserViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:browser animated:YES];
}

- (IBAction)createProjBtnOnClick:(id)sender {
    
    [self.view makeWaffle:@"Feature coming... eventually"];
}

- (void) didFinishChoosingProject:(ProjectBrowserViewController *) browser withID: (int) project_id {
    
    NSLog(@"ID = %d", project_id);
    [dm setProjectID:project_id];
    
    [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %d", project_id]];
    
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
            
            // set an observer for the field matched array caught from FieldMatching
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveFieldMatchedArray:) name:kFIELD_MATCHED_ARRAY object:nil];
            
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
