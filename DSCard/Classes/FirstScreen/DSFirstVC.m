//
//  DSFirstVC.m
//  DSCard
//
//  Created by Jinzhe xi on 10/13/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#define kOFFSET_FOR_KEYBOARD 120.0

#import "DSFirstVC.h"
#import "DSView.h"
#import "DSData.h"
#import "DSModel.h"
#import "DSAppState.h"

@implementation DSFirstVC

// ---------------------------------------------------------------------------------------
// initWithView - Initialize the first screen
// ---------------------------------------------------------------------------------------
- (id) initWithView:(DSView *)delegate
{
    if (debugFirstVC) NSLog(@"DSFirstVC initWithView");
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self = [super initWithNibName:@"DSFirstVC_iPad" bundle:nil];
    else if ([UIScreen mainScreen].bounds.size.height == 568)
        self = [super initWithNibName:@"DSFirstVC" bundle:nil];
    else if ([UIScreen mainScreen].bounds.size.height == 480)
        self = [super initWithNibName:@"DSFirstVC_Retina35" bundle:nil];
    
    if (self != nil)
    {
        viewDelegate = delegate;
    }
    
    return self;
}

// ---------------------------------------------------------------------------------------
// viewDidLoad -
// ---------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    if (debugFirstVC) NSLog(@"DSFirstVC viewDidLoad");
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.lblPound.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:180.0];
        self.lblMoney.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:180.0];
        self.lblTitle.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:70.0];
        self.text1.font = [UIFont fontWithName:@"MyriadPro-Regular" size:25.0];
        self.text2.font = [UIFont fontWithName:@"MyriadPro-Regular" size:25.0];
        self.lblOffPeak.font = [UIFont fontWithName:@"MyriadPro-Regular" size:70.0];
        self.lblMoneyOffPeak.font = [UIFont fontWithName:@"MyriadPro-Bold" size:70.0];
        self.lblPeak.font = [UIFont fontWithName:@"MyriadPro-Regular" size:70.0];
        self.lblMoneyPeak.font = [UIFont fontWithName:@"MyriadPro-Bold" size:70.0];
        self.btnShowFare.titleLabel.font = [UIFont fontWithName:@"Myriad Pro" size:70.0];

        self.btnShowFare.layer.cornerRadius=6.0f;
    }
    else
    {
        self.lblPound.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:80.0];
        self.lblMoney.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:80.0];
        self.lblTitle.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:30.0];
        self.text1.font = [UIFont fontWithName:@"MyriadPro-Regular" size:25.0];
        self.text2.font = [UIFont fontWithName:@"MyriadPro-Regular" size:25.0];
        self.lblOffPeak.font = [UIFont fontWithName:@"MyriadPro-Regular" size:25.0];
        self.lblMoneyOffPeak.font = [UIFont fontWithName:@"MyriadPro-Bold" size:20.0];
        self.lblPeak.font = [UIFont fontWithName:@"MyriadPro-Regular" size:25.0];
        self.lblMoneyPeak.font = [UIFont fontWithName:@"MyriadPro-Bold" size:20.0];
        self.btnShowFare.titleLabel.font = [UIFont fontWithName:@"Myriad Pro" size:30.0];
        
        self.btnShowFare.layer.cornerRadius=3.0f;
    }
    
    UIColor *clrSecondaryBlue = [UIColor colorWithRed:24.0f/255.0f green:159.0f/255.0f blue:213.0f/255.0f alpha:1.0f];
    
    self.text1.layer.cornerRadius=3.0f;
    self.text1.layer.masksToBounds=YES;
    self.text1.layer.borderColor=[clrSecondaryBlue CGColor];
    self.text1.layer.borderWidth= 1.0f;
    
    self.text2.layer.cornerRadius=3.0f;
    self.text2.layer.masksToBounds=NO;
    self.text2.layer.borderColor=[clrSecondaryBlue CGColor];
    self.text2.layer.borderWidth= 1.0f;
    
    self.btnShowFare.layer.masksToBounds=YES;
    
    self.detailView.hidden = YES;
    self.btnShowFare.hidden = NO;
    
    self.lblMoney.text = viewDelegate.model.appstate.balance;
    
    self.text1.inputView = self.pickerStations;
    self.text2.inputView = self.pickerStations;
    
    currentText = self.text1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ---------------------------------------------------------------------------------------
// preferredStatusBarStyle - Overriden method to change the status bar color
// ---------------------------------------------------------------------------------------
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// ---------------------------------------------------------------------------------------
// onSettings -
// ---------------------------------------------------------------------------------------

- (IBAction)onSettings:(id)sender {
    if (debugFirstVC) NSLog(@"DSFirstVC onSettings");
    
    if (currentText != nil)
    {
        [currentText resignFirstResponder];
    }
    
    [viewDelegate gotologinScreen];
    
}

// ---------------------------------------------------------------------------------------
// onShowFare -
// ---------------------------------------------------------------------------------------
- (IBAction)onShowFare:(id)sender {
    if (debugFirstVC) NSLog(@"DSFirstVC onShowFare");
    
    [currentText resignFirstResponder];
    
    viewDelegate.model.appstate.origin = self.text1.text;
    viewDelegate.model.appstate.destin = self.text2.text;
    
    [viewDelegate doGetFare];
}

// ---------------------------------------------------------------------------------------
// toggleDetailView - Swithch the view status between the detail view and show fare button
// ---------------------------------------------------------------------------------------
-(void)toggleDetailView
{
    if (debugFirstVC) NSLog(@"DSFirstVC toggleDetailView");
    self.btnShowFare.hidden = !self.btnShowFare.hidden;
    self.detailView.hidden = !self.detailView.hidden;
}

// =======================================================================================
// UITextField Delegate Methods
// =======================================================================================
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return TRUE;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentText = textField;
    
    if (self.btnShowFare.hidden == YES)
    {
        [self toggleDetailView];
    }
    
    return TRUE;
}


-(void)keyboardWillShow {
    [self setViewMovedUp:YES];
}

-(void)keyboardWillHide {
    [self setViewMovedUp:NO];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

// =======================================================================================
// UIPickerView Delegate Methods
// =======================================================================================

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [viewDelegate.model.station_list count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [viewDelegate.model.station_list objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentText.text = [viewDelegate.model.station_list objectAtIndex:row];
}

@end
