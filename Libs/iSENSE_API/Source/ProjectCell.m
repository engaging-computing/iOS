//
// ProjectCell.m
// iSENSE_API
//
// Created by Virinchi Balabhadrapatruni on 2/4/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import "ProjectCell.h"

@implementation ProjectCell

@synthesize projID;

- (id) initWithProject:(RProject *) project {
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ProjectCell"];
    if (self) {

        projID = project.project_id.intValue;
        self.textLabel.text = project.name;

        if ([project.owner_name class] != [NSNull class]) {
            self.detailTextLabel.text = [NSString stringWithFormat:@"Created by: %@", project.owner_name];
        } else {
            self.detailTextLabel.text = @"Unknown creator.";
        }
    }
    
    return self;
}

@end
