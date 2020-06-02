//
//  SoulMasterViewController.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "SoulMasterViewController.h"
#import "DetailViewController.h"

@interface SoulMasterViewController ()

@end

@implementation SoulMasterViewController

- (void)viewDidLoad {
  PrepareForSequeCallback prepareForSegue = ^void(DetailViewController *controller,
                                                  NSFetchedResultsController* fetchedResultsController,
                                                  NSIndexPath* indexPath) {
    Soul* object = (Soul*) [self.fetchedResultsController objectAtIndexPath:indexPath];
    controller.souls = object;
  };
  ConfigureCell configureCellCallback = ^(UITableViewCell* cell, NSObject* eventO) {
    Soul* event = (Soul*) eventO;
    NSString* forename = [GenericDataViewController getStringOrEmpty:event.forename defaultValue:@"Unknown"];
    NSString* surname  = [GenericDataViewController getStringOrEmpty:event.surname defaultValue:@"Unknown"];
    cell.textLabel.text = [[forename stringByAppendingString:@" "] stringByAppendingString:surname];
  };
  [super setupWithoutAddButton:@"SoulMaster"
       prepareForSegueCallback:prepareForSegue
         configureCellCallback:configureCellCallback
               getFetchRequest:^NSFetchRequest   *{ return Soul.fetchRequest; }
             getSortDescriptor:^NSSortDescriptor *{ return [[NSSortDescriptor alloc] initWithKey:@"surname" ascending:YES]; }];
  [super viewDidLoad];
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewSoul:)];
  self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.editButtonItem, addButton,nil];
}

- (void)insertNewSoul:(id)sender {
  NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
  (void) [[Soul alloc] initWithContext:context];
  
  [self saveContext:context];
}

@end
