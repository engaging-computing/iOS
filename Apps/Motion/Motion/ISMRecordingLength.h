//
// ISMRecordingLength.h
// Motion
//
// Created by Mike Stowell on 9/9/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <UIKit/UIKit.h>
#import "Constants.h"


@class ISMRecordingLength;

@protocol ISMRecordingLengthDelegate <NSObject>

@required
- (void) didChooseRecordingLength:(int)recordingLengthInSeconds withName:(NSString *)recordingLengthAsString andDelegate:(ISMRecordingLength *)delegateObject;

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
