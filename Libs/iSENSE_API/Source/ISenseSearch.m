//
// ISenseSearch.m
// iSENSE_API
//
// Created by Jeremy Poulin on 2/5/13.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import "ISenseSearch.h"

@implementation ISenseSearch

@synthesize query, buildType, page, perPage;

- (id) init {
    self = [super init];
    if (self) {
        query = @"";
        buildType = NEW;
        page = 1;
        perPage = 10;
    }
    
    return self;
}

- (id)initWithQuery:(NSString *)search page:(int)pageNumber itemsPerPage:(int)itemsPerPage andBuildType:(BuildType)type {
    self = [self init];
    if (self) {
        query = search;
        buildType = type;
        page = pageNumber;
        perPage = itemsPerPage;
    }
    return self;
}

@end
