//
//  DiceDataController.h
//  DiceRoller
//
//  Created by Rajia  on 10/3/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "DataManager.h"
@interface DiceDataController : UIView{
    API *api;
}
-(int)getDieNumber;
-(void) uploadDatadie1:(int)num1 die2: (int)num2 sumOfDies: (int)sumNum numOfTests: (int)numTest;


@end
