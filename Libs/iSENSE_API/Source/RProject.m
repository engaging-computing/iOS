//
// RProject.m
// iSENSE_API
//
// Created by Michael Stowell on 8/21/13.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import "RProject.h"

@implementation RProject

@synthesize project_id, featured_media_id, default_read, like_count, hidden, featured, name, url, timecreated, owner_name, owner_url;

- (id) init {
    if (self = [super init]) {
        name = @"";
        url = @"";
        timecreated = @"";
        owner_name = @"";
        owner_url = @"";
    }
    return self;
}

-(NSString *)description {
    NSString *objString = [NSString stringWithFormat:@"RProject: {\n\tproject_id: %@\n\tfeatured_media_id: %@\n\tdefault_read: %@\n\tlike_count: %@\n\thidden: %@\n\tfeatured:= %@\n\tname:= %@\n\turl:= %@\n\ttimecreated:= %@\n\towner_name:= %@\n\towner_url:= %@\n}", project_id, featured_media_id, default_read, like_count, hidden, featured, name, url, timecreated, owner_name, owner_url];
    return objString;
}

@end
