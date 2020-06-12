//
//  NSFetchRequestPicker.h
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Voyager_Log_Book+CoreDataModel.h"

typedef NSString* (^FetchedObjectToString)(id object);

@interface NSFetchRequestPicker : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) UITextField* textFieldL;

-(id) initWithStrings:(NSString*)title
     dataFetchRequest:(NSFetchRequest*)dataFetchRequest
 managedObjectContext:(NSManagedObjectContext*)managedObjectContext
fetchedObjectToString:(FetchedObjectToString)fetchedObjectToString
            textField:(UITextField*)textField;

#pragma UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

#pragma UIPickerViewDelegate
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component API_UNAVAILABLE(tvos);

- (NSMutableArray*) getData;
- (NSMutableArray*) getRawData;
@end

