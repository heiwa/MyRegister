//
//  AttrbuteObject.h
//  MyRegister
//
//  Created by heiwa on 2015/04/04.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionDetailEntity.h"

@interface AttrbuteObject : NSObject
@property (nonatomic) NSString* categoryName;
@property (nonatomic) BOOL left;
@property (nonatomic) NSInteger value;
@property (nonatomic) NSString* attrName;

- (id)init:(NSString*)name value:(NSInteger)v left:(BOOL)l attrName:(NSString*)attrN;
- (id)initDefault:(BOOL)left;
- (id)initWithEntity:(TransactionDetailEntity*) entity;
@end
