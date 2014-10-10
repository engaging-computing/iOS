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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //This is comparable to Android's OnStart
    api = [API getInstance];
    diceController = [[DiceDataController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rollClicked:(id)sender {
    int firstNum = [diceController getDieNumber];
    int secondNum = [diceController getDieNumber];
    int sum = firstNum + secondNum;
    int numTest = 0;
    
    [self.firstDieView showDieNumber:firstNum];
    [self.secondDieView showDieNumber:secondNum];
    
    self.sumLabel.text = [NSString stringWithFormat:@"The sum is %d", sum];
    //Call uploadData to upload the data set.
    [diceController uploadDatadie1:firstNum die2:secondNum sumOfDies:sum numOfTests:numTest++];

}
@end