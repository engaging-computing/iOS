//
// ISWTutorialContentController.h
// Writer
//
// Created by Mike Stowell on 12/09/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <UIKit/UIKit.h>

@interface ISWTutorialContentController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UILabel *titleTxt;

@property NSUInteger pageIndex;
@property NSString *titleLabel;
@property NSString *imageFile;


@end
