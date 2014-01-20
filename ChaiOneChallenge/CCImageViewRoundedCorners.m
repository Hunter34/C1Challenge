//
//  CCImageViewRoundedCorners.m
//  ChaiOneChallenge
//
//  Created by Mark Travis on 1/17/14.
//  Copyright (c) 2014 Mark Travis. All rights reserved.
//

#import "CCImageViewRoundedCorners.h"

@implementation CCImageViewRoundedCorners

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 20.0f;
        self.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
        self.layer.shadowRadius = 10.0f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    return self;
}

@end
