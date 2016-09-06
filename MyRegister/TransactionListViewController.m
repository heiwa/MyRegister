//
//  TransactionListViewController.m
//  MyRegister
//
//  Created by heiwa on 2016/05/06.
//  Copyright © 2016年 heiwa. All rights reserved.
//

#import "TransactionListViewController.h"
#import "TransactionDAO.h"
#import "TransactionDetailEntity.h"
#import "SheetParentView.h"

@implementation TransactionListViewController {
    NSInteger numOfPage;
    NSArray* transactions;
    NSInteger currentRowIndex;
    NSMutableArray* indexArray;
    SheetParentView* sheetView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    numOfPage = 10;
    currentRowIndex = 0;
    indexArray = [NSMutableArray array];
    [indexArray addObject:[NSNumber numberWithInt:0]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TransactionDAO* dao = [[TransactionDAO alloc] init];
    transactions = [dao getAllTransactions];
    [self displaySheet];
}
- (void) displaySheet {
    NSArray* showTransactions = [self extractTransaction];
    sheetView = [SheetParentView createFromDetails:showTransactions frame:self.scrollView.frame];
    
    for (UIView* view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self.scrollView addSubview:sheetView];
    [self.scrollView setContentSize:sheetView.frame.size];
}

- (NSArray*) extractTransaction {
    int count = 0;
    int tmpTransactionId = -1;
    NSMutableArray* showTransactions = [NSMutableArray array];
    for ( int i = [[indexArray objectAtIndex:currentRowIndex] intValue]; i < [transactions count]; i++) {
        TransactionDetailEntity* detail = [transactions objectAtIndex:i];
        int currentTransactionId = detail.transactionId;
        if (currentTransactionId != tmpTransactionId) {
            tmpTransactionId = currentTransactionId;
            count++;
            if (count > numOfPage) {
                if ([indexArray count] - 1 == currentRowIndex) {
                    [indexArray addObject:[NSNumber numberWithInt:i]];
                }
                break;
            }
        }
        [showTransactions addObject:detail];
    }
    return showTransactions;
}
- (IBAction)tapAfterButton:(id)sender {
    currentRowIndex--;
    if (currentRowIndex < 0) {
        currentRowIndex = 0;
    }
    [self displaySheet];
}

- (IBAction)tapBeforeButton:(id)sender {
    currentRowIndex++;
    [self displaySheet];
}

- (IBAction)tapTrashButton:(id)sender {
    NSArray* delTransactions = [sheetView getSelected];
    TransactionDAO* dao = [[TransactionDAO alloc] init];
    for (TransactionDetailEntity* trans in delTransactions) {
        [dao deleteTransaction:trans];
    }
    [self displaySheet];
}
@end
