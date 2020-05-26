//
//  Settings.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "Settings.h"

// Constants.m
NSString *const SettingsKeyFilterVessels = @"filterVessels";
NSString *const SettingsKeyFilterSouls = @"filterSouls";
NSString *const SettingsKeyFilterLogBookEntries = @"filterLogBookEntries";

@interface Settings ()

@end

@implementation Settings

+ (void)registerDefaults {
  NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @YES, SettingsKeyFilterVessels,
                                  @NO,  SettingsKeyFilterSouls,
                                  @YES, SettingsKeyFilterLogBookEntries,
                               nil];
  [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

- (bool)isProp:(NSString*) propKey {
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  bool propVal = [prefs boolForKey:propKey];
  return propVal;
}

- (bool)isFilterVessels {
  return [self isProp:SettingsKeyFilterVessels];
}

- (bool)isFilterSouls {
  return [self isProp:SettingsKeyFilterSouls];
}

- (bool)isFilterLogBookEntries {
  return [self isProp:SettingsKeyFilterLogBookEntries];
}

- (void)setProp:(NSString*) propKey newValue:(bool) newValue {
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs setBool:newValue forKey:propKey];
}

- (void)setFilterVessels:(bool) newValue {
  [self setProp:SettingsKeyFilterVessels newValue:newValue];
}
- (void)setFilterSouls:(bool) newValue {
  [self setProp:SettingsKeyFilterSouls newValue:newValue];
}
- (void)setFilterLogBookEntries:(bool) newValue {
  [self setProp:SettingsKeyFilterLogBookEntries newValue:newValue];
}
@end
