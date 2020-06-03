
#import "SoulsAutoCompleteDataSource.h"
#import "SoulsAutoCompleteObject.h"

@interface SoulsAutoCompleteDataSource ()

@property (strong, nonatomic) NSArray *soulObjects;

@end


@implementation SoulsAutoCompleteDataSource

+(NSString*) appendStr:(NSString*) retval with:(NSString*) with {
  if (!with) return retval;
  if (!retval) return with;
  return [[retval stringByAppendingString:@" "]  stringByAppendingString:with];
}

+(NSString*) soulToName:(Soul*) soul {
  NSString* forename = soul.forename;
  NSString* initials = soul.initials;
  NSString* surname  = soul.surname;
  if (forename && [forename length] == 0) forename = nil;
  if (initials && [initials length] == 0) initials = nil;
  if (surname &&  [surname length] == 0)  surname = nil;
  if (forename == nil && initials == nil && surname == nil) return nil;
  NSString* retval = forename;
  retval = [SoulsAutoCompleteDataSource appendStr:retval with:initials];
  retval = [SoulsAutoCompleteDataSource appendStr:retval with:surname];
  return retval;
}

+(NSArray<NSString*>*) SplitSpace:(NSString*) toSplit {
  NSArray<NSString*>* split = [toSplit componentsSeparatedByString:@" "];
  NSMutableArray<NSString*>* retval = [[NSMutableArray<NSString*> alloc] init];
  for (NSString* str in split)
    if ([str length] > 0) [retval addObject:str];
  return retval;
}

#pragma mark - MLPAutoCompleteTextField DataSource

+(struct NameParts) stringToNameParts:(NSArray<NSString*>*)stringParts {
  struct NameParts retval;
  retval.forename = @"";
  retval.initials = @"";
  retval.surname  = @"";
  if ([stringParts count] == 1) {
    retval.forename = stringParts[0];
  } else if ([stringParts count] == 2) {
    retval.forename = stringParts[0];
    retval.surname  = stringParts[1];
  } else if ([stringParts count] == 3) {
    retval.forename = stringParts[0];
    retval.initials = stringParts[1];
    retval.surname  = stringParts[2];
  } else {
    retval.forename = stringParts[0];
    NSArray* initialsElems = [stringParts subarrayWithRange:NSMakeRange(1, stringParts.count - 2)];
    retval.initials = [initialsElems componentsJoinedByString:@" "];
    retval.surname  = stringParts[[stringParts count] - 1];
  }
  return retval;
}
+(struct NameParts) stringToNameString:(NSString*) string {
  NSArray<NSString*>* stringParts = [SoulsAutoCompleteDataSource SplitSpace:string];
  return [SoulsAutoCompleteDataSource stringToNameParts:stringParts];
}

+(NSArray<Soul*>*) findSouls:(NSManagedObjectContext*) managedObjectContext string:(NSString*)string {
  if ([string length] == 0) {
    return [[NSArray alloc] init];
  }
  
  NSArray<NSString*>* stringParts = [SoulsAutoCompleteDataSource SplitSpace:string];
  NSFetchRequest<Soul*>* soulsFetchRequest = Soul.fetchRequest;
  if ([stringParts count] == 1) {
    [soulsFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(forename CONTAINS[cd] %@) OR (surname CONTAINS[cd] %@)", stringParts[0], stringParts[0]]];
  } else if ([stringParts count] == 2) {
    [soulsFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(forename CONTAINS[cd] %@) AND ((initials CONTAINS[cd] %@) OR (surname CONTAINS[cd] %@))", stringParts[0], stringParts[1], stringParts[1]]];
  } else if ([stringParts count] > 2) {
    NSArray* initialsElems = [stringParts subarrayWithRange:NSMakeRange(1, stringParts.count - 2)];
    [soulsFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(forename CONTAINS[cd] %@) AND (initials CONTAINS[cd] %@) AND (surname CONTAINS[cd] %@)", stringParts[0], [initialsElems componentsJoinedByString:@" "], stringParts[[stringParts count] - 1]]];
  }
  [soulsFetchRequest setFetchBatchSize:20];
  
  NSError* error = nil;
  return [managedObjectContext executeFetchRequest:soulsFetchRequest error:&error];
}

- (NSString*)textField:(HTAutocompleteTextField*)textField
   completionForPrefix:(NSString*)prefix
            ignoreCase:(BOOL)ignoreCase {
  NSArray<Soul*>* results = [SoulsAutoCompleteDataSource findSouls:self.managedObjectContext string:prefix];
  if (results) {
    for (Soul* soul in results) {
      return [SoulsAutoCompleteDataSource soulToName:soul];
    }
  }
  return nil;
}

@end
