//
//  InoutViewController.m
//  MyRegister
//
//  Created by heiwa on 2015/04/04.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "InoutViewController.h"
#import "SheetElementView.h"
#import "TransactionDAO.h"

@implementation InoutViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDateOrNow:0 month:0];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self displaySheet];
}
- (void) displaySheet
{
    for (UIView* view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    SheetElementView* sev = [[SheetElementView alloc] initWithFrame:self.scrollView.frame editable:NO];
    [self.scrollView addSubview:sev];
    
    TransactionDAO* dao = [[TransactionDAO alloc] init];
    NSArray* transactions = [dao getInout:[self getStartDate] endDate:[self getEndDate]];
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
    } else if(sumValueL > sumValueR) {
        AttrbuteObject* soneki = [[AttrbuteObject alloc] init:@"損" value:sumValueL-sumValueR left:NO attrName:@"損"];
        [sev addRow:nil right:soneki];
        self.sumValueLabel.text = [NSString stringWithFormat:@"¥%d",sumValueL ];
    } else {
        AttrbuteObject* soneki = [[AttrbuteObject alloc] init:@"益" value:sumValueR-sumValueL left:YES attrName:@"益"];
        [sev addRow:soneki right:nil];
        self.sumValueLabel.text = [NSString stringWithFormat:@"¥%d",sumValueR ];
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

- (void) setDateOrNow:(NSInteger)y month:(NSInteger)m {
    if (m <= 0 || y <= 0) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents* comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
        self.year = comp.year;
        self.month = comp.month;
    } else {
        self.year = y;
        self.month = m;
    }
    self.dateLabel.text = [NSString stringWithFormat:@"%04ld年%ld月", self.year, self.month];
}
- (NSString*)getStartDate {
    return [NSString stringWithFormat:@"%04ld-%02ld-01",self.year,self.month];
}
- (NSString*)getEndDate {
    return [NSString stringWithFormat:@"%04ld-%02ld-01",self.year,self.month+1];
}
- (IBAction)tapBefore:(id)sender {
    NSInteger y = self.year;
    NSInteger m = self.month - 1;
    if ( m == 0 ){
        m = 12;
        y -= 1;
    }
    [self setDateOrNow:y month:m];
    [self displaySheet];
}

- (IBAction)tapAfter:(id)sender {
    NSInteger y = self.year;
    NSInteger m = self.month + 1;
    if ( m == 13 ){
        m = 1;
        y += 1;
    }
    [self setDateOrNow:y month:m];
    [self displaySheet];
}

- (IBAction)tapNow:(id)sender {
    [self setDateOrNow:0 month:0];
    [self displaySheet];
}
- (IBAction)back:(UIStoryboardSegue*)segue {
    
}

@end
