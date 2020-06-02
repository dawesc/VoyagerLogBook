//
//  ArrayPicker.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "ArrayPicker.h"

@interface ArrayPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation ArrayPicker

@synthesize dataArray;

-(id) initWithStrings:(NSString*)title rows:(NSArray<NSString*>*)rows initialSelection:(NSInteger)initialSelection {
  self = [super initWithFrame:CGRectNull];
  if (self) {
    dataArray = [[NSMutableArray alloc] initWithArray:rows];
    [self setDataSource: self];
    [self setDelegate:   self];
    [self selectRow:initialSelection inComponent:0 animated:NO];
  }
  return self;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  return 1;
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [self.dataArray count];
}

#pragma UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component API_UNAVAILABLE(tvos) {
  return self.dataArray[row];
}

@end
