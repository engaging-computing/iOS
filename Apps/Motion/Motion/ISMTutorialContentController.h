//
//  ISMTutorialContentController.h
//  Motion
//
//  Created by Mike Stowell on 11/18/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISMTutorialContentController : UIViewController {

}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UILabel *titleTxt;

@property NSUInteger pageIndex;
@property NSString *titleLabel;
@property NSString *imageFile;


@end
