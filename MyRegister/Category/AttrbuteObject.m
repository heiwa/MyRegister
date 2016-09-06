//
//  AttrbuteObject.m
//  MyRegister
//
//  Created by heiwa on 2015/04/04.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "AttrbuteObject.h"

@implementation AttrbuteObject

- (id)init:(NSString*)name value:(NSInteger)v left:(BOOL)l attrName:(NSString*)attrN{
    self.categoryName = name;
    self.value = v;
    self.left = l;
    self.attrName = attrN;
    return self;
}
- (id)initDefault:(BOOL)left
{
    self.value = 0;
    self.left = left;

    if(left==YES){
        self.categoryName = @"支出";
        self.attrName = @"支出";
    }else {
        self.categoryName = @"現金";
        self.attrName = @"現金";
    }
    return self;
}
- (id)initWithEntity:(TransactionDetailEntity *)entity
{
    self.value = entity.value;
    if ( entity.lORr == 0 ) {
        self.left = YES;
    } else {
        self.left = NO;
    }
    self.attrName = entity.name;
    return self;
}
@end
