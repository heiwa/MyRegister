//
//  ColorDAO.m
//  MyRegister
//
//  Created by heiwa on 2015/07/20.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "ColorDAO.h"
#import "ConnectionManager.h"

@implementation ColorDAO
- (id) init {
    if(self = [super init]){
        db = [ConnectionManager getConnection];
        NSString* initsql = @"PRAGMA foreign_keys=ON";
        NSString* sql = @"CREATE TABLE IF NOT EXISTS colors (attrid INTEGER PRIMARY KEY, red REAL, green REAL, blue REAL, FOREIGN KEY(attrid) REFERENCES attrbutes(id));";
        [db open];
        [db executeUpdate:initsql];
        [db executeUpdate:sql];
        [db close];
        [self insertInitData];
    }
    return self;
}

- (void)insertInitData {
    [db open];
    // default set
    [self insertInitData:@"現金" red:0.984 green:0.906 blue:0.192];
    //[self insertInitData:@"損益"];
    [self insertInitData:@"収入" red:0.263 green:0.529 blue:0.914];
    [self insertInitData:@"支出" red:1.000 green:0.157 blue:0.098];
    [self insertInitData:@"資産" red:0.620 green:0.310 blue:0.176];
    [self insertInitData:@"借金" red:0.529 green:0.000 blue:0.800];
    [self insertInitData:@"純資産" red:0.894 green:0.608 blue:0.059];
    //[self insertInitData:@"益" red:0.263 green:0.529 blue:0.914];
    //[self insertInitData:@"損" red:1.000 green:0.157 blue:0.098];
    
    // added set
    NSString* sql = @"SELECT attrbutes.id, colors.red, colors.green, colors.blue FROM attrbutes JOIN colors ON attrbutes.pid = colors.attrid WHERE attrbutes.id NOT IN ( SELECT attrid FROM colors)";
    NSString* insert = [@"INSERT INTO colors (attrid, red, green, blue) " stringByAppendingString:sql];
    FMResultSet* res = [db executeQuery:sql];
    while ( [res next] ) {
        [db executeUpdate:insert];
        res = [db executeQuery:sql];
    }
    [db close];
}
- (void) insertInitData:(NSString*)name red:(double)red green:(double)green blue:(double)blue {
    NSString* select = @"SELECT attrid FROM colors, attrbutes WHERE colors.attrid = attrbutes.id AND name = ?";
    NSString* insert = @"INSERT INTO colors (attrid, red, green, blue) SELECT id, ?, ?, ? FROM attrbutes WHERE name = ?";
    FMResultSet* res = [db executeQuery:select,name];
    if(![res next]){
        NSNumber* nsRed = [NSNumber numberWithDouble:red];
        NSNumber* nsGreen = [NSNumber numberWithDouble:green];
        NSNumber* nsBlue = [NSNumber numberWithDouble:blue];
        [db executeUpdate:insert,nsRed,nsGreen,nsBlue,name];
    }
}
- (ColorEntity*) getColor:(int)attrid {
    ColorEntity* ret = nil;
    NSString* sql = @"SELECT * FROM colors WHERE attrid = ?";
    NSNumber* nsAttrid = [NSNumber numberWithInt:attrid];
    [db open];
    FMResultSet* result = [db executeQuery:sql, nsAttrid];
    if ( [result next] ) {
        ret = [[ColorEntity alloc] initWithId:attrid red:[result doubleForColumn:@"red"] green:[result doubleForColumn:@"green"] blue:[result doubleForColumn:@"blue"]];
    }
    [db close];
    return ret;
}
- (ColorEntity*) getColorByName:(NSString *)name {
    ColorEntity* ret = nil;
    NSString* sql = @"SELECT colors.attrid, colors.red, colors.green, colors.blue FROM colors, attrbutes WHERE colors.attrid = attrbutes.id AND attrbutes.name = ?";
    [db open];
    FMResultSet* result = [db executeQuery:sql, name];
    if ( [result next] ) {
        ret = [[ColorEntity alloc] initWithId:[result intForColumn:@"attrid"] red:[result doubleForColumn:@"red"] green:[result doubleForColumn:@"green"] blue:[result doubleForColumn:@"blue"]];
    }
    [db close];
    return ret;
}
@end
