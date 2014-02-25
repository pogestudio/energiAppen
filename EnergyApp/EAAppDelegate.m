//
//  EAAppDelegate.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EAAppDelegate.h"

#import "EAVariableViewController.h"
#import "EASavings1ViewController.h"
#import "EAInfo1ViewController.h"
#import "EATutorialViewController.h"
#import "EAOtherViewController.h"

#import "EADatabasePopulator.h"

@interface EAAppDelegate (Private)
-(void)addTutorialView;
@end



@implementation EAAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //populate db if needed
    EADatabasePopulator *dataPopulator = [[EADatabasePopulator alloc] init];
    _isFirstTime = ![dataPopulator doesDBContainEntries];
    [dataPopulator checkDatabaseAndPopulateIfNeeded];
            
    if (_isFirstTime) {
        [self addTutorialView];
    } else {
        [self addRegularView];
    }
    
    return YES;
}

-(void)addRegularView
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //do the tab bar
    tabBarController = [[UITabBarController alloc] init];
    NSMutableArray *localControllersArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    //vc1
    EAVariableViewController *variableVC = [[EAVariableViewController alloc] initWithTabBar];
    variableVC.managedObjectContext = self.managedObjectContext;
    UINavigationController *tempNavCon = [[UINavigationController alloc] initWithRootViewController:variableVC];
    [localControllersArray addObject:tempNavCon];
    tempNavCon = nil;
    
    //vc2
    EASavings1ViewController *savingsVC = [[EASavings1ViewController alloc] initWithTabBar];
    savingsVC.managedObjectContext = self.managedObjectContext;
    tempNavCon = [[UINavigationController alloc] initWithRootViewController:savingsVC];
    [localControllersArray addObject:tempNavCon];
    tempNavCon = nil;
    
    //vc3
    EAInfo1ViewController *infoVC = [[EAInfo1ViewController alloc] initWithTabBar];
    infoVC.managedObjectContext = self.managedObjectContext;
    tempNavCon = [[UINavigationController alloc] initWithRootViewController:infoVC];
    [localControllersArray addObject:tempNavCon];
    tempNavCon = nil;
    
    //vc4
    EAOtherViewController *otherVC = [[EAOtherViewController alloc] initWithTabBar];
    tempNavCon = [[UINavigationController alloc] initWithRootViewController:otherVC];
    [localControllersArray addObject:tempNavCon];
    tempNavCon = nil;
    
    
    tabBarController.viewControllers = localControllersArray;
    
    
    [_window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    
}

-(void)addTutorialView
{  
    if (_window == nil) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    tutorialVC = [[EATutorialViewController alloc] initAsFirstTime:_isFirstTime];
    
    [_window addSubview:tutorialVC.view];
    [self.window makeKeyAndVisible];
}

-(void)tutorialViewIsDone
{

    //if it's not first time we don't want to add the regularview, since it's already loaded in the background.
    if (_isFirstTime) {
        _isFirstTime = NO;
        [self addRegularView];
    }
    [tutorialVC.view removeFromSuperview];

    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"Ett fel har uppstått: SaveContext"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok :("
                                                  otherButtonTitles: nil];
            [alert show];
            //abort();
} 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EnergyApp" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EnergyApp.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
}    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
