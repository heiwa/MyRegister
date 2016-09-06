//
//  AttrbuteDAO.m
//  MyRegister
//
//  Created by heiwa on 2015/05/29.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "AttrbuteDAO.h"
#import "AttrbuteEntity.h"
#import "ConnectionManager.h"

@implementation AttrbuteDAO

- (id) init {
    if(self = [super init]){
        db = [ConnectionManager getConnection];
        NSString* initsql = @"PRAGMA foreign_keys=ON";
        NSString* sql = @"CREATE TABLE IF NOT EXISTS attrbutes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE , pid INTEGER, FOREIGN KEY(pid) REFERENCES attrbutes(id));";
        [db open];
        [db executeUpdate:initsql];
        [db executeUpdate:sql];
        [db close];
        [self insertInitData];
    }
    return self;
}
- (void) tableRefresh
{
    NSString* drop = @"DELETE attrbutes;";
    NSString* initsql = @"PRAGMA foreign_keys=ON";
    NSString* sql = @"CREATE TABLE IF NOT EXISTS attrbutes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE , pid INTEGER, FOREIGN KEY(pid) REFERENCES attrbutes(id));";
    [db open];
    [db executeUpdate:drop];
    [db executeUpdate:initsql];
    [db executeUpdate:sql];
    [db close];
    [self insertInitData];
}
- (void) insertInitData{
    [db open];
    [self insertInitData:@"現金"];
    //[self insertInitData:@"損益"];
    [self insertInitData:@"収入"];
    [self insertInitData:@"支出"];
    [self insertInitData:@"資産"];
    [self insertInitData:@"借金"];
    [self insertInitData:@"純資産"];
    [self insertInitData:@"益" parent:@"収入"];
    [self insertInitData:@"損" parent:@"支出"];
    [db close];
}
- (void) insertInitData:(NSString*) name{
    NSString* select = @"SELECT * FROM attrbutes WHERE name = ?";
    NSString* insert = @"INSERT INTO attrbutes (name) VALUES (?)";
    FMResultSet* res = [db executeQuery:select,name];
    if(![res next]){
        [db executeUpdate:insert,name];
    }
}
- (void) insertInitData:(NSString*) name parent:(NSString*) parent {
    NSString* select = @"SELECT * FROM attrbutes WHERE name = ?";
    FMResultSet* res = [db executeQuery:select,name];
    if(![res next]){
        [self insertNewAttr:name parent:parent];
    }
}
- (NSArray*)getAllAttrbutes{
    NSMutableArray* ret = [NSMutableArray array];
    NSString* select = @"SELECT * FROM attrbutes";
    [db open];
    FMResultSet* result = [db executeQuery:select];
    while( [result next] ){
        AttrbuteEntity* attr = [[AttrbuteEntity alloc] init];
        if(![result columnIndexIsNull:0]){
            int rid = [result intForColumnIndex:0];
        }
        if(![result columnIndexIsNull:1]){
            NSString* rname = [result stringForColumnIndex:1];
        }
        if(![result columnIndexIsNull:2]){
            int rpid = [result intForColumnIndex:2];
        }
        attr.aid = [result intForColumnIndex:0];
        attr.name = [result stringForColumnIndex:1];
        attr.pid = [result intForColumnIndex:2];
        
        [ret addObject:attr];
    }
    [db close];
    return ret;
}
- (NSArray*)getAttrbutesById:(NSArray *)attrID {
    NSMutableArray* ret = [NSMutableArray array];
    NSString* attrSQL1 = @"SELECT id FROM attrbutes WHERE pid IN ( ";
    NSString* attrSQLin = @"";
    NSString* attrSQL2 = @");";
    
    for ( int i = 0; i < [attrID count]; i++ ) {
        attrSQLin = [attrSQLin stringByAppendingString:[NSString stringWithFormat:@"%ld",[[attrID objectAtIndex:i] integerValue]]];
        if ( i != [attrID count] - 1 ) {
            attrSQLin = [attrSQLin stringByAppendingString:@","];
        }
    }
    [db open];
    FMResultSet* result = [db executeQuery:[attrSQL1 stringByAppendingString:[attrSQLin stringByAppendingString:attrSQL2]]];
    while( [result next] ){
        NSNumber* idnum = [NSNumber numberWithInt:[result intForColumnIndex:0]];
        
        [ret addObject:idnum];
    }
    [db close];
    return ret;
}
- (int)getCount{
    NSString* select = @"SELECT COUNT(*) FROM attrbutes";
    [db open];
    FMResultSet* result = [db executeQuery:select];
    if( [result next]){
        return [result intForColumnIndex:0];
    }
    return 0;
}
-(BOOL)insertNewAttr:(NSString *)attrname parent:(NSString *)parentname{
    NSString* insert = @"INSERT INTO attrbutes (name,pid) SELECT ?,id FROM attrbutes WHERE name = ?";
    [db open];
    BOOL ret = [db executeUpdate:insert,attrname,parentname];
    [db close];
    return ret;
}
-(NSArray*)getAttrbutes:(NSString *)attrname {
    NSMutableArray* ret = [NSMutableArray array];
    NSString* select = @"SELECT * FROM attrbutes WHERE name = ?";
    [db open];
    FMResultSet* result = [db executeQuery:select, attrname];
    while( [result next] ){
        AttrbuteEntity* attr = [[AttrbuteEntity alloc] init];
        attr.aid = [result intForColumnIndex:0];
        attr.name = [result stringForColumnIndex:1];
        attr.pid = [result intForColumnIndex:2];
        
        [ret addObject:attr];
    }
    [db close];
    return ret;
}
-(NSInteger)getParentId:(int)attrId {
    NSString* select = @"SELECT pid FROM attrbutes WHERE id = ?";
    [db open];
    FMResultSet* result = [db executeQuery:select, [NSNumber numberWithInt:attrId]];
    NSInteger ret = -1;
    if ( [result next] ) {
        ret = [result intForColumnIndex:0];
    }
    [db close];
    return ret;
}
-(void)deleteAttr:(NSString *)attrname {
    NSArray* attrs = [self getAttrbutes:attrname];
    AttrbuteEntity* deleteEntity = [attrs lastObject];
    NSString* delete = @"DELETE FROM attrbutes WHERE id = ?";
    [db open];
    [db executeUpdate:delete, [NSNumber numberWithInt:deleteEntity.aid]];
    [db close];
}
@end
