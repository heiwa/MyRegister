//
//  ConfigViewController.m
//  MyRegister
//
//  Created by heiwa on 2015/04/04.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "ConfigViewController.h"
#import "AttrbuteDAO.h"
#import "TransactionDAO.h"

@implementation ConfigViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tappableLabel.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.tappableLabel.text = str;
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
-(void)onTapEvent:(TappableLabel *)uil
{
    [self openPickerView];
}


- (IBAction)onTapAddAttr:(id)sender {
    NSLog([@"onTapAddAttr : " stringByAppendingString:self.attrNameField.text]);
    NSString* attrname = self.attrNameField.text;
    if([attrname isEqualToString:@""]){
        return;
    }
    AttrbuteDAO* dao = [[AttrbuteDAO alloc] init];
    if([dao insertNewAttr:attrname parent:self.tappableLabel.text]){
        self.attrNameField.text = @"";
        [self.attrNameField resignFirstResponder];
    }
}

- (IBAction)onTapCleanUp:(id)sender {
    NSString* attrname = self.tappableLabel.text;
    TransactionDAO* dao = [[TransactionDAO alloc] init];
    [dao deleteRecords:attrname];
    AttrbuteDAO* attrdao = [[AttrbuteDAO alloc] init];
    [attrdao deleteAttr:attrname];
//    AttrbuteDAO* attrdao = [[AttrbuteDAO alloc] init];
//    TransactionDAO* transdao = [[TransactionDAO alloc] init];
//    [attrdao tableRefresh];
//    [transdao tableRefresh];
}
@end
