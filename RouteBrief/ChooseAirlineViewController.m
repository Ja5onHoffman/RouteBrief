//
//  ChooseAirlineViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 11/29/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "ChooseAirlineViewController.h"
#import "SearchResultsController.h"
#import "Airlines.h"
#import "Airline.h"

@interface ChooseAirlineViewController () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *airlines;
//@property (nonatomic, strong) Airline *airlineModel;
@property (strong, nonatomic) IBOutlet UITableView *searchBar;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *searchText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation ChooseAirlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"airlineData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    self.airlines = [dictionary objectForKey:@"airlines"];
    
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavigationController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    // Remember searchBar default height is 0
    self.searchController.searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    NSArray *scopeButtonTitles = @[@"US Airlines", @"All Airlines"];
    self.searchController.searchBar.scopeButtonTitles = scopeButtonTitles;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonClicked:(id)sender {
    // For now
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Done button");
    }];
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
    
    cell.textLabel.text = [self.airlines[indexPath.row] objectForKey:@"Name"];

    return cell;
}

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = self.searchController.searchBar.text;
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        SearchResultsController *vc = (SearchResultsController *)navController.topViewController;
       // vc.searchResults = self.searchResults;
        [vc.tableView reloadData];
    }

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}




@end
