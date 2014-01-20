//
//  CCTableViewCell.h
//  ChaiOneChallenge
//
//  Created by Mark Travis on 1/15/14.
//  Copyright (c) 2014 Mark Travis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) IBOutlet UILabel *posterName;
@property (strong, nonatomic) IBOutlet UILabel *postText;


@end
