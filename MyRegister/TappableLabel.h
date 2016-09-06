//
//  TappableLabel.h
//  MyRegister
//
//  Created by heiwa on 2015/05/06.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TappableDelegate;

@interface TappableLabel : UILabel
@property (weak,nonatomic) id<TappableDelegate> delegate;
@end

@protocol TappableDelegate <NSObject>

-(void)onTapEvent:(TappableLabel*)label;

@end