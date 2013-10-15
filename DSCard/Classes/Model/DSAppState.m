//
//  DSAppState.m
//  DSCard
//
//  Created by Jinzhe xi on 10/13/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#import "DSAppState.h"

// --------------------------------------------------------------------------------------
// DSAppState - current state of application.
// --------------------------------------------------------------------------------------
@implementation DSAppState

@synthesize login;
@synthesize password;
@synthesize balance;
@synthesize origin;
@synthesize destin;
@synthesize fare1;
@synthesize fare2;

- (id)init
{
    self = [ super init ];
	
    if (self != nil)
    {
        self.login = @"";
		self.password = @"";
        self.balance = @"0.00";
        self.origin = @"";
        self.destin = @"";
        self.fare1 = @"0.00";
        self.fare2 = @"0.00";
    }
    return self;
}
@end
