//
//  EAInfo2ViewController.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EAInfo2ViewController : UITableViewController
{
    
    @private
    NSString *titleForView;
    NSString *textForCell;
    
}

- (id)initWithTitle:(NSString*)title text:(NSString*)text;

@end
