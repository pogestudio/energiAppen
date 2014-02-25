//
//  EAVariableCondition.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EAVariable;

@interface EAVariableCondition : NSManagedObject

@property (nonatomic, retain) NSString * condString;
@property (nonatomic, retain) NSString * condVarTitle;
@property (nonatomic, retain) EAVariable *ownerVariable;

@end
