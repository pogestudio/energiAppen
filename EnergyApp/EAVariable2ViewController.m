//
//  EAVariable2ViewController.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EAVariable2ViewController.h"
#import "EAVariable.h"
#import "EAVariableCondition.h"
#import "EAValue.h"
#import "EAVariable3ViewController.h"
#import "EAAppDelegate.h"
#import "EATemporaryValueStorage.h"


@interface EAVariable2ViewController ()
-(void)updateConditionOfAllVariablesUnderGroupName;
@end

@implementation EAVariable2ViewController


@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize variableGroupName;

- (id)initWithVariableGroupName:(NSString*)name
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.variableGroupName = name;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //set the nav bar title
    self.title = self.variableGroupName;

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.fetchedResultsController = nil;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //clear the temp storage in case we edited some data
    [EATemporaryValueStorage clearStorage];
    
    [self updateConditionOfAllVariablesUnderGroupName];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"An error ocurred: PerformFetch @ EAV2.1"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok :("
                                              otherButtonTitles: nil];
        [alert show];
        //abort();
}
    [self.tableView reloadData];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    int intToReturn = [[self.fetchedResultsController sections] count];
    return intToReturn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    int intToReturn = [sectionInfo numberOfObjects];
    return intToReturn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:CellIdentifier];
    }
    
    
    [self setUpCell:cell withIndexPath:indexPath];
    
    return cell;
}

-(void)setUpCell:(UITableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath
{
    //1 get the object for the index path
    //2 get it's label
    //3 get the number of values filled in
    //4 assign to cell
    
    EAVariable *variableForIndex = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *cellLabel = variableForIndex.title;
    NSString *valueOfVariable = variableForIndex.value.value;
    NSString *unit = variableForIndex.unitForTable;
    NSString *cellDetailLabel;

    if ([valueOfVariable isEqualToString:@""] || valueOfVariable == nil) {
        cellDetailLabel = @"----";
    } else {
        cellDetailLabel = [NSString stringWithFormat:@"%@ %@",valueOfVariable,unit];
    }
    
    cell.textLabel.text = cellLabel;
    cell.detailTextLabel.text = cellDetailLabel;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    EAVariable *fromTheSection = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *sName = fromTheSection.sectionName;
    NSAssert1((sName != nil || ![sName isEqualToString:@""]), @"Some section is empty!" , nil);
    return sName;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EAVariable *selectedVariable = [self.fetchedResultsController objectAtIndexPath:indexPath];
    EAVariable3ViewController *detailViewController = [[EAVariable3ViewController alloc] initWithVariable:selectedVariable];
    detailViewController.managedObjectContext = self.managedObjectContext;
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - 
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EAVariable" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ownerGroup.title = %@ AND shouldShow = 1",self.variableGroupName];
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortKey" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"sectionForTable" cacheName:self.variableGroupName];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"An error ocurred: PerformFetch @ V2.2"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok :("
                                              otherButtonTitles: nil];
        [alert show];
        //abort();
}

    return __fetchedResultsController;
}    


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

-(NSManagedObjectContext*)managedObjectContext
{
    if (__managedObjectContext == nil) {
        NSAssert1(nil,@"Should never be here. We're trying to use MOC before it's defined in EAVariable2", nil);
    }
    
    return __managedObjectContext;
}

-(void)updateConditionOfAllVariablesUnderGroupName
{
    //1 get the list of all the objects that belong to the current variablegroupname, and has a condition
    //2 loop through them, examine their condition
    //3 set to shouldbeshown = YES or NO accordingly
    //4 save MOC
    
    //1
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"EAVariable" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(conditionToShow != nil AND ownerGroup.title = %@)",self.variableGroupName];
    [request setPredicate:predicate];
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [moc executeFetchRequest:request error:&error];
    if (fetchedObjects == nil)
    {
        NSLog(@"\n\nERRRORRR in condition fetchrequest\n\n");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"An error ocurred: UpdateVN @ V2"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok :("
                                              otherButtonTitles: nil];
        [alert show];
        //abort();

    }
    
    //2
    
    for(EAVariable *variable in fetchedObjects)
    {
        
        NSFetchRequest *newRequest = [[NSFetchRequest alloc] init];
        [newRequest setEntity:entityDescription];
        
        EAVariableCondition *currentCondition = variable.conditionToShow;
        NSString *titleOfVariableWhichConditionIsMeantFor = currentCondition.condVarTitle;
        NSString *conditionString = currentCondition.condString;
        NSString *fullCondition = [NSString stringWithFormat:@"title = \'%@\' AND %@",titleOfVariableWhichConditionIsMeantFor,conditionString];
        NSPredicate *newPredicate = [NSPredicate predicateWithFormat:fullCondition];
        
        [newRequest setPredicate:newPredicate];
        
        NSError *error = nil;
        NSArray *theOneObject = [moc executeFetchRequest:newRequest error:&error];
        
        NSAssert1([theOneObject count] < 2, @"Something is wrong with our conditions", nil);
        
        NSInteger shouldShow;
        if ([theOneObject count] == 1) {
            //we have found an object that fits the description of our condition!
            shouldShow = 1;
        } else {
            shouldShow = 0;
        }
        variable.shouldShow = [NSNumber numberWithInt:shouldShow];
        
    }
    
    //4
    EAAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate saveContext];
    
    

}

@end
