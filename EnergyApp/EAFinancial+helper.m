//
//  EAFinancial+helper.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EAFinancial+helper.h"
#import "EASavings.h"

@implementation EAFinancial (helper)

- (void)setSavings:(NSNumber *)savings
{
    [self willChangeValueForKey:@"savings"];
    [self setPrimitiveValue:savings forKey:@"savings"];
    [self didChangeValueForKey:@"savings"];
    
    //set ownersavings to shown if savings is positive.
    //why? because shouldBeShown is the condition to show savings in savingsVC
    EASavings *ownerSavings = self.ownerSavings;
    NSInteger isSavingsPositive = [savings intValue] > 0 ? 1 : 0;
    ownerSavings.shouldBeShown = [NSNumber numberWithInt:isSavingsPositive];
}

@end
