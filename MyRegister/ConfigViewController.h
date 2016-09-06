//
//  ConfigViewController.h
//  MyRegister
//
//  Created by heiwa on 2015/04/04.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"
#import "TappableLabel.h"

@interface ConfigViewController : UIViewController <PickerViewControllerDelegate,TappableDelegate>
@property (strong, nonatomic) PickerViewController* pickerViewController;
@property (weak, nonatomic) IBOutlet TappableLabel *tappableLabel;
@property (weak, nonatomic) IBOutlet UITextField *attrNameField;
- (IBAction)onTapAddAttr:(id)sender;
- (IBAction)onTapCleanUp:(id)sender;
@end
