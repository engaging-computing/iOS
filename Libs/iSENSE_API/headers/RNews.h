//
// RNews.h
// iSENSE_API
//
// Created by Jeremy Poulin on 9/19/13.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <Foundation/Foundation.h>

@interface RNews : NSObject {
    
}

@property (strong) NSNumber *news_id;
@property (strong) NSNumber *hidden;
@property (strong) NSString *name;
@property (strong) NSString *content;
@property (strong) NSString *url;
@property (strong) NSString *timecreated;

@end
