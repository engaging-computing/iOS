//
//  ISMRecordingLength.h
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBTN_ONE_S 100
#define kBTN_TWO_S 101
#define kBTN_FIVE_S 102
#define kBTN_TEN_S 103
#define kBTN_THIRTY_S 104
#define kBTN_ONE_M 105
#define kBTN_TWO_M 106
#define kBTN_FIVE_M 107
#define kBTN_TEN_M 108
#define kBTN_THIRTY_M 109
#define kBTN_ONE_H 110
#define kBTN_PUSH_TO_STOP 111

@interface ISMRecordingLength : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *oneSBtn;
- (IBAction)oneSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *twoSBtn;
- (IBAction)twoSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fiveSBtn;
- (IBAction)fiveSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tenSBtn;
- (IBAction)tenSBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *thirtySBtn;
- (IBAction)thirtySBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *oneMBtn;
- (IBAction)oneMBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *twoMBtn;
- (IBAction)twoMBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *fiveMBtn;
- (IBAction)fiveMBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tenMBtn;
- (IBAction)tenMBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *thirtyMBtn;
- (IBAction)thirtyMBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *oneHBtn;
- (IBAction)oneHBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *pushToStopBtn;
- (IBAction)pushToStopBtnOnClick:(id)sender;

@end
