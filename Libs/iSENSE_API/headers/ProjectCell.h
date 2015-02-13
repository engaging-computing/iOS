//
// ProjectCell.h
// iSENSE_API
//
// Created by Virinchi Balabhadrapatruni on 2/4/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <UIKit/UIKit.h>
#import "RProject.h"

@interface ProjectCell : UITableViewCell

- (id) initWithProject:(RProject *) project;

@property int projID;

@end
