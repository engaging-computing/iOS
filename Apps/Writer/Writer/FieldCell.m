//
//  FieldCellTableViewCell.m
//  Writer
//
//  Created by Mike Stowell on 11/20/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "FieldCell.h"

@implementation FieldCell


- (void) awakeFromNib {

    // Initialization code
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (FieldCell *) setupCellWithField:(NSString *)field {

    self.fieldNameLbl.text = field;
    self.fieldNameLbl.backgroundColor = [UIColor clearColor];
    
    self.backgroundColor = [UIColor clearColor];

    return self;
}

- (void) setFieldData:(NSString *)fieldData {

    self.fieldDataTxt.text = fieldData;
}

- (NSString *) getData {

    // TODO or should we return what is in the UITextField?
    return self.fieldDataTxt.text;
}

@end
