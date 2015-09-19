//
//  FlightNumberViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 10/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "FlightNumberViewController.h"
#import "ScheduleViewController.h"
#import "CurrentWxViewController.h"
#import "FlightAwareCaller.h"
#import "NearestAirportsViewController.h"
#import "ChooseAirlineViewController.h"
#import "SearchResultsController.h"

@interface FlightNumberViewController () <UITextFieldDelegate, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *codeLabel;
@property (nonatomic, weak) IBOutlet UITextField *fnLabel;
@property (weak, nonatomic) IBOutlet UIButton *currentWxButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIButton *chooseAirlineButton;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (nonatomic ,weak) NSDate *date;

@end

@implementation FlightNumberViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"FlightNumberViewController viewDidLoad");
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
    self.navigationController.navigationBarHidden = YES;
    self.fnLabel.delegate = self;
    self.dateField.delegate = self;
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
    
    if (textField == self.dateField) {
        
        UIToolbar *doneBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(textFieldDidEndEditing:)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray *barItems = @[space, space, doneButton];
        doneBar.items = barItems;
        
        self.datePicker = [[UIDatePicker alloc] init];
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];

        [self.datePicker setDate:[NSDate date]];
        [self.datePicker setMinimumDate:[NSDate date]];
        textField.inputView = self.datePicker;
        textField.inputAccessoryView = doneBar;
        
        self.date = [self.datePicker date];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.dateField || [self.dateField isFirstResponder]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];

        self.dateField.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.date]];
        [self.dateField endEditing:YES];
    }
    
    _activeField = nil;
}

- (void)dismissKeyBoard:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"pressed");
    
    [self performSegueWithIdentifier:@"scheduledFlights" sender:self];
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"scheduledFlights"]) {
        ScheduleViewController *svc = segue.destinationViewController;
        svc.fn = self.fnLabel.text;
        svc.date = self.date;
        
    } else if ([segue.identifier isEqualToString:@"currentWxBrief"]) {
        UINavigationController *navController = segue.destinationViewController;
        NearestAirportsViewController *nvc = (NearestAirportsViewController *)navController.topViewController;
        [nvc startLocation];
    }
}

#pragma mark - Unwind Segue

- (IBAction)unwindToFlightNumberViewController:(UIStoryboardSegue *)segue
{
    if ([segue.identifier isEqualToString:@"ChooseAirlineCode"]) {
        ChooseAirlineViewController *cvc = segue.sourceViewController;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fnLabel.text = @"";
            self.ICAO = [cvc.selectedAirline substringFromIndex:[cvc.selectedAirline length] - 3];
            [self.chooseAirlineButton setTitle:cvc.selectedAirline forState:normal];
            self.fnLabel.text = cvc.icao;
        });
        
    } else if ([segue.identifier isEqualToString:@"SearchAirlineCode"]) {
        SearchResultsController *src = segue.sourceViewController;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.fnLabel.text = @"";
            self.ICAO = [src.selectedAirline substringFromIndex:[src.selectedAirline length] - 3];
            [self.chooseAirlineButton setTitle:src.selectedAirline forState:normal];
            self.fnLabel.text = self.ICAO;
        });
    }
}

#pragma mark - Keyboard/Text Field Handling

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
