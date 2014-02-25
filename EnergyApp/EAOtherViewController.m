//
//  EAOtherViewController.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EAOtherViewController.h"
#import "EAFacebookHelper.h"
#import "EAAboutUsViewController.h"

#import "EATutorialViewController.h"

@interface EAOtherViewController ()

@end

@implementation EAOtherViewController

@synthesize FBHelper;

- (id)initWithTabBar
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        self.title = @"Övrigt";
        UIImage* anImage = [UIImage imageNamed:@"tabbar_signpost"];
        UITabBarItem* theItem = [[UITabBarItem alloc] initWithTitle:@"Övrigt" image:anImage tag:1];
        self.tabBarItem = theItem;  
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    
    [self setupCell:cell forIndexPath:indexPath];
    
    return cell;
}

-(void)setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    
    NSInteger row = indexPath.row;
    
    NSInteger accessoryType;
    NSString *cellText;
    UIImage *cellImage;
    switch (row) {
        case 0:
        {
            //tutorial
            accessoryType = UITableViewCellAccessoryNone;
            cellText = @"Se guide";
            cellImage = [UIImage imageNamed:@"tutorialTableView"];
            break;

        }
        case 1:
        {
            //facebook
            accessoryType = UITableViewCellAccessoryNone;
            cellText = @"EnergiAppen på Facebook";
            cellImage = [UIImage imageNamed:@"facebookTableView"];
            break;
        }
        case 2:
        {
            //maila
            accessoryType = UITableViewCellAccessoryNone;
            cellText = @"Maila feedback/fråga";
            cellImage = [UIImage imageNamed:@"emailTableView"];
            break;
        }
        case 3:
        {
            //Om energiappen
            accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cellText = @"Om EnergiAppen";
            cellImage = [UIImage imageNamed:@"energyappTableView"];
            break;
        }
            
        default:
            NSAssert1(nil,@"Should never be here, something is wrong with setUpCell function", nil);
            break;
    }
    
    cell.accessoryType = accessoryType;
    cell.imageView.image = cellImage;
    cell.textLabel.text = cellText;
    
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

    switch (indexPath.row) {
        case 0:
        {
            //tutorial!
            EATutorialViewController *tut = [[EATutorialViewController alloc] initAsFirstTime:NO];
            [self presentModalViewController:tut animated:YES];
            
            break;
        }   
            
        case 1:
        {
            //facebook
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.FBHelper goToFacebookPage];
            break;
        }
        case 2:
        {
            //mail!
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self tryToOpenMail];
            break;
        }
        case 3:
        {
            //about US =)
            EAAboutUsViewController *newVC = [[EAAboutUsViewController alloc] initWithNibName:@"EAAboutUsViewController" bundle:nil];
            newVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newVC animated:YES];
            break;
        }
        default:
            
            NSAssert1(nil,@"Should never be here, something is wrong with didSelectRowAtIndexPath", nil);
            break;
    }
    
    
}

#pragma mark email
- (void)tryToOpenMail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Från appen: "];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"energiappen@pogestudio.com", nil];
        [mailer setToRecipients:toRecipients];
        NSString *emailBody = @"";
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ingen mail"
                                                        message:@"Tyvärr har enheten ingen möjlighet att skicka mail, verifiera att ett mailkonto är konfigurerat på enheten. Om det inte löser sig, skicka genom extern mail till energiappen@pogestudio.com"
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
