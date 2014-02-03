//
//  AppNetDataController.h
//  ChaiOneChallenge
//
//  Created by Mark Travis on 1/15/14.
//  Copyright (c) 2014 Mark Travis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppNetDataController : NSObject
{
    NSArray *arrayOfPosts;
}

+ (AppNetDataController *) defaultDataController;

- (void) loadAppNetPublicPosts;

- (NSArray *) arrayOfPosts;

@end
