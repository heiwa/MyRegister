//
//  PickerViewController.m
//  MyRegister
//
//  Created by heiwa on 2015/05/06.
//  Copyright (c) 2015年 heiwa. All rights reserved.
//

#import "PickerViewController.h"
#import "AttrbuteDAO.h"
#import "AttrbuteEntity.h"

@implementation PickerViewController
{
    AttrbuteDAO* dao;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    dao = [[AttrbuteDAO alloc] init];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray* array = [dao getAllAttrbutes];
    AttrbuteEntity* attr = [array objectAtIndex:row];
    [self.delegate applySelectedString:[NSString stringWithFormat:@"%@", attr.name]];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dao getCount];//db access
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray* array = [dao getAllAttrbutes];
    AttrbuteEntity* attr = [array objectAtIndex:row];
    return [NSString stringWithFormat:@"%@", attr.name];
}
- (IBAction)closeButtonTap:(id)sender
{
    [self.delegate closePickerView:self];
}
@end
