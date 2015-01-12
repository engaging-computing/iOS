//
//  ViewController.m
//  DiceRoller
//
//  Created by Rajia  on 9/30/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ViewController.h"
#import "Waffle.h"
@interface ViewController ()

@end

@implementation ViewController

int numTest = 0;

- (void)viewDidLoad{
    [super viewDidLoad];
	api = [API getInstance];
    diceController = [[DiceDataController alloc] init];
    int projectID = 876;
    DataManager *dm = [DataManager getInstance];
    [dm setProjectID:projectID];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rollClicked:(id)sender {
    int firstNum = [diceController getDieNumber];
    int secondNum = [diceController getDieNumber];
    int sum = firstNum + secondNum;
    
    [self.firstDieView showDieNumber:firstNum colorOfDie:WHITE_DICE];
    [self.secondDieView showDieNumber:secondNum colorOfDie:YELLOW_DICE];
    
    self.sumLabel.text = [NSString stringWithFormat:@"The sum is %d", sum];
    //Call uploadData to upload the data set.
    [diceController uploadDatadie1:firstNum die2:secondNum sumOfDies:sum numOfTests:numTest++];

}
//This is for making testing easier, however will be removed in the futer when the app is ready to be pushed to the app store. 
- (IBAction)closeBtnOnClick:(id)sender{
    [self.view makeWaffle:@"Exiting App." duration:WAFFLE_LENGTH_LONG position:WAFFLE_BOTTOM];
    exit(0);
}
@end