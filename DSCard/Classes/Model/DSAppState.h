//
//  DSAppState.h
//  DSCard
//
//  Created by Jinzhe xi on 10/13/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSAppState : NSObject
{
    NSString *login;        // Login name
    NSString *password;     // Login password
    
    NSString *balance;      // Current balance
    
    NSString *origin;       // The original location
    NSString *destin;       // The destination
    
    NSString *fare1;
    NSString *fare2;
}

@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *balance;
@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *destin;
@property (nonatomic, retain) NSString *fare1;
@property (nonatomic, retain) NSString *fare2;

@end
