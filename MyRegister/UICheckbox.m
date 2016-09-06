//
//  UICheckbox.m
//  MyRegister
//
//  Created by heiwa on 2016/05/15.
//  Copyright © 2016年 heiwa. All rights reserved.
//

#import "UICheckbox.h"

static NSInteger size = 25;

@implementation UICheckbox
{
    BOOL checked;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        SEL sel = sel_registerName("change");
        [self addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
        checked = YES;
        [self change];
    }
    return self;
}

- (void) change
{
    if (checked) {
        [self setImage:[UIImage imageNamed:@"checkoff.png"] forState:UIControlStateNormal];
        checked = NO;
    } else {
        [self setImage:[UIImage imageNamed:@"checkon.png"] forState:UIControlStateNormal];
        checked = YES;
    }
}
+(NSInteger)getSize {
    return size;
}
- (BOOL) isSelected {
    return checked;
}
@end
