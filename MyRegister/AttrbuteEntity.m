//
//  AttrbuteEntity.m
//  MyRegister
//
//  Created by heiwa on 2015/05/30.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "AttrbuteEntity.h"
#define LogStackTrace NSLog(@"%@",[NSThread callStackSymbols]);

@implementation AttrbuteEntity
-(id)init{
    if(self = [super init]){
        self.aid = 0;
        self.name = [NSString stringWithFormat:@""];
        //self.pid = 0;
    }
    return self;
}
-(id)initWithParam:(int)aid name:(NSString *)name pid:(int)pid{
    if(self = [super init]){
        self.aid = aid;
        self.name = name;
        self.pid = pid;
    }
    return self;
}
-(NSString*)toString{
    NSString* ret = [NSString stringWithFormat:@"id:%d, name:%@, pid:%d",self.aid,self.name,self.pid];
    return ret;
}
@end
