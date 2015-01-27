//
//  SearchResultsController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 12/7/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "SearchResultsController.h"

@interface SearchResultsController ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation SearchResultsController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    cell.textLabel.text = self.searchResults[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedAirline = cell.textLabel.text;
    
    [self performSegueWithIdentifier:@"SearchAirlineCode" sender:self];
}

@end
