//
//  ISMRecordingLength.h
//  Motion
//
//  Created by Mike Stowell on 9/9/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBTN_ONE_S 1
#define kBTN_TWO_S 2
#define kBTN_FIVE_S 5
#define kBTN_TEN_S 10
#define kBTN_THIRTY_S 30
#define kBTN_ONE_M 60
#define kBTN_TWO_M 120
#define kBTN_FIVE_M 300
#define kBTN_TEN_M 600
#define kBTN_THIRTY_M 1800
#define kBTN_ONE_H 3600
#define kBTN_PUSH_TO_STOP -1

@class ISMRecordingLength;

@protocol ISMRecordingLengthDelegate <NSObject>

@required
- (void) didChooseRecordingLength:(int)recordingLengthInSeconds withDelegate:(ISMRecordingLength *)delegateObject;

@end

@interface ISMRecordingLength : UIViewController {
}

@property (weak, nonatomic) id <ISMRecordingLengthDelegate> delegate;
- (void) setDelegateObject:(__weak id<ISMRecordingLengthDelegate>) delegateObject;

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
