//
//  SheetElementView.h
//  MyRegister
//
//  Created by heiwa on 2015/04/09.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttrbuteObject.h"
#import "PickerViewController.h"
#import "TappableLabel.h"

@interface SheetElementView : UIView <TappableDelegate>
{
    NSInteger rows;
    NSInteger rowsL;
    NSInteger rowsR;
    NSMutableArray* rowViews;
    UILabel* editing;
    BOOL textEditable;
    TransactionDetailEntity* transSample;
}
@property (weak,nonatomic) id<PickerViewControllerDelegate> delegate;
+(id) createFromTransaction:(NSArray*)transaction frame:(CGRect)frame;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithFrame:(CGRect)frame editable:(BOOL)editable;
-(void) setInitAttr;
-(id) initWithFrameAndAttr:(CGRect)frame left:(AttrbuteObject*)left right:(AttrbuteObject*)right;
-(void) addRow:(AttrbuteObject*)left right:(AttrbuteObject*)right;
-(void) addRow:(TransactionDetailEntity*) detail;
-(void) editText:(NSString*)str;
-(void) textFieldsResignFirstResponder;
-(NSArray*)getRowViews;
-(BOOL) isBalance;
-(TransactionDetailEntity*) getTransactionDetail;
@end
