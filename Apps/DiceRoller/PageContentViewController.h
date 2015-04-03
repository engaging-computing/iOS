//
//  PageContentViewController.h
//  DiceRoller
//
//  Created by Rajia  on 1/20/15.
//  Copyright (c) 2015 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UILabel *titleTxt;

@property NSUInteger pageIndex;
@property NSString *titleLabel;
@property NSString *imageFile;

@end
