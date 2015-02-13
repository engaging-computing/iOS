//
// CredentialManager.h
// iSENSE_API
//
// Created by Virinchi Balabhadrapatruni on 2/28/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "API.h"
#import "StringGrabber.h"
#import "Waffle.h"
#import "DLAVAlertView.h"
#import "DLAVAlertViewButtonTheme.h"

@class CredentialManager;
@protocol CredentialManagerDelegate <NSObject>

@required
- (void) didPressLogin:(CredentialManager *)mngr;

@end

@interface CredentialManager : UIViewController{
}

@property (strong, nonatomic) UIImageView *gravatarView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *loginoutButton;
@property (nonatomic) UIAlertView *loginalert;
@property (strong, nonatomic) API *api;
@property (nonatomic, weak) id <CredentialManagerDelegate> delegate;


- (void)loginLogout;
- (CredentialManager *) initWithDelegate:(__weak id<CredentialManagerDelegate>) delegateObject;

@end
