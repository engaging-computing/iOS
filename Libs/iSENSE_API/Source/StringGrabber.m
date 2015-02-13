//
// StringGrabber.m
// iSENSE_API
//
// Created by Mike Stowell on 12/28/12.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import "StringGrabber.h"

@implementation StringGrabber  

+ (NSString *) grabString:(NSString *)label {
	
	NSString *fname = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"strings"];
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:fname];
	NSString *loc = [d objectForKey:label];
	return loc;
}

+ (NSString *) grabField:(NSString *)label {

    NSString *fname = [[NSBundle mainBundle] pathForResource:@"Fields" ofType:@"strings"];
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:fname];
	NSString *loc = [d objectForKey:label];
	return loc;
}

+ (NSString *) concatenateHardcodedString:(NSString *)label with:(NSString *)string {
	
	NSString *hardCodedString = [self grabString:label];
	NSMutableString *temp = [NSMutableString stringWithFormat:@"%@%@", hardCodedString, string];
	
	return [NSString stringWithString:temp];
}

+ (NSString *) concatenate:(NSString*)string withHardcodedString:(NSString *)label {
    
    NSString *hardCodedString = [self grabString:label];
	NSMutableString *temp = [NSMutableString stringWithFormat:@"%@%@", string, hardCodedString];
	
	return [NSString stringWithString:temp];
}

@end