//
//  DieView.m
//  DiceRoller
//
//  Created by Rajia  on 9/30/14.
//  Copyright (c) 2014 iSENSE. All rights reserved.
//

#import "DieView.h"

@implementation DieView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        //Initilization Code
        
        //Create UIimage view and assign it to our property.
        self.dieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        //Add the imageview to the view
        [self addSubview:self.dieImageView];
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


- (void) showDieNumber:(int)num colorOfDie:(NSString*)dieColor{
  //This method takes in a number and appends it to a string called filename using the string withFormat class.
    
        NSString *fileName = [NSString stringWithFormat:@"%@%d.png", dieColor, num];
        self.dieImageView.image = [UIImage imageNamed:fileName];
}


@end
