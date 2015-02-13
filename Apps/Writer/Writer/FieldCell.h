//
// FieldCellTableViewCell.h
// Writer
//
// Created by Mike Stowell on 11/20/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <UIKit/UIKit.h>
#import "FieldData.h"

@interface FieldCell : UITableViewCell

- (FieldCell *) setupCellWithField:(NSString *)field data:(NSString *)data andRestrictions:(NSArray *)restr;

- (void) setFieldData:(NSString *)fieldData;
- (NSString *) getData;

@property (weak, nonatomic) IBOutlet UILabel *fieldNameLbl;
@property (weak, nonatomic) IBOutlet UITextField *fieldDataTxt;
@property (weak, nonatomic) NSArray *restrictions;

@end
