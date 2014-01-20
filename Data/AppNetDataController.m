//
//  AppNetDataController.m
//  ChaiOneChallenge
//
//  Created by Mark Travis on 1/15/14.
//  Copyright (c) 2014 Mark Travis. All rights reserved.
//

#import "AppNetDataController.h"
#import "AFNetworking.h"
#import "CCAppNetParsedData.h"

// Making the assumption that this URL should remain private, and is not something you would want
// to pass into this view object. Since this will only read the global stream, we can make it
// static.

static NSString *const BaseURLString = @"https://alpha-api.app.net/stream/0/posts/stream/global";

@interface AppNetDataController()

@property (strong, nonatomic) NSDictionary *post;
@property (strong, nonatomic) NSMutableArray *latestPosts;

@end

@implementation AppNetDataController

+ (AppNetDataController *) defaultDataController
{
    static AppNetDataController *defaultDataController = nil;
    if (!defaultDataController) {
        defaultDataController = [[super allocWithZone:nil] init];
    }
    
    return defaultDataController;
}

- (id)init
{
    self = [super init];
    return self;
}


- (void) loadAppNetPublicPosts
{
    NSURL *url = [NSURL URLWithString:BaseURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self parseStream:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
    NSLog(@"Kicked off JSON Request at %f",CACurrentMediaTime());

}

- (void) parseStream: (NSDictionary *) stream
{
    NSLog(@"Parsing JSON at %f",CACurrentMediaTime());
    self.latestPosts = [[NSMutableArray alloc] init];

    
    NSArray *data = [stream valueForKey:@"data"];
    for (NSDictionary *dict in data) {
        // Allocate the parsedData Object to be put into the NSArray
        CCAppNetParsedData *parsedData = [[CCAppNetParsedData alloc] init];

        // Dig into the user section of JSON to retrieve the avatar image URL
        NSDictionary *user = [dict valueForKey:@"user"];
        NSDictionary *avatar_image = [user valueForKey:@"avatar_image"];
        NSString *imageURL = [avatar_image valueForKey:@"url"];
        
        // Retrieve the avatar image and place it into the parsedData object
        parsedData.avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        
        // Retrieve the users name from the user section of the JSON object
        [parsedData setName:[user valueForKey:@"name"]];

        // Retrieve the text of the post from the main object
        [parsedData setPostText:[dict valueForKey:@"text"]];
        
        [self.latestPosts addObject:parsedData];
        parsedData = nil;
        
    }
    arrayOfPosts = self.latestPosts;
    NSLog(@"Finished parsing JSON at %f",CACurrentMediaTime());

    // Create a notification after the data has been loaded
    NSNotification *dataLoaded = [NSNotification notificationWithName:@"PublicTimeLineLoaded" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:dataLoaded];
}

- (NSArray *) arrayOfPosts
{
    return arrayOfPosts;
}

@end
