//
//  CCAppNetParsedData.h
//  ChaiOneChallenge
//
//  Created by Mark Travis on 1/17/14.
//  Copyright (c) 2014 Mark Travis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCAppNetParsedData : NSObject

@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *postText;
@property CGFloat textBoxHeight;
@property CGFloat textBoxWidth;

@end
