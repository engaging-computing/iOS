//
// ISWProjectController.h
// Writer
//
// Created by Mike Stowell on 11/5/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <UIKit/UIKit.h>
#import "ProjectBrowserViewController.h"
#import "FieldMatchingViewController.h"
#import "DataManager.h"
#import "Constants.h"
#import "Waffle.h"

#define kPROJ_MANUAL_ENTRY_DIALOG 100

@interface ISWProjectController : UIViewController <ProjectBrowserDelegate, UIAlertViewDelegate> {
    DataManager *dm;
}

@property (weak, nonatomic) IBOutlet UILabel *projectLbl;

@property (weak, nonatomic) IBOutlet UIButton *enterProjIDBtn;
- (IBAction)enterProjIDBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *browseProjBtn;
- (IBAction)browseProjBtnOnClick:(id)sender;

@end
