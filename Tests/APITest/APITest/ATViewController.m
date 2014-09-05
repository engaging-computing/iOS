//
//  ATViewController.m
//  APITest
//
//  Created by Mike Stowell on 9/4/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ATViewController.h"

// Global variables and constants
#define TestStatus BOOL
int _newProjID = -1;

@interface ATViewController()
@end

// Class implementation
@implementation ATViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set up the API
    api = [API getInstance];
    [api useDev:true];
    
    // set UI element delegates and properties
    _emailInputTxt.delegate = self;
    _passInputTxt.delegate = self;
    
    _testAllOutLbl.editable = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)loginBtnClick:(id)sender {
    NSString *email = [_emailInputTxt text];
    NSString *pass = [_passInputTxt text];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RPerson *user = [api createSessionWithEmail:email andPassword:pass];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (user != nil)
                [_loginOutLbl setText:@"pass"];
            else
                [_loginOutLbl setText:@"fail"];
        });
    });
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)testAllBtnClick:(id)sender {
    // reset the output
    [_testAllOutLbl setText:@""];
    
    // connectivity
    [self hasConnectivityTest];
    
    // create and get a project and its field
    [self createProjectTest];
    [self getProjectTest];
    [self getProjectFieldsTest];
    
    // create a data set and append. Then get it + the collection of all data sets
    [self uploadDataTest];
    [self appendDataTest];
    [self getDataSetTest];
    [self getDataSetsTest];
    
    // generic project and user search
    [self getProjectsAtPageTest];
    [self getCurrentUserTest];
    
    // not implemented
    [self uploadMediaTest];
    [self uploadMediaWithContribKeyTest];
    [self uploadDataWithContribKeyTest];
    [self appendDataWithContribKeyTest];
}

- (void)sendResultToOutput:(TestStatus)result ForTestName:(NSString *)test {
    NSString *output = [NSString stringWithFormat:@"%@%@%@%@%@",
                        [_testAllOutLbl text],
                        @"\n",
                        test,
                        @" - ",
                        (result) ? @"pass" : @"fail"];
    [_testAllOutLbl setText:output];
}

- (void) hasConnectivityTest {
    
    TestStatus result = [API hasConnectivity];
    [self sendResultToOutput:result ForTestName:@"Has Connectivity"];
}

- (void) getProjectTest {
    if (_newProjID == -1)
        [self sendResultToOutput:false ForTestName:@"Get Project"];
    else {
        RProject *proj = [api getProjectWithId:_newProjID];
        if (proj != nil)
            [self sendResultToOutput:true ForTestName:@"Get Project"];
        else
            [self sendResultToOutput:false ForTestName:@"Get Project"];
    }
}

- (void) getDataSetTest {
    

}

- (void) getProjectFieldsTest {
    

}

- (void) getDataSetsTest {
    

}

- (void) getProjectsAtPageTest {
    

}

- (void) getCurrentUserTest {
    

}

- (void) createProjectTest {
    NSArray *fields = [NSArray arrayWithObjects:
                       [[RProjectField alloc] initWithName:@"X" Type:[NSNumber numberWithInt:TYPE_NUMBER] AndUnit:@"m/s^2"],
                       [[RProjectField alloc] initWithName:@"Y" Type:[NSNumber numberWithInt:TYPE_NUMBER] AndUnit:@"m/s^2"],
                       [[RProjectField alloc] initWithName:@"Z" Type:[NSNumber numberWithInt:TYPE_NUMBER] AndUnit:@"m/s^2"],
                       nil];
    
    int newProjID = [api createProjectWithName:@"iOS API Test Project" andFields:fields];
    
    if (newProjID == -1)
        [self sendResultToOutput:false ForTestName:@"Create Project"];
    else {
        _newProjID = newProjID;
        [self sendResultToOutput:true ForTestName:@"Create Project"];
    }
}

- (void) appendDataTest {
    

}

- (void) appendDataWithContribKeyTest {
    

}

- (void) uploadDataTest {
    

}

- (void) uploadDataWithContribKeyTest {
    

}

- (void) uploadMediaTest {
    

}

- (void) uploadMediaWithContribKeyTest {

    
}

@end
