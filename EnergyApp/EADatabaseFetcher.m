//
//  EADatabaseFetcher.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EADatabaseFetcher.h"
#import "EAAppDelegate.h"
#import "EAVariable+additions.h"

@implementation EADatabaseFetcher

@synthesize managedObjectContext = __managedObjectContext;


-(EAVariable*)getVariableWithTitle:(NSString *)stringToLookup
{
    
    NSManagedObjectContext *moc = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"EAVariable" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"title = %@", stringToLookup];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *arrayOfFetch = [moc executeFetchRequest:request error:&error];
    if (arrayOfFetch == nil || [arrayOfFetch count] != 1)
    {
        NSLog(@"%@",stringToLookup);
        NSAssert1(nil,@"We get no returned values. Wrong title in getVariableForString?", nil);
    }
    
    EAVariable *variable = [arrayOfFetch objectAtIndex:0];
    
    NSAssert1(variable != nil, @"The value should not be nil.", nil);
    
    return variable;
}

-(NSString*)getValueOfVariableWithTitle:(NSString *)stringToLookup
{
    EAVariable *varToLookup = [self getVariableWithTitle:stringToLookup];
    NSString *actualValue = [varToLookup theValue];
    return actualValue;
}


-(NSManagedObjectContext*)managedObjectContext
{
    if (__managedObjectContext == nil) {
        EAAppDelegate *appDelegate = (EAAppDelegate*)[UIApplication sharedApplication].delegate;
        __managedObjectContext = appDelegate.managedObjectContext;
    }
    
    return __managedObjectContext;
}

@end
