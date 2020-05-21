//
//  AppDelegate.h
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>

typedef void (^ LocationCallback)(CLLocation*);

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
    NSMutableArray<LocationCallback>* callbacks;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager *)manager
didFailWithError:(NSError *)error;

@property (readonly, strong) NSPersistentCloudKitContainer *persistentContainer;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)saveContext;
- (void)getLocation:(LocationCallback)callback;
+ (NSString *)nicePosition:(CLLocation*)location;

@end

