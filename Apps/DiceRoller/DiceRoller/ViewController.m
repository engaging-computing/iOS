//
//  ViewController.m
//  DiceRoller
//
//  Created by Rajia  on 9/30/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ViewController.h"
#import "DiceDataController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //This is comparable to Android's OnStart
    api = [API getInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rollClicked:(id)sender {
    DiceDataController *diceController = [[DiceDataController alloc] init];
    int firstNum = [diceController getDieNumber];
    int secondNum = [diceController getDieNumber];
    
    [self.firstDieView showDieNumber:firstNum];
    [self.secondDieView showDieNumber:secondNum];
}
@end
