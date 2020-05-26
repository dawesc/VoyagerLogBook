//
//  VesselMasterViewController.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "VesselMasterViewController.h"
#import "DetailViewController.h"
#import "ActionSheetPicker.h"

@interface VesselMasterViewController ()

@end

@implementation VesselMasterViewController

- (void)viewDidLoad {
  PrepareForSequeCallback prepareForSegue = ^void(DetailViewController *controller,
                                                  NSFetchedResultsController* fetchedResultsController,
                                                  NSIndexPath* indexPath) {
    Vessel* object = (Vessel*) [self.fetchedResultsController objectAtIndexPath:indexPath];
    controller.vessel = object;
  };
  ConfigureCell configureCellCallback = ^(UITableViewCell* cell, NSObject* eventO) {
    Vessel* event = (Vessel*) eventO;
    cell.textLabel.text = [GenericDataViewController getStringOrEmpty:event.name defaultValue:@"Unknown Vessel"];
  };
  [super setupWithoutAddButton:@"VesselMaster"
       prepareForSegueCallback:prepareForSegue
         configureCellCallback:configureCellCallback
               getFetchRequest:^NSFetchRequest   *{ return Vessel.fetchRequest; }
             getSortDescriptor:^NSSortDescriptor *{ return [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO]; }];
  [super viewDidLoad];
    
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewVessel:)];
  self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.editButtonItem, addButton,nil];
}

- (void)insertNewVessel:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    (void)[[Vessel alloc] initWithContext:context];

    [self saveContext:context];
}

@end
