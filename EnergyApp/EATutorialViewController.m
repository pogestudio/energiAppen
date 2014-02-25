//
//  EATutorialViewController.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EATutorialViewController.h"
#import "EAAppDelegate.h"

@interface EATutorialViewController ()

@end

@implementation EATutorialViewController

@synthesize mainText,mainImage;
@synthesize previous,next,cancel;
@synthesize currentNumber;

-(id)initAsFirstTime:(BOOL)firstTime
{
    self = [super initWithNibName:@"EATutorialViewController" bundle:nil];
    if (self) {
        thisIsFirstTime = firstTime;

        if (thisIsFirstTime) {
            self.currentNumber = 1;
        } else {
            self.currentNumber = 2;
        }
        
        [self loadImages];
        [self loadText];
        
        _totalAmountOfItems = ([_shortTexts count] + [_longTexts count])+1;
    
    
    }
    return self;
}

-(void)loadImages
{
    NSArray *objects = [NSArray arrayWithObjects:@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    NSArray *keys = [NSArray arrayWithObjects:@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    _pictures = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
}

-(void)loadText
{
    NSArray *shortTextsObjects = [NSArray arrayWithObjects:
                                  @"Börja med att ange fakta om huset via fliken ”Huset”. Klicka sedan på de olika kategorierna för att se deras värden",
                                  @"Klicka på ett värde för att ange det. Är inget värde angett syns ”---” och i uträkningar görs då ett antagande från annan information Ni angett. Desto mer information Ni angett, desto mer korrekta åtgärdsförslag.",
                                  @"Om något är oklart angående ett värde finns presenteras mer information om ni klickar på info-knappen",
                                  @"Här ser Ni var Ni finner värdet och annan nyttig information.",
                                  @"När Ni angett värdet visas de förslag som passar ert hus under fliken ”Besparingar”",
                                  @"Under varje åtgärdsförslag kan Ni se mer detaljerad ekonomisk information, generell information samt tips inför energibesiktning",
                                  @"Under fliken ’Info’ finns kortfattad användbar energiinformation, samt rådgivning på hur man får en så bra energibesiktning som möjligt. Läs igenom för bästa resultat från EnergiAppen!",
                                  @"Har Ni frågor kan Ni gå in på Facebooksidan eller maila oss. Länkar finns i fliken ’Övrigt’. Där hittar ni även denna guide om Ni vill friska upp minnet eller introducera EnergiAppen för en bekant!",nil];
    
    NSArray *shortTextsKeys = [NSArray arrayWithObjects:@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    
    _shortTexts = [[NSDictionary alloc] initWithObjects:shortTextsObjects forKeys:shortTextsKeys];
    
    NSArray *longTextsObjects = [NSArray arrayWithObjects:@"Välkommen till EnergiAppen! Ta två minuter och gå igenom guiden för att lära dig använda EnergiAppen på bästa sätt.",
                          @"Det var allt! \n\nSkicka gärna feedback, bra som dålig, och ge förslag på hur Ni vill se att EnergiAppen skall utvecklas! Om fler tycker lika kan idén snabbt bli verklighet. Hör av er på Facebook eller via mail.\n\nBörja med en genomgång från toppen och ange de värden Ni har kännedom om - lämna sådant Ni inte har koll på och låt EnergiAppen göra statistiska antaganden.\n\nTrevlig pengajakt!",nil];
    
    NSArray *longTextsKeys = [NSArray arrayWithObjects:@"1",@"10", nil];
    
    _longTexts = [[NSDictionary alloc] initWithObjects:longTextsObjects forKeys:longTextsKeys];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpView];
}


-(void)setUpView
{
    
    
    //first decide which things to show, to fix the correct view
    if (self.currentNumber == 1) {
        self.previous.enabled = NO;
        self.next.enabled = YES;
        self.cancel.enabled = NO;
    } else if (self.currentNumber == 2)
    {        
        self.previous.enabled = NO;
        self.next.enabled = YES;
    } else  if (self.currentNumber == _totalAmountOfItems) {
            self.previous.enabled = YES;
            self.next.enabled = NO;
    } else
    {
        self.previous.enabled = YES;
        self.next.enabled = YES;            
    }
    NSString *keyForObject = [NSString stringWithFormat:@"%d",self.currentNumber];
    NSString *imageFilePath = [_pictures objectForKey:keyForObject];
    if (imageFilePath != nil) {
        UIImage *currentImage = [UIImage imageNamed:imageFilePath];
        self.mainImage.image = currentImage;
        self.mainImage.hidden = NO;
    } else {
        self.mainImage.hidden = YES;
    }
   
    NSString *infoToShow = [_shortTexts objectForKey:keyForObject];
    if (infoToShow == nil) {
        infoToShow = [_longTexts objectForKey:keyForObject];
    }
    
    [self setMainTextLabelTo:infoToShow];
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)setMainTextLabelTo:(NSString*)infoToShow
{
    static CGRect originalRectOfTextLabel;
    if ([self.mainText.text isEqualToString:@"Don't change - check changeslide func"]) {
        originalRectOfTextLabel = self.mainText.frame;
        if (!thisIsFirstTime) {
            //since we're not using our own window, we have to deal with the status bar. Raise the label a bit.
            NSInteger yPos = originalRectOfTextLabel.origin.y;
            originalRectOfTextLabel.origin.y = yPos-15;
        }
    }
    
    self.mainText.text = infoToShow;
    self.mainText.frame = originalRectOfTextLabel;
    [self.mainText sizeToFit];
}

#pragma mark button functions
-(IBAction)changeSlide:(id)sender
{
    NSAssert1([sender isKindOfClass:[UIBarButtonItem class]],@"Some weird function is calling change slides",nil);
    UIBarButtonItem *senderButton = (UIBarButtonItem*)sender;
    NSUInteger previousButtonTag = 10;
    NSUInteger nextButtonTag = 11;
    
    if (senderButton.tag == nextButtonTag)
    {
        self.currentNumber++;
    } else if (senderButton.tag == previousButtonTag)
    {
        self.currentNumber--;
    }
    
    if (self.currentNumber == _totalAmountOfItems && thisIsFirstTime) {
        [self showAgreement];
    } else if (self.currentNumber == _totalAmountOfItems)
    {
        [self cancelTutorial:nil];
    } else {
        [self setUpView];
    }
}

-(void)showAgreement
{
    NSString *textTheyHaveToAgreeTo = @"Förslagen baseras delvis på uppskattningar och indikerar besparingsmöjligheter. Vi uppmanar er att kontakta fackmän innan Ni genomför större åtgärder.";
    
    UIAlertView *agreement = [[UIAlertView alloc] initWithTitle:@"Påminnelse" message:textTheyHaveToAgreeTo delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil, nil];
    
    [agreement show];
}
-(IBAction)cancelTutorial:(id)sender
{
    if (thisIsFirstTime) {
        EAAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate tutorialViewIsDone];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}

#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self cancelTutorial:nil];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
