//
//  EAVariable3ViewController.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAVariable;
@class EADatabaseFetcher;

@interface EAVariable3ViewController : UIViewController <UITextFieldDelegate>



@property (retain, nonatomic) EAVariable *variable;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) EADatabaseFetcher *dbFetch;

- (id)initWithVariable:(EAVariable*)varToWorkWith;

@end
