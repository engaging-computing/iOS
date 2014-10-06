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

// Initializer for DM - note that implementors should use getInstance instead, but this is still made available
// when explicit new instances of DM are needed, such as in the QueueUploader
- (id)init {
    if (self = [super init]) {
        
        // initialize default vars
        api = [API getInstance];

        projectID = 0;
        [self setProjectFieldsToAllFields];
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

// Retrieve the array of field IDs for the current project
// valueForKey:@"field_id" is analagous to mapping over the RProjectField.field_id property
- (NSMutableArray *) getProjectFieldIDs {
    return [projectFields valueForKey:@"field_id"];
}

// Write the data in the data fields object to a JSON object for this current project
// The format will resemble {"field_id_0":"data_0", "field_id_1":"data_1", ... }
// The implementor should keep a JSON array of these returned JSON objects for each point of data
- (NSMutableDictionary *) writeDataToJSONObject:(DataContainer *)dc {

    NSMutableDictionary *dataJSON = [[NSMutableDictionary alloc] init];
    
    if (dc == nil) {
        NSLog(@"Fields object cannot be nil when writing data to JSON object");
        return nil;
    }

    // Loop through each field, and use it's recognized name to key into the data dictionary of the DataContainer
    // object.  If the data is not nil, it will be saved.  Otherwise, a blank string is saved for that field.
    for (RProjectField *field in projectFields) {
        
        NSString *name = field.recognized_name;
        NSNumber *dataPoint = [dc.data objectForKey:name];

        [dataJSON setObject:((dataPoint) ? dataPoint : @"") forKey:[NSString stringWithFormat:@"%@", field.field_id]];
    }

    return dataJSON;
}

// Change the data array from row-major to column-major
// It should take as an input a JSONArray of the JSONObjects created by the
// writeDataFieldsToJSONObject method
+ (NSMutableDictionary *) convertDataToColumnMajor:(NSMutableArray *)data forProjectID:(int)projID andRecognizedFields:(NSMutableArray *)recFields {

    NSMutableDictionary *outData = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *row     = [[NSMutableDictionary alloc] init];
    NSMutableArray *ids          = [[NSMutableArray alloc] init];
    NSMutableArray *outRow;

    // If the recognized fields are null, set up the recognized fields and fieldIDs.
    // Otherwise, if recognized fields are not null but the field IDs are, pull the project's field IDs, retaining
    // the user's passed in field-matched recognized fields array for that project.
    if (!recFields || recFields.count == 0 || !ids || ids.count == 0) {

        DataManager *dm = [[DataManager alloc] init];
        [dm setProjectID:projID];
        [dm retrieveProjectFields];
        ids = [dm getProjectFieldIDs];

        if (!recFields || recFields.count == 0) {
            recFields = [dm getRecognizedFields];
        }
    }

    // ensure recFields and ids arrays are of equal length
    if (recFields.count != ids.count) {
        NSLog(@"Unequal arrays of field IDs and recognized fields.  Cannot change data to column major");
        return nil;
    }

    // reorder the data from row major to column major format
    for (int i = 0; i < recFields.count; i++) {

        NSNumber *fieldID = [ids objectAtIndex:i];
        outRow = [[NSMutableArray alloc] init];

        for (int j = 0; j < (int)data.count; j++) {

            row = [data objectAtIndex:j];

            if ([row objectForKey:[NSString stringWithFormat:@"%d", fieldID.intValue]])
                [outRow addObject:[NSString stringWithFormat:@"%@",
                                   [row objectForKey:[NSString stringWithFormat:@"%d",fieldID.intValue]]]];
            else
                [outRow addObject:@""];
        }

        [outData setObject:outRow forKey:[NSString stringWithFormat:@"%@", fieldID]];
    }

    return outData;
}

@end
