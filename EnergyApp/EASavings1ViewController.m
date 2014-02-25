//
//  EASavings1ViewController.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EASavings1ViewController.h"
#import "EACalculateSavings.h"
#import "EASavings+calculate.h"
#import "EAFinancial.h"
#import "EASavings2ViewController.h"
#import "EAAppDelegate.h"

#import "EAFacebookHelper.h"

typedef enum {
    TableSortSavings,
    TableSortCost,
    TableSortPayback
} TableSort;

@interface EASavings1ViewController (Private)

@end

@implementation EASavings1ViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize FBHelper;

- (id)initWithTabBar
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        self.title = @"Besparingar";
        UIImage* anImage = [UIImage imageNamed:@"tabbar_calculator"];
        UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Besparingar" image:anImage tag:1];
        self.tabBarItem = theItem;   
        currentTableSort = TableSortSavings;
        self.FBHelper = [[EAFacebookHelper alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareToOthers:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.fetchedResultsController = nil;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //calculate savings
    EACalculateSavings * calcSavings = [[EACalculateSavings alloc] init];
    calcSavings.managedObjectContext = self.managedObjectContext;
    [calcSavings calculateSavings];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"An error ocurred: PerformFetch @ S1.1"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok :("
                                              otherButtonTitles: nil];
        [alert show];
	}
    
    //reload data to update the table after a new fetch as been made
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat tableWidth = self.tableView.bounds.size.width;
    CGFloat segmentWidth = tableWidth*0.25;
    CGFloat buffer = (screenWidth - segmentWidth*3.0)/2.0;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.bounds.size.width, 60)];
    
    //put a segmented control which changes the sorting.
    NSArray *arrayOfSort = [NSArray arrayWithObjects:@"Besparing",@"Kostnad",@"Återbetalning",nil];
    
    CGRect frameForTopSort = CGRectMake(buffer,10,segmentWidth*3,30);
    UISegmentedControl *topSort = [[UISegmentedControl alloc] initWithItems:arrayOfSort];
    topSort.frame = frameForTopSort;

    topSort.selectedSegmentIndex = currentTableSort;
    [topSort addTarget:self action:@selector(sortingChanged:) forControlEvents:UIControlEventValueChanged];
    topSort.segmentedControlStyle = UISegmentedControlStyleBar;
    
    [topSort setWidth:segmentWidth forSegmentAtIndex:0];
    [topSort setWidth:segmentWidth-10 forSegmentAtIndex:1];
    [topSort setWidth:segmentWidth+10 forSegmentAtIndex:2];
    
    
    [headerView addSubview:topSort];

    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
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
    
    [self setUpCell:cell forIndexPath:indexPath];
        
    return cell;
}

-(void)setUpCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    EASavings *savings = [self.fetchedResultsController objectAtIndexPath:indexPath];
    EAFinancial *financials = savings.financial;
    
    int value;
    double dValue;
    
    NSString *unit;
    NSString *subTitleText;
    
    //hide subtitletext altogether if there's no value. we don't want to show 0
    
    switch (currentTableSort) {
        case TableSortSavings:
        {
            value = [financials.savings intValue];
            unit = financials.unitForTable;
            if (value != 0) {
                subTitleText = [NSString stringWithFormat:@"ca %d %@",value,unit];
            } else {
                subTitleText = nil;
            }
            break;
        }
        case TableSortCost:
        {
            value = [financials.cost intValue];
            unit = @"kr";
            if (value != 0) {
                subTitleText = [NSString stringWithFormat:@"ca %d %@",value,unit];
            } else {
                subTitleText = nil; 
            }
            break;
        }
        case TableSortPayback:
        {
            dValue = [financials.payback doubleValue];
            unit = @"år";
            if (dValue != 0) {
                subTitleText = [NSString stringWithFormat:@"ca %.1f %@",dValue,unit];
            } else {
                subTitleText = nil;
            }
            break;
        }
        default:
            NSAssert1(nil,@"Should never be here, something is wrong with setupcell in savings1", nil);
            break;
    }
    

    cell.textLabel.text = savings.title;
    cell.detailTextLabel.text = subTitleText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //If the savings is 1, it's purely informational and no real values.
    //If so, hide the information
    
    if ([financials.savings intValue] == 1) {
        cell.detailTextLabel.text = @"";
    }
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
    EASavings *selected = [self.fetchedResultsController objectAtIndexPath:indexPath];
    EASavings2ViewController *newVC = [[EASavings2ViewController alloc] initWithSavings:selected];
    newVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newVC animated:YES];
}



-(void)sortingChanged:(id)sender
{
    NSAssert1([sender isKindOfClass:[UISegmentedControl class]], @"sender is not segmentcontroller :P", nil);
    UISegmentedControl *sortSeg = (UISegmentedControl*)sender;
    NSInteger selected = sortSeg.selectedSegmentIndex;
    currentTableSort = selected;
    
    NSError *error;
    [[self.fetchedResultsController  fetchRequest] setSortDescriptors:[self currentSortDescriptor]];
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSAssert1(nil, @"Got error in fetch request. wooot", nil);
    }
    [self.tableView reloadData];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EASavings" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shouldBeShown = 1"];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setSortDescriptors:[self currentSortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"sectionForTable" cacheName:@"Savings"];
    
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"An error ocurred: PerformFetch @ S1.2"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok :("
                                              otherButtonTitles: nil];
        [alert show];
	}
    __fetchedResultsController = aFetchedResultsController;
    
    return __fetchedResultsController;
}    

-(NSArray*)currentSortDescriptor
{
    NSSortDescriptor *sortDescriptor;
    switch (currentTableSort) {
        case TableSortSavings:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"financial.savings" ascending:NO];
            break;
        case TableSortCost:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"financial.cost" ascending:YES];
            break;
        case TableSortPayback:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"financial.payback" ascending:YES];
            break;
            
        default:
            NSAssert1(nil, @"Should never be here. something wrong with current sort descriptor", nil);
            break;
    }
    NSArray *sorters = [NSArray arrayWithObject:sortDescriptor];
    return sorters;
    
}

#pragma mark -
#pragma mark Share and Email related stuff
-(void)shareToOthers:(id)sender
{
    // open a dialog with two custom buttons
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Skryt om den användbara Appen!"
                                                             delegate:self cancelButtonTitle:@"Avbryt" destructiveButtonTitle:nil
                                                    otherButtonTitles: @"EnergiAppen @ Facebook", @"Posta på Facebook",@"Maila bekanta",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;

    //using app delegate for window, since it turns black if we use tabbar
    EAAppDelegate *appDelegate = (EAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [actionSheet showInView:appDelegate.window]; // show from our table view (pops up in the middle of the table)
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
        case 0:
        {
            [self.FBHelper goToFacebookPage];
            break;
        }
        case 1:
        {
            //posta på facebook
            [self.FBHelper postOnWall];
            break;
        }
        case 2:
        {
            //maila andra med en trevlig text
            [self tryToOpenMail];
            break;
        }
        case 3:
        {
            //cancel - do nothing
            break;
        }
        default:
            NSAssert1(nil,@"Should never be here, something is wrong with actionsheet function", nil);
            break;
    }
}

#pragma mark -
#pragma mark EMAIL STUFF
- (void)tryToOpenMail
{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Kolla in EnergiAppen!"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"", nil];
        [mailer setToRecipients:toRecipients];
        
        NSArray *arrayOfSavings = [self.fetchedResultsController fetchedObjects];
        NSInteger amountOfSuggestions = [arrayOfSavings count];
        NSString *emailBody = [NSString stringWithFormat:@"Hej!<br>Jag har använt EnergiAppen på iOS. Den visar besparingar, investeringskostnader och annan nyttig information på %d olika förslag för mitt hus! <br><br>(Förutom all annan information som hjälper Mig att sänka Mina energikostnader, förstås)<br> <a href=http://itunes.apple.com/se/app/cooliris/id294479487?l=en&mt=8>Testa du med!</a>",amountOfSuggestions];
        [mailer setMessageBody:emailBody isHTML:YES];
        
        
        UIImage *myImage = [UIImage imageNamed:@"emailAttachment"];
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"EnergiAppen"]; 
        
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ingen mail"
                                                        message:@"Tyvärr har enheten ingen möjlighet att skicka mail, kanske p.g.a. inget mailkonto är konfigurerat. Skicka igenom en extern mailklient."
                                                       delegate:nil
                                              cancelButtonTitle:@"Okey!"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    
    if (result == MFMailComposeResultSent)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mailet är färdigskrivet"
                                                        message:@"Det ligger och väntar i outbox, gå till mail-applikationen för att skicka iväg det!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    } else if (result == MFMailComposeResultFailed)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fel"
                                                        message:@"Ett fel utanför EnergiAppen uppstod och mailet är varken sparat eller skickat, prova att skicka manuellt istället."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }    
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}


@end
