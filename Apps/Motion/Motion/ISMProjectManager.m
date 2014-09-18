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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)enterProjIDBtnOnClick:(id)sender {
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
    //dfm = [[DataFieldManager alloc] initWithProjID:projNum API:api andFields:nil];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithInt:project_id] forKey:pPROJECT_ID];
    [prefs synchronize];
    
    [projectLbl setText:[NSString stringWithFormat:@"Uploading to Project: %d", project_id]];
    
    [self launchFieldMatchingViewControllerFromBrowse:TRUE];
}

- (void) launchFieldMatchingViewControllerFromBrowse:(bool)fromBrowse {
//    // get the fields to field match
//    UIAlertView *message = [self getDispatchDialogWithMessage:@"Loading fields..."];
//    [message show];
//    
//    dispatch_queue_t queue = dispatch_queue_create("loading_project_fields", NULL);
//    dispatch_async(queue, ^{
//        [dfm getOrder];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // set an observer for the field matched array caught from FieldMatching
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retrieveFieldMatchedArray:) name:kFIELD_MATCHED_ARRAY object:nil];
//            
//            // launch the field matching dialog
//            FieldMatchingViewController *fmvc = [[FieldMatchingViewController alloc] initWithMatchedFields:[dfm getOrderList] andProjectFields:[dfm getRealOrder]];
//            fmvc.title = @"Field Matching";
//            
//            if (fromBrowse) {
//                double delayInSeconds = 0.1;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    [self.navigationController pushViewController:fmvc animated:YES];
//                });
//            } else
//                [self.navigationController pushViewController:fmvc animated:YES];
//            
//            if (fromBrowse) [NSThread sleepForTimeInterval:1.0];
//            [message dismissWithClickedButtonIndex:nil animated:YES];
//            
//        });
//    });
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
