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
// API.h
// iSENSE_API
//
// Created by Jeremy Poulin on 8/21/13.
//

#import <Foundation/Foundation.h>
#import "RProject.h"
#import "RTutorial.h"
#import "RPerson.h"
#import "RDataSet.h"
#import "RNews.h"
#import "RProjectField.h"
#import "Reachability.h"
#import "ISKeys.h"
#import <MobileCoreServices/UTType.h>
#import <sys/time.h>

// Version number of the API tested and passed on this version
// number of the production iSENSE website.
#define VERSION_MAJOR @"4"
#define VERSION_MINOR @"1"

// Base URLs for use by any caller
#define BASE_LIVE_URL @"http://isenseproject.org"
#define BASE_DEV_URL @"http://rsense-dev.cs.uml.edu"

typedef enum {
    CREATED_AT_DESC,
    CREATED_AT_ASC,
    UPDATED_AT_DESC,
    UPDATED_AT_ASC
} SortType;

typedef enum {
    PROJECT,
    DATA_SET
} TargetType;

@interface API : NSObject {
}

// instance initializer
+ (API *)getInstance;

// connectivity checker
+ (BOOL)hasConnectivity;

// dev and base URL
- (void)useDev:(BOOL)useDev;
- (BOOL)isUsingDev;
- (void)setBaseUrl:(NSURL *)newUrl;

// user
- (RPerson *)createSessionWithEmail:(NSString *)p_email andPassword:(NSString *)p_password;
- (void)deleteSession;
- (bool)loadCurrentUserFromPrefs;
- (RPerson *)getCurrentUser;

// contributor keys
- (bool) validateKey:(NSString *)conKey forProject:(int)projectID;
- (NSString *)getCurrentContributorKey;

// project and data set GET
- (RProject *)getProjectWithId:(int)projectId;
- (RDataSet *)getDataSetWithId:(int)dataSetId;
- (NSArray *)getProjectFieldsWithId:(int)projectId;
- (NSArray *)getDataSetsWithId:(int)projectId;
- (NSArray *)getProjectsAtPage:(int)page withPageLimit:(int)perPage withFilter:(SortType)descending andQuery:(NSString *)search;

// project create
- (int)createProjectWithName:(NSString *)name  andFields:(NSArray *)fields;

// data set upload and append
- (bool)appendDataSetDataWithId:(int)dataSetId  andData:(NSDictionary *)data;
- (bool)appendDataSetDataWithId:(int)dataSetId  andData:(NSDictionary *)data withContributorKey:(NSString *)conKey;
- (int)uploadDataToProject:(int)projectId withData:(NSDictionary *)dataToUpload andName:(NSString *)name;
- (int)uploadDataToProject:(int)projectId withData:(NSDictionary *)dataToUpload withContributorKey:(NSString *)conKey as:(NSString *)conName andName:(NSString *)name;

// media upload
- (int)uploadMediaToProject:(int)projectId withFile:(NSData *)mediaToUpload andName:(NSString *) name withTarget: (TargetType) ttype;
- (int)uploadMediaToProject:(int)projectId withFile:(NSData *)mediaToUpload andName:(NSString *) name withTarget: (TargetType) ttype withContributorKey:(NSString *)conKey as:(NSString *)conName;

// etc
- (NSString *)getVersion;
+ (NSString *)getTimeStamp;

@end
