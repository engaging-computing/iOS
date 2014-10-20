//
//  ViewController.m
//  DiceRoller
//
//  Created by Rajia  on 9/30/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

int numTest = 0;

- (void)viewDidLoad{
    [super viewDidLoad];
	api = [API getInstance];
    diceController = [[DiceDataController alloc] init];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rollClicked:(id)sender {
    int firstNum = [diceController getDieNumber];
    int secondNum = [diceController getDieNumber];
    int sum = firstNum + secondNum;
    
    [self.firstDieView showDieNumber:firstNum colorOfDie:(@"White")];
    [self.secondDieView showDieNumber:secondNum colorOfDie:(@"Yellow")];
    
    self.sumLabel.text = [NSString stringWithFormat:@"The sum is %d", sum];
    //Call uploadData to upload the data set.
    [diceController uploadDatadie1:firstNum die2:secondNum sumOfDies:sum numOfTests:numTest++];

}
@end