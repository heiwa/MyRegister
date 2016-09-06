//
//  ColorEntity.m
//  MyRegister
//
//  Created by heiwa on 2015/07/20.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "ColorEntity.h"

@implementation ColorEntity
-(id) initWithId:(int)attrid red:(double)red green:(double)green blue:(double)blue {
    if(self = [super init]){
        self.attrid = attrid;
        self.red = red;
        self.green = green;
        self.blue = blue;
    }
    return self;
}
@end
