//
//  AppDelegate.h
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreData/CoreData.h>

typedef void (^ LocationCallback)(CLLocation*);
typedef void (^ BarometricCallback)(CMAltitudeData*);

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
    NSMutableArray<LocationCallback>* lCallbacks;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager *)manager
didFailWithError:(NSError *)error;

@property (readonly, strong) NSPersistentCloudKitContainer *persistentContainer;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CMAltimeter *altimiter;

- (void)saveContext;
- (void)getLocation:(LocationCallback)callback;
- (void)getPressure:(BarometricCallback)callback;
+ (NSString *)nicePosition:(CLLocation*)location;

@end

