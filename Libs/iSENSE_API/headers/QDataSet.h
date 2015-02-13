//
// QDataSet.h
// iSENSE API
//
// Created by Jeremy Poulin on 7/16/13, modified by Mike Stowell 9/6/13
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface QDataSet : NSManagedObject

@property (nonatomic, retain) id data;
@property (nonatomic, retain) id picturePaths;
@property (nonatomic, retain) NSNumber * projID;
@property (nonatomic, retain) NSNumber * uploadable;
@property (nonatomic, retain) NSString * dataDescription;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * hasInitialProj;
@property (nonatomic, retain) NSString * parentName;
@property (nonatomic, retain) id fields;

@end
