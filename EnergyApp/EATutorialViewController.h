//
//  EATutorialViewController.h
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EATutorialViewController : UIViewController <UIAlertViewDelegate>
{
    @private
    BOOL thisIsFirstTime;
    NSDictionary *_pictures;
    NSDictionary *_shortTexts;
    NSDictionary *_longTexts;
    NSInteger _totalAmountOfItems;
    
}

@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UILabel *mainText;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *previous;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *next;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancel;


@property(assign, nonatomic) NSUInteger currentNumber;

-(IBAction)changeSlide:(id)sender;
-(IBAction)cancelTutorial:(id)sender;

- (id)initAsFirstTime:(BOOL)firstTime;


@end
