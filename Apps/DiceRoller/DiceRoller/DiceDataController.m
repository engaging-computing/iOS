//
//  DiceDataController.m
//  DiceRoller
//
//  Created by Rajia  on 10/3/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "DiceDataController.h"

@implementation DiceDataController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (int) getDieNumber
{
    //this uses the arc4random function to generate a random number between 0-6
    int r = (arc4random()%6) + 1;
    return r;
}


-(void) uploadDatadie1:(int)num1 die2: (int)num2 sumOfDies: (int)sumNum numOfTests: (int)numTest{


    // operations performed that involve querying the iSENSE website should always be done in a background
    // thread.  in iOS, this is done by creating a dispatch queue.  the "upload_data_to_isense" name is
    // arbitrary, so feel free to change this string.
    dispatch_queue_t queue = dispatch_queue_create("upload_data_to_isense", NULL);
    dispatch_async(queue, ^{
        
        // normally, data would be passed into a method that makes this upload call.
        // we will declare an arbitrary dice-roll and name for the data set
        int whiteDiceValue = num1;
        int yellowDiceValue = num2;
        int diceRollSum = sumNum;
        NSString *dataSetName =[NSString stringWithFormat:@"Rajia's dice sum test %d",numTest];
        
        // declare an instance of the singleton API object
        API *isenseAPI = [API getInstance];
        
        // if using the development iSENSE site, turn on development mode
        [api useDev:true];
        
        // declare a project to upload to, username, and password.
        // this example assumes the project has the fields "white dice", "yellow dice", and "sum"
        int projectID = 876;
        NSString *userEmail = @"abeer603@gmail.com";
        NSString *password = @"dice1";
        
        // login to the iSENSE site
        [isenseAPI createSessionWithEmail:userEmail andPassword:password];
        
        // pull down fields for the iSENSE project as an array of RProjectField objects
        NSArray *projectFields = [isenseAPI getProjectFieldsWithId:projectID];
        
        // initialize an array to store your data
        NSMutableArray *rowMajorData = [[NSMutableArray alloc] init];
        
        // each data row is a dictionary, where the keys are the project's field IDs and the values
        // are the data you want to store for each field.  if you want more data rows per data
        // set, you can declare additional dictionaries, populate them as we will below, and also add
        // them to the data array.  PLEASE NOTE that iSENSE only accepts strings as keys and values,
        // however, so when adding the data to the dictionary, store the field ID and value as a string
        NSMutableDictionary *dataRow = [[NSMutableDictionary alloc] init];
        
        // loop through the project fields and store each data point in a dictionary
        for (RProjectField *field in projectFields) {
            
            // see if this field contains "white" or "yellow" in it
            if ([field.name.lowercaseString rangeOfString:@"white"].location != NSNotFound) {
                
                // if we're here, this is our value of the white dice
                // remember, the object and key should be strings!
                [dataRow setObject:[NSString stringWithFormat:@"%d", whiteDiceValue]
                            forKey:[NSString stringWithFormat:@"%d", field.field_id.intValue]];
                
                
            } else if ([field.name.lowercaseString rangeOfString:@"yellow"].location != NSNotFound) {
                
                // if we're here, this is our value of the yellow dice
                [dataRow setObject:[NSString stringWithFormat:@"%d", yellowDiceValue]
                            forKey:[NSString stringWithFormat:@"%d", field.field_id.intValue]];
                
            } else {
                
                // if we're here, this is the dice sum value
                [dataRow setObject:[NSString stringWithFormat:@"%d", diceRollSum]
                            forKey:[NSString stringWithFormat:@"%d", field.field_id.intValue]];
                
            }
        }
        
        // add this data row to our data array
        [rowMajorData addObject:dataRow];
        
        // at this point, feel free to add more data points to the rowMajorData array!
        // to prevent the need for parsing the project's fields and logging in multiple times,
        // make sure you only make these API calls once though.
        
        // when storing data, we typically follow the format we did above.  this style is called row-major
        // because we stored one data row in our array at a time.  iSENSE, however, expects data in
        // column-major format.  that is, our data object needs to be a dictionary where the keys are
        // the field IDs and the values are an array of all data points for that key.  luckily, the iSENSE
        // iOS library comes with a DataManager object that will perform this conversion step for us.
        NSDictionary *columnMajorData = [DataManager convertDataToColumnMajor:rowMajorData forProjectID:projectID];
        
        // upload the data to iSENSE
        [isenseAPI uploadDataToProject:projectID withData:columnMajorData andName:dataSetName];
        
        // you're done! this uploadDataToProject method returns a data set ID number that you can store or check.
        // this dataSetID variable will now contain either a positive integer if the data uploaded
        // successfully (namely the ID of your new data set), or -1 if the upload failed.  if your upload failed,
        // you may have misformatted the data
    
        //End Mike's code

}

@end
