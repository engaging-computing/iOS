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

#define WHITE_DICE @"WhiteDice"
#define YELLOW_DICE @"YellowDice"


#pragma mark - Methods

- (void) showDieNumber:(int)num colorOfDie:(NSString*)dieColor;

@end
