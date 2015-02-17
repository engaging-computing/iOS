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
// QueueCell.h
// iSENSE_API
//
// Created by Jeremy Poulin on 7/2/13.
// Modified by Mike Stowell
//

#import <UIKit/UIKit.h>
#import "QDataSet.h"
#import "Waffle.h"

@interface QueueCell : UITableViewCell

- (QueueCell *)setupCellWithDataSet:(QDataSet *)dataSet andKey:(NSNumber *)key;
- (void) toggleChecked;
- (void) setDataSetName:(NSString *)name;
- (NSNumber *)getKey;
- (void) setProjID:(NSString *)projID;
- (void) setDesc:(NSString *)desc;
- (BOOL) dataSetHasInitialProject;
- (BOOL) dataSetSetupWithProjectAndFields;
- (void) setFields:(NSMutableArray *)fields;
- (NSMutableArray *) getFields;

@property (nonatomic, assign) IBOutlet UILabel *nameAndDate;
@property (nonatomic, assign) IBOutlet UILabel *description;
@property (nonatomic, assign) IBOutlet UILabel *projIDLabel;

@property (nonatomic, retain) QDataSet *dataSet;
@property (nonatomic, retain) NSNumber *mKey;

@end
