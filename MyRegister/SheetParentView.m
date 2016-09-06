//
//  SheetParentView.m
//  MyRegister
//
//  Created by heiwa on 2016/05/06.
//  Copyright © 2016年 heiwa. All rights reserved.
//

#import "SheetParentView.h"
#import "UICheckbox.h"

@implementation SheetParentView

+(id) createFromDetails:(NSArray *)details frame:(CGRect)frame{
    SheetParentView* createView = [[SheetParentView alloc] initWithFrame:frame];
    NSMutableArray* transaction = [NSMutableArray array];
    int tmpTransactionId = ((TransactionDetailEntity*)[details objectAtIndex:0]).transactionId;
    for (TransactionDetailEntity* detail in details) {
        if (tmpTransactionId != detail.transactionId) {
            [createView addRows:[SheetElementView createFromTransaction:transaction frame:frame]];
            [transaction removeAllObjects];
            tmpTransactionId = detail.transactionId;
        }
        [transaction addObject:detail];
    }
    [createView addRows:[SheetElementView createFromTransaction:transaction frame:frame]];
    return createView;
}

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        elementItems = [NSMutableArray array];
        checkboxItems = [NSMutableArray array];
        contentHeight = 0;
    }
    return self;
}

-(void) addRows:(SheetElementView *)view {
    view.frame = CGRectMake([UICheckbox getSize], contentHeight, self.frame.size.width, view.frame.size.height);
    UICheckbox* checkbox = [[UICheckbox alloc] initWithFrame:CGRectMake(0, contentHeight, [UICheckbox getSize], [UICheckbox getSize])];
    contentHeight += view.frame.size.height;
    [elementItems addObject:view];
    [checkboxItems addObject:checkbox];
    [self addSubview:view];
    [self addSubview:checkbox];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + view.frame.size.height);
}

-(NSArray*) getSelected
{
    NSMutableArray* ret = [NSMutableArray array];
    for (int index = 0; index < [checkboxItems count]; index++) {
        UICheckbox* checkbox = [checkboxItems objectAtIndex:index];
        if ( [checkbox isSelected] ) {
            SheetElementView* item = [elementItems objectAtIndex:index];
            [ret addObject:[item getTransactionDetail]];
        }
    }
    return ret;
}
@end
