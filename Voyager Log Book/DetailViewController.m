//
//  DetailViewController.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "DetailViewController.h"
#import "SoulsAutoCompleteDataSource.h"
#import "SoulsAutoCompleteObject.h"
#import "ArrayPicker.h"
#import "NSFetchRequestPicker.h"
#import "PickerToolbar.h"
#import "TouchesUIScrollView.h"
#import <MLPAutoCompleteTextField/MLPAutoCompleteTextField.h>
#import <TagListView-Swift.h>

@class TagListView;

@interface DetailViewController () {
#pragma mark Log Book Entry Fields
  UITextField*  t_vessel;
  UITextField*  t_barometer;
  UITextView*   t_comments;
  UITextField*  t_dateOfArrival;
  UITextField*  t_dateOfArrivalEstimated;
  UITextField*  t_dateOfDeparture;
  UITextField*  t_destination;
  UITextView*   t_passageNotes;
  UITextField*  t_portOfArrival;
  UITextField*  t_portOfDeparture;
  UIStackView*  l_souls;
  TagListView*  v_souls;
  MLPAutoCompleteTextField*
                t_souls;
  UITextField*  t_waveHeight;
  UITextField*  t_weatherConditions;
  UITextField*  t_windDirection;
  UITextField*  t_windSpeed;
    
#pragma mark Soul Fields
  UITextField*  t_forename;
  UITextField*  t_initials;
  UITextField*  t_surname;
  UISwitch*     t_isFavourite;
  
#pragma mark Vessel Fields
  UITextField*  t_captain;
  UISwitch*     t_isDefault;
  UITextField*  t_homePort;
  UITextField*  t_name;
  UITextField*  t_owner;
  
#pragma mark Generic Fields
  TouchesUIScrollView* lastActiveView;
  TouchesUIScrollView* nothingView;
  TouchesUIScrollView* vesselView;
  TouchesUIScrollView* soulView;
  TouchesUIScrollView* lbeView;

  bool editing;
  bool didChange;
  bool isIpad;
  NSMutableArray* uiFields;
  NSMutableArray* objectSetters;
  UIBarButtonItem* btnEdit;
  UIBarButtonItem* btnDone;
  
  NSUInteger soulAutoCompleteCharacterCount;
  NSTimer* timer;
  
  SoulsAutoCompleteDataSource* soulsAutoCompleteDataSource;
}

@end

@implementation DetailViewController
- (UILabel*) setupLabel:(NSString*) lText {
  UILabel* label;
  label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.text = [lText stringByAppendingString:@":"];
  return label;
}

- (UITextField*) setupTextField {
  UITextField* field;
  field = [[UITextField alloc]  initWithFrame:CGRectZero];
  field.borderStyle = UITextBorderStyleRoundedRect;
  field.enabled = true;
  field.delegate = self;
    
  return field;
}
- (UITextView*) setupTextView {
  UITextView* field;
  field = [[UITextView alloc]  initWithFrame:CGRectZero];
  field.layer.borderWidth = 1.0f;
  field.layer.borderColor = [[UIColor grayColor] CGColor];
  field.editable = true;
  field.scrollEnabled = false;
  return field;
}
- (UISwitch*) setupSwitch {
  UISwitch* field;
  field = [[UISwitch alloc]  initWithFrame:CGRectZero];
  field.enabled = true;
        
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
  if (t_barometer)
    return;

  lastActiveView = nil;
  timer          = [[NSTimer alloc] init];
  
  isIpad        = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
  uiFields      = [[NSMutableArray alloc] init];
  objectSetters = [[NSMutableArray alloc] init];
  btnDone       = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(editDoneToggle:)];
  btnEdit       = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editDoneToggle:)];
  [self setupNothingFields];
  [self setupVesselFields];
  [self setupSoulFields];
  [self setupLbeFields];
}
- (void)setupNothingFields {
  UILabel* title = [[UILabel alloc] initWithFrame:CGRectZero];
  title.text = @"Welcome To Log Book";
  title.font = [UIFont boldSystemFontOfSize:24.0];
  
  UITextView* information   = [[UITextView alloc]  initWithFrame:CGRectZero];
  information.editable      = false;
  information.scrollEnabled = false;
  information.text = @"Welcome to Voyager Log Book; to get started create a Log Book entry by clicking the + icon in the navigation bar (press \"< Log Book\" if you cannot see this).";
  
  //Stack View
  UIStackView *stackView  = [[UIStackView alloc] init];
  stackView.axis          = UILayoutConstraintAxisVertical;
  stackView.alignment     = UIStackViewAlignmentFill;
  stackView.spacing       = 20;
  stackView.layoutMarginsRelativeArrangement = true;
  stackView.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(20, 20, 20, 20);
  
  [stackView addArrangedSubview:title];
  [stackView addArrangedSubview:information];

  stackView.translatesAutoresizingMaskIntoConstraints = false;
  [stackView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
  
  //Scroll view
  nothingView =[[TouchesUIScrollView alloc] initWithFrame:CGRectZero];
  nothingView.translatesAutoresizingMaskIntoConstraints = false;
  
  [nothingView addSubview:stackView];
  //Layout for Stack View
  [stackView.topAnchor      constraintEqualToAnchor:nothingView.topAnchor]      .active = true;
  [stackView.bottomAnchor   constraintEqualToAnchor:nothingView.bottomAnchor]   .active = true;
  [stackView.leadingAnchor  constraintEqualToAnchor:nothingView.leadingAnchor]  .active = true;
  [stackView.trailingAnchor constraintEqualToAnchor:nothingView.trailingAnchor] .active = true;
  [stackView.widthAnchor    constraintEqualToAnchor:nothingView.widthAnchor]    .active = true;
}

- (void)setupSoulFields {
  id l_forename     = [self setupLabel:@"Forename"];
  id l_initials     = [self setupLabel:@"Initals"];
  id l_surname      = [self setupLabel:@"Surname"];
  id l_isFavourite  = [self setupLabel:@"Favourite"];
  
  t_forename    = [self setupTextField];
  t_initials    = [self setupTextField];
  t_surname     = [self setupTextField];
  t_isFavourite = [self setupSwitch];
  
   // Update the user interface for the detail item.
  UIView *forename    = [self generateLabelField:true labelControl:l_forename    inputControl:t_forename];
  UIView *initials    = [self generateLabelField:true labelControl:l_initials    inputControl:t_initials];
  UIView *surname     = [self generateLabelField:true labelControl:l_surname     inputControl:t_surname];
  UIView *isFavourite = [self generateLabelField:true labelControl:l_isFavourite inputControl:t_isFavourite];

  //Stack View
  UIStackView *stackView = [[UIStackView alloc] init];

  stackView.axis          = UILayoutConstraintAxisVertical;
  stackView.distribution  = UIStackViewDistributionFill;
  stackView.alignment     = UIStackViewAlignmentFill;
  stackView.spacing       = 5;
  stackView.layoutMarginsRelativeArrangement = true;
  stackView.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(20, 20, 20, 20);

  [stackView addArrangedSubview:forename];
  [stackView addArrangedSubview:initials];
  [stackView addArrangedSubview:surname];
  [stackView addArrangedSubview:isFavourite];

  stackView.translatesAutoresizingMaskIntoConstraints = false;
  
  //Scroll view
  soulView =[[TouchesUIScrollView alloc] initWithFrame:CGRectZero];
  soulView.translatesAutoresizingMaskIntoConstraints = false;
  
  [soulView addSubview:stackView];
  //Layout for Stack View
  [stackView.topAnchor constraintEqualToAnchor:soulView.topAnchor].active = true;
  [stackView.bottomAnchor constraintEqualToAnchor:soulView.bottomAnchor].active = true;
  [stackView.leadingAnchor constraintEqualToAnchor:soulView.leadingAnchor].active = true;
  [stackView.trailingAnchor constraintEqualToAnchor:soulView.trailingAnchor].active = true;
  [stackView.widthAnchor constraintEqualToAnchor:soulView.widthAnchor].active = true;
}

- (void)setupVesselFields {
  id l_captain        = [self setupLabel:@"Captain"];
  id l_defaultVessel  = [self setupLabel:@"Default Vessel"];
  id l_homePort       = [self setupLabel:@"Home Port"];
  id l_name           = [self setupLabel:@"Name"];
  id l_owner          = [self setupLabel:@"Owner"];
  
  t_captain           = [self setupTextField];
  t_isDefault         = [self setupSwitch];
  t_homePort          = [self setupTextField];
  t_name              = [self setupTextField];
  t_owner             = [self setupTextField];
  
   // Update the user interface for the detail item.
  UIView *captain       = [self generateLabelField:true labelControl:l_captain        inputControl:t_captain];
  UIView *defaultVessel = [self generateLabelField:true labelControl:l_defaultVessel  inputControl:t_isDefault];
  UIView *homePort      = [self generateLabelField:true labelControl:l_homePort       inputControl:t_homePort];
  UIView *name          = [self generateLabelField:true labelControl:l_name           inputControl:t_name];
  UIView *owner         = [self generateLabelField:true labelControl:l_owner          inputControl:t_owner];

  //Stack View
  UIStackView *stackView = [[UIStackView alloc] init];

  stackView.axis          = UILayoutConstraintAxisVertical;
  stackView.distribution  = UIStackViewDistributionFill;
  stackView.alignment     = UIStackViewAlignmentFill;
  stackView.spacing       = 5;
  stackView.layoutMarginsRelativeArrangement = true;
  stackView.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(20, 20, 20, 20);

  [stackView addArrangedSubview:name];
  [stackView addArrangedSubview:defaultVessel];
  [stackView addArrangedSubview:owner];
  [stackView addArrangedSubview:homePort];
  [stackView addArrangedSubview:captain];

  stackView.translatesAutoresizingMaskIntoConstraints = false;
  
  //Scroll view
  vesselView =[[TouchesUIScrollView alloc] initWithFrame:CGRectZero];
  vesselView.translatesAutoresizingMaskIntoConstraints = false;
  
  [vesselView addSubview:stackView];
  //Layout for Stack View
  [stackView.topAnchor      constraintEqualToAnchor:vesselView.topAnchor].active      = true;
  [stackView.bottomAnchor   constraintEqualToAnchor:vesselView.bottomAnchor].active   = true;
  [stackView.leadingAnchor  constraintEqualToAnchor:vesselView.leadingAnchor].active  = true;
  [stackView.trailingAnchor constraintEqualToAnchor:vesselView.trailingAnchor].active = true;
  [stackView.widthAnchor    constraintEqualToAnchor:vesselView.widthAnchor].active    = true;
}

- (UIStackView*)setupSouls {
  UIStackView *stackView = [[UIStackView alloc] init];

  stackView.axis          = UILayoutConstraintAxisHorizontal;
  stackView.distribution  = UIStackViewDistributionEqualSpacing;
  stackView.alignment     = UIStackViewAlignmentFirstBaseline;
  stackView.spacing       = 5;

  [stackView addArrangedSubview:[self setupLabel:@"Guests"]];

  stackView.translatesAutoresizingMaskIntoConstraints = false;
  
  return stackView;
}
- (void)setupLbeFields {
  UILabel* l_vessel = [self setupLabel:@"Vessel"];
  UILabel* l_barometer = [self setupLabel:@"Barometer"];
  UILabel* l_comments = [self setupLabel:@"Comments"];
  UILabel* l_dateOfArrival = [self setupLabel:@"Date of Arrival"];
  UILabel* l_dateOfArrivalEstimated = [self setupLabel:@"Estimated Date of Arrival"];
  UILabel* l_dateOfDeparture = [self setupLabel:@"Date of Departure"];
  UILabel* l_destination = [self setupLabel:@"Destination"];
  UILabel* l_passageNotes = [self setupLabel:@"Voyage Notes"];
  UILabel* l_portOfArrival = [self setupLabel:@"Port of Arrival"];
  UILabel* l_portOfDeparture = [self setupLabel:@"Port of Departure"];
  l_souls = [self setupSouls];
  
  UILabel* l_waveHeight = [self setupLabel:@"Wave Height"];
  UILabel* l_weatherConditions = [self setupLabel:@"Weather Conditions"];
  UILabel* l_windDirection = [self setupLabel:@"Wind Direction"];
  UILabel* l_windSpeed = [self setupLabel:@"Wind Speed"];
  
  t_vessel = [self setupTextField];
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
  v_souls = [[TagListView alloc] initWithFrame:CGRectZero];
  v_souls.alignment = AlignmentLeft;
  v_souls.cornerRadius = 3.0f;
  v_souls.delegate = self;
  v_souls.tagBackgroundColor  = [[UIColor alloc] initWithRed:88.5f/255.0f green:142.0f/255.0f blue:228.9f/255.0f alpha:1.0f];
  t_souls = [[MLPAutoCompleteTextField alloc] initWithFrame:CGRectZero];
  t_souls.borderStyle = UITextBorderStyleRoundedRect;
  t_souls.enabled = true;
  t_souls.delegate = self;
  soulsAutoCompleteDataSource = [[SoulsAutoCompleteDataSource alloc] init];
  soulsAutoCompleteDataSource.managedObjectContext = self.managedObjectContext;
  t_souls.applyBoldEffectToAutoCompleteSuggestions = true;
  t_souls.showTextFieldDropShadowWhenAutoCompleteTableIsOpen = true;
  t_souls.autoCompleteDataSource  = soulsAutoCompleteDataSource;
  t_souls.autoCompleteDelegate    = self;
  t_souls.autoCompleteTableBackgroundColor = [UIColor colorWithRed:185.0f/255.0f green:206.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
  t_waveHeight = [self setupTextField];
  t_weatherConditions = [self setupTextField];
  t_windDirection = [self setupTextField];
  t_windSpeed = [self setupTextField];
  
   // Update the user interface for the detail item.
  UIView *vessel = [self generateLabelField:true labelControl:l_vessel inputControl:t_vessel];
  UIView *destination = [self generateLabelField:true labelControl:l_destination inputControl:t_destination];
  UIView *portOfDeparture = [self generateLabelField:true labelControl:l_portOfDeparture inputControl:t_portOfDeparture];
  UIView *dateOfDeparture = [self generateLabelField:true labelControl:l_dateOfDeparture inputControl:t_dateOfDeparture];
  UIView *portOfArrival = [self generateLabelField:true labelControl:l_portOfArrival inputControl:t_portOfArrival];
  UIView *dateOfArrival = [self generateLabelField:true labelControl:l_dateOfArrival inputControl:t_dateOfArrival];
  UIView *dateOfArrivalEstimated = [self generateLabelField:true labelControl:l_dateOfArrivalEstimated inputControl:t_dateOfArrivalEstimated];
  UIView *souls = [self generateLabelField:false labelControl:l_souls inputControl:v_souls];
  [t_souls setContentHuggingPriority:UILayoutPriorityDefaultLow  forAxis:UILayoutConstraintAxisHorizontal];
  [t_souls setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
  [(UIStackView*)souls addArrangedSubview:t_souls];
  
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

  [stackView addArrangedSubview:vessel];
  [stackView addArrangedSubview:destinationAndEta];
  [stackView addArrangedSubview:departure];
  [stackView addArrangedSubview:arrival];
  [stackView addArrangedSubview:souls];
  [stackView addArrangedSubview:weatherConditions];
  [stackView addArrangedSubview:wind];
  [stackView addArrangedSubview:barometerWave];
  [stackView addArrangedSubview:passageNotes];
  [stackView addArrangedSubview:comments];

  stackView.translatesAutoresizingMaskIntoConstraints = false;
  
  //Scroll view
  lbeView =[[TouchesUIScrollView alloc] initWithFrame:CGRectZero];
  lbeView.translatesAutoresizingMaskIntoConstraints = false;
  
  [lbeView addSubview:stackView];
  //Layout for Stack View
  [stackView.topAnchor      constraintEqualToAnchor:lbeView.topAnchor].active       = true;
  [stackView.bottomAnchor   constraintEqualToAnchor:lbeView.bottomAnchor].active    = true;
  [stackView.leadingAnchor  constraintEqualToAnchor:lbeView.leadingAnchor].active   = true;
  [stackView.trailingAnchor constraintEqualToAnchor:lbeView.trailingAnchor].active  = true;
  [stackView.widthAnchor    constraintEqualToAnchor:lbeView.widthAnchor].active     = true;
  
  [[t_souls superview]  bringSubviewToFront:t_souls];
  [[souls superview]    bringSubviewToFront:souls];
}

- (UIView*)  makeTwo:(UIView*) leftControl
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
                  labelControl:(UIView*) labelControl
                  inputControl:(UIView*) inputControl {
  if (!isIpad) horizontalStack = false;
  
  [labelControl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
  [inputControl setContentHuggingPriority:UILayoutPriorityDefaultLow  forAxis:UILayoutConstraintAxisHorizontal];
  
  [labelControl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
  [inputControl setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
  
  //Stack View
  UIStackView *stackView = [[UIStackView alloc] init];

  if (horizontalStack) {
    stackView.axis = UILayoutConstraintAxisHorizontal;
  } else {
    stackView.axis = UILayoutConstraintAxisVertical;
  }
  stackView.distribution  = UIStackViewDistributionFill;
  stackView.alignment     = UIStackViewAlignmentFill;
  stackView.spacing       = 5;
  stackView.translatesAutoresizingMaskIntoConstraints = false;

  [stackView addArrangedSubview:labelControl];
  [stackView addArrangedSubview:inputControl];

  [stackView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
  if (horizontalStack && [inputControl isKindOfClass:[UISwitch class]]) {
    [stackView.heightAnchor constraintEqualToConstant:31.0].active = true;
  }
  
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

-(IBAction) editDoneToggle:(id)sender {
  if (editing)
    [self doneEditing];
  [self setEnabled:!editing];
}

- (void)setEnabled:(bool) isEnabled {
  editing = isEnabled;
  if (self.vessel || self.souls || self.logBookEntry) {
    if (editing)
      self.navigationItem.rightBarButtonItem = btnDone;
    else
      self.navigationItem.rightBarButtonItem = btnEdit;
  } else {
    self.navigationItem.rightBarButtonItem = nil;
  }
  
  t_vessel.enabled            = isEnabled;
  t_barometer.enabled         = isEnabled;
  t_comments.editable         = isEnabled;
  t_dateOfArrival.enabled     = isEnabled;
  t_dateOfArrivalEstimated.enabled
                              = isEnabled;
  t_dateOfDeparture.enabled   = isEnabled;
  t_destination.enabled       = isEnabled;
  t_passageNotes.editable     = isEnabled;
  t_portOfArrival.enabled     = isEnabled;
  t_portOfDeparture.enabled   = isEnabled;
  t_waveHeight.enabled        = isEnabled;
  t_weatherConditions.enabled = isEnabled;
  t_windDirection.enabled     = isEnabled;
  t_windSpeed.enabled         = isEnabled;
  t_souls.enabled             = isEnabled;
  v_souls.enableRemoveButton  = isEnabled;
  [self showSouls];
  
  t_forename.enabled  = isEnabled;
  t_initials.enabled  = isEnabled;
  t_surname.enabled   = isEnabled;
  
  t_captain.enabled   = isEnabled;
  t_isDefault.enabled = !t_isDefault.on && isEnabled;
  t_homePort.enabled  = isEnabled;
  t_name.enabled      = isEnabled;
  t_owner.enabled     = isEnabled;
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

+ (NSDate*)stringToDate:(NSString*) str {
    if (!str) return nil;
    NSDateFormatter* formatter = [DetailViewController dateFormatter];
    return [formatter dateFromString:str];

}

+ (NSString*)dateToString:(NSDate*) date {
    if (!date) return nil;
    NSDateFormatter* formatter = [DetailViewController dateFormatter];
    return [formatter stringFromDate:date];
}

- (NSString*)getText:(NSObject*) ultimateField  {
    if (!ultimateField) return @"";
    if ([ultimateField isKindOfClass:[NSDate class]]) {
        return [DetailViewController dateToString:((NSDate*) ultimateField)];
    }
    if ([ultimateField isKindOfClass:[NSString class]]) {
        return ((NSString*) ultimateField);
    }
    return @"Unsupported field type";
}

- (void)linkField:(UIView*) control ultimateField:(NSObject*) ultimateField
    objectSetter:(ObjectSetter) objectSetter {
    
  [uiFields addObject:control];
  [objectSetters addObject:objectSetter];
  
  if ([control isKindOfClass:[UITextField class]]) {
    ((UITextField*) control).text = [self getText:ultimateField];
  }
  if ([control isKindOfClass:[UITextView class]]) {
    ((UITextView*) control).text = [self getText:ultimateField];
  }
  if ([control isKindOfClass:[UISwitch class]]) {
    ((UISwitch*) control).on = [self strToBool:[self getText:ultimateField]];
  }
}

+ (int)getArrayIndex:(int) defaultVal arrayElems:(NSArray*)arrayElems toFind:(NSString*) toFind{
  if (!toFind) return defaultVal;
  
  int index = 0;
  for (NSString* elem in arrayElems) {
      if ([elem isEqualToString:toFind])
          return index;
      ++index;
  }
  return defaultVal;
}

- (void)makeFixedPickerAction:(UITextField*)textField title:(NSString*)title arrayElems:(NSArray*) arrayElems {
  ArrayPicker* picker = [[ArrayPicker alloc]
           initWithStrings:title rows:arrayElems initialSelection:[DetailViewController getArrayIndex:0 arrayElems:arrayElems toFind:textField.text]];
  textField.inputView = picker;
  textField.inputAccessoryView = [[PickerToolbar alloc] initWithTextField:textField picker:picker title:title];
}
- (void)makeDatePickerAction:(UITextField*)textField title:(NSString*) title {
  UIDatePicker *datePicker = [[UIDatePicker alloc]init];
  datePicker.datePickerMode = UIDatePickerModeDateAndTime;
  
  NSDate* currentDate = nil;
  if ([textField.text length] > 0) {
    currentDate = [DetailViewController stringToDate:textField.text];
    [datePicker setDate:currentDate];
  }
  textField.inputView = datePicker;
  textField.inputAccessoryView = [[PickerToolbar alloc] initWithTextField:textField picker:datePicker title:title];
}

- (void)makeVesselPickerAction:(UITextField*)textField title:(NSString*)title {
  NSFetchRequestPicker* frPicker = [[NSFetchRequestPicker alloc]
                                    initWithStrings:title dataFetchRequest:Vessel.fetchRequest managedObjectContext:self.managedObjectContext
                                    fetchedObjectToString:^NSString *(id object) { return ((Vessel*)object).name; }
                                    textField:textField];
  textField.inputView = frPicker;
  textField.inputAccessoryView = [[PickerToolbar alloc] initWithTextField:textField picker:frPicker title:title];
}

- (TouchesUIScrollView*)getCurrentView {
  if (self.logBookEntry) {
    return lbeView;
  } else if (self.vessel) {
    return vesselView;
  } else if (self.souls) {
    return soulView;
  }
  return nothingView;
}

- (NSString*)boolToStr:(BOOL) b {
  return b ? @"1" : @"0";
}

- (BOOL)strToBool:(NSString*) s {
  if (!s) return false;
  return [s isEqualToString:@"1"];
}

- (bool)isNew {
  if (self.logBookEntry) {
    bool isNew = self.logBookEntry.destination == nil;
    if (isNew)
      self.logBookEntry.destination = @"";
    return isNew;
  } else if (self.vessel) {
    bool isNew = self.vessel.name == nil;
    if (isNew)
      self.vessel.name = @"";
    return isNew;
  } else if (self.souls) {
    bool isNew = self.souls.forename == nil;
    if (isNew)
      self.souls.forename = @"";
    return isNew;
  }
  return false;
}

- (void)configureView {
  // Update the user interface for the detail item.
  didChange = false;
  [uiFields      removeAllObjects];
  [objectSetters removeAllObjects];
    
  if (lastActiveView)
    [lastActiveView removeFromSuperview];
  lastActiveView = [self getCurrentView];
  if (lastActiveView) {
    [self.view addSubview:lastActiveView];
    //Layout for Stack View
    [lastActiveView.topAnchor    constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active    = true;
    [lastActiveView.leftAnchor   constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leftAnchor].active   = true;
    [lastActiveView.rightAnchor  constraintEqualToAnchor:self.view.safeAreaLayoutGuide.rightAnchor].active  = true;
    [lastActiveView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = true;
  }
  
  if (self.logBookEntry) {
    self.title = @"Log Book Entry";
    [self linkField:t_vessel                  ultimateField:self.logBookEntry.vessel.name objectSetter:^(NSString* newVal) { self.logBookEntry.vessel = [self lookupVesselByName:newVal]; }];
    [self makeVesselPickerAction:t_vessel title:@"Vessel"];
    [self linkField:t_barometer               ultimateField:self.logBookEntry.barometer objectSetter:^(NSString* newVal) { self.logBookEntry.barometer = newVal; }];
    [self linkField:t_comments                ultimateField:self.logBookEntry.comments objectSetter:^(NSString* newVal) { self.logBookEntry.comments = newVal; }];
    [self linkField:t_dateOfArrival           ultimateField:self.logBookEntry.dateOfArrival objectSetter:^(NSString* newVal) { self.logBookEntry.dateOfArrival = [DetailViewController stringToDate:newVal]; }];
    [self makeDatePickerAction:t_dateOfArrival title:@"Arrival Date"];
    [self linkField:t_dateOfArrivalEstimated  ultimateField:self.logBookEntry.dateOfArrivalEstimated objectSetter:^(NSString* newVal) { self.logBookEntry.dateOfArrivalEstimated = [DetailViewController stringToDate:newVal]; }];
    [self makeDatePickerAction:t_dateOfArrivalEstimated title:@"Arrival Date (Estimated)"];
    [self linkField:t_dateOfDeparture         ultimateField:self.logBookEntry.dateOfDeparture objectSetter:^(NSString* newVal) { self.logBookEntry.dateOfDeparture = [DetailViewController stringToDate:newVal]; }];
    [self makeDatePickerAction:t_dateOfDeparture title:@"Departure Date"];
    [self linkField:t_destination             ultimateField:self.logBookEntry.destination objectSetter:^(NSString* newVal) { self.logBookEntry.destination = newVal; }];
    [self linkField:t_passageNotes            ultimateField:self.logBookEntry.passageNotes objectSetter:^(NSString* newVal) { self.logBookEntry.passageNotes = newVal; }];
    [self linkField:t_portOfArrival           ultimateField:self.logBookEntry.portOfArrival objectSetter:^(NSString* newVal) { self.logBookEntry.portOfArrival = newVal; }];
    [self linkField:t_portOfDeparture         ultimateField:self.logBookEntry.portOfDeparture objectSetter:^(NSString* newVal) { self.logBookEntry.portOfDeparture = newVal; }];
    [self linkField:t_weatherConditions       ultimateField:self.logBookEntry.weatherConditions objectSetter:^(NSString* newVal) { self.logBookEntry.weatherConditions = newVal; }];
    [self linkField:t_windDirection           ultimateField:self.logBookEntry.windDirection objectSetter:^(NSString* newVal) { self.logBookEntry.windDirection = newVal; }];
    [self makeFixedPickerAction:t_windDirection title:@"Wind Direction" arrayElems:[DetailViewController windDirections]];
    [self linkField:t_windSpeed               ultimateField:self.logBookEntry.windSpeed objectSetter:^(NSString* newVal) { self.logBookEntry.windSpeed = newVal; }];
    [self showSouls];
  } else if (self.vessel) {
    self.title = @"Vessel";
    [self linkField:t_captain   ultimateField:self.vessel.captain   objectSetter:^(NSString* newVal) { self.vessel.captain = newVal; }];
    [self linkField:t_isDefault ultimateField:[self boolToStr:self.vessel.defaultVessel]
                                                                    objectSetter:^(NSString* newVal) { self.vessel.defaultVessel = [self strToBool:newVal]; }];
    [self linkField:t_homePort  ultimateField:self.vessel.homePort  objectSetter:^(NSString* newVal) { self.vessel.homePort = newVal; }];
    [self linkField:t_name      ultimateField:self.vessel.name      objectSetter:^(NSString* newVal) { self.vessel.name = newVal; }];
    [self linkField:t_owner     ultimateField:self.vessel.owner     objectSetter:^(NSString* newVal) { self.vessel.owner = newVal; }];
  } else if (self.souls) {
    self.title = @"Soul";
    [self linkField:t_forename    ultimateField:self.souls.forename objectSetter:^(NSString* newVal) { self.souls.forename = newVal; }];
    [self linkField:t_initials    ultimateField:self.souls.initials objectSetter:^(NSString* newVal) { self.souls.initials = newVal; }];
    [self linkField:t_surname     ultimateField:self.souls.surname  objectSetter:^(NSString* newVal) { self.souls.surname = newVal; }];
    [self linkField:t_isFavourite ultimateField:[self boolToStr:self.souls.isFavourite]
      objectSetter:^(NSString* newVal) { self.souls.isFavourite = [self strToBool:newVal]; }];
    
  } else {
    self.title = @"Voyager Log Book";
  }
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
  TouchesUIScrollView* scrollView = [self getCurrentView];
  if (!scrollView) return;
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
  scrollView.contentInset = contentInsets;
  scrollView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
  TouchesUIScrollView* scrollView = [self getCurrentView];
  if (!scrollView) return;
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
  soulAutoCompleteCharacterCount = 0;
  [self registerForKeyboardNotifications];
  [self setupFields];
  [self setEnabled:[self isNew]];
  [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated {
  if (editing) {
    [self doneEditing];
    editing = false;
  }
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
      _vessel       = nil;
      _souls        = nil;
      _logBookEntry = (LogBookEntry*) newDetailItem;
      
      // Update the view.
      [self configureView];
    }
  } else if ([newDetailItem isKindOfClass:[Vessel class]]) {
    if (_vessel != newDetailItem) {
      _logBookEntry = nil;
      _souls        = nil;
      _vessel = (Vessel*) newDetailItem;
      
      // Update the view.
      [self configureView];
    }
  } else if ([newDetailItem isKindOfClass:[Soul class]]) {
    if (_souls != newDetailItem) {
      _logBookEntry = nil;
      _vessel       = nil;
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

- (void)doneEditing {
  bool wasDefault = (self.vessel && self.vessel.defaultVessel);
  for (int i=0; i<[objectSetters count]; ++i) {
    ObjectSetter setter   = [objectSetters objectAtIndex:i];
    UIView*      control  = [uiFields      objectAtIndex:i];
    if ([control isKindOfClass:[UITextField class]]) {
      setter(((UITextField*) control).text);
    }
    if ([control isKindOfClass:[UITextView class]]) {
      setter(((UITextView*) control).text);
    }
    if ([control isKindOfClass:[UISwitch class]]) {
      setter([self boolToStr:((UISwitch*) control).on]);
    }
  }
  
  if (self.vessel) {
    if (wasDefault != self.vessel.defaultVessel) {
      NSFetchRequest<Vessel *>* currentDefaultFetchRequest = Vessel.fetchRequest;
      [currentDefaultFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"defaultVessel == %@", [NSNumber numberWithBool: YES]]];
      
      NSError* error = nil;
      NSArray* results = [self.managedObjectContext executeFetchRequest:currentDefaultFetchRequest error:&error];
      if (!results) {
          // Replace this implementation with code to handle the error appropriately.
          // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          NSLog(@"Unresolved error %@, %@", error, error.userInfo);
          abort();
      }

      for (Vessel* vessel in results) {
        vessel.defaultVessel = false;
      }
      self.vessel.defaultVessel = true;
      [self saveContext:self.managedObjectContext];
    }
  }
  NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
  [self saveContext:context];
}

-(Vessel*)lookupVesselByName:(NSString*)vesselName {
  NSFetchRequest<Vessel *>* byNameFetchRequest = Vessel.fetchRequest;
  [byNameFetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@", vesselName]];
  
  NSError* error = nil;
  NSArray* results = [self.managedObjectContext executeFetchRequest:byNameFetchRequest error:&error];
  if (!results) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, error.userInfo);
      abort();
  }

  for (Vessel* vessel in results) {
    return vessel;
  }
  NSLog(@"Cannot find vessel '%@'", vesselName);
  return nil;
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

#pragma mark MLPAutoCompleteTextFieldDelegate
/*IndexPath corresponds to the order of strings within the autocomplete table,
not the original data source.
 autoCompleteObject may be nil if the selectedString had no object associated with it.
 */
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (textField != t_souls) return;
  NSLog(@"autoCompleteTextField: %@", selectedString);
  [((SoulsAutoCompleteObject*)selectedObject) getSoulInstance];
}



- (void)showSouls{
  if (!self.logBookEntry) return;
  [v_souls removeAllTags];
  
  for (Soul* soul in self.logBookEntry.souls) {
    [v_souls addTag:[SoulsAutoCompleteDataSource soulToName:soul]];
  }
}
- (BOOL)addSoulToData:(Soul*) soul {
  for (Soul* soulExisting in self.logBookEntry.souls) {
    if (soul == soulExisting)
      return false;
  }
  
  self.logBookEntry.souls = [self.logBookEntry.souls setByAddingObject:soul];
  t_souls.text = @"";
  [t_souls reloadData];
  [self showSouls];
  return false;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField != t_souls) return true;
  if ([textField.text length] == 0) return false;
  
  NSArray<Soul*>* souls = [SoulsAutoCompleteDataSource findSouls:self.managedObjectContext string:textField.text];
  if ([souls count] == 0) {
    struct NameParts name = [SoulsAutoCompleteDataSource stringToNameString:textField.text];
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    Soul* soul = [[Soul alloc] initWithContext:context];
    soul.forename = name.forename;
    soul.initials = name.initials;
    soul.surname  = name.surname;
    [self saveContext:context];
    return [self addSoulToData:soul];
  } else {
    return [self addSoulToData:souls[0]];
  }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  if (!textField.inputDelegate) return true;
  return ![textField.inputDelegate isKindOfClass:[UIPickerView class]] && ![textField.inputDelegate isKindOfClass:[UIDatePicker class]];
}

#pragma mark TagListViewDelegate
- (void)tagPressed:(NSString * _Nonnull)title tagView:(TagView * _Nonnull)tagView sender:(TagListView * _Nonnull)sender {
  NSLog(@"Clicked: %@", title);
}
- (void)tagRemoveButtonPressed:(NSString * _Nonnull)title tagView:(TagView * _Nonnull)tagView sender:(TagListView * _Nonnull)sender {
  for (Soul* soul in self.logBookEntry.souls) {
    if ([title isEqualToString:[SoulsAutoCompleteDataSource soulToName:soul]]) {
      NSMutableSet<Soul*>* mutableSet = [self.logBookEntry.souls mutableCopy];
      [mutableSet removeObject:soul];
      self.logBookEntry.souls = [mutableSet copy];
      [self showSouls];
      return;
    }
  }
  NSLog(@"Failed to erase: %@", title);
}


@end
