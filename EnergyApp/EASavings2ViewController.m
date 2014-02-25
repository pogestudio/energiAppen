//
//  EASavings2ViewController.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EASavings2ViewController.h"
#import "EASavings.h"
#import "EAFinancial.h"
#import "EASavings1ViewController.h"
#import "EAVCVariables.h"

@interface EASavings2ViewController ()

@end

@implementation EASavings2ViewController

@synthesize savingsToShow;

- (id)initWithSavings:(EASavings *)savings
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        self.savingsToShow = savings;
        self.title = @"Förslag";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger sections = 2;
    if (self.savingsToShow.infoForAudit != nil && ![self.savingsToShow.infoForAudit isEqual:@""]) {
        //we have some info for the audit
        sections++;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    switch (section) {
        case 0:
        {
            //if it's no cost, remove cost and payback.
            NSInteger cost = [self.savingsToShow.financial.cost intValue];
            if (cost == 0) {
                rows = 1;
            } else {
                rows = 3;
            }
            break;
        }

        case 1:
            rows = 1;
            break;
        case 2:
            rows = 1;
            break;
        default:
            NSAssert1(nil,@"Should never be here, something is wrong with rowsForSection", nil);
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *stringToScaleAfter = [self stringForIndexPath:indexPath];
    
    UIFont *fontForTable = [EAVCVariables fontForTableViewMassText];
    CGFloat sizeOfCell = [EAVCVariables heightOfGroupedCellForString:stringToScaleAfter withFont:fontForTable];
    
    return sizeOfCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    [self setUpCell:cell forIndexPath:indexPath];
    
    return cell;
}

-(void)setUpCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        [self setUpFinancialCell:cell forIndexPath:indexPath];
    }
    else {
        [self setUpInfoCell:cell forIndexPath:indexPath];
    }
    
}

-(void)setUpFinancialCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    
    EASavings *savings = self.savingsToShow;
    EAFinancial *financials = savings.financial;
    
    int value;
    float dValue;
    
    NSString *mainLabel;
    NSString *unit;
    NSString *subTitleText;
    
    switch (indexPath.row) {
        case 0:
            value = [financials.savings intValue];
            unit = financials.unitForTable;
            subTitleText = [NSString stringWithFormat:@"%d %@",value,unit];
            break;
        case 1:
            value = [financials.cost intValue];
            unit = @"kr";
            subTitleText = [NSString stringWithFormat:@"%d %@",value,unit];
            break;
        case 2:
            dValue = [financials.payback doubleValue];
            unit = @"år";
            subTitleText = [NSString stringWithFormat:@"%.1f %@",dValue,unit];
            break;
        default:
            NSAssert1(nil,@"Should never be here, something is wrong with setupcell in savings1", nil);
            break;
    }
    mainLabel = [self stringForIndexPath:indexPath];
    cell.textLabel.text = mainLabel;
    cell.detailTextLabel.text = subTitleText;
    cell.accessoryType = UITableViewCellAccessoryNone;  
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    
}

-(void)setUpInfoCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    cell.textLabel.text = [self stringForIndexPath:indexPath];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [EAVCVariables fontForTableViewMassText];    
    cell.detailTextLabel.text = nil;
    
}

-(NSString*)stringForIndexPath:(NSIndexPath*)indexPath
{
    NSString *cellText;
    
    if (indexPath.section == 0) {
        
    }
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    cellText = @"Besparing";
                    break;
                case 1:
                    cellText = @"Investering";
                    break;
                case 2:
                    cellText = @"Återbetalning";
                    break;
                default:
                    NSAssert1(nil,@"Should never be here, something is wrong with stringForIndexPath in savings1", nil);
                    break;
            }
        }
            break;
        case 1:
            cellText = self.savingsToShow.infoToUser;
            break;
        case 2:
            cellText = self.savingsToShow.infoForAudit;
            break;
        default:
            NSAssert1(nil,@"Should never be here, something is wrong with stringForIndexPath", nil);
            break;
    }
    
    return cellText;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* header;
    switch (section) {
        case 0:
            header = self.savingsToShow.title;
            break;
        case 1:
            header = @"Åtgärdsförslaget";
            break;
        case 2:
            header = @"Inför energibesiktning";
            break;
            
        default:
            NSAssert1(nil,@"Should never be here, something is wrong with titleForHeader", nil);
            break;
    }
    
    return header;
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
