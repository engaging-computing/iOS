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
//        enabledFieldsHash = nil;
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
        
        // TODO - setup the enabledFields hash
    }
}

// Since no project is yet selected, set the field objects to contain all fields
- (void) setProjectFieldsToAllFields {
//    NSArray *allFieldsAsStrings = [[NSArray alloc] initWithObjects:
//                          sACCEL_X, sACCEL_Y, sACCEL_Z,
//                          sACCEL_TOTAL, sTEMPERATURE_C,
//                          sTEMPERATURE_F, sTEMPERATURE_K,
//                          sTIME_MILLIS, sLUX, sANGLE_DEG,
//                          sANGLE_RAD, sLATITUDE, sLONGITUDE,
//                          sMAG_X, sMAG_Y, sMAG_Z, sMAG_TOTAL,
//                          sALTITUDE, sPRESSURE, sGYRO_X,
//                          sGYRO_Y, sGYRO_Z, nil];
//    
//    enabledFieldsHash = [[NSMutableSet alloc] init];
//    [enabledFieldsHash addObjectsFromArray:allFieldsAsStrings];
    
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
    return [projectFields valueForKey:@"name"]; // TODO test. really we want to map over RProjectField.name
}

// Retrieve the array of fields for the current project, as rearranged by the FieldMatching class
- (NSMutableArray *) getRecognizedFields {
    return [projectFields valueForKey:@"recognized_name"]; // TODO test. really we want to map over RProjectField.recognized_name
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
    
    // TODO implement
    
    NSMutableDictionary *dataJSON = [[NSMutableDictionary alloc] init];
    
    if (f == nil) {
        NSLog(@"Fields object cannot be nil when writing data to JSON object");
        return nil;
    }
    
    for (RProjectField *field in projectFields) {
        ; // TODO
    }
    
    // this variable is used to index into the fields array 
//    int fieldCounter = 0;
    
//    if ([enabledFieldsHash containsObject:sACCEL_X] && f.accel_x != nil)
//        [dataJSON setObject:f.accel_x forKey:((RProjectField *)[projectFields objectAtIndex:fieldCounter++]).field_id];
//    
    
    return dataJSON;
}

// Change the data array from row-major to column-major
- (NSMutableArray *) convertDataToColumnFormat:(NSMutableArray *)data {
    // TODO implement
    
    
    
    
    
    
    
    return nil;
}

@end
