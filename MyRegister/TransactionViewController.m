//
//  TransactionViewController.m
//  MyRegister
//
//  Created by heiwa on 2015/04/04.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "TransactionViewController.h"
#import "SheetElementView.h"
#import "TransactionDAO.h"
#import "AttrbuteEntity.h"

@implementation TransactionViewController
{
    SheetElementView* sev;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    sev = nil;
    [self setSheetElement];
    self.scrollView.delegate = self;
    [self.scrollView setContentSize:sev.frame.size];
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapScreen:)];
    [self.view addGestureRecognizer:tapGesture];
    
}
- (void)setSheetElement {
    if (sev != nil) {
        [sev removeFromSuperview];
    }
    sev = [[SheetElementView alloc] initWithFrame:self.scrollView.frame editable:YES];
    [sev setInitAttr];
    sev.delegate = self;
    [self.scrollView addSubview:sev];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftAddButtonTap:(id)sender {
    [sev addRow:[[AttrbuteObject alloc] initDefault:YES] right:nil];
}

- (IBAction)rightAddButtonTap:(id)sender {
    [sev addRow:nil right:[[AttrbuteObject alloc] initDefault:NO]];
}

- (IBAction)registerButtonTap:(id)sender {
    if ( ![sev isBalance] ) {
        return ;
    }
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSString* date = [df stringFromDate:self.datePicker.date];
    
    TransactionDAO* dao = [[TransactionDAO alloc] init];
    [dao insertNewTransaction:[sev getRowViews] date:date];
    
    [self setSheetElement];
}
- (void)openPickerView
{
    self.pickerViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"PickerViewController"];
    self.pickerViewController.delegate = self;
    
    UIView* pickerView = self.pickerViewController.view;
    CGPoint middleCenter = pickerView.center;
    
    UIWindow* mainWindow = [UIApplication sharedApplication].keyWindow;
    //UIWindow* mainWindow = (((TWAppDelegate*) [UIApplication sharedApplication].delegate).window);
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    pickerView.center = offScreenCenter;
    
    [mainWindow addSubview:pickerView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    pickerView.center = middleCenter;
    [UIView commitAnimations];
}
- (void)applySelectedString:(NSString *)str
{
    [sev editText:str];
}
- (void)closePickerView:(PickerViewController *)controller
{
    // PickerViewをアニメーションを使ってゆっくり非表示にする
    UIView *pickerView = controller.view;
    
    // アニメーション完了時のPickerViewの位置を計算
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    
    [UIView beginAnimations:nil context:(void *)pickerView];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    // アニメーション終了時に呼び出す処理を設定
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    pickerView.center = offScreenCenter;
    [UIView commitAnimations];
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // PickerViewをサブビューから削除
    UIView *pickerView = (__bridge UIView *)context;
    [pickerView removeFromSuperview];
}

- (IBAction)onTapScreen:(id)sender {
    [sev textFieldsResignFirstResponder];
}
@end
