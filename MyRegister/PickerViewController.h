//
//  PickerViewController.h
//  MyRegister
//
//  Created by heiwa on 2015/05/06.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewControllerDelegate;

@interface PickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) id<PickerViewControllerDelegate> delegate;

- (IBAction)closeButtonTap:(id)sender;
@end

@protocol PickerViewControllerDelegate <NSObject>
-(void)applySelectedString:(NSString*)str;
-(void)openPickerView;
-(void)closePickerView:(PickerViewController*)controller;
@end
