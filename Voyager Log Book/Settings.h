//
//  Settings.h
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const SettingsKeyFilterVessels;
FOUNDATION_EXPORT NSString *const SettingsKeyFilterSouls;
FOUNDATION_EXPORT NSString *const SettingsKeyFilterLogBookEntries;

@interface Settings : NSObject

+ (void)registerDefaults;
- (bool)isProp:(NSString*) propKey;

- (bool)isFilterVessels;
- (bool)isFilterSouls;
- (bool)isFilterLogBookEntries;

- (void)setProp:(NSString*) propKey newValue:(bool) newValue;

- (void)setFilterVessels:(bool) newValue;
- (void)setFilterSouls:(bool) newValue;
- (void)setFilterLogBookEntries:(bool) newValue;

@end

