//
//  AppDelegate.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (instancetype)init {
    if (self = [super init]) {
        lCallbacks = [[NSMutableArray<LocationCallback> alloc] init];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    self.altimiter = [[CMAltimeter alloc] init];
    
    return YES;
}

#pragma mark - Location Manager methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location;
    location = [[CLLocation alloc] init];
    location = locations.lastObject;
    NSLog(@"%@", location.description);
    @synchronized (lCallbacks) {
        for (LocationCallback callback in lCallbacks) {
            callback(location);
        }
        [lCallbacks removeAllObjects];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError: (NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)getLocation:(LocationCallback)callback {
    @synchronized (lCallbacks) {
        [(lCallbacks) addObject:callback];
    }
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestLocation];
}

- (void)getPressure:(BarometricCallback)callback {
    if (![CMAltimeter isRelativeAltitudeAvailable]) {
        callback(nil);
        return;
    }
    
    // start altitude tracking
    [self.altimiter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
        
        callback(altitudeData);
        [self.altimiter stopRelativeAltitudeUpdates];
    }];
    
}

+ (NSString *)nicePosition:(CLLocation*) location {
    double latitude  = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;

    int latSeconds = (int)round(fabs(latitude * 3600));
    int latDegrees = latSeconds / 3600;
    latSeconds = latSeconds % 3600;
    int latMinutes = latSeconds / 60;
    latSeconds %= 60;

    int longSeconds = (int)round(fabs(longitude * 3600));
    int longDegrees = longSeconds / 3600;
    longSeconds = longSeconds % 3600;
    int longMinutes = longSeconds / 60;
    longSeconds %= 60;

    char latDirection = (latitude >= 0) ? 'N' : 'S';
    char longDirection = (longitude >= 0) ? 'E' : 'W';

    return [NSString stringWithFormat:@"%i° %i' %i\" %c, %i° %i' %i\" %c", latDegrees, latMinutes, latSeconds, latDirection, longDegrees, longMinutes, longSeconds, longDirection];
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentCloudKitContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentCloudKitContainer alloc] initWithName:@"Voyager_Log_Book"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
