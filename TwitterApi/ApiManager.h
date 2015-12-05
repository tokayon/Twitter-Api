//
//  ApiManager.h
//  TwitterApi
//
//  Created by Sergii Sinkevych on 01.12.15.
//  Copyright © 2015 Sergii Sinkevych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiManager : NSURLSession

+ (ApiManager *)sharedInstance;

- (NSMutableURLRequest *)createBasicRequestWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret;
- (NSMutableURLRequest *)createBearerRequestWithUsername:(NSString *)username;
- (void)getDataWithRequest:(NSMutableURLRequest*)request
                   success:(void(^)(NSData *responceData))success
                   failure:(void(^)(NSError *error))failure;
- (NSArray *)tweetsFromArray:(NSArray *)array;

@end
