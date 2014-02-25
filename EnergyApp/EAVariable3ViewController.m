//
//  EAVariable3ViewController.m
//  EnergyApp
//
//  Created by Carl-Arvid Ewerbring on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EAVariable3ViewController.h"
#import "EAVariable.h"
#import "EAValue.h"
#import "EAVariable4ViewController.h"

#import "EADatabaseFetcher.h"

#import "EAAppDelegate.h"

@interface EAVariable3ViewController ()
-(void)saveMoc;
-(void)setUpViewForPicker;
-(void)setUpViewForTextField;
-(void)setUpViewForBool;
-(IBAction)showInfoView:(id)sender;
-(IBAction)clearValue:(id)sender;
-(void)valueSelectedAtPickerRow:(NSInteger)row;

//boolview
-(IBAction)segmentedValueHasChanged:(id)sender;

@property (retain, nonatomic) IBOutlet UIPickerView *picker;
@property (retain, nonatomic) IBOutlet UITextField *theTextField;
@property (retain, nonatomic) IBOutlet UILabel *unitLabel;
@property (retain, nonatomic) IBOutlet UILabel *shortInfoLabel;

@property (retain, nonatomic) IBOutlet UILabel *pickerLabel;
@property (retain, nonatomic) IBOutlet UIToolbar *pickerToolBar;

//boolView
@property (retain, nonatomic) IBOutlet UISegmentedControl *boolSegControl;
@property (retain, nonatomic) IBOutlet UIButton *resetButton;

@property (retain, nonatomic) NSArray *arrayForPicker;

@end

@implementation EAVariable3ViewController 

@synthesize picker, theTextField, unitLabel, pickerLabel,pickerToolBar, boolSegControl, resetButton,shortInfoLabel;
@synthesize variable, arrayForPicker;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize dbFetch = __dbFetch;


- (id)initWithVariable:(EAVariable*)varToWorkWith
{
    self = [super initWithNibName:@"EAVariable3ViewController" bundle:nil];
    if (self) {
        self.variable = varToWorkWith;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //set the nav bar title
    self.title = self.variable.title;
    
    //add infobutton to navigationdisplay
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
    [infoButton addTarget:self action:@selector(showInfoView:) forControlEvents:UIControlEventTouchUpInside];    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //set the state of the view
    if ([self.variable.usesPickerView intValue] == 1) {
        [self setUpViewForPicker];
    } else if ([self.variable.usesTextField intValue] == 1)
    {
        [self setUpViewForTextField];
    } else if([self.variable.usesBool intValue] == 1)
    {
        [self setUpViewForBool];
    }
    else
    {
        NSAssert1(nil,@"Should never be here, something is wrong with viewWillAppear in EAVar3", nil);
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view.window endEditing: YES];
}

#pragma mark -
#pragma mark UIRelated

-(void)setUpViewForTextField
{
   
    
    //1
    self.theTextField.hidden = NO;
    //2
    self.theTextField.text = self.variable.value.value;
    //3
    [self.theTextField becomeFirstResponder];
    //4
    self.shortInfoLabel.hidden = NO;
    self.unitLabel.hidden = NO;
    self.unitLabel.text = self.variable.unitForTable;
    self.shortInfoLabel.text = self.variable.inputDescription;
    
    //5
    NSString *defaultValue = [self.dbFetch getValueOfVariableWithTitle:self.variable.title];
    self.theTextField.placeholder = defaultValue;

}

-(void)setUpViewForPicker
{
    //1 show the picker
    //2 show the picker label
    //3 load the array into the picker
    //4 show current value in label
    //5 choose the current value as selected in thepicker

    //1
    self.picker.hidden = NO;
    self.pickerLabel.hidden = NO;
    self.pickerToolBar.hidden = NO;
    self.shortInfoLabel.hidden = NO;
    self.unitLabel.hidden = NO;
    self.unitLabel.text = self.variable.unitForTable;
    self.shortInfoLabel.text = self.variable.inputDescription;
    
    //3
    NSArray *valuesForPicker = [self.variable.valuesForPicker allObjects];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"sortKey" ascending:YES];
    self.arrayForPicker = [valuesForPicker sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
    
    //4
    self.pickerLabel.text = self.variable.value.value;
    
    //5
    
 

    [self scrollPickerViewToRightValue];
}

-(void)scrollPickerViewToRightValue
{
    //if we have a value defined, use that.
    //if we don't, get the default value and scroll through the pickerarray until we find a match

    EAValue *valueToScrollTo = self.variable.value;
    NSInteger pickerIntegerForCurrentValue = 0;
    
    if (valueToScrollTo != nil)
    {
        pickerIntegerForCurrentValue = [self.arrayForPicker indexOfObject:valueToScrollTo];
    } else {
        
        NSString *defaultString = [self.dbFetch getValueOfVariableWithTitle:self.variable.title];
        
        for (EAValue *value in self.arrayForPicker) {
            if ([value.value isEqualToString:defaultString]) {
                pickerIntegerForCurrentValue = [self.arrayForPicker indexOfObject:value];
                break;
            }
        }
        [self valueSelectedAtPickerRow:pickerIntegerForCurrentValue];
    }
    
    [self.picker selectRow:pickerIntegerForCurrentValue inComponent:0 animated:NO];

    
}


-(void)valueSelectedAtPickerRow:(NSInteger)row
{
    
    //1
    EAValue *selectedValue = [self.arrayForPicker objectAtIndex:row];
    self.pickerLabel.text = selectedValue.value;
    //2
    self.variable.value = selectedValue;
    
    [self saveMoc];
}
-(void)setUpViewForBool
{
    //1 show seg control
    //2 show reset button
    //3 give seg control the right value, if it exists
    
    self.boolSegControl.hidden = NO;
    self.resetButton.hidden = NO;
    self.unitLabel.hidden = YES;
    
    if (![self.variable.value.value isEqualToString:@""])
    {        
        NSInteger value = [self.variable.value.value intValue];
        value = [self transformValueForSegCtrl:value];
        self.boolSegControl.selectedSegmentIndex = value;
    }
    
    
}

-(NSInteger)transformValueForSegCtrl:(NSInteger)value
{
    NSInteger newValue;
    
    if (value == 0) {
        newValue = 1;
    } else {
        newValue = 0;
    }
    
    return newValue;
}

-(IBAction)segmentedValueHasChanged:(id)sender
{
    NSAssert1([sender isKindOfClass:[UISegmentedControl class]], @"The object in segmentValueHasChanged function is not UISegmentedControl, as it's supposed to be!",nil);
    UISegmentedControl *segCtrl = (UISegmentedControl*)sender;
    int selectedIndex = segCtrl.selectedSegmentIndex;
    int value = [self transformValueForSegCtrl:selectedIndex];
    self.variable.value.value  = [NSString stringWithFormat:@"%d",value];
    [self saveMoc];
}

-(void)showInfoView:(id)sender
{
    NSString *information = self.variable.information;
    NSString *location  = self.variable.whereToFindIt;
    NSString *name = self.variable.title;
    
    EAVariable4ViewController *infoController = [[EAVariable4ViewController alloc] initWithInformation:information andLocation:location forVariable:name];
    
    UINavigationController *newNavigationController = [[UINavigationController alloc] initWithRootViewController:infoController];
    
    self.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:newNavigationController animated:YES];
    
    
}

#pragma mark UITextfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //1 get the value from the textfield
    //2 check if it's within the bounds
    //3 if not, show alert and dismiss new change
    //4 if it is, go ahead as usual
    
    NSString *newStringInTextfield = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL isValueOk = [self checkIfValueIsWithinBounds:newStringInTextfield];
    
    if (!isValueOk) {
        //show alert
        int lowerBound = [self.variable.lowerBound intValue];
        int upperBound = [self.variable.upperBound intValue];
        
        NSString *messageToUser = [NSString stringWithFormat:@"Ange ett värde mellan %d och %d %@",lowerBound,upperBound,self.variable.unitForTable];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fel värde" message:messageToUser                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    return isValueOk;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //1 get string of the textfield
    //2 if it's not empty, make sure it's within boundaries
    //3 if it's within boundaries, create a new value and save it.
    
    //1
    NSString *stringInTextField = textField.text;
    
    //2
    //BOOL stringIsWithinBoundaries = [self checkIfValueIsWithinBounds:stringInTextField];
    //NSAssert1(stringIsWithinBoundaries, @"Some logic fail in the way you're managing values", nil);
    
    //3
    self.variable.value.value = stringInTextField;
    
    [self saveMoc];
    
}

-(BOOL)checkIfValueIsWithinBounds:(NSString*)newString
{
    int lowerBound = [self.variable.lowerBound intValue];
    int upperBound = [self.variable.upperBound intValue];
    int valueFromString = [newString intValue];
    
    BOOL isValueOk;
    if (lowerBound <= valueFromString && valueFromString <= upperBound) {
        isValueOk = YES;
    } else {
        isValueOk = NO;
    }

    return isValueOk;
}

#pragma mark Pickerview datasource & delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int intToReturn = [self.arrayForPicker count];
    return intToReturn;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    EAValue *valueForRow = [self.arrayForPicker objectAtIndex:row];
    NSString *stringToReturn = valueForRow.value;
    return stringToReturn;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self valueSelectedAtPickerRow:row];
}

-(IBAction)clearValue:(id)sender
{
    const int tagForArrayReset = 50;
    const int tagForBoolReset = 51;
    int currentTag;
    
    if ([sender isKindOfClass:[UIButton class]]) {
        currentTag = ((UIButton*)sender).tag;
    } else if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        currentTag = ((UIBarButtonItem*)sender).tag;
    } else {
        NSAssert1(nil,@"Should never be here, something is wrong with clearValue", nil);
    }
    
    switch (currentTag) {
        case tagForArrayReset:
            self.variable.value = nil;
            break;
        case tagForBoolReset:
            self.variable.value.value = @"";            
            break;
        default:
            NSAssert1(nil,@"Should never be here, something is wrong with clearValue", nil);
            break;
    }
    
    [self saveMoc];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSManagedObjectContext*)managedObjectContext
{
    if (__managedObjectContext == nil) {
        NSAssert1(nil,@"Should never be here. We're trying to use MOC before it's defined in EAVariable2", nil);
    }
    
    return __managedObjectContext;
}

-(EADatabaseFetcher*)dbFetch
{
    if (__dbFetch == nil) {
        __dbFetch = [[EADatabaseFetcher alloc] init];
    }
    
    return __dbFetch;
}

-(void)saveMoc
{
    EAAppDelegate *appDelegate = (EAAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate saveContext];

}

@end
