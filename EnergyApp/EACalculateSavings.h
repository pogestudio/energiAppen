//
//  EACalculateSavings.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 
 Function of class:
 Basically an interface for calculating the savings. Removing logic fom VC
 
 */


#import <Foundation/Foundation.h>

@interface EACalculateSavings : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)calculateSavings;

@end
