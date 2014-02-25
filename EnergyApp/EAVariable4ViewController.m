//
//  EAVariable4ViewController.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EAVariable4ViewController.h"

#import "EAVCVariables.h"

@interface EAVariable4ViewController ()


@property (retain, nonatomic) NSString *information;
@property (retain, nonatomic) NSString *whereToFindIt;

@end

@implementation EAVariable4ViewController

@synthesize whereToFindIt,information;

- (id)initWithInformation:(NSString*)info andLocation:(NSString*)location forVariable:(NSString*)variableName
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.information = info;
        self.whereToFindIt = location;
        
        self.title = variableName;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Klar" style:UIBarButtonSystemItemDone target:self action:@selector(dismissView:)];
    
    
    
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dismissView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view data source

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section) {
        case 0:
        {
            sectionName = @"Var hittar man uppgifter?";
            break;
        }

        case 1:
        {
            sectionName = @"Generell information";
            break;
        }
            
        default:
        {
            NSAssert1(nil,@"Should never be here, something is wrong with titleForHeaderInSection", nil);
        }
            break;
    }
    
    return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *stringToScaleAfter = [self stringForIndexPath:indexPath];
    UIFont *fontForTable = [EAVCVariables fontForTableViewMassText];
    CGFloat sizeOfCell = [EAVCVariables heightOfGroupedCellForString:stringToScaleAfter withFont:fontForTable];
    
    return sizeOfCell;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [EAVCVariables fontForTableViewMassText];
    }
    NSString *stringForCell = [self stringForIndexPath:indexPath];
    
    cell.textLabel.text = stringForCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSString*)stringForIndexPath:(NSIndexPath*)indexPath
{
    NSString *stringToReturn;
    switch (indexPath.section) {
        case 0:
        {
            // where to find it
            stringToReturn = self.whereToFindIt;
        }
            break;
        case 1:
        {
            //information
            stringToReturn = self.information;
            
        }
            break;
        default:
        {
            NSAssert1(nil,@"Should never be here, something is wrong with setUpCell in EAVar4", nil);
        }
            break;
    }
    
    return stringToReturn;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
