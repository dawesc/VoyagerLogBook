//
//  GenericDataViewController.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "GenericDataViewController.h"
#import "DetailViewController.h"

@interface GenericDataViewController ()

@end

@implementation GenericDataViewController {
  bool addButtonS;
  NSString* cacheNameS;
  ActionCallback addCallbackS;
  PrepareForSequeCallback prepareForSegueCallbackS;
  ConfigureCell       configureCellCallbackS;
  GetFetchRequest     getFetchRequestS;
  GetSortDescriptor   getSortDescriptorS;
}

- (void)
       setupWithAddButton:(NSString*)cacheName
              addCallback:(ActionCallback)addCallback
  prepareForSegueCallback:(PrepareForSequeCallback)prepareForSegueCallback
    configureCellCallback:(ConfigureCell)configureCellCallback
          getFetchRequest:(GetFetchRequest)getFetchRequest
        getSortDescriptor:(GetSortDescriptor)getSortDescriptor {
  cacheNameS                = cacheName;
  addButtonS                = true;
  addCallbackS              = addCallback;
  prepareForSegueCallbackS  = prepareForSegueCallback;
  configureCellCallbackS    = configureCellCallback;
  getFetchRequestS          = getFetchRequest;
  getSortDescriptorS        = getSortDescriptor;
}

- (void)
    setupWithoutAddButton:(NSString*)cacheName
  prepareForSegueCallback:(PrepareForSequeCallback)prepareForSegueCallback
    configureCellCallback:(ConfigureCell)configureCellCallback
          getFetchRequest:(GetFetchRequest)getFetchRequest
        getSortDescriptor:(GetSortDescriptor)getSortDescriptor {
  cacheNameS                = cacheName;
  addButtonS                = false;
  prepareForSegueCallbackS  = prepareForSegueCallback;
  configureCellCallbackS    = configureCellCallback;
  getFetchRequestS          = getFetchRequest;
  getSortDescriptorS        = getSortDescriptor;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  if (addButtonS) {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onInsert:)];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:addButton,nil];
  }
  self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)saveContext:(NSManagedObjectContext*) context {
  // Save the context.
  NSError *error = nil;
  if (![context save:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    abort();
  }
}

- (void)onInsert:(id)sender {
  if (addButtonS) {
    addCallbackS();
  }
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"showDetail"]) {
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath == nil) {
      [self.tableView selectRowAtIndexPath:0 animated:false scrollPosition:UITableViewScrollPositionNone];
      indexPath = [self.tableView indexPathForSelectedRow];
    }
    DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
    self.detailViewController = controller;


    controller.fetchedResultsController = self.fetchedResultsController;
    controller.managedObjectContext = self.managedObjectContext;
    controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    controller.navigationItem.leftItemsSupplementBackButton = YES;
    
    prepareForSegueCallbackS(controller, [self fetchedResultsController], indexPath);
  }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    id event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    configureCellCallbackS(cell, event);
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSManagedObjectContext *context = self.fetchedResultsController.managedObjectContext;
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];

    NSError *error = nil;
    if (![context save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, error.userInfo);
      abort();
    }
  }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController*)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest* fetchRequest = getFetchRequestS();

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = getSortDescriptorS();

    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController* aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:cacheNameS];
    aFetchedResultsController.delegate = self;

    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }

    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            configureCellCallbackS([tableView cellForRowAtIndexPath:indexPath], anObject);
            break;

        case NSFetchedResultsChangeMove:
            configureCellCallbackS([tableView cellForRowAtIndexPath:indexPath], anObject);
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.

 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

+ (NSString*) getStringOrEmpty:(NSString *) data defaultValue:(NSString *) defaultValue {
  if (data && [data length] > 0)
    return data.description;
  else
    return defaultValue;
}

+ (NSString*) getStringOrEmptyD:(NSDate *) data defaultValue:(NSString *) defaultValue {
  if (data)
    return [DetailViewController dateToString:data];
  else
    return defaultValue;
}

@end
