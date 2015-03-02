/*
 * iSENSE Project - isenseproject.org
 * This file is part of the iSENSE iOS API and applications.
 *
 * Copyright (c) 2015, University of Massachusetts Lowell. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer. Redistributions in binary
 * form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials
 * provided with the distribution. Neither the name of the University of
 * Massachusetts Lowell nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * BSD 3-Clause License
 * http://opensource.org/licenses/BSD-3-Clause
 *
 * Our work is supported by grants DRL-0735597, DRL-0735592, DRL-0546513, IIS-1123998,
 * and IIS-1123972 from the National Science Foundation and a gift from Google Inc.
 *
 */

//
// CredentialManager.m
// iSENSE_API
//
// Created by Virinchi Balabhadrapatruni on 2/28/14.
//

#import "CredentialManager.h"

@class DLAVAlertViewTheme;
@class DLAVAlertViewButtonTheme;

@interface CredentialManager ()

@end

@implementation CredentialManager

@synthesize loginoutButton, nameLabel, gravatarView,  api, loginalert, delegate;

- (void) loadView {

    self.view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 276, 102)];
    gravatarView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 102, 102)];

    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 20, 148, 21)];
    [nameLabel setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.view.autoresizesSubviews = NO;
    
    api = [API getInstance];
    
    self.view.clipsToBounds = YES;
    
    [self.view addSubview:gravatarView];
    [self.view addSubview:nameLabel];

    loginoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginoutButton setFrame:CGRectMake(150, 54, 75, 44)];
    [loginoutButton addTarget:self action:@selector(loginLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginoutButton];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    
    DLAVAlertViewButtonTheme *theme = [[DLAVAlertViewButtonTheme alloc] initWithTextShadowColor:[UIColor blackColor] andTextShadowOpacity:0.0f andTextShadowRadius:0.0 andTextShadowOffset:CGSizeMake(1.0f, 1.0f)];
    [theme setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    
    
    [DLAVAlertView applyTheme:theme toButton:loginoutButton animated:NO];
    
    [self loadUserInfo];
}

- (CredentialManager *) initWithDelegate:(__weak id<CredentialManagerDelegate>) delegateObject {

    self = [self init];
    self.delegate = delegateObject;
    return self;
}

- (CGRect)frameForOrientation:(UIInterfaceOrientation)orientation {

	CGRect frame;
	
	if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
		CGRect bounds = [UIScreen mainScreen].bounds;
		frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.width);
	} else {
		frame = [UIScreen mainScreen].bounds;
	}
	
	return frame;
}


- (void) loadUserInfo {
    
    NSBundle *isenseBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"iSENSE_API_Bundle" withExtension:@"bundle"]];
    
    if ([api getCurrentUser] == nil) {

        NSString *path = [isenseBundle pathForResource:@"default_user" ofType:@"png"];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        [gravatarView setImage:img];
        [nameLabel setText:@"Not Logged In"];
        [loginoutButton setTitle:@"Login" forState:UIControlStateNormal];

        return;
    }
        
    [gravatarView setImage:[[api getCurrentUser] gravatarImage]];
    [nameLabel setText:[[api getCurrentUser] name]];
    [loginoutButton setTitle:@"Logout" forState:UIControlStateNormal];
}

- (void)loginLogout {
    
    if ([api getCurrentUser] == nil) {
        [self.delegate didPressLogin:self];
        return;
    }

    [api deleteSession];
    [self loadUserInfo];
}

@end
