//
//  ViewController.h
//  DiceRoller
//
//  Created by Rajia  on 9/30/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DieView.h"
#import "API.h"
#import "DiceDataController.h"

@interface ViewController : UIViewController{
    API *api;
    DiceDataController *diceController;
}
@property (weak, nonatomic) IBOutlet UIButton *rollButton;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet DieView *firstDieView;
@property (weak, nonatomic) IBOutlet DieView *secondDieView;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
- (IBAction)closeBtnOnClick:(id)sender;
@end
