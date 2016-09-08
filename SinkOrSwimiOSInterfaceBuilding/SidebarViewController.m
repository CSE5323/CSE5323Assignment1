//
//  SidebarViewController.m
//  SinkOrSwimiOSInterfaceBuilding
//
//  Created by Jenn Le on 9/5/16.
//  Copyright © 2016 Mobile Design Group. All rights reserved.
//

#import "SidebarViewController.h"
#import "MoviesTableViewController.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *data;
@end

@implementation SidebarViewController

-(NSArray*) menuItems {
    if(!_menuItems) {   //using lazy instantiation to set an array with the cell identifiers
        _menuItems = @[@"title", @"popularMovies", @"upcomingMovies", @"topRatedMovies", @"appSettings", @"numOfMovies", @"numOfMoviesPicker", @"numOfReviews", @"numOfReviewsStepper", @"viewType"];
    }
    return _menuItems;
}

-(NSArray*) data {
    if(!_data) {   //using lazy instantiation to set an array with the cell identifiers
        _data = @[@"10", @"20",@"30"];
    }
    return _data;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Picker
    self.numMoviesPicker.delegate = self;
    self.numMoviesPicker.dataSource = self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold"                size:16];
        
        pickerLabel.textAlignment=NSTextAlignmentCenter;
    }
    [pickerLabel setText:[self.data objectAtIndex:row]];
    
    return pickerLabel;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSString * title = nil;
//    
//    switch(row) {
//        case 0:
//            title = @"10";
//            break;
//        case 1:
//            title = @"20";
//            break;
//        case 2:
//            title = @"30";
//            break;
//    }
//    return title;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    NSString *name = [self.menuItems objectAtIndex:indexPath.row];
    
    UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    MoviesTableViewController *controller = (MoviesTableViewController *)navController.topViewController;
    
    if( [name  isEqual: @"popularMovies"] ) {
        controller.categoryCounter = 0;
    } else if( [name  isEqual: @"upcomingMovies"] ) {
        controller.categoryCounter = 1;
    } else if( [name  isEqual: @"topRatedMovies"] ) {
        controller.categoryCounter = 2;
    }
    
    
}

@end