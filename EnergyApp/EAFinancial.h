//
//  EAFinancial.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EASavings;

@interface EAFinancial : NSManagedObject

@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSNumber * payback;
@property (nonatomic, retain) NSNumber * savings;
@property (nonatomic, retain) NSString * unitForTable;
@property (nonatomic, retain) EASavings *ownerSavings;

@end
