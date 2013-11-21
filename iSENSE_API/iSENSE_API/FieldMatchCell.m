//
//  FieldMatchCell.m
//  iSENSE_API
//
//  Created by Michael Stowell on 11/14/13.
//  Copyright (c) 2013 Jeremy Poulin. All rights reserved.
//

#import "FieldMatchCell.h"

@implementation FieldMatchCell

@synthesize fieldName, fieldMatch;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (FieldMatchCell *)setupCellWithName:(NSString *)name andMatch:(NSString *)match {
    
    [self.fieldName setText:name];
    [self.fieldMatch.titleLabel setText:match];
    
    return self;
}

- (void) setName:(NSString *)name {
    [fieldName setText:name];
}

- (void) setMatch:(NSString *)match {
    [fieldMatch.titleLabel setText:match];
}

- (NSString *) getName {
    return fieldName.text;
}

- (NSString *) getMatch {
    return fieldMatch.titleLabel.text;
}

@end