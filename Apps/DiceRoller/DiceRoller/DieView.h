//
//  DieView.h
//  DiceRoller
//
//  Created by Rajia  on 9/30/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DieView : UIView

#pragma mark - Properties

@property (strong, nonatomic)UIImageView *dieImageView;

//Create a method to change the image in the dieView Property

#pragma mark - Methods

- (void) showDieNumber:(int)num colorOfDie:(NSString*)dieColor;

@end
