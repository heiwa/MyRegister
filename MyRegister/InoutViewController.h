//
//  InoutViewController.h
//  MyRegister
//
//  Created by heiwa on 2015/04/04.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InoutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *sumValueLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
- (IBAction)tapBefore:(id)sender;
- (IBAction)tapAfter:(id)sender;
- (IBAction)tapNow:(id)sender;
- (IBAction)back:(UIStoryboardSegue*)segue;

@end
