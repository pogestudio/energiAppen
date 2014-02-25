//
//  EAVCVariables.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EAVCVariables.h"

@implementation EAVCVariables


+(UIFont*)fontForTableViewMassText
{
    UIFont *fontWeAreUsing = [UIFont fontWithName:@"Helvetica" size:16.0];
    
    return fontWeAreUsing;
}

+(CGFloat)heightOfGroupedCellForString:(NSString *)text withFont:(UIFont *)font
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat tableWidth = screenWidth*0.87;
    
    CGSize sizeOfConstraint = CGSizeMake(tableWidth, 2000);
    
    CGSize sizeOfString = [text sizeWithFont:font
                                         constrainedToSize:sizeOfConstraint
                                             lineBreakMode:UILineBreakModeWordWrap];
    CGFloat buffer = 20;
    return sizeOfString.height + buffer;
    
}
@end
