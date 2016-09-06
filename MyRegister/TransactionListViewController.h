//
//  TransactionListViewController.h
//  MyRegister
//
//  Created by heiwa on 2016/05/06.
//  Copyright © 2016年 heiwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)tapAfterButton:(id)sender;
- (IBAction)tapBeforeButton:(id)sender;
- (IBAction)tapTrashButton:(id)sender;

@end
