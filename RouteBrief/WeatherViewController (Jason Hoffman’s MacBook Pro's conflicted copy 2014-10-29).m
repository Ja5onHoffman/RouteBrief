//
//  WeatherViewController.m
//  RouteBrief
//
//  Created by Jason Hoffman on 10/11/14.
//  Copyright (c) 2014 No5age. All rights reserved.
//

#import "WeatherViewController.h"
#import "FlightAwareCaller.h"

@interface WeatherViewController () <FlightAwareCallerDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *originLabel;
//@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
//@property (weak, nonatomic) IBOutlet UILabel *alternateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *originWeather;
//@property (weak, nonatomic) IBOutlet UILabel *destinationWeather;
//@property (weak, nonatomic) IBOutlet UILabel *alternateWeather;
@property (weak, nonatomic) IBOutlet UITableViewCell *originCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *destinationCell;

@property (nonatomic, strong) FlightAwareCaller *fac;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fac = [[FlightAwareCaller alloc] init];
    _originCell.textLabel.text = self.origin;
    _destinationCell.textLabel.text = self.destination;
    
    NSString * (^compHandler)(NSString *, NSError *) = ^(NSString *results, NSError *error) {
        if (!error) {
            continue;
        }
            dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });
        return results;
    };
    
    
    [_fac getMetarForAirport:self.origin completionHandler:compHandler];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:  forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
