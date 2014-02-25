//
//  EAFacebookHelper.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 
 Function of class:
 Interface for the FB functions that we use in the appp
 
 */

#import <UIKit/UIKit.h>

#import "FBConnect.h"

@interface EAFacebookHelper : NSObject <FBSessionDelegate, FBDialogDelegate>
{
    @private
    NSString *_appId;
    NSString *_pageId;
}

@property (retain,nonatomic) Facebook *facebook;

-(void)postOnWall;
-(void)goToFacebookPage;

@end
