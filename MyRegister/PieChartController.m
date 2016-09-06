//
//  PieChartController.m
//  MyRegister
//
//  Created by heiwa on 2016/08/14.
//  Copyright © 2016年 heiwa. All rights reserved.
//

#import "PieChartController.h"
#import "TransactionDAO.h"
#import "TransactionDetailEntity.h"

@implementation PieChartController
@synthesize displayTrans;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDateOrNow:0 month:0];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self displaySheet];
}
- (void) displaySheet
{
    TransactionDAO* dao = [[TransactionDAO alloc] init];
    NSArray* transactions = [dao getInout:[self getStartDate] endDate:[self getEndDate]];
    self.displayTrans = [self filterLeft:[self aggrigateTransactions:transactions]];
    
    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame:self.chartView.frame];
    hostView.collapsesLayers = NO;
    self.xyGraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme]; //kCPTPlainWhiteTheme
    [self.xyGraph applyTheme:theme];
    hostView.hostedGraph = self.xyGraph;
    self.xyGraph.axisSet = nil;
    CPTPieChart* pieChart = [[CPTPieChart alloc] init];
    pieChart.pieRadius = 80.0;
    pieChart.dataSource = self;
    pieChart.delegate = self;
    [self.xyGraph addPlot:pieChart];
    [self addLegend];
//    [self.chartView addSubview:hostView];
    [self.view addSubview:hostView];
}
- (void) addLegend
{
    // 凡例インスタンスを生成
    CPTLegend *theLegend = [CPTLegend legendWithPlots:[NSArray arrayWithObject:[self.xyGraph plotAtIndex:0]]];
    // 凡例の列数を指定
    theLegend.numberOfColumns = 3;//([self.displayTrans count] + 1 )/2;
    // 凡例の表示部分の背景色を指定
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    // 凡例の外枠線の表示をする
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    // 凡例の外枠線の角丸の程度
    theLegend.cornerRadius = 5.0;
    
    // 作成した凡例をグラフに追加
    self.xyGraph.legend = theLegend;
    // 凡例の位置をグラフの下側に設定
    // (他にもCPTRectAnchor...で上側や右側などいろいろな場所に配置可能)
    self.xyGraph.legendAnchor = CPTRectAnchorBottom;
    
    // 凡例の位置を調整
    self.xyGraph.legendDisplacement = CGPointMake(20, 30);
}
// グラフの各項目にラベルをつける
-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    TransactionDetailEntity* entity = [self.displayTrans objectAtIndex:index];
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:
                           [NSString stringWithFormat:@"%@", entity.name]];
    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
    
    textStyle.color = [CPTColor lightGrayColor];
    label.textStyle = textStyle;
    return label;
}
// 凡例ための文字列を返す
-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    TransactionDetailEntity* entity = [self.displayTrans objectAtIndex:index];
    return [[NSString alloc] initWithFormat:@"%@", entity.name];
}

//-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
//{
//}
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.displayTrans count];
}
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    TransactionDetailEntity* entity = [self.displayTrans objectAtIndex:idx];
    return [NSNumber numberWithInt:entity.value];
}
- (NSArray*)aggrigateTransactions:(NSArray*)trans
{
    NSMutableDictionary* ret = [NSMutableDictionary dictionary];
    
    for ( TransactionDetailEntity* tran in trans ) {
        TransactionDetailEntity* tmp = [ret objectForKey:tran.name];
        if ( tmp == nil ) {
            [ret setObject:tran forKey:tran.name];
        } else {
            [tmp addTransaction:tran];
        }
    }
    return [ret allValues];
}
- (NSArray*)filterLeft:(NSArray*) trans
{
    NSMutableArray* ret = [NSMutableArray array];
    for ( TransactionDetailEntity* tran in trans ) {
        if ( tran.lORr == 0 ) {
            [ret addObject:tran];
        }
    }
    return ret;
}

- (void) setDateOrNow:(NSInteger)y month:(NSInteger)m {
    if (m <= 0 || y <= 0) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents* comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
        self.year = comp.year;
        self.month = comp.month;
    } else {
        self.year = y;
        self.month = m;
    }
    self.dateLabel.text = [NSString stringWithFormat:@"%04ld年%ld月", self.year, self.month];
}
- (NSString*)getStartDate {
    return [NSString stringWithFormat:@"%04ld-%02ld-01",self.year,self.month];
}
- (NSString*)getEndDate {
    return [NSString stringWithFormat:@"%04ld-%02ld-01",self.year,self.month+1];
}

- (IBAction)tapBefore:(id)sender {
    NSInteger y = self.year;
    NSInteger m = self.month - 1;
    if ( m == 0 ){
        m = 12;
        y -= 1;
    }
    [self setDateOrNow:y month:m];
    [self displaySheet];
}

- (IBAction)tapAfter:(id)sender {
    NSInteger y = self.year;
    NSInteger m = self.month + 1;
    if ( m == 13 ){
        m = 1;
        y += 1;
    }
    [self setDateOrNow:y month:m];
    [self displaySheet];
}

- (IBAction)tapNow:(id)sender {
    [self setDateOrNow:0 month:0];
    [self displaySheet];
}
@end
