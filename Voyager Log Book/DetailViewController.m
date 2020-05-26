//
//  DetailViewController.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "DetailViewController.h"
#import "ActionSheetPicker.h"

@interface DetailViewController () {
    UILabel* l_barometer;
    UILabel* l_comments;
    UILabel* l_dateOfArrival;
    UILabel* l_dateOfArrivalEstimated;
    UILabel* l_dateOfDeparture;
    UILabel* l_destination;
    UILabel* l_passageNotes;
    UILabel* l_portOfArrival;
    UILabel* l_portOfDeparture;
    UILabel* l_waveHeight;
    UILabel* l_weatherConditions;
    UILabel* l_windDirection;
    UILabel* l_windSpeed;
    
    
    UITextField*  t_barometer;
    UITextView*   t_comments;
    UITextField*  t_dateOfArrival;
    UITextField*  t_dateOfArrivalEstimated;
    UITextField*  t_dateOfDeparture;
    UITextField*  t_destination;
    UITextView*   t_passageNotes;
    UITextField*  t_portOfArrival;
    UITextField*  t_portOfDeparture;
    UITextField*  t_waveHeight;
    UITextField*  t_weatherConditions;
    UITextField*  t_windDirection;
    UITextField*  t_windSpeed;
    
    UIScrollView* scrollView;
    
    bool didChange;
    bool isIpad;
    NSMutableArray* uiFields;
    NSMutableArray* objectSetters;
    NSMutableArray* editorActions;
}

@end

@implementation DetailViewController
- (UILabel*) setupLabel:(NSString*) lText {
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [lText stringByAppendingString:@":"];
    return label;
}

- (UITextField*) setupTextField
{
    UITextField* field;
    field = [[UITextField alloc]  initWithFrame:CGRectZero];
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.enabled = true;
    field.delegate = self;
    
    [field addTarget:self action:@selector(textFieldClicked:) forControlEvents:UIControlEventTouchDown];
    
    return field;
}
- (UITextView*) setupTextView
{
    UITextView* field;
    field = [[UITextView alloc]  initWithFrame:CGRectZero];
    field.layer.borderWidth = 1.0f;
    field.layer.borderColor = [[UIColor grayColor] CGColor];
    field.editable = true;
    field.scrollEnabled = false;
    field.delegate = self;
    return field;
}
+ (NSArray *)windDirections
{
    static NSArray *_titles;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _titles = @[@"N",@"NNE",@"NE",@"ENE",@"E",@"ESE",@"SE",@"SSE",@"S",@"SSW",@"SW",@"WSW",@"W",@"WNW",@"NW",@"NNW"];
    });
    return _titles;
}
- (void)setupFields {
    if (l_barometer)
        return;
    
    isIpad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    uiFields = [[NSMutableArray alloc] init];
    objectSetters = [[NSMutableArray alloc] init];
    editorActions = [[NSMutableArray alloc] init];
    
    l_barometer = [self setupLabel:@"Barometer"];
    l_comments = [self setupLabel:@"Comments"];
    l_dateOfArrival = [self setupLabel:@"Date of Arrival"];
    l_dateOfArrivalEstimated = [self setupLabel:@"Estimated Date of Arrival"];
    l_dateOfDeparture = [self setupLabel:@"Date of Departure"];
    l_destination = [self setupLabel:@"Destination"];
    l_passageNotes = [self setupLabel:@"Voyage Notes"];
    l_portOfArrival = [self setupLabel:@"Port of Arrival"];
    l_portOfDeparture = [self setupLabel:@"Port of Departure"];
    l_waveHeight = [self setupLabel:@"Wave Height"];
    l_weatherConditions = [self setupLabel:@"Weather Conditions"];
    l_windDirection = [self setupLabel:@"Wind Direction"];
    l_windSpeed = [self setupLabel:@"Wind Speed"];
    
    
    t_barometer = [self setupTextField];
    t_comments = [self setupTextView];
    t_dateOfArrival = [self setupTextField];
    if (isIpad)
        [t_dateOfArrival.widthAnchor constraintEqualToConstant:200].active = true;
    t_dateOfArrivalEstimated = [self setupTextField];
    t_dateOfDeparture = [self setupTextField];
    if (isIpad)
        [t_dateOfDeparture.widthAnchor constraintEqualToConstant:200].active = true;
    t_destination = [self setupTextField];
    t_passageNotes = [self setupTextView];
    t_portOfArrival = [self setupTextField];
    t_portOfDeparture = [self setupTextField];
    t_waveHeight = [self setupTextField];
    t_weatherConditions = [self setupTextField];
    t_windDirection = [self setupTextField];
    t_windSpeed = [self setupTextField];
    
     // Update the user interface for the detail item.
    UIView *destination = [self generateLabelField:true labelControl:l_destination inputControl:t_destination];
    UIView *portOfDeparture = [self generateLabelField:true labelControl:l_portOfDeparture inputControl:t_portOfDeparture];
    UIView *dateOfDeparture = [self generateLabelField:true labelControl:l_dateOfDeparture inputControl:t_dateOfDeparture];
    UIView *portOfArrival = [self generateLabelField:true labelControl:l_portOfArrival inputControl:t_portOfArrival];
    UIView *dateOfArrival = [self generateLabelField:true labelControl:l_dateOfArrival inputControl:t_dateOfArrival];
    UIView *dateOfArrivalEstimated = [self generateLabelField:true labelControl:l_dateOfArrivalEstimated inputControl:t_dateOfArrivalEstimated];
//        UIView *souls = [self generateLabelFieldAndMapDate:true labelControl:l_dateOfArrivalEstimated inputControl:t_dateOfArrivalEstimated outputText:self.detailItem.dateOfArrivalEstimated];
    UIView *weatherConditions = [self generateLabelField:true labelControl:l_weatherConditions inputControl:t_weatherConditions];
    UIView *barometer = [self generateLabelField:true labelControl:l_barometer inputControl:t_barometer];
    UIView *waveHeight = [self generateLabelField:true labelControl:l_waveHeight inputControl:t_waveHeight];
    UIView *windSpeed = [self generateLabelField:true labelControl:l_windSpeed inputControl:t_windSpeed];
    UIView *windDirection = [self generateLabelField:true labelControl:l_windDirection inputControl:t_windDirection];
    UIView *passageNotes = [self generateLabelField:false labelControl:l_passageNotes inputControl:t_passageNotes];
    UIView *comments = [self generateLabelField:false labelControl:l_comments inputControl:t_comments];
    

    UIView* destinationAndEta = [self makeTwo:destination rightControl:dateOfArrivalEstimated leftBig:false rightBig:false isNarrow:false];
    UIView* departure = [self makeTwo:portOfDeparture rightControl:dateOfDeparture leftBig:true rightBig:false isNarrow:true];
    UIView* arrival = [self makeTwo:portOfArrival rightControl:dateOfArrival leftBig:true rightBig:false isNarrow:true];
    
    
    UIView* wind = [self makeTwo:windSpeed rightControl:windDirection leftBig:false rightBig:false isNarrow:false];
    UIView* barometerWave = [self makeTwo:barometer rightControl:waveHeight leftBig:false rightBig:false isNarrow:false];

    //Stack View
    UIStackView *stackView = [[UIStackView alloc] init];

    stackView.axis          = UILayoutConstraintAxisVertical;
    stackView.distribution  = UIStackViewDistributionFill;
    stackView.alignment     = UIStackViewAlignmentFill;
    stackView.spacing       = 5;
    stackView.layoutMarginsRelativeArrangement = true;
    stackView.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(20, 20, 20, 20);

    [stackView addArrangedSubview:destinationAndEta];
    [stackView addArrangedSubview:departure];
    [stackView addArrangedSubview:arrival];
    //[stackView addArrangedSubview:souls];
    [stackView addArrangedSubview:weatherConditions];
    [stackView addArrangedSubview:wind];
    [stackView addArrangedSubview:barometerWave];
    [stackView addArrangedSubview:passageNotes];
    [stackView addArrangedSubview:comments];

    stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    //Scroll view
    scrollView =[[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.delaysContentTouches = false;
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    
    [scrollView addSubview:stackView];
//        //Layout for Stack View
    [stackView.topAnchor constraintEqualToAnchor:scrollView.topAnchor].active = true;
    [stackView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor].active = true;
    [stackView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor].active = true;
    [stackView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor].active = true;
    [stackView.widthAnchor constraintEqualToAnchor:scrollView.widthAnchor].active = true;
    
    
    [self.view addSubview:scrollView];
    //Layout for Stack View
    [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = true;
    [scrollView.leftAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor].active = true;
    [scrollView.rightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor].active = true;
    [scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = true;
}

- (UIView*) makeTwo:(UIView*) leftControl
rightControl:(UIView*) rightControl
leftBig:(bool) leftBig
rightBig:(bool) rightBig
isNarrow:(bool) isNarrow
{
    //Stack View
    UIStackView *stackView = [[UIStackView alloc] init];

    if (!isIpad) {
        /* On iPhone we don't actually allow anything other than bog standard stacking */
    } else if (leftBig == rightBig) {
        [leftControl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [rightControl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        stackView.distribution = UIStackViewDistributionFillEqually;
    } else if (rightBig) {
        [leftControl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [rightControl setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        stackView.distribution = UIStackViewDistributionFill;
    } else {
        [leftControl setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [rightControl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        stackView.distribution = UIStackViewDistributionFill;
    }
    
    if (isIpad) {
        stackView.axis = UILayoutConstraintAxisHorizontal;
    } else {
        stackView.axis = UILayoutConstraintAxisVertical;
    }
    
    stackView.alignment     = UIStackViewAlignmentFill;
    
    if (!isNarrow) {
        if (isIpad) {
            stackView.spacing = 20;
        } else {
            stackView.spacing = 10;
        }
    }
        

    [stackView addArrangedSubview:leftControl];
    [stackView addArrangedSubview:rightControl];

    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [stackView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    return stackView;
}

- (UIView*) generateLabelField:(bool) horizontalStack
labelControl:(UILabel*) labelControl
inputControl:(UIView*) inputControl
{
    if (!isIpad) horizontalStack = false;
    
    [labelControl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [inputControl setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [labelControl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [inputControl setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    //Stack View
    UIStackView *stackView = [[UIStackView alloc] init];

    if (horizontalStack) {
        stackView.axis = UILayoutConstraintAxisHorizontal;
    } else {
        stackView.axis = UILayoutConstraintAxisVertical;
    }
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.spacing = 5;

    [stackView addArrangedSubview:labelControl];
    [stackView addArrangedSubview:inputControl];

    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [stackView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    return stackView;
}

- (UIView*) generateLabelFieldAndMapText:(bool) horizontalStack
labelControl:(UILabel*) labelControl
inputControl:(UITextField*) inputControl
outputText:(NSString *) outputText
{
    UIView* stackView = [self generateLabelField:horizontalStack labelControl:labelControl inputControl:inputControl];
    [stackView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    return stackView;
}

- (UIView*) generateLabelFieldAndMapTextArea:(bool) horizontalStack
labelControl:(UILabel*) labelControl
inputControl:(UITextView*) inputControl
outputText:(NSString *) outputText
{
    UIView* stackView = [self generateLabelField:horizontalStack labelControl:labelControl inputControl:inputControl];
    [stackView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    return stackView;
}

- (UIView*) generateLabelFieldAndMapDate:(bool) horizontalStack
labelControl:(UILabel*) labelControl
inputControl:(UITextField*) inputControl
outputText:(NSDate *) outputText
{
    UIView* stackView = [self generateLabelField:horizontalStack labelControl:labelControl inputControl:inputControl];
    [stackView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    return stackView;
}

- (void)setEnabled:(bool) isEnabled {
    t_barometer.enabled = isEnabled;
    t_comments.editable = isEnabled;
    t_dateOfArrival.enabled = isEnabled;
    t_dateOfArrivalEstimated.enabled = isEnabled;
    t_dateOfDeparture.enabled = isEnabled;
    t_destination.enabled = isEnabled;
    t_passageNotes.editable = isEnabled;
    t_portOfArrival.enabled = isEnabled;
    t_portOfDeparture.enabled = isEnabled;
    t_waveHeight.enabled = isEnabled;
    t_weatherConditions.enabled = isEnabled;
    t_windDirection.enabled = isEnabled;
    t_windSpeed.enabled = isEnabled;
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [_formatter setDateStyle:NSDateFormatterShortStyle];
        [_formatter setTimeStyle:NSDateFormatterShortStyle];
    });
    return _formatter;
}

- (NSDate*)stringToDate:(NSString*) str {
    if (!str) return nil;
    NSDateFormatter* formatter = [DetailViewController dateFormatter];
    return [formatter dateFromString:str];

}

- (NSString*)dateToString:(NSDate*) date {
    if (!date) return nil;
    NSDateFormatter* formatter = [DetailViewController dateFormatter];
    return [formatter stringFromDate:date];
}

- (NSString*)getText:(NSObject*) ultimateField  {
    if (!ultimateField) return @"";
    if ([ultimateField isKindOfClass:[NSDate class]]) {
        return [self dateToString:((NSDate*) ultimateField)];
    }
    if ([ultimateField isKindOfClass:[NSString class]]) {
        return ((NSString*) ultimateField);
    }
    return @"Unsupported field type";
}

- (void)linkField:(UIView*) control ultimateField:(NSObject*) ultimateField
    objectSetter:(ObjectSetter) objectSetter
    editorAction:(EditorAction) editorAction {
    
    [uiFields addObject:control];
    [objectSetters addObject:objectSetter];
    if (editorAction)
        [editorActions addObject:editorAction];
    else
        [editorActions addObject:[[NSNull alloc] init]];
    
    if ([control isKindOfClass:[UITextField class]]) {
        ((UITextField*) control).text = [self getText:ultimateField];
    }
    if ([control isKindOfClass:[UITextView class]]) {
        ((UITextView*) control).text = [self getText:ultimateField];
    }
}

- (int)getArrayIndex:(int) defaultVal arrayElems:(NSArray*)arrayElems toFind:(NSString*) toFind{
    int index = 0;
    for (NSString* elem in arrayElems) {
        if ([elem isEqualToString:toFind])
            return index;
        ++index;
    }
    return defaultVal;
}

- (void)linkField:(UIView*) control ultimateField:(NSObject*) ultimateField
objectSetter:(ObjectSetter) objectSetter {
    [self linkField:control ultimateField:ultimateField objectSetter:objectSetter editorAction:nil];
}
- (EditorAction)makeFixedPickerAction:(NSString*) title arrayElems:(NSArray*) arrayElems {
    return ^(UITextField* textField) {
        // Done block:
        ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            textField.text = selectedValue;
            [self aTextFieldDidEndEditing:textField fieldText:selectedValue];
            };

        ActionSheetStringPicker* picker = [[ActionSheetStringPicker alloc] initWithTitle:title rows:arrayElems initialSelection:[self getArrayIndex:0 arrayElems:arrayElems toFind:textField.text] doneBlock:done cancelBlock:nil origin:textField];
        picker.tapDismissAction = TapActionCancel;
        [picker showActionSheetPicker];
    };
}

- (void)configureView {
    // Update the user interface for the detail item.
    didChange = false;
    [uiFields      removeAllObjects];
    [objectSetters removeAllObjects];
    [editorActions removeAllObjects];
    
    if (self.logBookEntry) {
        [self setEnabled:true];
        [self linkField:t_barometer ultimateField:self.logBookEntry.barometer objectSetter:^(NSString* newVal) { self.logBookEntry.barometer = newVal; }];
        [self linkField:t_comments ultimateField:self.logBookEntry.comments objectSetter:^(NSString* newVal) { self.logBookEntry.comments = newVal; }];
        [self linkField:t_dateOfArrival ultimateField:self.logBookEntry.dateOfArrival objectSetter:^(NSString* newVal) { self.logBookEntry.dateOfArrival = [self stringToDate:newVal]; }];
        [self linkField:t_dateOfArrivalEstimated ultimateField:self.logBookEntry.dateOfArrivalEstimated objectSetter:^(NSString* newVal) { self.logBookEntry.dateOfArrivalEstimated = [self stringToDate:newVal]; }];
        [self linkField:t_dateOfDeparture ultimateField:self.logBookEntry.dateOfDeparture objectSetter:^(NSString* newVal) { self.logBookEntry.dateOfDeparture = [self stringToDate:newVal]; }];
        [self linkField:t_destination     ultimateField:self.logBookEntry.destination objectSetter:^(NSString* newVal) { self.logBookEntry.destination = newVal; }];
        [self linkField:t_passageNotes ultimateField:self.logBookEntry.passageNotes objectSetter:^(NSString* newVal) { self.logBookEntry.passageNotes = newVal; }];
        [self linkField:t_portOfArrival ultimateField:self.logBookEntry.portOfArrival objectSetter:^(NSString* newVal) { self.logBookEntry.portOfArrival = newVal; }];
        [self linkField:t_portOfDeparture ultimateField:self.logBookEntry.portOfDeparture objectSetter:^(NSString* newVal) { self.logBookEntry.portOfDeparture = newVal; }];
        [self linkField:t_weatherConditions ultimateField:self.logBookEntry.weatherConditions objectSetter:^(NSString* newVal) { self.logBookEntry.weatherConditions = newVal; }];
        [self linkField:t_windDirection ultimateField:self.logBookEntry.windDirection objectSetter:^(NSString* newVal) { self.logBookEntry.windDirection = newVal; }
           editorAction:[self makeFixedPickerAction:@"Wind Direction" arrayElems:[DetailViewController windDirections]]];
        [self linkField:t_windSpeed ultimateField:self.logBookEntry.windSpeed objectSetter:^(NSString* newVal) { self.logBookEntry.windSpeed = newVal; }];
    } else {
        [self setEnabled:false];
    }
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(keyboardWasShown:)
            name:UIKeyboardDidShowNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self
             selector:@selector(keyboardWillBeHidden:)
             name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    [self setupFields];
    [self configureView];
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(NSObject *)newDetailItem {
  if (newDetailItem == nil) {
    _logBookEntry = nil;
    _vessel       = nil;
    _souls        = nil;
    // Update the view.
    [self configureView];
  } else if ([newDetailItem isKindOfClass:[LogBookEntry class]]) {
    if (_logBookEntry != newDetailItem) {
      _logBookEntry = (LogBookEntry*) newDetailItem;
      
      // Update the view.
      [self configureView];
    }
  } else if ([newDetailItem isKindOfClass:[Vessel class]]) {
    if (_vessel != newDetailItem) {
      _vessel = (Vessel*) newDetailItem;
      
      // Update the view.
      [self configureView];
    }
  } else if ([newDetailItem isKindOfClass:[Soul class]]) {
    if (_souls != newDetailItem) {
      _souls = (Soul*) newDetailItem;
      
      // Update the view.
      [self configureView];
    }
  }
}

- (int)findControl:(UIView*) control {
    int index = 0;
    for (UIView* textFieldArr in uiFields) {
        if (control == textFieldArr) {
            return index;
        }
        ++index;
    }
    return -1;
}

- (void)saveContext:(NSManagedObjectContext*) context {
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)aTextFieldDidEndEditing:(UIView*) control fieldText:(NSString*) fieldText {
    int index = [self findControl:control];
    if (index == -1) {
        NSLog(@"Couldn't find setter!");
        return;
    }
    ((ObjectSetter)[objectSetters objectAtIndex:index])(fieldText);
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [self saveContext:context];
}

-(IBAction) textFieldClicked:(id)sender {
    UITextField* control = (UITextField*) sender;
    int index = [self findControl:control];
    if (index == -1) {
        return;
    }
    if ([editorActions[index] isEqual:[NSNull null]]) {
        return; //Return if no action set
    }
    ((EditorAction)[editorActions objectAtIndex:index])(control);
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    int index = [self findControl:textField];
    if (index == -1) {
        return true;
    }
    return ([editorActions[index] isEqual:[NSNull null]]);
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self aTextFieldDidEndEditing:textField fieldText:textField.text];
}

#pragma mark <UITextFieldDelegate, UITextViewDelegate>
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self aTextFieldDidEndEditing:textView fieldText:textView.text];
}

@end
