//
//  EAFacebookHelper.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EAFacebookHelper.h"

@implementation EAFacebookHelper

@synthesize facebook = __facebook;

-(id)init
{
    self = [super init];
    if (self) {
        _appId = @"254397404662840";
        _pageId = @"193095237487542";

    }
    
    return self;
}

-(void)postOnWall
{
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _appId, @"app_id",
                                   @"http://www.facebook.com/EnergiAppen", @"link",
                                   @"EnergiAppen", @"name",
                                   @"http://pogestudio.com/energiAppen/bilder/icon_facebook_wall_large.png",@"picture",
                                   @"Sänk energikostnaderna!", @"caption",
                                   @"Använd EnergiAppen för att kolla hur mycket pengar Ni kan spara. Smidigt och enkelt i mobilen!", @"description",
                                   nil];
    
    [self.facebook dialog:@"feed" andParams:params andDelegate:self];
}

-(void)goToFacebookPage
{
    NSString *fullUrlString = [NSString stringWithFormat:@"fb://profile/%@", _pageId];
    NSURL *urlApp = [NSURL URLWithString:fullUrlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:urlApp])
    {
        //we have facebook app
        [[UIApplication sharedApplication] openURL:urlApp];
    } else {
        fullUrlString = [NSString stringWithFormat:@"https://facebook.com/%@",_pageId];
        NSURL *urlSafari = [NSURL URLWithString:fullUrlString];
        [[UIApplication sharedApplication] openURL:urlSafari];
    }
    

}


#pragma mark -
#pragma mark facebook
-(Facebook*)facebook
{
    if (__facebook != nil) {
        return __facebook;
    }
    
    __facebook = [[Facebook alloc] initWithAppId:_appId andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        __facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        __facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![__facebook isSessionValid]) {
        [__facebook authorize:nil];
    }
    
    return __facebook;
    
}

// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url]; 
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url]; 
}


#pragma mark -
#pragma mark SessionDelegate
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
    
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
    
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
    
}


#pragma mark - 
#pragma mark DialogDelegate
/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidComplete:(FBDialog *)dialog
{
    
}

/**
 * Called when the dialog succeeds with a returning url.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url
{
    
}

/**
 * Called when the dialog get canceled by the user.
 */
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url
{
    
}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog
{
    
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
    NSString *errorDescription = error.localizedDescription;
    UIAlertView *agreement = [[UIAlertView alloc] initWithTitle:@"Error" message:errorDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [agreement show];
    
}

/**
 * Asks if a link touched by a user should be opened in an external browser.
 *
 * If a user touches a link, the default behavior is to open the link in the Safari browser,
 * which will cause your app to quit.  You may want to prevent this from happening, open the link
 * in your own internal browser, or perhaps warn the user that they are about to leave your app.
 * If so, implement this method on your delegate and return NO.  If you warn the user, you
 * should hold onto the URL and once you have received their acknowledgement open the URL yourself
 * using [[UIApplication sharedApplication] openURL:].
 */
- (BOOL)dialog:(FBDialog*)dialog shouldOpenURLInExternalBrowser:(NSURL *)url
{
    return YES;
}


@end
