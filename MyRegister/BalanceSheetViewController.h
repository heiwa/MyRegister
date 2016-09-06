//
//  BalanceSheetViewController.h
//  MyRegister
//
//  Created by heiwa on 2015/04/04.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceSheetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *sumValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger tmpDay;
- (IBAction)tapNow:(id)sender;
- (IBAction)tapBeforeMonth:(id)sender;
- (IBAction)tapBeforeDay:(id)sender;
- (IBAction)tapAfterDay:(id)sender;
- (IBAction)tapAfterMonth:(id)sender;
@end
