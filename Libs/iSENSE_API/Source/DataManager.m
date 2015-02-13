/*
 * iSENSE Project - isenseproject.org
 * This file is part of the iSENSE iOS API and applications.
 *
 * Copyright (c) 2015, University of Massachusetts Lowell. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer. Redistributions in binary
 * form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials
 * provided with the distribution. Neither the name of the University of
 * Massachusetts Lowell nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * BSD 3-Clause License
 * http://opensource.org/licenses/BSD-3-Clause
 *
 * Our work is supported by grants DRL-0735597, DRL-0735592, DRL-0546513, IIS-1123998,
 * and IIS-1123972 from the National Science Foundation and a gift from Google Inc.
 *
 */

//
// DataManager.m
// iSENSE_API
//
// Created by Mike Stowell on 9/19/14.
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
        [[RProjectField alloc] initWithName:sACCEL_X       type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"m/s^2" andRestrictions:nil],
        [[RProjectField alloc] initWithName:sACCEL_Y       type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"m/s^2" andRestrictions:nil],
        [[RProjectField alloc] initWithName:sACCEL_Z       type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"m/s^2" andRestrictions:nil],
        [[RProjectField alloc] initWithName:sACCEL_TOTAL   type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"m/s^2" andRestrictions:nil],
        [[RProjectField alloc] initWithName:sTEMPERATURE_C type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"C"     andRestrictions:nil],
        [[RProjectField alloc] initWithName:sTEMPERATURE_F type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"F"     andRestrictions:nil],
        [[RProjectField alloc] initWithName:sTEMPERATURE_K type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"K"     andRestrictions:nil],
        [[RProjectField alloc] initWithName:sTIME_MILLIS   type:[NSNumber numberWithInt:TYPE_TIMESTAMP] unit:@"ms"    andRestrictions:nil],
        [[RProjectField alloc] initWithName:sLUX           type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"lm"    andRestrictions:nil],
        [[RProjectField alloc] initWithName:sANGLE_DEG     type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"deg"   andRestrictions:nil],
        [[RProjectField alloc] initWithName:sANGLE_RAD     type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"rad"   andRestrictions:nil],
        [[RProjectField alloc] initWithName:sLATITUDE      type:[NSNumber numberWithInt:TYPE_LAT]       unit:@"deg"   andRestrictions:nil],
        [[RProjectField alloc] initWithName:sLONGITUDE     type:[NSNumber numberWithInt:TYPE_LON]       unit:@"deg"   andRestrictions:nil],
        [[RProjectField alloc] initWithName:sMAG_X         type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"amp"   andRestrictions:nil],
        [[RProjectField alloc] initWithName:sMAG_Y         type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"amp"   andRestrictions:nil],
        [[RProjectField alloc] initWithName:sMAG_Z         type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"amp"   andRestrictions:nil],
        [[RProjectField alloc] initWithName:sMAG_TOTAL     type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"amp"   andRestrictions:nil],
        [[RProjectField alloc] initWithName:sALTITUDE      type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"m"     andRestrictions:nil],
        [[RProjectField alloc] initWithName:sPRESSURE      type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"Pa"    andRestrictions:nil],
        [[RProjectField alloc] initWithName:sGYRO_X        type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"SI"    andRestrictions:nil],
        [[RProjectField alloc] initWithName:sGYRO_Y        type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"SI"    andRestrictions:nil],
        [[RProjectField alloc] initWithName:sGYRO_Z        type:[NSNumber numberWithInt:TYPE_NUMBER]    unit:@"SI"    andRestrictions:nil],
        nil];
    
    projectFields = [[NSMutableArray alloc] init];
    [projectFields addObjectsFromArray:allFieldsAsFieldObjects];
}

// Gets the project ID currently associated with this class
- (int) getProjectID {
    return projectID;
}

// Sets the project ID to associate with this class
- (void) setProjectID:(int)projID {
    projectID = projID;
}

// Returns the array of RProjectFields associated with this project as an immutable copy
- (NSArray *) getProjectFields {
    return [projectFields copy];
}

// Set the array of RProjectFields for this project
- (void) setProjectFields:(NSArray *)projFields {
    projectFields = [projFields mutableCopy];
}

// Retrieve the array of fields for the current project, as displayed on the website
// valueForKey:@"name" is analagous to mapping over the RProjectField.name property
- (NSArray *) getUserDefinedFields {
    return [[projectFields valueForKey:@"name"] copy];
}

// Retrieve the array of fields for the current project, as rearranged by the FieldMatching class
// valueForKey:@"recognized_name" is analagous to mapping over the RProjectField.recognized_name property
- (NSArray *) getRecognizedFields {
    return [[projectFields valueForKey:@"recognized_name"] copy];
}

// Retrieve the array of field IDs for the current project
// valueForKey:@"field_id" is analagous to mapping over the RProjectField.field_id property
- (NSArray *) getProjectFieldIDs {
    return [[projectFields valueForKey:@"field_id"] copy];
}

// Write the data in the data fields object to a JSON object for this current project
// The format will resemble {"field_id_0":"data_0", "field_id_1":"data_1", ... }
// The implementor should keep a JSON array of these returned JSON objects for each point of data
- (NSDictionary *) writeDataToJSONObject:(DataContainer *)dc {

    // data is required in the container to record it
    if (dc == nil) {
        NSLog(@"Fields object cannot be nil when writing data to JSON object");
        return nil;
    }

    // if no project is currently selected, return the result of writeDataForArbitraryProject
    if (projectID <= 0) {
        return [self writeDataForArbitraryProject:dc];
    }

    NSMutableDictionary *dataJSON = [[NSMutableDictionary alloc] init];

    // Loop through each field, and use it's recognized name to key into the data dictionary of the DataContainer
    // object.  If the data is not nil, it will be saved.  Otherwise, a blank string is saved for that field.
    for (RProjectField *field in projectFields) {
        
        NSString *name = field.recognized_name;
        NSNumber *dataPoint = [dc.data objectForKey:name];

        [dataJSON setObject:((dataPoint) ? dataPoint : @"") forKey:[NSString stringWithFormat:@"%@", field.field_id]];
    }

    return [dataJSON copy];
}

// Similar implementation to writeDataToJSONObject.  However, since no project is currently selected,
// every possible field is in the projectFields array and all have an ID of 0.  Instead of keying the
// data by the field ID then, this method will key the data by the name of the field the data is for.
// In this way, the data can later be reorganized for a particular project by matching the field names
// as keys in this dictionary to the field IDs of the project corresponding to those recognized field names.
- (NSDictionary *) writeDataForArbitraryProject:(DataContainer *)dc {

    NSMutableDictionary *dataJSON = [[NSMutableDictionary alloc] init];

    for (RProjectField *field in projectFields) {

        NSString *name = field.recognized_name;
        NSNumber *dataPoint = [dc.data objectForKey:name];

        [dataJSON setObject:((dataPoint) ? dataPoint : @"") forKey:name];
    }

    return [dataJSON copy];
}

// Change the data array from row-major to column-major
// It should take as an input a JSONArray of the JSONObjects created by the
// writeDataFieldsToJSONObject method
+ (NSDictionary *) convertDataToColumnMajor:(NSArray *)data forProjectID:(int)projID {

    NSMutableDictionary *outData = [[NSMutableDictionary alloc] init];
    NSMutableArray *outRow;

    NSDictionary *row = [[NSDictionary alloc] init];
    NSArray *ids = [[NSArray alloc] init];


    // get the field IDs for this project
    DataManager *dm = [[DataManager alloc] init];
    [dm setProjectID:projID];
    [dm retrieveProjectFields];
    ids = [dm getProjectFieldIDs];

    // reorder the data from row major to column major format
    for (int i = 0; i < ids.count; i++) {

        NSNumber *fieldID = [ids objectAtIndex:i];
        outRow = [[NSMutableArray alloc] init];

        for (int j = 0; j < (int)data.count; j++) {

            row = [data objectAtIndex:j];

            if ([row objectForKey:[NSString stringWithFormat:@"%d", fieldID.intValue]]) {
                [outRow addObject:[NSString stringWithFormat:@"%@", [row objectForKey:[NSString stringWithFormat:@"%d",fieldID.intValue]]]];
            } else {
                [outRow addObject:@""];
            }
        }

        [outData setObject:outRow forKey:[NSString stringWithFormat:@"%@", fieldID]];
    }

    return [outData copy];
}

// Change the arbitrary data array from row-major to column-major, re-keying the data with the
// proper field IDs pulled from the project
+ (NSDictionary *) convertArbitraryDataToColumnMajor:(NSArray *)data forProjectID:(int)projID andRecognizedFields:(NSArray *)recognizedFields {

    NSMutableDictionary *outData = [[NSMutableDictionary alloc] init];
    NSMutableArray *outRow;

    NSDictionary *row = [[NSDictionary alloc] init];
    NSArray *ids = [[NSArray alloc] init];

    // get the field IDs for this project
    DataManager *dm = [[DataManager alloc] init];
    [dm setProjectID:projID];
    [dm retrieveProjectFields];
    ids = [dm getProjectFieldIDs];

    // the field IDs should be in ordered, corresponding to the recognized fields
    if (ids.count != recognizedFields.count) {
        NSLog(@"Fields IDs do not match recognized fields in convertArbitraryDataToColumnMajor - cannot convert data");
        return nil;
    }

    // reorder the data from row major to column major format
    for (int i = 0; i < ids.count; i++) {

        NSNumber *fieldID = [ids objectAtIndex:i];
        NSString *fieldName = [recognizedFields objectAtIndex:i];
        outRow = [[NSMutableArray alloc] init];

        for (int j = 0; j < (int)data.count; j++) {

            row = [data objectAtIndex:j];

            if ([row objectForKey:fieldName]) {
                [outRow addObject:[NSString stringWithFormat:@"%@", [row objectForKey:fieldName]]];
            } else {
                [outRow addObject:@""];
            }
        }

        [outData setObject:outRow forKey:[NSString stringWithFormat:@"%@", fieldID]];
    }
    
    return [outData copy];
}

@end
