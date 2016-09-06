//
//  SheetParentView.h
//  MyRegister
//
//  Created by heiwa on 2016/05/06.
//  Copyright © 2016年 heiwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SheetElementView.h"

@interface SheetParentView : UIView
{
    NSMutableArray* elementItems;
    NSMutableArray* checkboxItems;
    NSInteger contentHeight;
}
+(id) createFromDetails:(NSArray*)details frame:(CGRect)frame;
-(id) initWithFrame:(CGRect)frame;
-(void) addRows:(SheetElementView*) view;
-(NSArray*) getSelected;

@end
