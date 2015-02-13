//
// FieldData.h
// Writer
//
// Created by Mike Stowell on 11/20/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <Foundation/Foundation.h>

@interface FieldData : NSObject

@property (strong, nonatomic) NSString *fieldName;
@property (strong, nonatomic) NSString *fieldData;
@property (strong, nonatomic) NSNumber *fieldType;
@property (strong, nonatomic) NSArray  *fieldRestrictions;

@end
