
#import <Foundation/Foundation.h>
#import <HTAutocompleteTextField.h>
#import <UIKit/UIKit.h>
#import "Voyager_Log_Book+CoreDataModel.h"

struct NameParts {
  NSString* forename;
  NSString* initials;
  NSString* surname;
};

@interface SoulsAutoCompleteDataSource : NSObject<HTAutocompleteDataSource>

- (NSString*)textField:(HTAutocompleteTextField*)textField
   completionForPrefix:(NSString*)prefix
            ignoreCase:(BOOL)ignoreCase;

+(struct NameParts) stringToNameParts:(NSArray<NSString*>*)parts;
+(struct NameParts) stringToNameString:(NSString*) string;
+(NSString*) appendStr:(NSString*) retval with:(NSString*) with;
+(NSString*) soulToName:(Soul*) soul;

+(NSArray<Soul*>*) findSouls:(NSManagedObjectContext*) managedObjectContext string:(NSString*)string;

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end
