//
//  ApiManager.m
//  TwitterApi
//
//  Created by Sergii Sinkevych on 01.12.15.
//  Copyright © 2015 Sergii Sinkevych. All rights reserved.
//

#import "ApiManager.h"
#import "AppDelegate.h"
#import "Tweet.h"

@interface ApiManager() <NSURLSessionDataDelegate, NSURLSessionDelegate>

@property (strong, nonatomic) NSURLSession *session;

@end
@implementation ApiManager

+ (ApiManager *)sharedInstance {
    static dispatch_once_t once;
    static ApiManager *instance;
    dispatch_once(&once, ^{
        instance = [[ApiManager alloc] init];
    });
    return instance;
}

- (NSMutableURLRequest *)createBasicRequestWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret {
    NSString *authString = [NSString stringWithFormat:@"https://api.twitter.com/oauth2/token"];
    NSURL *authURL = [NSURL URLWithString:authString];
    
    NSString *concatenate = [NSString stringWithFormat:@"%@:%@", apiKey, apiSecret];
    NSData *encodeData = [concatenate dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodeString = [encodeData base64EncodedStringWithOptions:0];
    NSString *basicString = [NSString stringWithFormat:@"Basic %@", encodeString];
    
    NSMutableURLRequest *basicRequest = [NSMutableURLRequest requestWithURL:authURL];
    [basicRequest addValue:basicString forHTTPHeaderField:@"Authorization"];
    basicRequest.HTTPBody = [@"grant_type=client_credentials" dataUsingEncoding:NSUTF8StringEncoding];
    basicRequest.HTTPMethod = @"POST";

    return basicRequest;
}

- (NSMutableURLRequest *)createBearerRequestWithUsername:(NSString *)username {
    NSString *urlString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/user_timeline.json?count=20&screen_name=%@", username];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *bearerRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *bearerString = [NSString stringWithFormat:@"Bearer %@", appDel.token];
    [bearerRequest addValue:bearerString forHTTPHeaderField:@"Authorization"];
    bearerRequest.HTTPMethod = @"GET";
    return bearerRequest;
}

- (void)getDataWithRequest:(NSMutableURLRequest*)request
                   success:(void(^)(NSData *responceData))success
                   failure:(void(^)(NSError *error))failure {
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *taskError) {
        if (!taskError) {
            success(data);
        } else {
            failure(taskError);
        }
    }];
    [dataTask resume];
}


- (NSArray *)tweetsFromArray:(NSArray *)array {
    
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        Tweet *tweet = [[Tweet alloc] init];
        [tweet setupWithDictionary:dict];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end