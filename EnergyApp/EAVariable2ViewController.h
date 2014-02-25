//
//  EAVariable2ViewController.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EAVariable2ViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{

}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (retain, nonatomic) NSString *variableGroupName;

- (id)initWithVariableGroupName:(NSString*)name;

@end
