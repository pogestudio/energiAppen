//
//  EASavings2ViewController.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EASavings;


@interface EASavings2ViewController : UITableViewController

-(id)initWithSavings:(EASavings*)savings;

@property (strong, nonatomic) EASavings *savingsToShow;

@end
