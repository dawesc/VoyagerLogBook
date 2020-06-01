//
//  SoulsAutoCompleteObject.m
//  MLPAutoCompleteDemo
//
//  Created by Eddy Borja on 4/19/13.
//  Copyright (c) 2013 Mainloop. All rights reserved.
//

#import "SoulsAutoCompleteObject.h"
#import "SoulsAutoCompleteDataSource.h"

@interface SoulsAutoCompleteObject ()
@property (strong) Soul* soul;
@end

@implementation SoulsAutoCompleteObject


- (id)initWithSoul:(Soul*)soul {
    self = [super init];
    if (self) {
        [self setSoul:soul];
    }
    return self;
}

- (Soul*) getSoulInstance {
  return self.soul;
}
#pragma mark - MLPAutoCompletionObject Protocl

- (NSString *)autocompleteString {
    return [SoulsAutoCompleteDataSource soulToName:self.soul];
}

@end
