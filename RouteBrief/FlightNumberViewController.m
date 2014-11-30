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

@interface FlightNumberViewController () <UITextFieldDelegate, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *codeLabel;
@property (nonatomic, weak) IBOutlet UITextField *fnLabel;
@property (weak, nonatomic) IBOutlet UIButton *currentWxButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) UITextField *activeField;


@end

@implementation FlightNumberViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"FlightNumberViewController viewDidLoad");
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard:)];
    [self.view addGestureRecognizer:tapGesture];
    self.navigationController.navigationBarHidden = YES;
    _fnLabel.delegate = self;
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
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
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

// Add segue instead of button press? YES
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"scheduledFlights"]) {
        ScheduleViewController *svc = segue.destinationViewController;
        svc.fn = _fnLabel.text;
        NSLog(@"_fnLabel.text: %@", _fnLabel.text);
        NSLog(@"svc.fn: %@", svc.fn);
    } else if ([segue.identifier isEqualToString:@"currentWxBrief"]) {
        UINavigationController *navController = segue.destinationViewController;
        NearestAirportsViewController *nvc = (NearestAirportsViewController *)navController.topViewController;
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [nvc.fac startLocation];
        });
    }
}

#pragma mark - Keyboard/Text Field Handling

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
