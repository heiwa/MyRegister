//
//  AttrbuteDAO.h
//  MyRegister
//
//  Created by heiwa on 2015/05/29.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface AttrbuteDAO : NSObject
{
    FMDatabase* db;
}
-(id)init;
-(void)tableRefresh;
-(void)insertInitData;
-(NSArray*)getAllAttrbutes;
-(NSArray*)getAttrbutesById:(NSArray*)attrID;
-(int)getCount;
-(BOOL)insertNewAttr:(NSString*)attrname parent:(NSString*)parentname;
-(NSArray*)getAttrbutes:(NSString*)attrname;
-(NSInteger)getParentId:(int)attrId;
-(void)deleteAttr:(NSString*)attrname;

@end
