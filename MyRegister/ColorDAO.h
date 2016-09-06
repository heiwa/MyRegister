//
//  ColorDAO.h
//  MyRegister
//
//  Created by heiwa on 2015/07/20.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ColorEntity.h"

@interface ColorDAO : NSObject
{
    FMDatabase* db;
}
-(id)init;
-(ColorEntity*)getColor:(int)attrid;
-(ColorEntity*)getColorByName:(NSString*)name;
@end
