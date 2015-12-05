//
//  Tweet.h
//  TwitterApi
//
//  Created by Sergii Sinkevych on 30.11.15.
//  Copyright © 2015 Sergii Sinkevych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * tweetID;
@property (nonatomic, retain) NSString * username;

- (void)setupWithDictionary:(NSDictionary *)dict;
- (NSString *)createdAtStringValue;

@end
