//
// Fields.m
// iSENSE_API
//
//  Created by Mike Stowell on 3/4/13.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
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
