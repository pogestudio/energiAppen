//
//  EAVariableGroup.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EAVariableClass.h"

@class EAVariableClass;

@interface EAVariableGroup : EAVariableClass

@property (nonatomic, retain) NSSet *variables;
@end

@interface EAVariableGroup (CoreDataGeneratedAccessors)

- (void)addVariablesObject:(EAVariableClass *)value;
- (void)removeVariablesObject:(EAVariableClass *)value;
- (void)addVariables:(NSSet *)values;
- (void)removeVariables:(NSSet *)values;

@end
