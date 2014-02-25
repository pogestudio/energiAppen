//
//  EADatabaseFetcher.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 
 Function of class:
 Calls the DB and tries to fetch a variable, then calls the theValue category recursing the stuff back back and back
 
 */
#import <Foundation/Foundation.h>

@class EAVariable;

@interface EADatabaseFetcher : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(EAVariable*)getVariableWithTitle:(NSString *)stringToLookup;
-(NSString*)getValueOfVariableWithTitle:(NSString *)stringToLookup;

@end
