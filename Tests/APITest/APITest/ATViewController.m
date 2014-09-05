//
//  ATViewController.m
//  APITest
//
//  Created by Mike Stowell on 9/4/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ATViewController.h"
#define TestStatus BOOL

@interface ATViewController()

@end

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
    
    RPerson *user = [api createSessionWithEmail:email andPassword:pass];
    if (user != nil) {
        [_loginOutLbl setText:@"pass"];
    }
    else {
        [_loginOutLbl setText:@"fail"];
    }

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
    [self hasConnectivityTest];
    [self getProjectTest];
    [self getDataSetTest];
    [self getProjectFieldsTest];
    [self getDataSetsTest];
    [self getProjectsAtPageTest];
    [self getCurrentUserTest];
    [self createProjectTest];
    [self appendDataTest];
    [self appendDataWithContribKeyTest];
    [self uploadDataTest];
    [self uploadDataWithContribKeyTest];
    [self uploadMediaTest];
    [self uploadMediaWithContribKeyTest];
}

- (TestStatus) hasConnectivityTest {
    
    return false;
}

- (TestStatus) getProjectTest {
    
    return false;
}

- (TestStatus) getDataSetTest {
    
    return false;
}

- (TestStatus) getProjectFieldsTest {
    
    return false;
}

- (TestStatus) getDataSetsTest {
    
    return false;
}

- (TestStatus) getProjectsAtPageTest {
    
    return false;
}

- (TestStatus) getCurrentUserTest {
    
    return false;
}

- (TestStatus) createProjectTest {
    
    return false;
}

- (TestStatus) appendDataTest {
    
    return false;
}

- (TestStatus) appendDataWithContribKeyTest {
    
    return false;
}

- (TestStatus) uploadDataTest {
    
    return false;
}

- (TestStatus) uploadDataWithContribKeyTest {
    
    return false;
}

- (TestStatus) uploadMediaTest {
    
    return false;
}

- (TestStatus) uploadMediaWithContribKeyTest {
    
    return false;
}

@end
