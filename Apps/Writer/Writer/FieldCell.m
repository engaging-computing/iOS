//
// FieldCellTableViewCell.m
// Writer
//
// Created by Mike Stowell on 11/20/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import "FieldCell.h"

@implementation FieldCell

@synthesize restrictions;

- (void) awakeFromNib {
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}

- (FieldCell *) setupCellWithField:(NSString *)field data:(NSString *)data andRestrictions:(NSArray *)restr {

    self.fieldNameLbl.text = field;
    self.fieldNameLbl.backgroundColor = [UIColor clearColor];

    self.fieldDataTxt.text = data;

    self.restrictions = restr;
    
    self.backgroundColor = [UIColor clearColor];

    return self;
}

- (void) setFieldData:(NSString *)fieldData {

    self.fieldDataTxt.text = fieldData;
}

- (NSString *) getData {

    return self.fieldDataTxt.text;
}

@end
