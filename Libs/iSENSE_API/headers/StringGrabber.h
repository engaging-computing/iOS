//
// StringGrabber.h
// iSENSE_API
//
// Created by Mike Stowell on 12/28/12.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//


#import <Foundation/Foundation.h>

@interface StringGrabber : NSObject {}    

+ (NSString *) grabString:(NSString *)label;
+ (NSString *) grabField: (NSString *)label;
+ (NSString *) concatenateHardcodedString:(NSString *)label with:(NSString *)string;
+ (NSString *) concatenate:(NSString*)string withHardcodedString:(NSString *)label;

@end
