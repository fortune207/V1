//
//  DSModel+Auth.m
//  DSCard
//
//  Created by Jinzhe xi on 10/13/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#import "DSModel+Auth.h"
#import "DSModel.h"
#import "DSView.h"
#import "DSData.h"
#import "DSAppState.h"
#import <CFNetwork/CFNetwork.h>
#import <CFNetwork/CFHTTPStream.h>

@implementation DSModel (Auth)

// ------------------------------------------------------------------------------------
// doLogin -
// ------------------------------------------------------------------------------------
- (void)doLogin
{
    if (debugModel) NSLog(@"DSModelAuth doLogin");
    
    // Initialize the login information
    NSString *requestStr = [NSString stringWithFormat:@"j_username=%@&j_password=%@",
                            appstate.login, appstate.password];
    NSData *requestData = [NSData dataWithBytes:[requestStr UTF8String] length:[requestStr length]];
    
    NSURL *url = [NSURL URLWithString:LOGIN_POST_URL];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
  	[urlRequest setHTTPBody:requestData];
    [urlRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    [urlRequest setTimeoutInterval:30];
    
    // Send POST
    [page_results setLength:0];
    page_connection = [[NSURLConnection alloc]
                       initWithRequest:urlRequest
                       delegate:self];
    
    // Check conenction
    if (!page_connection) {
        NSLog(@"ERROR: in URL connection setup");
        
    } else {
        
        request_type = REQUEST_TYPE_LOGIN;
        
        // Show network activity indicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

// ------------------------------------------------------------------------------------
// doGetFare -
// ------------------------------------------------------------------------------------
- (void)doGetFare:(int)requestType
{
    if (debugModel) NSLog(@"DSModelAuth doGetFare");
    
    request_type = requestType;
    
    if (request_type == REQUEST_TYPE_GET_FARE)
    {
        NSURL *url = [NSURL URLWithString:GET_FARE_URL];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [urlRequest setHTTPMethod:@"GET"];
        [urlRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
        [urlRequest setTimeoutInterval:30];
        
        // Send POST
        [page_results setLength:0];
        page_connection = [[NSURLConnection alloc]
                           initWithRequest:urlRequest
                           delegate:self];
        
        // Check conenction
        if (!page_connection) {
            NSLog(@"ERROR: in URL connection setup");
            
        } else {
            
            request_type = REQUEST_TYPE_GET_FARE;
            
            // Show network activity indicator
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    }
    
    else if (request_type == REQUEST_TYPE_POST_FARE)
    {
        // Initialize the form params
        NSString *requestStr = [NSString stringWithFormat:@"__VIEWSTATE=%@&ctl00$cphMain$txt_origin=%@&ctl00$cphMain$txt_destination=%@&ctl00$cphMain$ddl_FareType=%@&ctl00$cphMain$btn_submit=%@", token, appstate.origin, appstate.destin, @"Adult", @"Show fares"];
        NSData *requestData = [NSData dataWithBytes:[requestStr UTF8String] length:[requestStr length]];

        NSURL *url = [NSURL URLWithString:GET_FARE_URL];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:requestData];
        [urlRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
        [urlRequest setTimeoutInterval:30];

        // Send POST
        [page_results setLength:0];
        page_connection = [[NSURLConnection alloc]
                           initWithRequest:urlRequest
                           delegate:self];

        // Check conenction
        if (!page_connection) {
            NSLog(@"ERROR: in URL connection setup");
            
        } else {
            
            request_type = REQUEST_TYPE_POST_FARE;
            
            // Show network activity indicator
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    }
}

// ============================= Connection Handling =====================================

// ---------------------------------------------------------------------------------------
// connectionShouldUseCredentialStorage
// ---------------------------------------------------------------------------------------
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    if (debugModel) NSLog(@"DSModelAuth connectionShouldUseCredentialStorage");
    return YES;
}

// ---------------------------------------------------------------------------------------
// didReceiveAuthenticationChallenge
// ---------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (debugModel) NSLog(@"DSModelAuth didReceiveAuthenticationChallenge");
}

// ---------------------------------------------------------------------------------------
// didCancelAuthenticationChallenge
// ---------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (debugModel) NSLog(@"DSModelAuth didCancelAuthenticationChallenge");
}

// ---------------------------------------------------------------------------------------
// willCacheResponse
// ---------------------------------------------------------------------------------------
- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	if (debugModel) NSLog(@"DSModelAuth willCacheResponse");
	return nil;
}

// ---------------------------------------------------------------------------------------
// didReceiveResponse
// ---------------------------------------------------------------------------------------
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if (debugModel) NSLog(@"DSModelAuth didReceiveResponse");
    
    if ([response respondsToSelector:@selector(statusCode)]) {
        conn_status = (int)[(NSHTTPURLResponse *)response statusCode];
        
    } else {
        conn_status = 0;
    }
}

// ---------------------------------------------------------------------------------------
// didReceiveData
// ---------------------------------------------------------------------------------------
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (debugModel) NSLog(@"DSModelAuth didReceiveData");
	[page_results appendData:data];
}

// ---------------------------------------------------------------------------------------
// didFailWithError
// ---------------------------------------------------------------------------------------
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	if (debugModel) NSLog(@"DSModelAuth didFailWithError %ld", (long)[error code]);
	
    // Hide network activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Handle error by issuing messages
    switch ([error code]) {
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorNetworkConnectionLost:
            [view generalAlert:@"Connection Error" message:@"\nPlease check your WiFi connection.\n\n" poptostart:1];
            break;
        case NSURLErrorTimedOut:
            [view generalAlert:@"Connection Timeout" message:@"\nNo response from server. Please check your settings.\n\n" poptostart:1];
            break;
        default:
            [view generalAlert:@"Connection Error" message:@"\nUnknown error while contacting server.\n\n" poptostart:1];
            break;
    }
    
	// Release connection
    page_connection = nil;
}

// ---------------------------------------------------------------------------------------
// connectionDidFinishLoading
// ---------------------------------------------------------------------------------------
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
	if (debugModel) NSLog(@"DSModelAuth connectionDidFinishLoading %d", conn_status);
    
    // Release connection
    page_connection = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Checking log in status
    if (request_type == REQUEST_TYPE_LOGIN)
    {
        // Log in fails
        if (![self extractCurrentBalance])
        {
            [view generalAlert:@"Failure on signing in" message:@"\nCheck your login details.\n\n" poptostart:1];
        }
        
        // Log in success
        else
        {
            [self.view gotofirstScreen];
            
            [self updateUserDetails];
        }
    }
    
    // Extract token parameter
    else if (request_type == REQUEST_TYPE_GET_FARE)
    {
        [self extractToken];
        
        // Post form again with token
        [self doGetFare:REQUEST_TYPE_POST_FARE];
    }
    
    // Getting fares
    else if (request_type == REQUEST_TYPE_POST_FARE)
    {
        [self extractFares];
        
        [view showFares];
    }
    
    // If username or password is incorrect then display alert
    else if (conn_status == 401)
    {
        [view generalAlert:@"Incorrect Crendential!" message:@"\nYour log-in credentials are incorrect!\n\n" poptostart:1];
    }
}

@end
