#import <UIImageView+AFNetworking.h>
#import <JLTMDbClient.h>
#import "MoviesTableViewController.h"
#import "MoviesModel.h"
#import "MovieDetailsViewController.h"


@interface MoviesTableViewController ()

@property (strong,nonatomic) MoviesModel* myMoviesModel;

@end

@implementation MoviesTableViewController

-(MoviesModel*)myMoviesModel{
    
    if(!_myMoviesModel)
        _myMoviesModel =[MoviesModel sharedInstance];
    
    return _myMoviesModel;
}

- (void)viewDidLoad {
    NSLog(@"MoviesTableViewController.viewDidLoad");
    
    [super viewDidLoad];

    self.tableView.rowHeight = 60.0f;
    
    //Randomly get new movies every 10 seconds
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 10.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //Refresh when pulling down from top
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    //Sidebar menu
    SWRevealViewController *revealViewController = self.revealViewController;
    //revealViewController.delegate = self;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    //Default # of movies at 10
    self.numMovies = 10;
    
    //Set view title
    self.mainNavItem.title = [self.myMoviesModel getMovieCategoryTitle];
    
    //Fetch movies
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myMoviesModel getTotalNumOfMovies];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MovieCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Get movie by indexPath.row
    NSDictionary *movieDict = [self.myMoviesModel getMovieByIndex:indexPath.row];
    
    //Setup table cell text
    cell.textLabel.text = movieDict[@"original_title"];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    //Setup table cell imageView
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    if (movieDict[@"poster_path"] != [NSNull null]) {
        NSString *imageUrl = [self.imagesBaseUrlString stringByAppendingString:movieDict[@"poster_path"]];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"TMDB"]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailsViewController *movieDetailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovieDetailsViewController"];
    
    NSDictionary *movieDict = [self.myMoviesModel getMovieByIndex:indexPath.row];
    
    movieDetailViewController.movieId = movieDict[@"id"];
    movieDetailViewController.movieTitle = movieDict[@"title"];
    movieDetailViewController.imagesBaseUrlString = self.imagesBaseUrlString;
    [self.navigationController pushViewController:movieDetailViewController animated:YES];
}

@end
