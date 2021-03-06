#import <UIImageView+AFNetworking.h>
#import <JLTMDbClient.h>
#import "CollectionViewController.h"
#import "ImageModel.h"
#import "CollectionViewCell.h"
#import "MoviesTableViewController.h"

@interface CollectionViewController ()


@property (strong,nonatomic) ImageModel* myImageModel;

@end

@implementation CollectionViewController

//-(ImageModel*)myImageModel{
//    
//    if(!_myImageModel)
//        _myImageModel =[ImageModel sharedInstance];
//    
//    return _myImageModel;
//}

static NSString * const reuseIdentifier = @"ImageCollectCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadConfiguration];
    
    //sidebar menu
    SWRevealViewController *revealViewController = self.revealViewController;
    //revealViewController.delegate = self;
    if ( revealViewController )
    {
        [self.sidebarButton2 setTarget: self.revealViewController];
        [self.sidebarButton2 setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    // UPDATE: this is only required when the cell is configured programatically
    // Since we use the storyboard, we should NOT register the class. Per the instructions here:
    // https://developer.apple.com/library/ios/documentation/WindowsViews/Conceptual/CollectionViewPGforIOS/CreatingCellsandViews/CreatingCellsandViews.html#//apple_ref/doc/uid/TP40012334-CH7-SW10
    //[self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return [self.myImageModel getTotalNumOfImages];
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MoviesTableViewController *moviesController = [[MoviesTableViewController alloc] init];
    
//    static NSString *CellIdentifier = @"MovieCoverCell";
    
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSDictionary *movieDict = self.moviesArray[indexPath.row];

    cell.backgroundColor = [UIColor blueColor];
//    cell.imageView.image = [self.myImageModel getImageWithName:[self.myImageModel getImageNameByIndex:indexPath.row]];
    
    if (movieDict[@"poster_path"] != [NSNull null]) {
        NSString *imageUrl = [self.imagesBaseUrlString stringByAppendingString:movieDict[@"poster_path"]];
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"TMDB"]];
    }
    
    
    return cell;
}

- (void) loadConfiguration {
//    __block UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Please try again later", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
    
    [[JLTMDbClient sharedAPIInstance] GET:kJLTMDbConfiguration withParameters:nil andResponseBlock:^(id response, NSError *error) {
        if (!error)
            self.imagesBaseUrlString = [response[@"images"][@"base_url"] stringByAppendingString:@"w92"];
        else
            NSLog(@"error");
//            [errorAlertView show];
    }];
}



#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end