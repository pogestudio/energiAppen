//
//  EAInfo1ViewController.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EAInfo1ViewController : UITableViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


-(id)initWithTabBar;

@end
