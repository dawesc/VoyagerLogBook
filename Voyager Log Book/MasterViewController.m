//
//  MasterViewController.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "SoulMasterViewController.h"
#import "VesselMasterViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
  PrepareForSequeCallback prepareForSegue = ^void(DetailViewController *controller,
                                                  NSFetchedResultsController* fetchedResultsController,
                                                  NSIndexPath* indexPath) {
    LogBookEntry *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    controller.logBookEntry = object;
  };
  ConfigureCell configureCellCallback = ^(UITableViewCell* cell, NSObject* eventO) {
    LogBookEntry* event = (LogBookEntry*) eventO;
    NSString* portOfDeparture = [GenericDataViewController getStringOrEmpty:event.destination defaultValue:@"Unknown Destination"];
    NSString* dateOfDeparture = [GenericDataViewController getStringOrEmptyD:event.dateOfDeparture defaultValue:@"Unknown Date"];
    cell.textLabel.text = [[portOfDeparture stringByAppendingString:@" "] stringByAppendingString:dateOfDeparture];
  };
  [super setupWithoutAddButton:@"LogBookEntryMaster"
       prepareForSegueCallback:prepareForSegue configureCellCallback:configureCellCallback
               getFetchRequest:^NSFetchRequest   *{ return LogBookEntry.fetchRequest; }
             getSortDescriptor:^NSSortDescriptor *{ return [[NSSortDescriptor alloc] initWithKey:@"dateOfDeparture" ascending:NO]; }];
  [super viewDidLoad];
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
  // Do any additional setup after loading the view.
  id fontAwesome = [UIFont fontWithName:@"FontAwesome5Free-Solid" size:24];
  NSDictionary *fontDictionary = @{NSFontAttributeName : fontAwesome};
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewLogBookEntry:)];
  
  UIBarButtonItem *soulBarButton = [[UIBarButtonItem alloc] initWithTitle:@"\uf0c0" style:UIBarButtonItemStylePlain target:self action:@selector(showSouls:)];
  [soulBarButton   setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
  [soulBarButton   setTitleTextAttributes:fontDictionary forState:UIControlStateHighlighted];
  [soulBarButton   setTitleTextAttributes:fontDictionary forState:UIControlStateFocused];
  
  UIBarButtonItem *vesselBarButton = [[UIBarButtonItem alloc] initWithTitle:@"\uf21a" style:UIBarButtonItemStylePlain target:self action:@selector(showVessels:)];
  [vesselBarButton setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
  [vesselBarButton setTitleTextAttributes:fontDictionary forState:UIControlStateHighlighted];
  [vesselBarButton setTitleTextAttributes:fontDictionary forState:UIControlStateFocused];
  
  self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:soulBarButton, vesselBarButton, addButton,nil];
}

- (void)showSouls:(id)sender {
  [self performSegueWithIdentifier:@"soulsSetup" sender:self];
}

- (void)showVessels:(id)sender {
  [self performSegueWithIdentifier:@"vesselsSetup" sender:self];
}

- (void)insertNewLogBookEntry:(id)sender {
  NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
  LogBookEntry *newEvent = [[LogBookEntry alloc] initWithContext:context];
      
  // If appropriate, configure the new managed object.
  newEvent.dateOfDeparture = [NSDate now];
  AppDelegate* appDelegate = (AppDelegate*) UIApplication.sharedApplication.delegate;
  void (^ myLocationCallback)(CLLocation*) = ^(CLLocation* newLocation) {
    if (newLocation && !newEvent.portOfDeparture) {
      newEvent.portOfDeparture = [AppDelegate nicePosition:newLocation];
      [self saveContext:context];
    }
  };
  void (^ myPressureCallback)(CMAltitudeData*) = ^(CMAltitudeData* newPressure) {
    if (newPressure && !newEvent.barometer) {
      NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
      formatter.maximumFractionDigits = 2;
      formatter.minimumIntegerDigits = 1;
      
      newEvent.barometer = [NSString stringWithFormat:@"%.2f hPA", newPressure.pressure.floatValue*10];
      [self saveContext:context];
    }
  };
  
  [appDelegate getLocation:myLocationCallback];
  [appDelegate getPressure:myPressureCallback];
  
  NSFetchRequest<Vessel *>* currentDefaultFetchRequest = Vessel.fetchRequest;
  [currentDefaultFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"defaultVessel == %@", [NSNumber numberWithBool: YES]]];
  
  NSError* error = nil;
  NSArray* results = [context executeFetchRequest:currentDefaultFetchRequest error:&error];
  if (results) {
    for (Vessel* vessel in results) {
      newEvent.vessel = vessel;
    }
  }
  
  [self saveContext:context];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [super prepareForSegue:segue sender:sender];
  
  if ([[segue identifier] isEqualToString:@"soulsSetup"]) {
    SoulMasterViewController *controller = (SoulMasterViewController *)[segue destinationViewController];
    controller.managedObjectContext = self.managedObjectContext;
  } else if ([[segue identifier] isEqualToString:@"vesselsSetup"]) {
    VesselMasterViewController *controller = (VesselMasterViewController *)[segue destinationViewController];
    controller.managedObjectContext = self.managedObjectContext;
  }
}

@end
