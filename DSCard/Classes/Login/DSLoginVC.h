//
//  DSLoginVC.h
//  DSCard
//
//  Created by Jinzhe xi on 10/13/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSView;

@interface DSLoginVC : UIViewController <UITextFieldDelegate>
{
    DSView *viewDelegate;
    
    UITextField *currentText;
}

@property (weak, nonatomic) IBOutlet UITextField *txtLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtPass;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc1;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc2;

- (id) initWithView:(DSView *)delegate;

- (IBAction)onLogin:(id)sender;
- (IBAction)onDone:(id)sender;

@end
