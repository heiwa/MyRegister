//
//  TransactionDAO.m
//  MyRegister
//
//  Created by heiwa on 2015/06/06.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "TransactionDAO.h"
#import "ConnectionManager.h"
#import "RowView.h"
#import "AttrbuteDAO.h"
#import "AttrbuteEntity.h"

@implementation TransactionDAO
- (id) init {
    if(self = [super init]){
        [[AttrbuteDAO alloc] init];
        db = [ConnectionManager getConnection];
        NSString* initsql = @"PRAGMA foreign_keys=ON";
        NSString* sql = @"CREATE TABLE IF NOT EXISTS transactions (transactionId INTEGER PRIMARY KEY AUTOINCREMENT,  transactionDate TEXT , deleteFlag INTEGER);";
        NSString* sql2 = @"CREATE TABLE IF NOT EXISTS transactionDetails (detailId INTEGER PRIMARY KEY AUTOINCREMENT, transactionId INTEGER, leftORright INTEGER, attrId INTEGER, value INTEGER, FOREIGN KEY(transactionId) REFERENCES transactions(transactionId), FOREIGN KEY(attrId) REFERENCES attrbutes(id));";
        [db open];
        [db executeUpdate:initsql];
        [db executeUpdate:sql];
        [db executeUpdate:sql2];
        [db close];
    }
    return self;
}
- (BOOL) tableRefresh
{
    NSString* drop = @"DROP TABLE transactionDetails;";
    NSString* drop2 = @"DROP TABLE transactions;";
    NSString* sql = @"CREATE TABLE IF NOT EXISTS transactions (transactionId INTEGER PRIMARY KEY AUTOINCREMENT,  transactionDate TEXT , deleteFlag INTEGER);";
    NSString* sql2 = @"CREATE TABLE IF NOT EXISTS transactionDetails (detailId INTEGER PRIMARY KEY AUTOINCREMENT, transactionId INTEGER, leftORright INTEGER, attrId INTEGER, value INTEGER, FOREIGN KEY(transactionId) REFERENCES transactions(transactions.stransactionId), FOREIGN KEY(attrId) REFERENCES attrbutes(id));";
    BOOL success = YES;
    
    [db open];
    success = success & [db executeUpdate:drop];
    success = success &[db executeUpdate:drop2];
    success = success &[db executeUpdate:sql];
    success = success &[db executeUpdate:sql2];
    [db close];
    return success;
}
- (BOOL) insertNewTransaction:(NSArray *)attrs date:(NSString*)date {
    NSString* insertSQL = @"INSERT INTO transactions ( transactionDate, deleteFlag ) VALUES ( ?, 0 );";
    [db open];
    [db beginTransaction];
    BOOL success = [db executeUpdate:insertSQL,date];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    NSInteger transID = [db lastInsertRowId];
    
    AttrbuteObject* attr = nil;
    for ( RowView* row in attrs ) {
        attr = [row getAttrLeft];
        if (attr != nil) {
            success = success & [self insertDetail:transID lORr:0 attrname:attr.attrName value:attr.value];
            if ([db hadError]) {
                NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            }
        }
        attr = [row getAttrRight];
        if (attr != nil) {
            success = success & [self insertDetail:transID lORr:1 attrname:attr.attrName value:attr.value];
            if ([db hadError]) {
                NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            }
        }
    }
    [db commit];
    [db close];
    return success;
}
- (BOOL) insertDetail:(NSInteger) transID lORr:(NSInteger)lORr attrname:(NSString*)attrname value:(NSInteger)value
{
    NSString* insertSQL = @"INSERT INTO transactionDetails ( transactionId, leftORright, attrId, value ) SELECT ?, ?, id, ? FROM attrbutes WHERE name = ?";
    return [db executeUpdate:insertSQL,[[NSNumber alloc] initWithInteger:transID],[[NSNumber alloc] initWithInteger:lORr],[[NSNumber alloc] initWithInteger:value ],attrname];
}
- (NSArray*) getAllTransactions
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    return [self getTransactionsBefore:[df stringFromDate:[NSDate date]]];
}
- (NSArray*) getTransactionsBefore:(NSString *)date
{
    NSString* sql = @"SELECT transactionDetails.transactionId,leftORright,name,value FROM transactionDetails JOIN transactions ON transactionDetails.transactionId = transactions.transactionId JOIN attrbutes ON transactionDetails.attrId = attrbutes.id WHERE transactionDate <= ? AND deleteFlag = 0 ORDER BY transactionDate DESC, transactionDetails.transactionId DESC;";
    
    NSMutableArray* ret = [NSMutableArray array];
    
    [db open];
    FMResultSet* result = [db executeQuery:sql,date];
    while ( [result next] ) {
        TransactionDetailEntity* trans = [[TransactionDetailEntity alloc] init];
        trans.transactionId = [result intForColumnIndex:0];
        trans.lORr = [result intForColumnIndex:1];
        trans.name = [result stringForColumnIndex:2];
        trans.value = [result intForColumnIndex:3];
        
        [ret addObject:trans];
    }
    [db close];
    return ret;
}
- (NSArray*) getInout:(NSString *)startDate endDate:(NSString *)endDate
{
    AttrbuteDAO* attrDAO = [[AttrbuteDAO alloc] init];
    NSMutableArray* ids = [NSMutableArray array];
    [ids addObject:[NSNumber numberWithInt:2]];
    [ids addObject:[NSNumber numberWithInt:3]];
    NSString* attrSQLin = @"2,3";
    while ( [ids count] > 0 ) {
        ids = [attrDAO getAttrbutesById:ids];
        for ( int i = 0; i < [ids count]; i++ ) {
            attrSQLin = [attrSQLin stringByAppendingString:[NSString stringWithFormat:@",%ld",[[ids objectAtIndex:i] integerValue]]];
        
        }
    }
    
    NSString* sql = @"SELECT leftORright,name,value FROM transactionDetails JOIN transactions ON transactionDetails.transactionId = transactions.transactionId JOIN attrbutes ON transactionDetails.attrId = attrbutes.id WHERE transactionDate >= ? AND transactionDate < ? AND deleteFlag = 0 AND attrbutes.id IN ( ";
    sql = [sql stringByAppendingString:[attrSQLin stringByAppendingString:@" );"]];
    
    NSMutableArray* ret = [NSMutableArray array];
    
    [db open];
    FMResultSet* result = [db executeQuery:sql,startDate,endDate];
    while ( [result next] ) {
        TransactionDetailEntity* trans = [[TransactionDetailEntity alloc] init];
        trans.lORr = [result intForColumnIndex:0];
        trans.name = [result stringForColumnIndex:1];
        trans.value = [result intForColumnIndex:2];
        
        [ret addObject:trans];
    }
    [db close];
    return ret;
}
- (void) deleteRecords:(NSString *)attrName
{
    AttrbuteDAO* attrDAO = [[AttrbuteDAO alloc] init];
    NSArray* targetAttrs = [attrDAO getAttrbutes:attrName];
    AttrbuteEntity* targetAttr = (AttrbuteEntity*)[targetAttrs lastObject];
    NSInteger insteadId = [attrDAO getParentId:targetAttr.aid];
    
    NSArray* targetTransactions = [self getTransactions:targetAttr.aid];
    NSString* select = @"SELECT leftORright, value, attrId FROM transactionDetails WHERE transactionId = ?";
    NSString* delete = @"DELETE FROM transactionDetails WHERE transactionId = ? AND attrId = ?";
    NSString* update = @"UPDATE transactionDetails SET attrId = ? WHERE transactionId = ? AND attrId = ?";
    
    BOOL isSucceeded = YES;
    [db open];
    [db beginTransaction];
    for (NSNumber* transId in targetTransactions) {
        FMResultSet* result = [db executeQuery:select, transId];
        BOOL delFlag = [self needDelete:result delAttrId:targetAttr.aid];
        BOOL resultFlag = YES;
        if ( delFlag ) {
            resultFlag = [db executeUpdate:delete, transId, [NSNumber numberWithInt:targetAttr.aid]];
        } else {
            resultFlag = [db executeUpdate:update, [NSNumber numberWithInteger:insteadId], transId, [NSNumber numberWithInt:targetAttr.aid]];
        }
        if (!resultFlag) {
            isSucceeded = NO;
            break;
        }
    }
    if (isSucceeded) {
        [db commit];
    } else {
        [db rollback];
    }
    [db close];
    
}

- (NSArray*) getTransactions:(int) attrId
{
    NSString* sql = @"SELECT DISTINCT transactionId FROM transactionDetails WHERE attrId = ?";
    NSMutableArray* ret = [NSMutableArray array];
    [db open];
    FMResultSet* result = [db executeQuery:sql, [NSNumber numberWithInt:attrId]];
    while ( [result next] ) {
        [ret addObject:[NSNumber numberWithInt:[result intForColumnIndex:0]]];
    }
    [db close];
    return ret;
}
- (BOOL) needDelete:(FMResultSet*) result delAttrId:(int)delAttrId
{
    int leftSum = 0;
    int rightSum = 0;
    while ( [result next] ) {
        if ( [result intForColumn:@"attrId"] != delAttrId) {
            if ( [result intForColumn:@"leftORright"] == 0) {
                leftSum += [result intForColumn:@"value"];
            } else {
                rightSum += [result intForColumn:@"value"];
            }
        }
    }
    if ( leftSum == rightSum) {
        return YES;
    }
    return NO;
}
- (void) deleteTransaction:(TransactionDetailEntity*)delTrans
{
    NSString* delDetailSQL = @"DELETE FROM transactionDetails WHERE transactionId = ?";
    NSString* delTransSQL = @"DELETE FROM transactions WHERE transactionId = ?";
    
    [db open];
    [db beginTransaction];
    
    BOOL success1 = [db executeUpdate:delDetailSQL, [NSNumber numberWithInt:delTrans.transactionId]];
    BOOL success2 = [db executeUpdate:delTransSQL, [NSNumber numberWithInt:delTrans.transactionId]];
    
    if ( success1 && success2 ) {
        [db commit];
    } else {
        [db rollback];
    }
    [db close];
}
@end
