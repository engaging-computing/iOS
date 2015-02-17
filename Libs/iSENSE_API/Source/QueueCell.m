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
// QueueCell.m
// iSENSE API
//
// Created by Jeremy Poulin on 7/2/13.
// Modified by Mike Stowell
//

#import "QueueCell.h"

@implementation QueueCell

@synthesize nameAndDate, description, projIDLabel, dataSet, mKey;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (QueueCell *)setupCellWithDataSet:(QDataSet *)ds andKey:(NSNumber *)key {
    
    self.dataSet = ds;
    
    self.mKey = key;
    self.nameAndDate.text = ds.name;
    self.description.text = ds.dataDescription;

    if (ds.projID.intValue <= 0) {
        self.projIDLabel.text = @"No Project";
        self.projIDLabel.textColor = [UIColor redColor];
    } else {
        self.projIDLabel.text = [NSString stringWithFormat:@"%d", ds.projID.intValue];
        self.projIDLabel.textColor = [UIColor blackColor];
    }

    [self setCheckedSwitch:ds.uploadable.boolValue];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)setCheckedSwitch:(bool)checked {
    if (checked) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void) toggleChecked {
    if (dataSet.uploadable.boolValue == false) {
        [self setCheckedSwitch:true];
        dataSet.uploadable = [NSNumber numberWithBool:true];
    } else {
        [self setCheckedSwitch:false];
        dataSet.uploadable = [NSNumber numberWithBool:false];
    }
}

- (void) setDataSetName:(NSString *)name {
    self.nameAndDate.text = name;
    [dataSet setName:name];
}

- (NSNumber *)getKey {
    return mKey;
}

- (void) setProjID:(NSString *)projID {
    [self.projIDLabel setText:projID];
    self.projIDLabel.textColor = [UIColor blackColor];

    [dataSet setProjID:[NSNumber numberWithInt:[projID intValue]]];
    [dataSet setUploadable:[NSNumber numberWithBool:(projID > 0)]];
}

- (void) setDesc:(NSString *)desc {
    self.description.text = desc;
    [dataSet setDataDescription:desc];
}

- (BOOL) dataSetHasInitialProject {
    NSNumber *initial = [dataSet hasInitialProj];
    return [initial boolValue];
}

- (BOOL) dataSetSetupWithProjectAndFields {
    NSNumber *projID = [dataSet projID];
    id fields = [dataSet fields];
    return (projID.intValue > 0 && fields != NULL);
}

- (void) setFields:(NSMutableArray *)fields {
    [dataSet setFields:fields];
}

- (NSMutableArray *) getFields {
    return dataSet.fields;
}

@end
