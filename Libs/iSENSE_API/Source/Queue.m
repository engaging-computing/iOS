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
// Queue.m
// iSENSE API
//
// Created by Jeremy Poulin on 4/26/13.
//

#include "Queue.h"

@implementation NSMutableDictionary (QueueAdditions)

// Queues are first-in-first-out, so we remove objects from the head
- (id) dequeue {

    NSArray *keys = [self allKeys];
    id firstKey = [keys objectAtIndex:0];
    id headObject = [self objectForKey:firstKey];

    if (headObject != nil) {
        [self removeObjectForKey:firstKey];
        return headObject;
    }
    
    if (self.count != 0) NSLog(@"Cannot dequeue dataSet: invalid key");
    else NSLog(@"Cannot dequeue dataSet: empty queue");
    
    return headObject;
}

// Add to the tail of the queue (no one likes it when people cut in line!)
- (void) enqueue:(id)anObject withKey:(int)key {
          
    // This method automatically adds to the end of the array
    NSNumber *keyObj = [NSNumber numberWithInt:key];
    [self setObject:anObject forKey:keyObj];
}


// Allows any arbitrary node to be removed
- (id) removeFromQueueWithKey:(NSNumber *)key {

    NSArray *keys = [self allKeys];
    NSNumber *firstKey = [keys objectAtIndex:0];
    id headObject;
    if (key == firstKey) {

        headObject = [self dequeue];
        NSLog(@"%@", [self allKeys].description);
        return headObject;
    } else {

        headObject = [self objectForKey:key];
        if (headObject != nil) {
            
            [self removeObjectForKey:key];
            NSLog(@"%@", [self allKeys].description);
            return headObject;
        } else {
            NSLog(@"Cannot remove dataSet: invalid key");
        }
    }
    NSLog(@"I should never get here from queue remove with key");
    return headObject;
}

@end