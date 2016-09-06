//
//  ConnectionManager.h
//  MyRegister
//
//  Created by heiwa on 2015/06/06.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface ConnectionManager : NSObject
+ (FMDatabase*) getConnection;
@end
