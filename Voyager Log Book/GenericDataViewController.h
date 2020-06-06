//
//  GenericDataViewController.h
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Voyager_Log_Book+CoreDataModel.h"

@class DetailViewController;

/*PrepareForSequeCallback
 LogBookEntry *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
 controller.detailItem = object;
 */
typedef void (^ActionCallback)(void);
typedef void (^PrepareForSequeCallback)(DetailViewController *controller,
                                        NSFetchedResultsController* fetchedResultsController,
                                        NSIndexPath* indexPath);
typedef void (^ConfigureCell)(UITableViewCell* cell, NSObject* event);
typedef NSFetchRequest* (^GetFetchRequest)(void); //e.g. LogBookEntry.fetchRequest
typedef NSSortDescriptor* (^GetSortDescriptor)(void); //e.g. [[NSSortDescriptor alloc] initWithKey:@"dateOfDeparture" ascending:NO];
  
@interface GenericDataViewController : UITableViewController <NSFetchedResultsControllerDelegate>

-(void)setupWithAddButton:(NSString*)cacheName
            addCallback:(ActionCallback)addCallback
prepareForSegueCallback:(PrepareForSequeCallback)prepareForSegueCallback
  configureCellCallback:(ConfigureCell)configureCellCallback
        getFetchRequest:(GetFetchRequest)getFetchRequest
      getSortDescriptor:(GetSortDescriptor)getSortDescriptor;

-(void)setupWithoutAddButton:(NSString*)cacheName
prepareForSegueCallback:(PrepareForSequeCallback)prepareForSegueCallback
  configureCellCallback:(ConfigureCell)configureCellCallback
        getFetchRequest:(GetFetchRequest)getFetchRequest
      getSortDescriptor:(GetSortDescriptor)getSortDescriptor;

- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)saveContext:(NSManagedObjectContext*) context;
- (void)onInsert:(id)sender;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Fetched results controller

- (NSFetchedResultsController<LogBookEntry *> *)fetchedResultsController;
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller;
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath;

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller;


+ (NSString*) getStringOrEmpty:(NSString *) data defaultValue:(NSString *) defaultValue;
+ (NSString*) getStringOrEmptyD:(NSDate *) data defaultValue:(NSString *) defaultValue;

@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) DetailViewController *detailViewController;

@end
