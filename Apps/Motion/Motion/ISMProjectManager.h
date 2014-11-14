//
//  ISMProjectManager.h
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectBrowserViewController.h"
#import "FieldMatchingViewController.h"
#import "DataManager.h"

#define kPROJ_MANUAL_ENTRY_DIALOG 100

@interface ISMProjectManager : UIViewController <ProjectBrowserDelegate, UIAlertViewDelegate> {
    DataManager *dm;
}

@property (weak, nonatomic) IBOutlet UILabel *projectLbl;

@property (weak, nonatomic) IBOutlet UIButton *enterProjIDBtn;
- (IBAction)enterProjIDBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *browseProjBtn;
- (IBAction)browseProjBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *noProjBtn;
- (IBAction)noProjBtnOnClick:(id)sender;

@end
