//
//  AttrbuteEntity.h
//  MyRegister
//
//  Created by heiwa on 2015/05/30.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttrbuteEntity : NSObject
@property(nonatomic) int aid;
@property(nonatomic) NSString* name;
@property(nonatomic) int pid;

-(id)initWithParam:(int) aid name:(NSString*)name pid:(int)pid;
-(NSString*)toString;
@end
