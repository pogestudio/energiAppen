//
//  EAAppDelegate.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EATutorialViewController;
@interface EAAppDelegate : UIResponder <UIApplicationDelegate>
{
    UITabBarController *tabBarController;
    EATutorialViewController *tutorialVC;
    @private
    BOOL _isFirstTime;

}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)tutorialViewIsDone;


@property (strong, nonatomic) UINavigationController *navigationController;

@end
