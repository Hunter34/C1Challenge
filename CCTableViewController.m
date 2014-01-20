//
//  CCTableTableViewController.m
//  ChaiOneChallenge
//
//  Created by Mark Travis on 1/15/14.
//  Copyright (c) 2014 Mark Travis. All rights reserved.
//

#import "CCTableViewController.h"
#import "AppNetDataController.h"
#import "CCTableViewCell.h"

@interface CCTableViewController () 

@end

@implementation CCTableViewController

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
        
    // Register as an observer so that we know when to reload the tableview after the data has been loaded
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"PublicTimeLineLoaded" object:nil];
    
    // Implement the Pull-To-Refresh functionality
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refresh];

}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PublicTimeLineLoaded" object:nil];
}

- (void) refreshView: (id)sender
{
    [[AppNetDataController defaultDataController] loadAppNetPublicPosts];
//    [self reloadTableView];
    [(UIRefreshControl *)sender endRefreshing];
}

- (void) reloadTableView
{
    NSLog(@"Reloading TableView at %f",CACurrentMediaTime());
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // We will only be concerned with one Section for this simple application
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *ar = [[AppNetDataController defaultDataController] arrayOfPosts];

    return [ar count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"publicTimeline" forIndexPath:indexPath];
        
    NSArray *ar = [[AppNetDataController defaultDataController] arrayOfPosts];
    
    CCAppNetParsedData *pd = [ar objectAtIndex:[indexPath row]];
    [cell.postText setText:[pd postText]];
    
//    CGPoint origin = CGPointMake(cell.frame.origin.x, cell.frame.origin.y);
//    [cell.postText setFrame:CGRectMake(origin.x, origin.y, pd.textBoxWidth, pd.textBoxHeight)];

    CGFloat width = cell.postText.frame.size.width;
    CGRect desiredFrame = CGRectMake(cell.postText.frame.origin.x, cell.postText.frame.origin.y, cell.postText.frame.size.width, CGFLOAT_MAX);
    
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    CGRect cellRect = cell.postText.frame;
    NSLog(@"\n\n");
    NSLog(@"%@ is table view cell before resizing", NSStringFromCGRect(cell.frame));
    NSLog(@"%@ is the label cell frame before resizing", NSStringFromCGRect(cell.postText.frame));
    CGRect labelSize = cell.postText.frame;
    labelSize = cellRect;
    labelSize = [cell.postText.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cellFont} context:nil];
    CGFloat labelHeight = ceilf(labelSize.size.height);
    CGFloat labelWidth = ceilf(labelSize.size.width);
    labelSize.size.height = labelHeight;
    labelSize.size.width = labelWidth;
    cell.postText.frame = labelSize;
    
    [cell.postText setMinimumScaleFactor:0.0];
    [cell.postText setNumberOfLines:0];
    [cell.postText setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.postText sizeToFit];
//    [cell.postText layoutSubviews];

    [cell.avatarImage setImage:[pd avatar]];
    [cell.posterName setText:[pd name]];

    NSLog(@"%@",cell.posterName.text);
    NSLog(@"%@", cell.postText.text);
    NSLog(@"%@ is the label cell frame", NSStringFromCGRect(cell.postText.frame));
    NSLog(@"%@ is the table view frame", NSStringFromCGRect(cell.frame));

    cell.avatarImage.contentMode = UIViewContentModeScaleAspectFit;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 214; // self.view.frame.size.width;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    NSArray *ar = [[AppNetDataController defaultDataController] arrayOfPosts];
    CCAppNetParsedData *pd = [ar objectAtIndex:[indexPath row]];
    CGRect labelSize = [[pd postText] boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cellFont} context:nil];
    CGFloat cellHeight = ceilf(labelSize.size.height);
//    if (cellHeight < 66.0) {
//        cellHeight = 80.0;
//    }
    [[ar objectAtIndex:[indexPath row]] setTextBoxHeight:cellHeight];
    [[ar objectAtIndex:[indexPath row]] setTextBoxWidth:width];
    NSLog(@"%@",[pd postText]);
    NSLog(@"%@", NSStringFromCGRect(labelSize));
    NSLog(@"%f",cellHeight);
    return (cellHeight+33.0);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
