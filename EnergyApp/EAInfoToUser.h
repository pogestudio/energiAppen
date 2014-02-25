//
//  EAInfoToUser.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EAInfoToUser : NSManagedObject

@property (nonatomic, retain) NSNumber * sectionForTable;
@property (nonatomic, retain) NSString * sectionName;
@property (nonatomic, retain) NSNumber * sortKey;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;

@end
