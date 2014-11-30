//
//  ChooseAirlineViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 11/29/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "ChooseAirlineViewController.h"

@interface ChooseAirlineViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *airlines;

@end

@implementation ChooseAirlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"airlineData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    

    _airlines = [dictionary objectForKey:@"airlines"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.airlines count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AirlineName" forIndexPath:indexPath];
    
    cell.textLabel.text = _airlines[indexPath.row][@"Name"];

    return cell;
}


@end
