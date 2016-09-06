//
//  TransactionDetailEntity.h
//  MyRegister
//
//  Created by heiwa on 2015/06/14.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionDetailEntity : NSObject
@property(nonatomic) int transactionId;
@property(nonatomic) int lORr;
@property(nonatomic) NSString* name;
@property(nonatomic) int value;

-(id) initWithParam:(int) lORr name:(NSString*)name value:(int)value;
-(void) addTransaction:(TransactionDetailEntity*)tran;
@end
