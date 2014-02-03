//
//  CCTableTableViewController.h
//  ChaiOneChallenge
//
//  Created by Mark Travis on 1/15/14.
//  Copyright (c) 2014 Mark Travis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCAppNetParsedData.h"

@interface CCTableViewController : UITableViewController
@property (strong, nonatomic) CCAppNetParsedData *netDataController;

@end
