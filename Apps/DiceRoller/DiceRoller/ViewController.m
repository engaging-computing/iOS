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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
