#import <Foundation/Foundation.h>
#import "MLPAutoCompletionObject.h"
#import "Voyager_Log_Book+CoreDataModel.h"

@interface SoulsAutoCompleteObject : NSObject <MLPAutoCompletionObject>

- (id)initWithSoul:(Soul*)soul;
- (Soul*) getSoulInstance;

@end
