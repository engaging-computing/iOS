//
//  ISWViewController.h
//  Writer
//
//  Created by Mike Stowell on 11/4/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "API.h"
#import "QueueUploaderView.h"
#import "CredentialManager.h"
#import "DLAVAlertViewController.h"
#import "Waffle.h"

#define USE_DEV true

@interface ISWViewController : UIViewController
<UIAlertViewDelegate, UITextFieldDelegate, CredentialManagerDelegate, QueueUploaderDelegate> {

    API *api;

    UILabel *devLbl;
    
    CredentialManager *credentialMgr;
    DLAVAlertView *credentialMgrAlert;
}

// Queue Saver properties
@property (nonatomic, strong) DataSaver *dataSaver;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// UI properties
@property (weak, nonatomic) IBOutlet UIBarButtonItem *credentialBarBtn;
- (IBAction)credentialBarBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *dataSetNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *dataSetNameTxt;

@property (weak, nonatomic) IBOutlet UIButton *projectBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveRowBtn;
- (IBAction)saveRowBtnOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveDataSetBtn;
- (IBAction)saveDataSetBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadBtnOnClick:(id)sender;

@end

