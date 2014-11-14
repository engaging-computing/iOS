//
//  RProjectField.m
//  iSENSE_API
//
//  Created by Michael Stowell on 8/21/13.
//  Copyright (c) 2013 iSENSE Project, UMass Lowell. All rights reserved.
//

#import "RProjectField.h"

@implementation RProjectField

@synthesize field_id = _field_id, name = _name, recognized_name = _recognized_name, type = _type, unit = _unit;

- (id) init {
    if (self = [super init]) {
        self.type = [NSNumber numberWithInt:TYPE_TEXT];
        self.unit = @"";
        self.name = @"";
    }
    return self;
}

- (id)initWithName:(NSString *)uname type:(NSNumber *)utype andUnit:(NSString *)uunit {
    self = [super init];
    if (self) {
        self.type = utype;
        self.unit = uunit;
        self.name = uname;
    }
    return self;
}

// Overridden setter for the name variable, which will call the getRecognizedNameFromUserDefinedName function
- (void) setName:(NSString *)name {
    _name = name;
    [self getRecognizedNameFromUserDefinedName];
}

-(NSString *)description {
    NSString *objString = [NSString stringWithFormat:@"RProjectField: {\n\tfield_id: %@\n\tname: %@\n\trecognized_name: %@\n\ttype: %@\n\tunit: %@\n}", _field_id, _name, _recognized_name, _type, _unit];
    return objString;
}

// Parses the name field to attempt to obtain a recognized name for the field
- (void) getRecognizedNameFromUserDefinedName {
    
    // parse the field and try to match the name with recognized field names
    switch (self.type.intValue) {
            
        case TYPE_NUMBER:
            // Temperature
            if ([self.name.lowercaseString rangeOfString:@"temp"].location != NSNotFound) {
                if ([self.unit.lowercaseString rangeOfString:@"c"].location != NSNotFound) {
                    self.recognized_name = sTEMPERATURE_C;
                } else if ([self.unit.lowercaseString rangeOfString:@"k"].location != NSNotFound) {
                    self.recognized_name = sTEMPERATURE_K;
                } else {
                    self.recognized_name = sTEMPERATURE_F;
                }
                break;
            }
            
            // Altitude
            else if ([self.name.lowercaseString rangeOfString:@"altitude"].location != NSNotFound) {
                self.recognized_name = sALTITUDE;
                break;
            }
            
            // Light
            else if ([self.name.lowercaseString rangeOfString:@"light"].location != NSNotFound ||
                     [self.name.lowercaseString rangeOfString:@"lumin"].location != NSNotFound) {
                self.recognized_name = sLUX;
                break;
            }
            
            // Heading
            else if ([self.name.lowercaseString rangeOfString:@"heading"].location != NSNotFound ||
                     [self.name.lowercaseString rangeOfString:@"angle"].location != NSNotFound) {
                if ([self.unit.lowercaseString rangeOfString:@"rad"].location != NSNotFound) {
                    self.recognized_name = sANGLE_RAD;
                } else {
                    self.recognized_name = sANGLE_DEG;
                }
                break;
            }
            
            // Magnetic
            else if ([self.name.lowercaseString rangeOfString:@"magnetic"].location != NSNotFound) {
                if ([self.name.lowercaseString rangeOfString:@"x"].location != NSNotFound) {
                    self.recognized_name = sMAG_X;
                } else if ([self.name.lowercaseString rangeOfString:@"y"].location != NSNotFound) {
                    self.recognized_name = sMAG_Y;
                } else if ([self.name.lowercaseString rangeOfString:@"z"].location != NSNotFound) {
                    self.recognized_name = sMAG_Z;
                } else {
                    self.recognized_name = sMAG_TOTAL;
                }
                break;
            }
            
            // Acceleration
            else if ([self.name.lowercaseString rangeOfString:@"accel"].location != NSNotFound) {
                if ([self.name.lowercaseString rangeOfString:@"x"].location != NSNotFound) {
                    self.recognized_name = sACCEL_X;
                } else if ([self.name.lowercaseString rangeOfString:@"y"].location != NSNotFound) {
                    self.recognized_name = sACCEL_Y;
                } else if ([self.name.lowercaseString rangeOfString:@"z"].location != NSNotFound) {
                    self.recognized_name = sACCEL_Z;
                } else {
                    self.recognized_name = sACCEL_TOTAL;
                }
                break;
            }
            
            // Pressure
            else if ([self.name.lowercaseString rangeOfString:@"pressure"].location != NSNotFound) {
                self.recognized_name = sPRESSURE;
                break;
            }
            
            // Gyroscope
            else if ([self.name.lowercaseString rangeOfString:@"gyro"].location != NSNotFound) {
                if ([self.name.lowercaseString rangeOfString:@"x"].location != NSNotFound) {
                    self.recognized_name = sGYRO_X;
                } else if ([self.name.lowercaseString rangeOfString:@"y"].location != NSNotFound) {
                    self.recognized_name = sGYRO_Y;
                } else {
                    self.recognized_name = sGYRO_Z;
                }
                break;
            }
            
            // No match found
            else {
                self.recognized_name = sNULL_STRING;
                break;
            }
            
            break;
            
        case TYPE_TIMESTAMP:
            // Timestamp
            self.recognized_name = sTIME_MILLIS;
            break;
            
        case TYPE_LAT:
            // Latitude
            self.recognized_name = sLATITUDE;
            break;
            
        case TYPE_LON:
            // Longitude
            self.recognized_name = sLONGITUDE;
            break;
            
        default:
            // No match found
            self.recognized_name = sNULL_STRING;
            break;
    }
}

@end
