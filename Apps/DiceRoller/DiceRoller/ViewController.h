//
//  ViewController.h
//  DiceRoller
//
//  Created by Rajia  on 9/30/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DieView.h"
#import "API.h"
#import "DiceDataController.h"
#import "DLAVAlertViewController.h"
#import "CredentialManager.h"
#import "GlobalColors.h"
#import "Waffle.h"
#import "Constants.h"

@interface ViewController : UIViewController
<UIAlertViewDelegate,
UITextFieldDelegate,
CredentialManagerDelegate>
{
    //API, DataManager and DiceDataController
    API *api;
    DiceDataController *diceController;
    DataManager *dm;
    
    // Credential Manager
    CredentialManager *credentialMgr;
    DLAVAlertView *credentialMgrAlert;
    NSString *dataSetName;
}
@property (weak, nonatomic) IBOutlet UIButton *rollButton;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet DieView *firstDieView;
@property (weak, nonatomic) IBOutlet DieView *secondDieView;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
- (IBAction)closeBtnOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *credentialBarBtn;
- (IBAction)credentialBarBtnOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
- (IBAction)nameBtnOnClick:(id)sender;

@end
