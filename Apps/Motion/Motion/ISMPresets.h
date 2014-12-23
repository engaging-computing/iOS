//
//  ISMPresets.h
//  Motion
//
//  Created by Mike Stowell on 12/22/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>

// delegate class and protocol
@class ISMPresets;

@protocol ISMPresetsDelegate<NSObject>

@required
- (void) didFinishSavingPresetWithID:(int)presetID;
@end

// presets interface
@interface ISMPresets : UIViewController {
}

// delegate properties
@property (nonatomic, weak) id <ISMPresetsDelegate> delegate;
- (id)initWithDelegate: (__weak id<ISMPresetsDelegate>) delegateObject;

@property (weak, nonatomic) IBOutlet UIButton *gpsPresetBtn;
- (IBAction)gpsPresetBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *accelPresetBtn;
- (IBAction)accelPresetBtnOnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *defaultPresetBtn;
- (IBAction)defaultPresetBtnOnClick:(id)sender;

@end
