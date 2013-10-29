//
//  DataFieldManager.h
//  iOS Data Collector
//
//  Created by Mike Stowell on 2/21/13.
//  Copyright 2013 iSENSE Development Team. All rights reserved.
//  Engaging Computing Lab, Advisor: Fred Martin
//

#import <Foundation/Foundation.h>
#import "Fields.h"
#import "API.h"

@interface DataFieldManager : NSObject {
    bool enabledFields[22];
    
    int projID;
    API *api;
    Fields *f;
    
    NSMutableArray *projFields;
}

/* old methods */
- (void) setEnabledField:(bool)value atIndex:(int)index;
- (bool) enabledFieldAtIndex:(int)index;
- (id) reOrderData:(id)oldData forExperimentID:(int)eid;

/* new methods */
- (id) instanceWithProjID:(int)projectID API:(API *)isenseAPI andFields:(Fields *)fields;
- (void) getOrder;
- (void) getProjectFieldOrder;
- (int) getProjID;
- (void) setProjID:(int)projectID;
- (NSMutableArray *) getProjectFields;
- (NSMutableArray *) getOrderList;
- (Fields *) getFields;
- (void) enableAllFields;
- (void) setEnabledFields:(NSMutableArray *)acceptedFields;
- (NSMutableDictionary *) putData;
- (NSMutableArray *) putDataForNoProjectID;
+ (NSMutableArray *) reOrderData:(NSMutableArray *)data forProjectID:(int)projectID API:(API *)api andFieldOrder:(NSMutableArray *)fieldOrder;


/* old properties */
@property (nonatomic, retain) NSMutableArray *order;
@property (nonatomic, retain) NSMutableArray *data;

/* new properties */
@property (nonatomic, retain) NSMutableArray *realOrder;

@end