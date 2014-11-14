//
//  FieldGrabber.m
//  Data_Collector
//
//  Created by Mike Stowell on 12/28/12.
//  Copyright 2013 iSENSE Project, UMass Lowell. All rights reserved.
//


#import "FieldGrabber.h"

@implementation FieldGrabber

+ (NSString *) grabField:(NSString *)label {
    NSString *fname = [[NSBundle mainBundle] pathForResource:@"Fields" ofType:@"strings"];
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:fname];
	NSString *loc = [d objectForKey:label];
	return loc;
}

@end