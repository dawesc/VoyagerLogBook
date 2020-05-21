//
//  DetailViewController.h
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Voyager_Log_Book+CoreDataModel.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) LogBookEntry *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

