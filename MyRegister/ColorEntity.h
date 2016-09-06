//
//  ColorEntity.h
//  MyRegister
//
//  Created by heiwa on 2015/07/20.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorEntity : NSObject
@property(nonatomic) int attrid;
@property(nonatomic) double red;
@property(nonatomic) double green;
@property(nonatomic) double blue;

-(id)initWithId:(int)attrid red:(double)red green:(double)green blue:(double)blue;
@end
