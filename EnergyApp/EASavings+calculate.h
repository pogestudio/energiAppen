//
//  EASavings+calculateSavings.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 
 Function of category:
 Calculate the savings depending on the title
 
 */


#import "EASavings.h"

@interface EASavings (calculate) <NSFetchedResultsControllerDelegate>

-(void)calculateFinancials;

@end
