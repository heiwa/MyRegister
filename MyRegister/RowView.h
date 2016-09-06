//
//  RowView.h
//  MyRegister
//
//  Created by heiwa on 2015/04/06.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttrbuteObject.h"
#import "TappableLabel.h"

@interface RowView : UIView
@property (weak, nonatomic) id<TappableDelegate> delegate;
+(double)getHeight;
-(id)initWithFrame:(CGRect)frame editable:(BOOL)editable;
-(void)setAttr:(AttrbuteObject*)left right:(AttrbuteObject*)right;
-(void)setAttrLeft:(AttrbuteObject*)attr;
-(void)setAttrRight:(AttrbuteObject*)attr;
-(AttrbuteObject*)getAttrLeft;
-(AttrbuteObject*)getAttrRight;
-(void)allResignFirstResponder;
@end
