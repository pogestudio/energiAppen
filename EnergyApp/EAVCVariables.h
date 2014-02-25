//
//  EAVCVariables.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 
 Function of class:
 Offers VC Variables and functions. 
 
 */

#import <UIKit/UIKit.h>

@interface EAVCVariables : NSObject
{
    
}

+(UIFont*)fontForTableViewMassText;
+(CGFloat)heightOfGroupedCellForString:(NSString*)text withFont:(UIFont*)font;

@end
