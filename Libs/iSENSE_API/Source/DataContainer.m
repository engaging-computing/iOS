//
//  Fields.m
//  iOS Data Collector
//
//  Created by Mike Stowell on 3/4/13.
//  Copyright 2013 iSENSE Project, UMass Lowell. All rights reserved.
//

#import "DataContainer.h"

@implementation DataContainer

@synthesize data;

-(id) init {
    if (self = [super init]) {
        data = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) addData:(NSString *)dataValue forKey:(NSString *)dataKey {
    [data setValue:dataValue forKey:dataKey];
}

@end
