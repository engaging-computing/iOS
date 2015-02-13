//
// ISenseSearch.h
// iSENSE_API
//
// Created by Jeremy Poulin on 2/5/13.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <Foundation/Foundation.h>

typedef enum BuildType { NEW = 0, APPEND = 1 } BuildType;

@interface ISenseSearch : NSObject {
}

@property (nonatomic, retain) NSString *query;
@property (nonatomic, assign) BuildType buildType;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int perPage;

- (id) init;
- (id) initWithQuery:(NSString *)q page:(int)pageNumber itemsPerPage:(int)itemsPerPage andBuildType:(BuildType)bt;

@end
