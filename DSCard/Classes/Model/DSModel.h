//
//  DSModel.h
//  DSCard
//
//  Created by Wei Jin on 10/12/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSView;
@class DSAppState;

@interface DSModel : NSObject
{
    DSView *view;
    
    DSAppState *appstate; // App state info
    
    int request_type;
    
    NSURLConnection *page_connection;
    NSMutableData *page_results;
    int conn_status;
    
    NSString *token;
    
    NSString *LOGIN_POST_URL;
    NSString *GET_FARE_URL;
    
    NSMutableArray *station_list;
}

@property (nonatomic, retain) DSView *view;
@property (nonatomic, retain) DSAppState *appstate;
@property (nonatomic, retain) NSMutableArray *station_list;

- (void) updateUserDetails;
- (BOOL) extractCurrentBalance;
- (void) extractToken;
- (void) extractFares;

@end
