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

-(id) initWithAddButton:(ActionCallback)addCallback
prepareForSegueCallback:(PrepareForSequeCallback)prepareForSegueCallback
  configureCellCallback:(ConfigureCell)configureCellCallback
        getFetchRequest:(GetFetchRequest)getFetchRequest
      getSortDescriptor:(GetSortDescriptor)getSortDescriptor;

@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
