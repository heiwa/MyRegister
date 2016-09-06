//
//  PieChartController.h
//  MyRegister
//
//  Created by heiwa on 2016/08/14.
//  Copyright © 2016年 heiwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface PieChartController : UIViewController<CPTPieChartDataSource, CPTPieChartDataSource>
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(nonatomic, strong) CPTXYGraph *xyGraph;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSArray* displayTrans;
- (IBAction)tapBefore:(id)sender;
- (IBAction)tapAfter:(id)sender;
- (IBAction)tapNow:(id)sender;

@end
