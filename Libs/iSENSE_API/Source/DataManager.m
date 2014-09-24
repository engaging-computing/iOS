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
        
        dc = [[DataContainer alloc] init];
        
        projectID = 0;
        projectFields = nil;
    }
    return self;
}

// Get the project fields of the project id specified by the projectID variable of this class
- (void) retrieveProjectFields {
    
    // have fields already been pulled?
    if (projectFields && projectFields.count > 0) {
        NSLog(@"Fields already retrieved for this project.");
    }
    
    // if using a project ID of 0, this indicates a project will be selected later.
    if (projectID == 0) {
        [self setProjectFieldsToAllFields];
        return;
    }

    // otherwise, we will retrieve the fields from iSENSE
    projectFields = [[api getProjectFieldsWithId:projectID] mutableCopy];

    if (projectFields && projectFields.count == 0) {
        NSLog(@"No fields available for project %d", projectID);
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

// Get the array of RProjectFields associated with this project
- (NSMutableArray *) getProjectFields {
    return projectFields;
}

// Explicitly set the array of RProjectFields for this project
- (void) setProjectFields:(NSMutableArray *)projFields {
    projectFields = projFields;
}

// Retrieve the array of fields for the current project, as displayed on the website
// valueForKey:@"name" is analagous to mapping over the RProjectField.name property
- (NSMutableArray *) getUserDefinedFields {
    return [projectFields valueForKey:@"name"];
}

// Retrieve the array of fields for the current project, as rearranged by the FieldMatching class
// valueForKey:@"recognized_name" is analagous to mapping over the RProjectField.recognized_name property
- (NSMutableArray *) getRecognizedFields {
    return [projectFields valueForKey:@"recognized_name"];
}

// Get the current data fields object
- (DataContainer *) getDataContainerObject {
    return dc;
}

// Set the current data fields object that data will be pulled from
- (void) setDataContainerObject:(DataContainer *)dataContainer {
    dc = dataContainer;
}

// Write the data in the data fields object to a JSON object for this current project
// The format will resemble {"field_id_0":"data_0", "field_id_1":"data_1", ... }
// The implementor should keep a JSON array of these returned JSON objects for each point of data
- (NSMutableDictionary *) writeDataFieldsToJSONObject {

    NSMutableDictionary *dataJSON = [[NSMutableDictionary alloc] init];
    
    if (dc == nil) {
        NSLog(@"Fields object cannot be nil when writing data to JSON object");
        return nil;
    }
    
    for (RProjectField *field in projectFields) {
        
        NSString *name = field.recognized_name;
        
        if ([name isEqualToString:sACCEL_X])
            [dataJSON setObject:(dc.accel_x == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.accel_x] forKey:field.field_id];
        else if ([name isEqualToString:sACCEL_Y])
            [dataJSON setObject:(dc.accel_y == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.accel_y] forKey:field.field_id];
        else if ([name isEqualToString:sACCEL_Z])
            [dataJSON setObject:(dc.accel_z == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.accel_z] forKey:field.field_id];
        else if ([name isEqualToString:sACCEL_TOTAL])
            [dataJSON setObject:(dc.accel_total == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.accel_total] forKey:field.field_id];
        else if ([name isEqualToString:sTEMPERATURE_C])
            [dataJSON setObject:(dc.temperature_c == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.temperature_c] forKey:field.field_id];
        else if ([name isEqualToString:sTEMPERATURE_F])
            [dataJSON setObject:(dc.temperature_f == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.temperature_f] forKey:field.field_id];
        else if ([name isEqualToString:sTEMPERATURE_K])
            [dataJSON setObject:(dc.temperature_k == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.temperature_k] forKey:field.field_id];
        else if ([name isEqualToString:sTIME_MILLIS])
            [dataJSON setObject:(dc.time_millis == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.time_millis] forKey:field.field_id];
        else if ([name isEqualToString:sLUX])
            [dataJSON setObject:(dc.lux == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.lux] forKey:field.field_id];
        else if ([name isEqualToString:sANGLE_DEG])
            [dataJSON setObject:(dc.angle_deg == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.angle_deg] forKey:field.field_id];
        else if ([name isEqualToString:sANGLE_RAD])
            [dataJSON setObject:(dc.angle_rad == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.angle_rad] forKey:field.field_id];
        else if ([name isEqualToString:sLATITUDE])
            [dataJSON setObject:(dc.latitude == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.latitude] forKey:field.field_id];
        else if ([name isEqualToString:sLONGITUDE])
            [dataJSON setObject:(dc.longitude == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.longitude] forKey:field.field_id];
        else if ([name isEqualToString:sMAG_X])
            [dataJSON setObject:(dc.mag_x == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.mag_x] forKey:field.field_id];
        else if ([name isEqualToString:sMAG_Y])
            [dataJSON setObject:(dc.mag_y == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.mag_y] forKey:field.field_id];
        else if ([name isEqualToString:sMAG_Z])
            [dataJSON setObject:(dc.mag_z == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.mag_z] forKey:field.field_id];
        else if ([name isEqualToString:sMAG_TOTAL])
            [dataJSON setObject:(dc.mag_total == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.mag_total] forKey:field.field_id];
        else if ([name isEqualToString:sALTITUDE])
            [dataJSON setObject:(dc.altitude == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.altitude] forKey:field.field_id];
        else if ([name isEqualToString:sPRESSURE])
            [dataJSON setObject:(dc.pressure == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.pressure] forKey:field.field_id];
        else if ([name isEqualToString:sGYRO_X])
            [dataJSON setObject:(dc.gyro_x == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.gyro_x] forKey:field.field_id];
        else if ([name isEqualToString:sGYRO_Y])
            [dataJSON setObject:(dc.gyro_y == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.gyro_y] forKey:field.field_id];
        else if ([name isEqualToString:sGYRO_Z])
            [dataJSON setObject:(dc.gyro_z == nil) ? @"" : [NSString stringWithFormat:@"%@", dc.gyro_z] forKey:field.field_id];
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
