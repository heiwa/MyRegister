//
//  ConnectionManager.m
//  MyRegister
//
//  Created by heiwa on 2015/06/06.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "ConnectionManager.h"

@implementation ConnectionManager
+(FMDatabase*) getConnection{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* dir = [paths objectAtIndex:0];
    NSString* db_path = [dir stringByAppendingPathComponent:@"myRegister.db"];
    NSLog(@"db_path::");
    NSLog(@"%@",db_path);
    return [FMDatabase databaseWithPath:db_path];
}
@end
