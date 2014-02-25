//
//  EAOtherViewController.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class EAFacebookHelper;

@interface EAOtherViewController : UITableViewController <MFMailComposeViewControllerDelegate>
{
    @private
    NSArray *_listArray;
}

@property (retain, nonatomic) EAFacebookHelper *FBHelper;


-(id)initWithTabBar;


@end
