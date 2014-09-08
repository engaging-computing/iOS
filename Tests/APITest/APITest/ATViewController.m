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
NSMutableArray *_fieldIDs;
int _newDataSetID = 0;

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
    if (_newProjID == -1 || _newDataSetID == 0)
        [self sendResultToOutput:false ForTestName:@"Get Data Set"];
    else {
        RDataSet *dataSet = [api getDataSetWithId:_newDataSetID];
        if (dataSet == nil)
            [self sendResultToOutput:false ForTestName:@"Get Data Set"];
        else
            [self sendResultToOutput:true ForTestName:@"Get Data Set"];
    }
}

- (void) getProjectFieldsTest {
    if (_newProjID == -1)
        [self sendResultToOutput:false ForTestName:@"Get Projects Fields"];
    else {
        NSArray *fields = [api getProjectFieldsWithId:_newProjID];
        if (fields != nil && fields.count == 3) {
            _fieldIDs = [[NSMutableArray alloc] init];
            for (int i = 0; i < fields.count; i++) {
                [_fieldIDs addObject: [(RProjectField *)[fields objectAtIndex:i] field_id]];
            }
            [self sendResultToOutput:true ForTestName:@"Get Projects Fields"];
        } else
            [self sendResultToOutput:false ForTestName:@"Get Projects Fields"];
    }

}

- (void) getDataSetsTest {
    if (_newProjID == -1 || _newDataSetID == 0)
        [self sendResultToOutput:false ForTestName:@"Get Data Sets"];
    else {
        NSArray *dataSets = [api getDataSetsWithId:_newProjID];
        if (dataSets == nil || dataSets.count != 1)
            [self sendResultToOutput:false ForTestName:@"Get Data Sets"];
        else
            [self sendResultToOutput:true ForTestName:@"Get Data Sets"];
    }
}

- (void) getProjectsAtPageTest {
    
    NSArray *projects = [api getProjectsAtPage:1 withPageLimit:20 withFilter:CREATED_AT_DESC andQuery:@""];
    if (projects == nil || projects.count != 20)
        [self sendResultToOutput:false ForTestName:@"Get Projects"];
    else
        [self sendResultToOutput:true ForTestName:@"Get Projects"];
    
}

- (void) getCurrentUserTest {
    RPerson *curUser = [api getCurrentUser];
    if (curUser != nil && [[curUser name] isEqualToString:@"Test T."])
        [self sendResultToOutput:true ForTestName:@"Get Current User"];
    else
        [self sendResultToOutput:false ForTestName:@"Get Current User"];
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
    if (_newProjID == -1 || _fieldIDs == nil || _newDataSetID == 0)
        [self sendResultToOutput:false ForTestName:@"Append Data"];
    else {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < _fieldIDs.count; i++) {
            NSMutableArray *dataPoints = [[NSMutableArray alloc] init];
            [dataPoints addObject:[NSNumber numberWithInt:(i+5)]];
            
            [data setObject:dataPoints forKey:[NSString stringWithFormat:@"%@", [_fieldIDs objectAtIndex:i]]];
        }
        
        bool success = [api appendDataSetDataWithId:_newDataSetID andData:data];
        
        if (success)
            [self sendResultToOutput:true ForTestName:@"Append Data"];
        else
            [self sendResultToOutput:false ForTestName:@"Append Data"];
    }


}

- (void) appendDataWithContribKeyTest {
    // Not implemented - cannot automate contributor keys in current API
}

- (void) uploadDataTest {
    if (_newProjID == -1 || _fieldIDs == nil)
        [self sendResultToOutput:false ForTestName:@"Upload Data"];
    else {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < _fieldIDs.count; i++) {
            NSMutableArray *dataPoints = [[NSMutableArray alloc] init];
            [dataPoints addObject:[NSNumber numberWithInt:i]];
            
            [data setObject:dataPoints forKey:[NSString stringWithFormat:@"%@", [_fieldIDs objectAtIndex:i]]];
        }
        
        int dataSetID = [api uploadDataToProject:_newProjID withData:data andName:@"Test Data Set 1"];
        if (dataSetID != 0) {
            _newDataSetID = dataSetID;
            [self sendResultToOutput:true ForTestName:@"Upload Data"];
        } else
            [self sendResultToOutput:false ForTestName:@"Upload Data"];
    }
}

- (void) uploadDataWithContribKeyTest {
    // Not implemented - cannot automate contributor keys in current API
}

- (void) uploadMediaTest {
    // Not implemented - postponed until media is used in iOS
}

- (void) uploadMediaWithContribKeyTest {
    // Not implemented - cannot automate contributor keys in current API
}

@end
