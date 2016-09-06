//
//  BalanceSheetViewController.m
//  MyRegister
//
//  Created by heiwa on 2015/04/04.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "BalanceSheetViewController.h"
#import "SheetElementView.h"
#import "TransactionDAO.h"
#import "TransactionDetailEntity.h"

@implementation BalanceSheetViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDateOrNow:0 month:0 day:0];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self displaySheet];
}
- (void)displaySheet
{
    for (UIView* view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    SheetElementView* sev = [[SheetElementView alloc] initWithFrame:self.scrollView.frame editable:NO];
    [self.scrollView addSubview:sev];
    
    TransactionDAO* dao = [[TransactionDAO alloc] init];
    NSArray* transactions = [dao getTransactionsBefore:[self getDateString]];
    NSArray* displayTrans = [self aggrigateTransactions:transactions];
    int sumValueL = 0;
    int sumValueR = 0;
    for ( TransactionDetailEntity* tran in displayTrans ) {
        if ( tran.lORr == 0 ) {
            [sev addRow:[[AttrbuteObject alloc] initWithEntity:tran ] right:nil];
            sumValueL += tran.value;
        } else {
            [sev addRow:nil right:[[AttrbuteObject alloc] initWithEntity:tran]];
            sumValueR += tran.value;
        }
    }
    [self.scrollView setContentSize:sev.frame.size];
    if ( sumValueL == sumValueR ) {
        self.sumValueLabel.text = [NSString stringWithFormat:@"¥%d",sumValueL ];
    }
}
- (NSArray*)aggrigateTransactions:(NSArray*)trans
{
    NSMutableDictionary* ret = [NSMutableDictionary dictionary];
    
    for ( TransactionDetailEntity* tran in trans ) {
        TransactionDetailEntity* tmp = [ret objectForKey:tran.name];
        if ( tmp == nil ) {
            [ret setObject:tran forKey:tran.name];
        } else {
            [tmp addTransaction:tran];
        }
    }
    return [ret allValues];
}
- (IBAction)tapNow:(id)sender {
    [self setDateOrNow:0 month:0 day:0];
    [self displaySheet];
}

- (IBAction)tapBeforeMonth:(id)sender {
    NSInteger y = self.year;
    NSInteger m = self.month - 1;
    NSInteger d = self.tmpDay;
    if ( m == 0 ){
        m = 12;
        y -= 1;
    }
    if ( m == 2 && d >= 29 ) {
        d = 28;
    } else if ( (m == 4 || m == 6 || m == 9 || m == 11) && d >= 31 ) {
        d = 30;
    }
    [self setDateOrNow:y month:m day:d];
    [self displaySheet];
}

- (IBAction)tapBeforeDay:(id)sender {
    NSInteger y = self.year;
    NSInteger m = self.month;
    NSInteger d = self.day - 1;
    if ( d == 0 ){
        m -= 1;
        d = 31;
        if ( m == 0 ){
            m = 12;
            y -= 1;
        }
    }
    if ( m == 2 && d >= 29 ) {
        d = 28;
    } else if ( (m == 4 || m == 6 || m == 9 || m == 11) && d >= 31 ) {
        d = 30;
    }
    self.tmpDay = d;
    [self setDateOrNow:y month:m day:d];
    [self displaySheet];
}

- (IBAction)tapAfterDay:(id)sender {
    NSInteger y = self.year;
    NSInteger m = self.month;
    NSInteger d = self.day + 1;
    if ( (m == 2 && d >= 29) || ( (m == 4 || m == 6 || m == 9 || m == 11) && d >= 31 ) || d >= 32 ) {
        d = 1;
        m += 1;
        if ( m == 13 ) {
            m = 1;
            y += 1;
        }
    }
    self.tmpDay = d;
    [self setDateOrNow:y month:m day:d];
    [self displaySheet];
}

- (IBAction)tapAfterMonth:(id)sender {
    NSInteger y = self.year;
    NSInteger m = self.month + 1;
    NSInteger d = self.tmpDay;
    if ( m == 13 ){
        m = 1;
        y += 1;
    }
    if ( m == 2 && d >= 29 ) {
        d = 29;
    } else if ( (m == 4 || m == 6 || m == 9 || m == 11) && d >= 31 ) {
        d = 30;
    }
    [self setDateOrNow:y month:m day:d];
    [self displaySheet];
}

- (void) setDateOrNow:(NSInteger)y month:(NSInteger)m day:(NSInteger)d {
    if (m <= 0 || y <= 0 || d <= 0) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents* comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        self.year = comp.year;
        self.month = comp.month;
        self.day = comp.day;
        self.tmpDay = comp.day;
    } else {
        self.year = y;
        self.month = m;
        self.day = d;
    }
    self.dateLabel.text = [NSString stringWithFormat:@"%04ld年%ld月%ld日", self.year, self.month, self.day];
}
- (NSString*)getDateString {
    return [NSString stringWithFormat:@"%04ld-%02ld-%02ld",self.year,self.month,self.day];
}
@end
