//
//  PickerToolbar.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "PickerToolbar.h"
#import "ArrayPicker.h"
#import "NSFetchRequestPicker.h"
#import "DetailViewController.h"

@interface PickerToolbar ()

@end

@implementation PickerToolbar {
  ArrayPicker*            arrayPicker;
  NSFetchRequestPicker*   fetchPicker;
  UIDatePicker*           datePicker;
}

-(id) initWithTextField:(UITextField*)textField
                 picker:(id)picker
                  title:(NSString*)title {
  self = [super initWithFrame:CGRectNull];
  if (self) {
    arrayPicker = nil;
    fetchPicker = nil;
    datePicker  = nil;
    if ([picker isKindOfClass:[ArrayPicker class]]) {
      arrayPicker = (ArrayPicker*) picker;
    } else if ([picker isKindOfClass:[NSFetchRequestPicker class]]) {
      fetchPicker = (NSFetchRequestPicker*) picker;
    } else if ([picker isKindOfClass:[UIDatePicker class]]) {
      datePicker = (UIDatePicker*) picker;
    }
    self.textFieldL = textField;
    [self setBarStyle:UIBarStyleDefault];
    [self setTranslucent:true];
    //[self setTintColor:[[UIColor alloc] initWithRed:76.0f/255.0f green: 217.0f/255.0f blue: 100.0f/255.0f alpha: 1.0f]];
    [self sizeToFit];

    UIBarButtonItem* doneButton     = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneButtonPressed)];
    UIBarButtonItem* spacer1        = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* spaceButton    = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem* spacer2        = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* cancelButton   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancel)];
    spaceButton.enabled = false;
    
    [self setItems:[NSArray arrayWithObjects:cancelButton, spacer1, spaceButton, spacer2, doneButton,nil] animated: false];
    [self setUserInteractionEnabled:true];
  }
  return self;
}

- (void)pickerCancel {
  [self.textFieldL resignFirstResponder];
}

-(void) pickerDoneButtonPressed {
  [self.textFieldL resignFirstResponder];

  if (arrayPicker) {
    NSInteger row = [arrayPicker selectedRowInComponent:0];
    if (row < [arrayPicker.dataArray count])
      self.textFieldL.text = [arrayPicker.dataArray objectAtIndex:row];
  } else if (fetchPicker) {
    NSArray* rows = [fetchPicker getData];
    NSInteger row = [fetchPicker selectedRowInComponent:0];
    if (row < [rows count])
      self.textFieldL.text = [rows objectAtIndex:row];
  } else if (datePicker) {
    self.textFieldL.text = [DetailViewController dateToString:datePicker.date];
  }
}

@end
