//
//  EACalculateSavings.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EACalculateSavings.h"
#import "EASavings+calculate.h"
#import "EAAppDelegate.h"
#import "EATemporaryValueStorage.h"

@interface EACalculateSavings (Private)

-(NSArray*)getAllEASavings;

@end

@implementation EACalculateSavings

@synthesize managedObjectContext = __managedObjectContext;

-(void)calculateSavings
{
    //1 clear the temporary storage of variables
    //2 get an array with all the easavings
    //3 loop through them and send each to a calc.func.
    //4 save moc
        
    //1
    [EATemporaryValueStorage clearStorage];
    
    //2
    NSArray *arrayWithAllSavings = [self getAllEASavings];
    
    //3
    for (EASavings* savings in arrayWithAllSavings)
    {
        [savings calculateFinancials];
        
    }
    
    //4
    EAAppDelegate *appDelegate = (EAAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
    
}

-(NSArray*)getAllEASavings
{
    NSManagedObjectContext *moc = self.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"EASavings" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"title" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    NSArray *arrayOfFetch = [moc executeFetchRequest:request error:&error];
    if (arrayOfFetch == nil || [arrayOfFetch count] == 0)
    {
        NSAssert1(nil,@"We get no returned values in fetcharray of getAllEaSavings?", nil);
    }

    return arrayOfFetch;
}


-(NSManagedObjectContext*)managedObjectContext
{
    if (__managedObjectContext == nil) {
        NSAssert1(nil,@"Should never be here. We're trying to use MOC before it's defined in EAVariable2", nil);
    }
    
    return __managedObjectContext;
}

@end
