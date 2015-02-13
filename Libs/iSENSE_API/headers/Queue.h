//
// Queue.h
// iSENSE API
//
// Created by Jeremy Poulin on 4/26/13.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#ifndef __iSENSE_API__queue__
#define __iSENSE_API__queue__

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)anObject withKey:(int)key;
- (id) removeFromQueueWithKey:(NSNumber *)key;

@end

#endif
