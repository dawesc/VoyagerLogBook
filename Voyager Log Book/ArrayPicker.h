//
//  ArrayPicker.h
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArrayPicker : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource> {
  NSMutableArray *dataArray;
}

@property (nonatomic, retain) NSMutableArray<NSString*>* dataArray;

-(id) initWithStrings:(NSString*)title rows:(NSArray<NSString*>*)rows initialSelection:(NSInteger)initialSelection;

#pragma UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

#pragma UIPickerViewDelegate
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component API_UNAVAILABLE(tvos);

@end

