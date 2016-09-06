//
//  TappableLabel.m
//  MyRegister
//
//  Created by heiwa on 2015/05/06.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "TappableLabel.h"

@implementation TappableLabel
-(id)init
{
    self = [super init];
    if(self){
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer* ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:ges];
    }
    return self;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:ges];
}
-(void)onTap:(UITapGestureRecognizer*)sender
{
    NSLog(@"TappableLabel::onTap");
    [self.delegate onTapEvent:self];
}
@end
