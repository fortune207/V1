//
//  DSView.h
//  DSCard
//
//  Created by Wei Jin on 10/12/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSModel;
@class DSFirstVC;
@class DSLoginVC;

@interface DSView : UIViewController
{
    DSModel *model;
    UIWindow *window;
    
    UINavigationController *nc;
    
    DSFirstVC *firstVC;
    DSLoginVC *loginVC;
    
    UIAlertView *generalalert;
}

@property (nonatomic, retain) DSModel *model;
@property (nonatomic, retain) DSLoginVC *loginVC;
@property (nonatomic, retain) DSFirstVC *firstVC;

-(id) initWithModel:(DSModel *) some_model;
-(void) gotologinScreen;
-(void) gotofirstScreen;
-(void) doLogin;
-(void) doGetFare;
-(void) showFares;

- (void) generalAlert:(NSString *)title message:(NSString *)message poptostart:(NSInteger)poptostart;

@end
