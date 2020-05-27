//
//  DetailViewController.h
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Voyager_Log_Book+CoreDataModel.h"

@interface DetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

typedef void (^ ObjectSetter)(NSString*);
typedef void (^ EditorAction)(UITextField*);

@property (strong, nonatomic) IBOutlet UIView *logBookEntryView;
@property (strong, nonatomic) LogBookEntry    *logBookEntry;
@property (strong, nonatomic) Vessel          *vessel;
@property (strong, nonatomic) Soul            *souls;
@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (NSArray*)  windDirections;
+ (NSDate*)   stringToDate:(NSString*) str;
+ (NSString*) dateToString:(NSDate*) date;

-(void) textFieldClicked:(UITextField*)sender;

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

#pragma mark <UITextFieldDelegate, UITextViewDelegate>
- (void)textViewDidEndEditing:(UITextView *)textView;

@end

