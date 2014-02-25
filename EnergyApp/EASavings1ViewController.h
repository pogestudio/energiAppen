//
//  EASavings1ViewController.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@class EAFacebookHelper;

@interface EASavings1ViewController : UITableViewController	 <MFMailComposeViewControllerDelegate, //for mail
                                                                UIActionSheetDelegate >	// for UIActionSheet

{
    @private
    NSInteger currentTableSort;
}


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) EAFacebookHelper *FBHelper;


-(id)initWithTabBar;

@end
