//
//  Fields.h
//  iOS Data Collector
//
//  Created by Mike Stowell on 3/4/13.
//  Copyright 2013 iSENSE Project, UMass Lowell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataContainer : NSObject {}

@property (retain) NSMutableDictionary* data;
-(void) addData:(NSString *)dataValue forKey:(NSString *)dataKey;

// Fields string constants
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
