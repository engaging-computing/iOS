//
//  DataManager.h
//  iSENSE_API
//
//  Created by Mike Stowell on 9/19/14.
//  Copyright (c) 2014 Jeremy Poulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RProjectField.h"
#import "DataContainer.h"
#import "API.h"

@interface DataManager : NSObject {
    
    API *api;
    
    // the data container object used to record a point of data
    DataContainer *dc;
    
    // the current project ID
    int projectID;
    
    // a list of the fields as they appear on iSENSE
    NSMutableArray *projectFields;
}

+ (DataManager *)getInstance;
- (void) retrieveProjectFields; // analogous to "getOrder"

- (int) getProjectID;
- (void) setProjectID:(int)projID;

- (NSMutableArray *) getProjectFields;
- (void) setProjectFields:(NSMutableArray *)projFields;

- (NSMutableArray *) getUserDefinedFields;
- (NSMutableArray *) getRecognizedFields;
- (NSMutableArray *) getProjectFieldIDs;

- (DataContainer *) getDataContainerObject;
- (void) setDataContainerObject:(DataContainer *)dataContainer;

- (NSMutableDictionary *) writeDataFieldsToJSONObject;

// a staticly available row-to-column major formatting of data
+ (NSMutableArray *) convertDataToColumnMajor:(NSMutableArray *)data forProjectID:(int)projID andRecognizedFields:(NSMutableArray *)recFields;

@end
