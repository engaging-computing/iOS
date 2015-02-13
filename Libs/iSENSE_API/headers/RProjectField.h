//
// RProjectField.h
// iSENSE_API
//
// Created by Michael Stowell on 8/21/13.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <Foundation/Foundation.h>
#import "DataContainer.h"

#define TYPE_TIMESTAMP 1
#define TYPE_NUMBER 2
#define TYPE_TEXT 3
#define TYPE_LAT 4
#define TYPE_LON 5

@interface RProjectField : NSObject {
}

@property (nonatomic, strong) NSNumber *field_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *recognized_name;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSArray  *restrictions;

- (id)initWithName:(NSString *)uname type:(NSNumber *)utype
              unit:(NSString *)uunit andRestrictions:(NSArray *)urestrictions;

@end
