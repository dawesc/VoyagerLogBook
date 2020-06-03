#import <Foundation/Foundation.h>
#import "Voyager_Log_Book+CoreDataModel.h"

@interface SoulsAutoCompleteObject : NSObject

- (id)initWithSoul:(Soul*)soul;
- (Soul*) getSoulInstance;

@end
