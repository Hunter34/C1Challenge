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

@implementation CCTableViewController

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

#pragma mark - Table view data source

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
    [cell.avatarImage setImage:[pd avatar]];
    [cell.posterName setText:[pd name]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // These "magic numbers" are here because I'm too lazy to do the right thing
    // and correctly calculate the row height and cache it. This only works on
    // 3.5" screens.
    
    CGFloat width = 238.0;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        width = 402.0;
    }

    NSArray *ar = [[AppNetDataController defaultDataController] arrayOfPosts];
    CCAppNetParsedData *pd = [ar objectAtIndex:[indexPath row]];

    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    CGRect labelSize = [[pd postText] boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:cellFont}
                                                   context:nil];
    
    CGFloat cellHeight = MAX(70.0, labelSize.size.height);

    return cellHeight;
}

@end
