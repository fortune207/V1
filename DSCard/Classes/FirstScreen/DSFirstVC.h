//
//  DSFirstVC.h
//  DSCard
//
//  Created by Jinzhe xi on 10/13/13.
//  Copyright (c) 2013 Wei Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSView;
@class MBProgressHUD;

@interface DSFirstVC : UIViewController <UITextFieldDelegate, UIPickerViewDataSource,
                        UIPickerViewDelegate>
{
    DSView *viewDelegate;
    
    // current textfield in editing
    UITextField *currentText;
    
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UILabel *lblPound;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *text1;
@property (weak, nonatomic) IBOutlet UITextField *text2;
@property (weak, nonatomic) IBOutlet UILabel *lblOffPeak;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyOffPeak;
@property (weak, nonatomic) IBOutlet UILabel *lblPeak;
@property (weak, nonatomic) IBOutlet UILabel *lblMoneyPeak;
@property (weak, nonatomic) IBOutlet UIButton *btnShowFare;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerStations;

- (id) initWithView:(DSView *)delegate;
-(void)toggleDetailView;
- (void) showProgress;
- (void) hideProgress;

- (IBAction)onSettings:(id)sender;
- (IBAction)onShowFare:(id)sender;

@end
