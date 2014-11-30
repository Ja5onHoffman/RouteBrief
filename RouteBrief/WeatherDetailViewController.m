//
//  WeatherDetailViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 10/20/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "WeatherDetailViewController.h"

@interface WeatherDetailViewController () <UIAlertViewDelegate>


@end

@implementation WeatherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.metarLabel.text = @"";
    self.tafLabel.text = @"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"labelsUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noResults:) name:@"noResults" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UITableViewDelegate

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"tableViewHeightForRowAtIndexPath");
    
    // Being called before label info updates from _fac
    
    
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            CGRect rect = CGRectMake(100, 10, 205, 1000);
            self.metarLabel.frame = rect;
            self.metarLabel.backgroundColor = [UIColor redColor];
            
            [self.metarLabel sizeToFit];
            
            rect.size.height = self.metarLabel.frame.size.height;
            self.metarLabel.frame = rect;
            
            NSLog(@"metar text %@", self.metarLabel.text);
            
            return self.metarLabel.frame.size.height + 20;
            
        } else if (indexPath.section == 0 && indexPath.row == 1) {
            
            CGRect rect = CGRectMake(100, 10, 205, 10000);
            self.tafLabel.frame = rect;
            self.tafLabel.backgroundColor = [UIColor blueColor];
            [self.tafLabel sizeToFit];
            
            rect.size.height = self.tafLabel.frame.size.height;
            self.tafLabel.frame = rect;
            
            NSLog(@"taf text %@", self.tafLabel.text);
            
            return self.tafLabel.frame.size.height + 20;
        }

    return 88;
} */

- (void)reload:(NSNotification *)note
{
    
    NSLog(@"metarText %@", _metarText);
    NSLog(@"tafText %@", _tafText);
    
    NSDictionary *attributes = @{NSFontAttributeName : self.metarLabel.font};
    
    /*CGSiz rect1 = [self.metarText boundingRectWithSize:CGSizeMake(self.metarLabel.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil]; */
    
    self.metarLabel.text = self.metarText;
    CGSize size1 = [self.metarText sizeWithAttributes:attributes];
    [self.metarLabel sizeThatFits:size1];
    
    
    self.tafLabel.text = self.tafText;
    CGSize size2 = [self.tafText sizeWithAttributes:attributes];
    [self.tafLabel sizeThatFits:size2];
    
    [self.tableView reloadData];
}

- (void)noResults:(NSNotification *)note
{
    NSString *alertMessage = [NSString stringWithFormat:@"No results returned. Are you sure %@ is a valid airport?", [self.codeMetar.text substringToIndex:3]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No results" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Go Back" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"pressed");

        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert addAction:action];
    
    NSLog(@"self.results: %d", self.results);
    
    if (self.results == NO) {
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
