//
//  DiceDataController.m
//  DiceRoller
//
//  Created by Rajia  on 10/3/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "DiceDataController.h"

@implementation DiceDataController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (int) getDieNumber
{
    //this uses the arc4random function to generate a random number between 0-6
    int r = (arc4random()%6) + 1;
    return r;
}

@end
