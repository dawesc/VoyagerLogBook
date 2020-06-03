//
//  NSFetchRequestPicker.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "NSFetchRequestPicker.h"
#import "DetailViewController.h"

@interface NSFetchRequestPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation NSFetchRequestPicker {
  NSFetchRequest*             dataFetchRequestL;
  NSManagedObjectContext*     managedObjectContextL;
  FetchedObjectToString       fetchedObjectToStringL;
  NSMutableArray*             dataArray;
  double                      lastRefresh;
  bool                        isSetup;
}

-(id) initWithStrings:(NSString*)title
     dataFetchRequest:(NSFetchRequest*)dataFetchRequest
 managedObjectContext:(NSManagedObjectContext*)managedObjectContext
fetchedObjectToString:(FetchedObjectToString)fetchedObjectToString
            textField:(UITextField*)textField {
  self = [super initWithFrame:CGRectNull];
  if (self) {
    self.textFieldL         = textField;
    dataFetchRequestL       = dataFetchRequest;
    managedObjectContextL   = managedObjectContext;
    fetchedObjectToStringL  = fetchedObjectToString;
    lastRefresh             = 0;
    dataArray               = [[NSMutableArray alloc] init];
    isSetup                 = false;
    [self setDataSource: self];
    [self setDelegate:   self];
  }
  return self;
}

- (void)checkOk {
  double currentTime = CACurrentMediaTime();
  if (currentTime - lastRefresh < 5) {
    return;
  }
  
  [dataArray removeAllObjects];
  NSError* error = nil;
  NSArray* objects = [managedObjectContextL executeFetchRequest:dataFetchRequestL error:&error];
  if (!objects) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    abort();
  }
  for (id object in objects)
    [dataArray addObject:fetchedObjectToStringL(object)];
  
  if (isSetup)
    return;
  
  isSetup = true;
  if ([self.textFieldL.text length] > 0)
    [self selectRow:[DetailViewController getArrayIndex:0 arrayElems:dataArray toFind:self.textFieldL.text] inComponent:0 animated:NO];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  [self checkOk];
  return 1;
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  [self checkOk];
  return [dataArray count];
}

#pragma UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component API_UNAVAILABLE(tvos) {
  [self checkOk];
  return dataArray[row];
}

- (NSMutableArray*) getData {
  return dataArray;
}

@end
