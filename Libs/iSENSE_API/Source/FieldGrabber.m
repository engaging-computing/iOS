//
// FieldGrabber.m
// iSENSE_API
//
// Created by Mike Stowell on 12/28/12.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
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