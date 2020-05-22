//
//  DetailViewController.m
//  Voyager Log Book
//
//  Created by Christopher Dawes on 21/05/2020.
//  Copyright © 2020 Camding Ltd. All rights reserved.
//

#import "DetailViewController.h"

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
    return field;
}
- (UITextView*) setupTextView
{
    UITextView* field;
    field = [[UITextView alloc]  initWithFrame:CGRectZero];
    field.layer.borderWidth = 1.0f;
    field.layer.borderColor = [[UIColor grayColor] CGColor];
    field.editable = true;
    field.text = @"Bob";
    field.scrollEnabled = false;
    return field;
}
- (UITextField*) setupDatePicker
{
    //FIXME UIDatePicker
    UITextField* field;
    field = [[UITextField alloc] initWithFrame:CGRectZero];
    field.borderStyle = UITextBorderStyleRoundedRect;
    return field;
}
- (UITextField*) setupPicker:(NSArray*) options
{
    //FIXME UIPickerView
    UITextField* field;
    field = [[UITextField alloc]  initWithFrame:CGRectZero];
    field.borderStyle = UITextBorderStyleRoundedRect;
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
    t_dateOfArrival = [self setupDatePicker];
    t_dateOfArrivalEstimated = [self setupDatePicker];
    t_dateOfDeparture = [self setupDatePicker];
    t_destination = [self setupTextField];
    t_passageNotes = [self setupTextView];
    t_portOfArrival = [self setupTextField];
    t_portOfDeparture = [self setupTextField];
    t_waveHeight = [self setupTextField];
    t_weatherConditions = [self setupTextField];
    t_windDirection = [self setupPicker:[DetailViewController windDirections]];
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
    
    
    UIView* wind = [self makeTwo:windSpeed rightControl:windDirection leftBig:false rightBig:false isNarrow:true];
    UIView* conditions = [self makeThree:barometer centerControl:waveHeight rightControl:wind];

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
    [stackView addArrangedSubview:conditions];
    [stackView addArrangedSubview:passageNotes];
    [stackView addArrangedSubview:comments];

    stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    //Scroll view
    scrollView =[[UIScrollView alloc] initWithFrame:CGRectZero];
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

    if (leftBig == rightBig) {
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
    
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewDistributionFill;
    if (!isNarrow)
        stackView.spacing = 20;

    [stackView addArrangedSubview:leftControl];
    [stackView addArrangedSubview:rightControl];

    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [stackView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    return stackView;
}

- (UIView*) makeThree:(UIView*) leftControl
centerControl:(UIView*) centerControl
rightControl:(UIView*) rightControl
{
    //Stack View
    UIStackView *stackView = [[UIStackView alloc] init];

    stackView.distribution = UIStackViewDistributionFillEqually;
    
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewDistributionFill;
    stackView.spacing = 10;

    [stackView addArrangedSubview:leftControl];
    [stackView addArrangedSubview:centerControl];
    [stackView addArrangedSubview:rightControl];

    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [stackView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    return stackView;
}

- (UIView*) generateLabelField:(bool) horizontalStack
labelControl:(UILabel*) labelControl
inputControl:(UIView*) inputControl
{
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

- (void)configureView {
// Update the user interface for the detail item.
if (self.detailItem) {
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

- (void)setDetailItem:(LogBookEntry *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}


@end
