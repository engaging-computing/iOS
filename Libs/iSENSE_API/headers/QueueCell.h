//
// QueueCell.h
// iSENSE_API
//
// Created by Jeremy Poulin on 7/2/13.
// Modified by Mike Stowell
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
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
