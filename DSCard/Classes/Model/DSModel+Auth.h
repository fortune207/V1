//
//  DSModel+Auth.h
//  DSCard
//
//  Created by Jinzhe xi on 10/13/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#import "DSModel.h"

// ---------------------------------------------------------------------------------------
typedef enum
{
    REQUEST_TYPE_UNKNOWN = 0,
    REQUEST_TYPE_LOGIN = 1,
    REQUEST_TYPE_GET_FARE = 2,
    REQUEST_TYPE_POST_FARE = 3,
    
} DSModelRequestType;
// ---------------------------------------------------------------------------------------

@interface DSModel (Auth)

- (void)doLogin;
- (void)doGetFare:(int) requestType;

@end
