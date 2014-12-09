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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = @[@"One", @"Two", @"Three", @"Four", @"Five"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.array[indexPath.row];
    
    return cell;
}

@end
