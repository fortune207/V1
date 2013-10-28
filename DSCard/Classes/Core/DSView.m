//
//  DSView.m
//  DSCard
//
//  Created by Wei Jin on 10/12/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#import "DSView.h"
#import "DSModel.h"
#import "DSData.h"
#import "DSAppState.h"
#import "DSFirstVC.h"
#import "DSLoginVC.h"
#import "DSModel+Auth.h"
#import "MBProgressHUD.h"

@implementation DSView

@synthesize model;
@synthesize loginVC;
@synthesize firstVC;

// ---------------------------------------------------------------------------------------
// initWithModel -
// ---------------------------------------------------------------------------------------
-(id) initWithModel:(DSModel *)some_model
{
    if (debugView) NSLog(@"DSView initWithModel");
    
    self = [super init];
    
    if (self != nil)
    {
        // Connect to model
        model = some_model;
        
        // Create window
        window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
        
        // Create firstVC
        firstVC = [[DSFirstVC alloc] initWithView:self];
        
        // Create loginVC
        loginVC = [[DSLoginVC alloc] initWithView:self];
        
        // Set the firstVC as first screen
        nc = [[UINavigationController alloc]initWithRootViewController:firstVC];
        nc.navigationBarHidden = YES;
        
        // Initialize general alert message box
        generalalert = [[UIAlertView alloc]
                        initWithTitle:@""
                        message:@""
                        delegate:self
                        cancelButtonTitle: nil
                        otherButtonTitles: @"OK", nil];
        [generalalert dismissWithClickedButtonIndex:0 animated:NO];
        
        window.rootViewController = nc;
        
        [window makeKeyAndVisible];
        
        if( [model.appstate.login isEqualToString:@""] == NO )
        {
            [model doLogin];
        }
    }
    
    return self;
}

// ---------------------------------------------------------------------------------------
// viewDidLoad -
// ---------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    if (debugView) NSLog(@"DSView viewDidLoad");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ---------------------------------------------------------------------------------------
// generalAlert -
// ---------------------------------------------------------------------------------------
- (void) generalAlert:(NSString *)title message:(NSString *)message poptostart:(NSInteger)poptostart {
    if (debugView) NSLog(@"DSView generalAlert");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	if (poptostart) {
        
	}
    generalalert.title = title;
    generalalert.message = message;
	[generalalert show];
}

// ---------------------------------------------------------------------------------------
// gotologinScreen -
// ---------------------------------------------------------------------------------------
-(void) gotologinScreen
{
    if (debugView) NSLog(@"DSView gotologinScreen");
    
    //[nc popViewControllerAnimated:YES];
    [nc pushViewController:loginVC animated:YES];
}

// ---------------------------------------------------------------------------------------
// gotofirstScreen -
// ---------------------------------------------------------------------------------------
- (void) gotofirstScreen
{
    if (debugView) NSLog(@"DSView gotofirstScreen");
    
    firstVC.lblMoney.text = model.appstate.balance;
    
    [nc popViewControllerAnimated:YES];
    //[nc pushViewController:firstVC animated:YES];
}

// ---------------------------------------------------------------------------------------
// doLogin -
// ---------------------------------------------------------------------------------------
-(void) doLogin
{
    if (debugView) NSLog(@"DSView doLogin");
    
    [model doLogin];
}

// ---------------------------------------------------------------------------------------
// doGetFare -
// ---------------------------------------------------------------------------------------
-(void) doGetFare
{
    if (debugView) NSLog(@"DSView doGetFare");
    
    [model doGetFare:REQUEST_TYPE_GET_FARE];
}

// ---------------------------------------------------------------------------------------
// showFares -
// ---------------------------------------------------------------------------------------
-(void) showFares
{
    if (debugView) NSLog(@"DSView showFares");
    
    firstVC.lblMoneyOffPeak.text = model.appstate.fare1;
    firstVC.lblMoneyPeak.text = model.appstate.fare2;
    
    [firstVC toggleDetailView];
}

@end
