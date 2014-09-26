//
//  Fields.h
//  iOS Data Collector
//
//  Created by Mike Stowell on 3/4/13.
//  Copyright 2013 iSENSE Development Team. All rights reserved.
//  Engaging Computing Lab, Advisor: Fred Martin
//

#import <Foundation/Foundation.h>

@interface DataContainer : NSObject {}

@property (retain) NSMutableDictionary* data;
-(void) addData:(NSNumber *)dataValue forKey:(NSString *)dataKey;

// Fields constants
#define fACCEL_X        0
#define fACCEL_Y        1
#define fACCEL_Z        2
#define fACCEL_TOTAL    3
#define fTEMPERATURE_C  4
#define fTEMPERATURE_F  5
#define fTEMPERATURE_K  6
#define fTIME_MILLIS    7
#define fLUX            8
#define fANGLE_DEG      9
#define fANGLE_RAD      10
#define fLATITUDE       11
#define fLONGITUDE      12
#define fMAG_X          13
#define fMAG_Y          14
#define fMAG_Z          15
#define fMAG_TOTAL      16
#define fALTITUDE       17
#define fPRESSURE       18
#define fGYRO_X         19
#define fGYRO_Y         20
#define fGYRO_Z         21

// Fields strings
#define sNULL_STRING    @"nil"
#define sACCEL_X        @"Accel-X"
#define sACCEL_Y        @"Accel-Y"
#define sACCEL_Z        @"Accel-Z"
#define sACCEL_TOTAL    @"Accel-Total"
#define sTEMPERATURE_C  @"Temperature-C"
#define sTEMPERATURE_F  @"Temperature-F"
#define sTEMPERATURE_K  @"Temperature-K"
#define sTIME_MILLIS    @"Time"
#define sLUX            @"Luminous Flux"
#define sANGLE_DEG      @"Angle-Deg"
#define sANGLE_RAD      @"Angle-Rad"
#define sLATITUDE       @"Latitude"
#define sLONGITUDE      @"Longitude"
#define sMAG_X          @"Magnetic-X"
#define sMAG_Y          @"Magnetic-Y"
#define sMAG_Z          @"Magnetic-Z"
#define sMAG_TOTAL      @"Magnetic-Total"
#define sALTITUDE       @"Altitude"
#define sPRESSURE       @"Pressure"
#define sGYRO_X         @"Gyroscope-X"
#define sGYRO_Y         @"Gyroscope-Y"
#define sGYRO_Z         @"Gyroscope-Z"

@end
