//
//  ISDRProjectManager.h
//  Dice Roller
//
//  Created by Rajia Abdelaziz on 11/28/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectBrowserViewController.h"
#import "FieldMatchingViewController.h"
#import "DataManager.h"
#import "Constants.h"
#import "Waffle.h"

#define kPROJ_MANUAL_ENTRY_DIALOG 100

@interface ISDRProjectManager : UIViewController <ProjectBrowserDelegate, UIAlertViewDelegate> {
    DataManager *dm;
    ISDRProjectManager *pm;
    API *api;
    UIViewController *vc; 
}

@property (weak, nonatomic) IBOutlet UILabel *projectLbl;

@property (weak, nonatomic) IBOutlet UIButton *enterProjIDBtn;
- (IBAction)enterProjIDBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *browseProjBtn;
- (IBAction)browseProjBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeBtnOnClick:(id)sender;

-(bool)projectHasValidFields;

@end