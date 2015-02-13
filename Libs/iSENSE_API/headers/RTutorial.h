//
// RTutorial.h
// iSENSE_API
//
// Created by Michael Stowell on 8/21/13.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <Foundation/Foundation.h>

@interface RTutorial : NSObject {
    
}

@property (strong) NSNumber *tutorial_id;
@property (strong) NSNumber *hidden;
@property (strong) NSString *name;
@property (strong) NSString *url;
@property (strong) NSString *timecreated;
@property (strong) NSString *owner_name;
@property (strong) NSString *owner_url;

@end
