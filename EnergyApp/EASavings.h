//
//  EASavings.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EAFinancial;

@interface EASavings : NSManagedObject

@property (nonatomic, retain) NSString * infoForAudit;
@property (nonatomic, retain) NSString * infoToUser;
@property (nonatomic, retain) NSNumber * sectionForTable;
@property (nonatomic, retain) NSNumber * shouldBeShown;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) EAFinancial *financial;

@end
