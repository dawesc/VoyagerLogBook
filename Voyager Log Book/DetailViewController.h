//
//  DetailViewController.h
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoulsAutoCompleteObject.h"
#import "Voyager_Log_Book+CoreDataModel.h"
#import <TagListView-Swift.h>

@interface DetailViewController :
UIViewController<UITextFieldDelegate, TagListViewDelegate>

typedef void (^ ObjectSetter)(NSString*);

@property (weak, nonatomic) IBOutlet UIView   *logBookEntryView;
@property (strong, nonatomic) LogBookEntry    *logBookEntry;
@property (strong, nonatomic) Vessel          *vessel;
@property (strong, nonatomic) Soul            *souls;
@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext*     managedObjectContext;

+ (NSArray*)  windDirections;
+ (NSDate*)   stringToDate:(NSString*) str;
+ (NSString*) dateToString:(NSDate*) date;
+ (int)getArrayIndex:(int) defaultVal arrayElems:(NSArray*)arrayElems toFind:(NSString*) toFind;

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

#pragma mark MLPAutoCompleteTextFieldDelegate
- (void)autoCompleteTextField:(UITextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(SoulsAutoCompleteObject*)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark TagListViewDelegate
- (void)tagPressed:(NSString * _Nonnull)title tagView:(TagView * _Nonnull)tagView sender:(TagListView * _Nonnull)sender;
- (void)tagRemoveButtonPressed:(NSString * _Nonnull)title tagView:(TagView * _Nonnull)tagView sender:(TagListView * _Nonnull)sender;

@end

