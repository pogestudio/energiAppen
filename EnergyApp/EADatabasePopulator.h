//
//  EADatabasePopulator.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 
 Function of class:
 Populate the DB at first time launch.
 Inludes three sections: Variables, Savings and Info
 plus all the functions of populating
 
 */


#import <Foundation/Foundation.h>
@class EAVariableGroup;
@class EAVariableCalculator;

@interface EADatabasePopulator : NSObject
{
    EAVariableGroup *theHouse;
    
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) EAVariableCalculator *variableStorage;

-(void)checkDatabaseAndPopulateIfNeeded;
-(BOOL)doesDBContainEntries;


@end
