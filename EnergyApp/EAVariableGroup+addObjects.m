//
//  EAVariableGroup+addObjects.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EAVariableGroup+addObjects.h"
#import "EAVariable.h"
#import "EAValue.h"

@implementation EAVariableGroup (addObjects)

- (void)addSubitemsObject:(EAVariableClass *)value {
    NSMutableSet* tempSet = [NSMutableSet setWithSet:self.variables];
    [tempSet addObject:value];
    self.variables = tempSet;
}

-(NSString*)stringForAmountOfValuesInTable
{
    NSArray *objects = [self.variables allObjects];
    NSInteger amountOfValues = 0;
    
    NSInteger amountOfNonEmptyValues = 0;
    
    for (EAVariable *variable in objects)
    {
        EAValue *valueOfVariable = variable.value;
        NSString *textStoredInValue = valueOfVariable.value;
        
        if ([variable.shouldShow intValue] == 1) {
            amountOfValues++;
            
            if (textStoredInValue != nil && ![textStoredInValue isEqualToString:@""])
            {
                amountOfNonEmptyValues++;
            }
        }
    }
    
    NSString *subtitleForCell;
    
    if (amountOfNonEmptyValues == 0) {
        subtitleForCell = @"Inga värden ifyllda";
    } else {
        subtitleForCell = [NSString stringWithFormat:@"%d av %d värden ifyllda",amountOfNonEmptyValues,amountOfValues];
    }
    
    return subtitleForCell;
}

@end
