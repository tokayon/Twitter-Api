//
//  Tweet.m
//  TwitterApi
//
//  Created by Sergii Sinkevych on 30.11.15.
//  Copyright © 2015 Sergii Sinkevych. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet


- (void)setupWithDictionary:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]] == NO) {
        return;
    } else {
        self.text = [dict objectForKey:@"text"];
        self.tweetID = [dict objectForKey:@"id"];
        
        NSString *dateString = [dict objectForKey:@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        NSDate *date = [formatter dateFromString:dateString];
        if (date)
            self.createdAt = date;
        self.username = [[dict objectForKey:@"user"] objectForKey:@"name"];
        NSDictionary *adDict = [dict objectForKey:@"retweeted_status"];
        self.imageURL = [[adDict objectForKey:@"user"] objectForKey:@"profile_image_url_https"];
    }
}

- (NSString *)createdAtStringValue {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSLocale *russianLocale = [NSLocale localeWithLocaleIdentifier:@"ru"];
    [formatter setLocale:russianLocale];
    return [formatter stringFromDate:self.createdAt];
}


@end
