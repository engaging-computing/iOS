//
//  DataSaver.h
//  iSENSE API
//
//  Created by Jeremy Poulin on 4/26/13.
//  Copyright 2013 iSENSE Development Team. All rights reserved.
//  Engaging Computing Lab, Advisor: Fred Martin
//

#ifndef __iSENSE_API__DataSaver__
#define __iSENSE_API__DataSaver__

#import <Foundation/Foundation.h>
#import "QDataSet.h"
#import "Queue.h"
#import "API.h"
#import "DLAVAlertView.h"

#define DATA_NONE_UPLOADED  1500
#define DATA_UPLOAD_SUCCESS 1501
#define DATA_UPLOAD_FAILED  1502

@interface DataSaver : NSObject {}

-(id)   initWithContext:(NSManagedObjectContext *)context;

-(void) addDataSetFromCoreData:(QDataSet *)dataSet;
-(BOOL) addDataSet:(QDataSet *)dataSet;
-(void) addDataSetWithContext:(NSManagedObjectContext *) manObjCntxt name:(NSString *)name parentName:(NSString *)prntName description:(NSString *)dscrptn projectID:(int)projID data:(id)data mediaPaths:(id)media uploadable:(BOOL)upldbl hasInitialProject:(BOOL)hasInitialProj andFields:(id)fields;

-(id)   removeDataSet:(NSNumber *)key;

-(BOOL) editDataSetWithKey:(NSNumber *)key andChangeProjIDTo:(NSNumber *)newProjID;
-(BOOL) editDataSetWithKey:(NSNumber *)key andChangeDescription:(NSString *)newDescription;
-(BOOL) editDataSetWithKey:(NSNumber *)key andChangeFieldsTo:(NSMutableArray *)newFields;

-(int) upload:(NSString *)parentName;

-(void) removeAllDataSets;

-(id)   getDataSet;
-(id)   getDataSetWithKey:(NSNumber *)key;

-(int)  dataSetCountWithParentName:(NSString *)pn;

@property (nonatomic, retain) NSMutableDictionary *dataQueue;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end


#endif
