//
//  ATViewController.h
//  APITest
//
//  Created by Mike Stowell on 9/4/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../../Libs/iSENSE_API/iSENSE_API/API.h"

@interface ATViewController : UIViewController <UITextFieldDelegate> {
    API *api;
}

@property (strong, nonatomic) IBOutlet UITextField *emailInputTxt;
@property (strong, nonatomic) IBOutlet UITextField *passInputTxt;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *loginOutLbl;

@property (strong, nonatomic) IBOutlet UIButton *testAllBtn;
- (IBAction)testAllBtnClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *testOutputLbl;

@end
