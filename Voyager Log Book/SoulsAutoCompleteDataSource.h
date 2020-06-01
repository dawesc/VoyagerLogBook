
#import <Foundation/Foundation.h>
#import <MLPAutoCompleteTextField/MLPAutoCompleteTextFieldDataSource.h>
#import "Voyager_Log_Book+CoreDataModel.h"

struct NameParts {
  NSString* forename;
  NSString* initials;
  NSString* surname;
};

@interface SoulsAutoCompleteDataSource : NSObject <MLPAutoCompleteTextFieldDataSource>

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
      possibleCompletionsForString:(NSString *)string
                 completionHandler:(void(^)(NSArray *suggestions))handler;

+(struct NameParts) stringToNameParts:(NSArray<NSString*>*)parts;
+(struct NameParts) stringToNameString:(NSString*) string;
+(NSString*) appendStr:(NSString*) retval with:(NSString*) with;
+(NSString*) soulToName:(Soul*) soul;

+(NSArray<Soul*>*) findSouls:(NSManagedObjectContext*) managedObjectContext string:(NSString*)string;

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end
