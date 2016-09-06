//
//  TransactionViewController.h
//  MyRegister
//
//  Created by heiwa on 2015/04/04.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"

@interface TransactionViewController : UIViewController <PickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) PickerViewController* pickerViewController;

- (IBAction)leftAddButtonTap:(id)sender;
- (IBAction)rightAddButtonTap:(id)sender;
- (IBAction)registerButtonTap:(id)sender;
//- (void)openPickerView;
- (IBAction)onTapScreen:(id)sender;
@end
