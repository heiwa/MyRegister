//
//  SheetElementView.m
//  MyRegister
//
//  Created by heiwa on 2015/04/09.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "SheetElementView.h"
#import "RowView.h"

@implementation SheetElementView

+(id)createFromTransaction:(NSArray *)transaction frame:(CGRect)frame {
    SheetElementView* createView = [[SheetElementView alloc] initWithFrame:frame editable:NO];
    for (TransactionDetailEntity* detail in transaction) {
        [createView addRow:detail];
    }
    return createView;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        rows = 0;
        rowsR = 0;
        rowsL = 0;
        textEditable = YES;
        rowViews = [NSMutableArray array];
        self.frame = CGRectMake(0, 0, frame.size.width, 0);
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame editable:(BOOL)editable {
    self = [self initWithFrame:frame];
    textEditable = editable;
    return self;
}
-(void)setInitAttr
{
    RowView* r = [[RowView alloc] initWithFrame:CGRectMake(0, rows*[RowView getHeight], self.frame.size.width, [RowView getHeight]) editable:textEditable];
    r.delegate = self;
    [r setAttr:[[AttrbuteObject alloc] initDefault:YES] right:[[AttrbuteObject alloc] initDefault:NO]];
    rows = 1;
    rowsL = 1;
    rowsR = 1;
    [rowViews addObject:r];
    [self addSubview:r];
    self.frame = CGRectMake(0, 0, self.frame.size.width, [RowView getHeight]);
}
-(id)initWithFrameAndAttr:(CGRect)frame left:(AttrbuteObject*)left right:(AttrbuteObject*)right
{
    self = [super initWithFrame:frame];
    if(self){
        rows = 0;
        rowViews = [NSMutableArray array];
        RowView* r = [[RowView alloc] initWithFrame:CGRectMake(0, rows*[RowView getHeight], frame.size.width, [RowView getHeight]) editable:textEditable];
        r.delegate = self;
        [r setAttr:left right:right];
        rows = 1;
        rowsL = 1;
        rowsR = 1;
        [rowViews addObject:r];
        [self addSubview:r];
        self.frame = CGRectMake(0, 0, frame.size.width, [RowView getHeight]);
    }

    return self;
}
-(void)addRow:(AttrbuteObject *)left right:(AttrbuteObject *)right
{
    if(left==nil && right==nil){
        return;
    }else if (left==nil){
        if(rowsL > rowsR){
            RowView* tmp = [rowViews objectAtIndex:rowsR];
            [tmp setAttrRight:right];
            rowsR++;
        }else{
            RowView* r = [[RowView alloc] initWithFrame:CGRectMake(0, rows*[RowView getHeight], self.frame.size.width, [RowView getHeight])];
            r.delegate = self;
            [r setAttrRight:right];
            rows++;
            rowsR++;
            [rowViews addObject:r];
            [self addSubview:r];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, rows*[RowView getHeight]);

        }
    }else if (right==nil){
        if(rowsL < rowsR){
            RowView* tmp = [rowViews objectAtIndex:rowsL];
            [tmp setAttrLeft:left];
            rowsL++;
        }else{
            RowView* r = [[RowView alloc] initWithFrame:CGRectMake(0, rows*[RowView getHeight], self.frame.size.width, [RowView getHeight])];
            r.delegate = self;
            [r setAttrLeft:left];
            rows++;
            rowsL++;
            [rowViews addObject:r];
            [self addSubview:r];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, rows*[RowView getHeight]);

        }
    }else{
        RowView* r = [[RowView alloc] initWithFrame:CGRectMake(0, rows*[RowView getHeight], self.frame.size.width, [RowView getHeight]) editable:textEditable];
        r.delegate = self;
        if(rowsL == rowsR){
            [r setAttr:left right:right];
        }else if(rowsL < rowsR){
            RowView* tmp = [rowViews objectAtIndex:rowsL];
            [tmp setAttrLeft:left];
            [r setAttrRight:right];
        }else{
            RowView* tmp = [rowViews objectAtIndex:rowsR];
            [tmp setAttrRight:right];
            [r setAttrLeft:left];
        }
        rows++;
        rowsL++;
        rowsR++;
        [rowViews addObject:r];
        [self addSubview:r];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, rows*[RowView getHeight]);
    }
}
-(void) addRow:(TransactionDetailEntity *)detail {
    AttrbuteObject* attr = [[AttrbuteObject alloc] initWithEntity:detail];
    if (attr.left) {
        [self addRow:attr right:nil];
    } else {
        [self addRow:nil right:attr];
    }
    transSample = detail;
}
-(void)onTapEvent:(TappableLabel *)uil
{
    editing = uil;
    [self.delegate openPickerView];
}
-(void)editText:(NSString *)str
{
    editing.text = str;
}
-(void)textFieldsResignFirstResponder
{
    for ( RowView* rowView in rowViews ) {
        [rowView allResignFirstResponder];
    }
}
-(NSArray*)getRowViews
{
    return rowViews;
}
-(BOOL)isBalance
{
    int leftValue = 0;
    int rightValue = 0;
    for ( RowView* row in rowViews ) {
        leftValue += [row getAttrLeft].value;
        rightValue += [row getAttrRight].value;
    }
    return leftValue == rightValue;
}
-(TransactionDetailEntity*) getTransactionDetail
{
    return transSample;
}
@end
