//
//  QueueCell.m
//  Data_Collector
//
//  Created by Jeremy Poulin on 7/2/13.
//  Modified by Mike Stowell
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
