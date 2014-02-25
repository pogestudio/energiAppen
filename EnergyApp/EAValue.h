//
//  EAValue.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EAVariable;

@interface EAValue : NSManagedObject

@property (nonatomic, retain) NSNumber * typeOfValue;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSNumber * sortKey;
@property (nonatomic, retain) EAVariable *ownerPickerVariable;
@property (nonatomic, retain) EAVariable *ownerVariable;

@end
