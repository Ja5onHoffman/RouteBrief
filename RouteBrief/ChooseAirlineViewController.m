//
//  ChooseAirlineViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 11/29/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "ChooseAirlineViewController.h"
#import "SearchResultsController.h"
#import "FlightStatsCaller.h"

@interface ChooseAirlineViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) __block NSArray *airlines;
@property (strong, nonatomic) IBOutlet UITableView *searchBar;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *searchText;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation ChooseAirlineViewController

/****************************************************
 
- This shouldn't always have to  reload the data.
 
- Currently case sensitive
 
*****************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavigationController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    FlightStatsCaller *fsc = [FlightStatsCaller sharedFlightStatsCaller];
    [fsc getActiveAirlinesWithCompHandler:^(NSArray *ar) {
        self.airlines = ar;
        [self.tableView reloadData];
    }];

    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    
    // Keeps searchbar on screen but not the behavior I want
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    // Remember searchBar default height is 0
    self.searchController.searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    /* Consider adding scope buttons
     *
    NSArray *scopeButtonTitles = @[@"US Airlines", @"All Airlines"];
    self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles; */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.airlines count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AirlineName" forIndexPath:indexPath];
    NSString *cellText = [NSString stringWithFormat:@"%@ - %@", [self.airlines[indexPath.row] objectForKey:@"name"], [self.airlines[indexPath.row] objectForKey:@"icao"]];
    
    cell.textLabel.text = cellText;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected");
        
    self.selectedAirline = [NSString stringWithFormat:@"%@ - %@", [self.airlines[indexPath.row] objectForKey:@"name"], [self.airlines[indexPath.row] objectForKey:@"icao"]];
    self.icao = [self.airlines[indexPath.row] objectForKey:@"icao"];
    
    [self performSegueWithIdentifier:@"ChooseAirlineCode" sender:self];
}

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = self.searchController.searchBar.text;
    
    [self updateFilteredContentForAirlineName:searchString];
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        SearchResultsController *vc = (SearchResultsController *)navController.topViewController;
        vc.searchResults = self.searchResults;
        [vc.tableView reloadData];
    }
}

- (void)updateFilteredContentForAirlineName:(NSString *)airlineName
{
    if (airlineName == nil) {
        self.searchResults = [self.airlines mutableCopy];
    } else {
        
        NSMutableArray *searchResults = [[NSMutableArray alloc] init];
        
        for (NSDictionary *airline in self.airlines) {
            if ([airline[@"name"] containsString:airlineName] || [airline[@"icao"] containsString:[airlineName uppercaseString]]) {
                NSString *str = [NSString stringWithFormat:@"%@ - %@", airline[@"name"], airline[@"icao"]];
                [searchResults addObject:str];
            }
            
            self.searchResults = searchResults;
        }
    }
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
