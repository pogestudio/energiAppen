//
//  EAVariableGroup+addObjects.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 
 Function of category:
 Offer a working interface to add objects. This main use of this class is no longer needed since we do not use NSOrderedSet.

 Also delivers the subtitle that we wish present in EAVariable1VC
 
 */

#import "EAVariableGroup.h"

@interface EAVariableGroup (addObjects)

- (void)addSubitemsObject:(EAVariableClass *)value;
-(NSString*)stringForAmountOfValuesInTable;
@end
