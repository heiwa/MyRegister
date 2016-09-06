//
//  TransactionDetailEntity.m
//  MyRegister
//
//  Created by heiwa on 2015/06/14.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "TransactionDetailEntity.h"

@implementation TransactionDetailEntity
-(id)init{
    if(self = [super init]){
        self.transactionId = 0;
        self.lORr = 0;
        self.name = [NSString stringWithFormat:@""];
        self.value = 0;
    }
    return self;
}
-(id)initWithParam:(int)lORr name:(NSString *)name value:(int)value{
    if(self = [super init]){
        self.lORr = lORr;
        self.name = name;
        self.value = value;
    }
    return self;
}
-(void)addTransaction:(TransactionDetailEntity *)tran
{
    if ( self.lORr == tran.lORr ) {
        self.value += tran.value;
    } else {
        if ( self.value >= tran.value ) {
            self.value -= tran.value;
        } else {
            self.lORr = tran.lORr;
            self.value = tran.value - self.value;
        }
    }
}
@end
