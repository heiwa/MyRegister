//
//  TransactionDAO.h
//  MyRegister
//
//  Created by heiwa on 2015/06/06.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "TransactionDetailEntity.h"

@interface TransactionDAO : NSObject
{
    FMDatabase* db;
}
- (BOOL) tableRefresh;
- (BOOL) insertNewTransaction:(NSArray*)attrs date:(NSString*)date;
- (NSArray*) getAllTransactions;
- (NSArray*) getTransactionsBefore:(NSString*)date;
- (NSArray*) getInout:(NSString*)startDate endDate:(NSString*)endDate;
- (void) deleteRecords:(NSString*)attrName;
- (void) deleteTransaction:(TransactionDetailEntity*) delTrans;
@end
