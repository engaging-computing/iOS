//
//  DataManager.m
//  iSENSE_API
//
//  Created by Mike Stowell on 9/19/14.
//  Copyright (c) 2014 Jeremy Poulin. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

// Get a singleton instance of the DM class
+ (DataManager *)getInstance {
    static DataManager *dm = nil;
    
    static dispatch_once_t initDataManager;
    dispatch_once(&initDataManager, ^{
        dm = [[self alloc] init];
    });
    
    return dm;
}

// Private initializer for DM
- (id)init {
    if (self = [super init]) {
        
        // initialize default vars
        api = [API getInstance];
        
        f = [[Fields alloc] init];
        
        projectID = 0;
        projectFields = nil;
    }
    return self;
}

// Get the project fields of the project id specified by the projectID variable of this class
- (void) retrieveProjectFields {
    
    // have fields already been pulled?
    if (projectFields != nil && projectFields.count > 0) {
        NSLog(@"Fields already retrieved for this project.");
    }
    
    // if using a project ID of 0, this indicates a project will be selected later.
    // otherwise, we will retrieve the fields from iSENSE
    if (projectID == 0) {
        [self setProjectFieldsToAllFields];
    } else {
        projectFields = [[api getProjectFieldsWithId:projectID] mutableCopy];
        
        if (projectFields == nil || projectFields.count == 0) {
            NSLog(@"No fields available for project %d", projectID);
        }
    }
}

// Since no project is yet selected, set the field objects to contain all fields
- (void) setProjectFieldsToAllFields {

    NSArray *allFieldsAsFieldObjects = [NSArray arrayWithObjects:
        [[RProjectField alloc] initWithName:sACCEL_X type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"m/s^2"],
        [[RProjectField alloc] initWithName:sACCEL_Y type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"m/s^2"],
        [[RProjectField alloc] initWithName:sACCEL_Z type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"m/s^2"],
        [[RProjectField alloc] initWithName:sACCEL_TOTAL type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"m/s^2"],
        [[RProjectField alloc] initWithName:sTEMPERATURE_C type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"C"],
        [[RProjectField alloc] initWithName:sTEMPERATURE_F type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"F"],
        [[RProjectField alloc] initWithName:sTEMPERATURE_K type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"K"],
        [[RProjectField alloc] initWithName:sTIME_MILLIS type:[NSNumber numberWithInt:TYPE_TIMESTAMP] andUnit:@"ms"],
        [[RProjectField alloc] initWithName:sLUX type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"lm"],
        [[RProjectField alloc] initWithName:sANGLE_DEG type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"degrees"],
        [[RProjectField alloc] initWithName:sANGLE_RAD type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"radians"],
        [[RProjectField alloc] initWithName:sLATITUDE type:[NSNumber numberWithInt:TYPE_LAT] andUnit:@"degrees"],
        [[RProjectField alloc] initWithName:sLONGITUDE type:[NSNumber numberWithInt:TYPE_LON] andUnit:@"degrees"],
        [[RProjectField alloc] initWithName:sMAG_X type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"amp"],
        [[RProjectField alloc] initWithName:sMAG_Y type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"amp"],
        [[RProjectField alloc] initWithName:sMAG_Z type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"amp"],
        [[RProjectField alloc] initWithName:sMAG_TOTAL type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"amp"],
        [[RProjectField alloc] initWithName:sALTITUDE type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"m"],
        [[RProjectField alloc] initWithName:sPRESSURE type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"Pa"],
        [[RProjectField alloc] initWithName:sGYRO_X type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"SI"],
        [[RProjectField alloc] initWithName:sGYRO_Y type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"SI"],
        [[RProjectField alloc] initWithName:sGYRO_Z type:[NSNumber numberWithInt:TYPE_NUMBER] andUnit:@"SI"],
        nil];
    
    projectFields = [[NSMutableArray alloc] init];
    [projectFields addObjectsFromArray:allFieldsAsFieldObjects];
}

// Get the project ID currently associated with this class
- (int) getProjectID {
    return projectID;
}

// Set the project ID to associate with this class
- (void) setProjectID:(int)projID {
    projectID = projID;
}

// Retrieve the array of fields for the current project, as displayed on the website
- (NSMutableArray *) getUserDefinedFields {
    // TODO test. really we want to map over RProjectField.name, and I'm unsure if I have to override the valueForKey method in the class
    return [projectFields valueForKey:@"name"];
}

// Retrieve the array of fields for the current project, as rearranged by the FieldMatching class
- (NSMutableArray *) getRecognizedFields {
    // TODO test. really we want to map over RProjectField.recognized_name, and I'm unsure if I have to override the valueForKey method in the class
    return [projectFields valueForKey:@"recognized_name"];
}

// Get the current data fields object
- (Fields *) getDataFieldsObject {
    return f;
}

// Set the current data fields object that data will be pulled from
- (void) setDataFieldsObject:(Fields *)fields {
    f = fields;
}

// Write the data in the data fields object to a JSON object for this current project
// The format will resemble {"field_id_0":"data_0", "field_id_1":"data_1", ... }
// The implementor should keep a JSON array of these returned JSON objects for each point of data
- (NSMutableDictionary *) writeDataFieldsToJSONObject {

    NSMutableDictionary *dataJSON = [[NSMutableDictionary alloc] init];
    
    if (f == nil) {
        NSLog(@"Fields object cannot be nil when writing data to JSON object");
        return nil;
    }
    
    for (RProjectField *field in projectFields) {
        
        NSString *name = field.recognized_name;
        
        if ([name isEqualToString:sACCEL_X])
            [dataJSON setObject:(f.accel_x == nil) ? @"" : [NSString stringWithFormat:@"%@", f.accel_x] forKey:field.field_id];
        else if ([name isEqualToString:sACCEL_Y])
            [dataJSON setObject:(f.accel_y == nil) ? @"" : [NSString stringWithFormat:@"%@", f.accel_y] forKey:field.field_id];
        else if ([name isEqualToString:sACCEL_Z])
            [dataJSON setObject:(f.accel_z == nil) ? @"" : [NSString stringWithFormat:@"%@", f.accel_z] forKey:field.field_id];
        else if ([name isEqualToString:sACCEL_TOTAL])
            [dataJSON setObject:(f.accel_total == nil) ? @"" : [NSString stringWithFormat:@"%@", f.accel_total] forKey:field.field_id];
        else if ([name isEqualToString:sTEMPERATURE_C])
            [dataJSON setObject:(f.temperature_c == nil) ? @"" : [NSString stringWithFormat:@"%@", f.temperature_c] forKey:field.field_id];
        else if ([name isEqualToString:sTEMPERATURE_F])
            [dataJSON setObject:(f.temperature_f == nil) ? @"" : [NSString stringWithFormat:@"%@", f.temperature_f] forKey:field.field_id];
        else if ([name isEqualToString:sTEMPERATURE_K])
            [dataJSON setObject:(f.temperature_k == nil) ? @"" : [NSString stringWithFormat:@"%@", f.temperature_k] forKey:field.field_id];
        else if ([name isEqualToString:sTIME_MILLIS])
            [dataJSON setObject:(f.time_millis == nil) ? @"" : [NSString stringWithFormat:@"%@", f.time_millis] forKey:field.field_id];
        else if ([name isEqualToString:sLUX])
            [dataJSON setObject:(f.lux == nil) ? @"" : [NSString stringWithFormat:@"%@", f.lux] forKey:field.field_id];
        else if ([name isEqualToString:sANGLE_DEG])
            [dataJSON setObject:(f.angle_deg == nil) ? @"" : [NSString stringWithFormat:@"%@", f.angle_deg] forKey:field.field_id];
        else if ([name isEqualToString:sANGLE_RAD])
            [dataJSON setObject:(f.angle_rad == nil) ? @"" : [NSString stringWithFormat:@"%@", f.angle_rad] forKey:field.field_id];
        else if ([name isEqualToString:sLATITUDE])
            [dataJSON setObject:(f.latitude == nil) ? @"" : [NSString stringWithFormat:@"%@", f.latitude] forKey:field.field_id];
        else if ([name isEqualToString:sLONGITUDE])
            [dataJSON setObject:(f.longitude == nil) ? @"" : [NSString stringWithFormat:@"%@", f.longitude] forKey:field.field_id];
        else if ([name isEqualToString:sMAG_X])
            [dataJSON setObject:(f.mag_x == nil) ? @"" : [NSString stringWithFormat:@"%@", f.mag_x] forKey:field.field_id];
        else if ([name isEqualToString:sMAG_Y])
            [dataJSON setObject:(f.mag_y == nil) ? @"" : [NSString stringWithFormat:@"%@", f.mag_y] forKey:field.field_id];
        else if ([name isEqualToString:sMAG_Z])
            [dataJSON setObject:(f.mag_z == nil) ? @"" : [NSString stringWithFormat:@"%@", f.mag_z] forKey:field.field_id];
        else if ([name isEqualToString:sMAG_TOTAL])
            [dataJSON setObject:(f.mag_total == nil) ? @"" : [NSString stringWithFormat:@"%@", f.mag_total] forKey:field.field_id];
        else if ([name isEqualToString:sALTITUDE])
            [dataJSON setObject:(f.altitude == nil) ? @"" : [NSString stringWithFormat:@"%@", f.altitude] forKey:field.field_id];
        else if ([name isEqualToString:sPRESSURE])
            [dataJSON setObject:(f.pressure == nil) ? @"" : [NSString stringWithFormat:@"%@", f.pressure] forKey:field.field_id];
        else if ([name isEqualToString:sGYRO_X])
            [dataJSON setObject:(f.gyro_x == nil) ? @"" : [NSString stringWithFormat:@"%@", f.gyro_x] forKey:field.field_id];
        else if ([name isEqualToString:sGYRO_Y])
            [dataJSON setObject:(f.gyro_y == nil) ? @"" : [NSString stringWithFormat:@"%@", f.gyro_y] forKey:field.field_id];
        else if ([name isEqualToString:sGYRO_Z])
            [dataJSON setObject:(f.gyro_z == nil) ? @"" : [NSString stringWithFormat:@"%@", f.gyro_z] forKey:field.field_id];
        else
            [dataJSON setObject:@"" forKey:field.field_id];
    }
    
    return dataJSON;
}

// Change the data array from row-major to column-major
// It should take as an input a JSONArray of the JSONObjects created by the
// writeDataFieldsToJSONObject method
- (NSMutableArray *) convertDataToColumnFormat:(NSMutableArray *)data {
    
    // TODO implement once we confirm the rest of the DataManager works with the application
    
    
    return nil;
}

@end
