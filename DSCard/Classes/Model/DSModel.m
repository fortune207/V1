//
//  DSModel.m
//  DSCard
//
//  Created by Wei Jin on 10/12/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#import "DSModel.h"
#import "DSView.h"
#import "DSData.h"
#import "DSAppState.h"

@implementation DSModel

@synthesize appstate;
@synthesize view;
@synthesize station_list;

// ------------------------------------------------------------------------------------
// init -
// ------------------------------------------------------------------------------------
- (id) init
{
    if (debugModel) NSLog(@"DSModel init");
    
    self = [ super init ];
    if (self != nil )
    {
        appstate = [[DSAppState alloc] init];
        [self readUserDetails];
        
        station_list = [[NSMutableArray alloc] init];
        [self initStationsList];
        
        request_type = 0;
        
        // Initialize variables used for HTTP communication
        page_results = [[NSMutableData alloc] initWithLength:0];
        page_connection = nil;
        conn_status = 0;
        
        token = @"";
        LOGIN_POST_URL = @"https://oyster.tfl.gov.uk/oyster/security_check";
        GET_FARE_URL = @"http://www.tfl.gov.uk/tfl/tickets/faresandtickets/farefinder/current/default.aspx";
    }
    
    return self;
}

// ------------------------------------------------------------------------------------
// initStationsList - Initialize the stations list
// ------------------------------------------------------------------------------------
- (void) initStationsList
{
    if (debugModel) NSLog(@"DSModel initStationsList");
    
    NSString *settingsPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *plistPath = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *stationsArray = [settingsDictionary objectForKey:@"Stations List"];

    station_list = [NSMutableArray arrayWithArray:stationsArray];
}

// ------------------------------------------------------------------------------------
// readUserDetails - Read user details from settings
// ------------------------------------------------------------------------------------
- (void) readUserDetails
{
    if (debugModel) NSLog(@"DSModel readUserDetails");
    
    // Set the username
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    if (username == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        appstate.login = username;
    }
    
    // Set the password
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    if (password == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        appstate.password = password;
    }
    
    // Set the password
    NSString *balance = [[NSUserDefaults standardUserDefaults] stringForKey:@"balance"];
    if (password == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"balance"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        appstate.balance = balance;
    }

}

// ------------------------------------------------------------------------------------
// updateUserDetails - Update user details into settings
// ------------------------------------------------------------------------------------
- (void) updateUserDetails
{
    if (debugModel) NSLog(@"DSModel updateUserDetails");
    
    // Set the username
    [[NSUserDefaults standardUserDefaults] setObject:appstate.login forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Set the password
    [[NSUserDefaults standardUserDefaults] setObject:appstate.password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Set the balance
    [[NSUserDefaults standardUserDefaults] setObject:appstate.balance forKey:@"balance"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// ------------------------------------------------------------------------------------
// searchItem -
// ------------------------------------------------------------------------------------
- (NSString *) searchItem:(NSString *) pattern source:(NSString *)searchedString
{
    if (debugModel) NSLog(@"DSModel searchItem");
    
    NSError* error = nil;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:
                                  pattern options:0 error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:searchedString options:0
                                    range:NSMakeRange(0, [searchedString length])];
    
    NSString *res = [searchedString substringWithRange:[match rangeAtIndex:1]];
    
    return res;
}

// ------------------------------------------------------------------------------------
// extractCurrentBalance - TRUE on log in success, FALSE on failure
// ------------------------------------------------------------------------------------
- (BOOL) extractCurrentBalance
{
    if (debugModel) NSLog(@"DSModel extractCurrentBalance");
    
    NSString *pagestring = [[NSString alloc] initWithData:page_results encoding:NSUTF8StringEncoding];
    
    NSString *res = [self searchItem:@".*?(Sign out).*?" source:pagestring];
    
    if ([res isEqualToString:@""])
    {
        return FALSE;
    }
    
    appstate.balance = [self searchItem:@">Balance:.*?(-?\\d+\\.\\d+)</span>" source:pagestring];
    
    return TRUE;
}

// ------------------------------------------------------------------------------------
// extractToken -
// ------------------------------------------------------------------------------------
- (void) extractToken
{
    if (debugModel) NSLog(@"DSModel extractToken");
    
    NSString *pagestring = [[NSString alloc] initWithData:page_results encoding:NSUTF8StringEncoding];
    
    token = [self searchItem:@"name=\"__VIEWSTATE\" id=\"__VIEWSTATE\" value=\"(.*?)\"" source:pagestring];
}

// ------------------------------------------------------------------------------------
// extractFares -
// ------------------------------------------------------------------------------------
- (void) extractFares
{
    if (debugModel) NSLog(@"DSModel extractFares");
    
    NSString *pagestring = [[NSString alloc] initWithData:page_results encoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    
    NSString *pattern = @"<strong>(£?\\d+\\.\\d+)</strong>";
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    int i=0;
    
    NSArray* matches = [regex matchesInString:pagestring options:0 range:NSMakeRange(0, [pagestring length])];
    for ( NSTextCheckingResult* match in matches )
    {
        
        NSRange group1 = [match rangeAtIndex:1];
        
        if (i==0)
        {
            appstate.fare2 = [pagestring substringWithRange:group1];
        }
        
        else if (i == 1)
        {
            appstate.fare1 = [pagestring substringWithRange:group1];
        }
        
        i++;
    }
}


@end