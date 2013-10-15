//
//  DSLoginVC.m
//  DSCard
//
//  Created by Jinzhe xi on 10/13/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#import "DSLoginVC.h"
#import "DSView.h"
#import "DSModel.h"
#import "DSAppState.h"
#import "DSData.h"

@implementation DSLoginVC

// ---------------------------------------------------------------------------------------
// initWithView -
// ---------------------------------------------------------------------------------------
- (id) initWithView:(DSView *)delegate
{
    if (debugLoginVC) NSLog(@"DSLoginVC initWithView");
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self = [super initWithNibName:@"DSLoginVC_iPad" bundle:nil];
    else if ([UIScreen mainScreen].bounds.size.height == 568)
        self = [super initWithNibName:@"DSLoginVC" bundle:nil];
    else if ([UIScreen mainScreen].bounds.size.height == 480)
        self = [super initWithNibName:@"DSLoginVC_Retina35" bundle:nil];
    
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
    if (debugLoginVC) NSLog(@"DSLoginVC viewDidLoad");
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.txtLogin.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0];
        self.txtPass.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0];
        self.btnLogin.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:70.0];
        self.btnDone.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:70.0];
        self.lblTitle.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:70.0];
        self.lblDesc1.font = [UIFont fontWithName:@"MyriadPro-Regular" size:40.0];
        self.lblDesc2.font = [UIFont fontWithName:@"MyriadPro-Regular" size:40.0];
        
        self.btnLogin.layer.cornerRadius=6.0f;
    }
    else
    {
        self.txtLogin.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0];
        self.txtPass.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0];
        self.btnLogin.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:20.0];
        self.btnDone.titleLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0];
        self.lblTitle.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:25.0];
        self.lblDesc1.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0];
        self.lblDesc2.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0];
        
        self.btnLogin.layer.cornerRadius=3.0f;
    }
    
    self.btnLogin.layer.masksToBounds=YES;
    
    self.txtLogin.layer.cornerRadius=3.0f;
    self.txtLogin.layer.masksToBounds=YES;
    self.txtLogin.layer.borderColor=[[UIColor whiteColor] CGColor];
    self.txtLogin.layer.borderWidth= 1.0f;
    
    self.txtPass.layer.cornerRadius=3.0f;
    self.txtPass.layer.masksToBounds=YES;
    self.txtPass.layer.borderColor=[[UIColor whiteColor] CGColor];
    self.txtPass.layer.borderWidth= 1.0f;
    
    self.txtLogin.text = viewDelegate.model.appstate.login;
    self.txtPass.text = viewDelegate.model.appstate.password;
    
    currentText = self.txtLogin;
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
// onLogin -
// ---------------------------------------------------------------------------------------
- (IBAction)onLogin:(id)sender
{
    if (debugLoginVC) NSLog(@"DSLoginVC onLogin");
    
    [currentText resignFirstResponder];
    
    viewDelegate.model.appstate.login = self.txtLogin.text;
    viewDelegate.model.appstate.password = self.txtPass.text;
    
    [viewDelegate doLogin];
}

// ---------------------------------------------------------------------------------------
// onDone -
// ---------------------------------------------------------------------------------------
- (IBAction)onDone:(id)sender {
    if (debugLoginVC) NSLog(@"DSLoginVC onDone");
    
    [currentText resignFirstResponder];
    
    [viewDelegate gotofirstScreen];
}

// =======================================================================================
// UITextField Delegate Methods
// =======================================================================================
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentText = textField;
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.txtPass)
    {
        [self onLogin:textField];
    }
    
    return TRUE;
}

@end
