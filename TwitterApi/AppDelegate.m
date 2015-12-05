//
//  AppDelegate.m
//  TwitterApi
//
//  Created by Sergii on 27.11.15.
//  Copyright © 2015 Sergii Sinkevych. All rights reserved.
//

#import "AppDelegate.h"
#import "ApiManager.h"

/////////////////////////// ENTER YOUR API KEY AND SECRET HERE ////////////////////////
static NSString *apiKey =      @"uLKQ9DAnPtKyQ8eGN4V4ylNd5";
static NSString *apiSecret =   @"CGrC0clCrthTpdTLroF2x7TiyqOAjUswW2nL6sypfoFk9l8KUf";
///////////////////////////////////////////////////////////////////////////////////////


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *lastToken = nil;
    //NSString *lastToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"access_token"];
    
    if (lastToken.length > 0) {
        self.token = lastToken;
    } else {
        
        ApiManager *apiManager = [ApiManager sharedInstance];
        NSMutableURLRequest *basicRequest = [apiManager createBasicRequestWithApiKey:apiKey
                                                                           apiSecret:apiSecret];
        
        [apiManager getDataWithRequest:basicRequest success:^(NSData *responceData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responceData
                                                                 options:0 error:nil];
            NSString *token = dict[@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
