//
//  RowView.m
//  MyRegister
//
//  Created by heiwa on 2015/04/06.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "RowView.h"
#import "ColorEntity.h"
#import "ColorDAO.h"

static NSInteger textSize = 20;
static NSInteger marginH = 5;

@implementation RowView
{
    TappableLabel* leftL;
    UILabel* leftY;
    UITextField* leftV;
    TappableLabel* rightL;
    UILabel* rightY;
    UITextField* rightV;
    BOOL textEditable;
}
+ (double) getHeight
{
    return textSize+marginH*2;
}
- (id)initWithFrame:(CGRect)frame editable:(BOOL)editable {
    self = [self initWithFrame:frame];
    if ( self ) {
        textEditable = editable;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, textSize+marginH*2);
//        AttrbuteObject* l = [[AttrbuteObject alloc] initDefault:YES];
//        AttrbuteObject* r = [[AttrbuteObject alloc] initDefault:NO];
        leftL = nil;
        leftY = nil;
        leftV = nil;
        rightL = nil;
        rightY = nil;
        rightV = nil;
        textEditable = YES;
        
        NSInteger w = self.frame.size.width/4;
        leftY = [[UILabel alloc]init];
        leftY.text = @"";
        leftY.font = [UIFont systemFontOfSize:textSize];
        leftY.frame = CGRectMake(w, marginH, textSize/2, textSize+marginH);
        [self addSubview:leftY];
        rightY = [[UILabel alloc]init];
        rightY.text = @"";
        rightY.font = [UIFont systemFontOfSize:textSize];
        rightY.frame = CGRectMake(w*3, marginH, textSize/2, textSize+marginH);
        [self addSubview:rightY];

//        [self setAttr:l right:r];
    }
    return self;
}
/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, UIColor.blackColor.CGColor);
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, self.frame.size.width/2, 0);
    CGContextAddLineToPoint(context, self.frame.size.width/2, self.frame.size.height);
}
 */
-(void) setAttr:(AttrbuteObject *)left right:(AttrbuteObject *)right
{
    [self setAttrLeft:left];
    [self setAttrRight:right];
}
-(void)setAttrLeft:(AttrbuteObject *)attr
{
    NSInteger w = self.frame.size.width/4;
    if(leftL==nil){
        leftL = [[TappableLabel alloc]init];
        [self addSubview:leftL];
    }
    leftL.text = attr.attrName;
    leftL.font = [UIFont systemFontOfSize:textSize];
    leftL.frame = CGRectMake(0, marginH, w, textSize+marginH);
    leftL.delegate = self.delegate;
    if(leftV==nil){
        leftV = [[UITextField alloc]init];
        [self addSubview:leftV];
    }
    leftV.text = [NSString stringWithFormat:@"%ld",attr.value];
    leftV.font = [UIFont systemFontOfSize:textSize];
    leftV.frame = CGRectMake(w+textSize/2, marginH, w-textSize/2, textSize+marginH);
    leftV.keyboardType = UIKeyboardTypeNumberPad;
    leftV.enabled = textEditable;
    leftY.text = @"¥";
    
    ColorDAO* colorDao = [[ColorDAO alloc] init];
    ColorEntity* color = [colorDao getColorByName:attr.attrName];
    UIColor* uiColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:1.0];
    leftL.backgroundColor = uiColor;
    leftY.backgroundColor = uiColor;
    leftV.backgroundColor = uiColor;
}
-(void)setAttrRight:(AttrbuteObject *)attr
{
    NSInteger w = self.frame.size.width/4;
    if(rightL==nil){
        rightL = [[TappableLabel alloc]init];
        [self addSubview:rightL];
    }
    rightL.text = attr.attrName;
    rightL.font = [UIFont systemFontOfSize:textSize];
    rightL.frame = CGRectMake(w*2, marginH, w, textSize+marginH);
    rightL.delegate = self.delegate;
    if(rightV==nil){
        rightV = [[UITextField alloc]init];
        [self addSubview:rightV];
    }
    rightV.text = [NSString stringWithFormat:@"%ld",attr.value];;
    rightV.font = [UIFont systemFontOfSize:textSize];
    rightV.frame = CGRectMake(w*3+textSize/2, marginH, w-textSize/2, textSize+marginH);
    rightV.keyboardType = UIKeyboardTypeNumberPad;
    rightV.enabled = textEditable;
    rightY.text = @"¥";
    
    ColorDAO* colorDao = [[ColorDAO alloc] init];
    ColorEntity* color = [colorDao getColorByName:attr.attrName];
    UIColor* uiColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:1.0];
    rightL.backgroundColor = uiColor;
    rightY.backgroundColor = uiColor;
    rightV.backgroundColor = uiColor;
}
-(AttrbuteObject*)getAttrLeft
{
    if ( [leftL.text isEqualToString:@""] || [leftV.text isEqualToString:@"0"] ) {
        return nil;
    }
    return [[AttrbuteObject alloc] init:@"" value:[leftV.text integerValue] left:YES attrName:leftL.text];
}
-(AttrbuteObject*)getAttrRight
{
    if ( [rightL.text isEqualToString:@""] || [rightV.text isEqualToString:@"0"] ) {
        return nil;
    }
    return [[AttrbuteObject alloc] init:@"" value:[rightV.text integerValue] left:NO attrName:rightL.text];
}
-(void)allResignFirstResponder
{
    if ( leftV.isFirstResponder ) {
        [leftV resignFirstResponder];
    }
    if ( rightV.isFirstResponder ) {
        [rightV resignFirstResponder];
    }
}
@end
